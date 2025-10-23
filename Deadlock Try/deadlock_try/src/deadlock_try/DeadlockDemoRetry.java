/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package deadlock_try;

/**
 *
 * @author paddy
 */
import java.sql.*;
import java.util.concurrent.CountDownLatch;

public class DeadlockDemoRetry {

    private static final String DB_URL  = System.getenv().getOrDefault("DB_URL",  "jdbc:mysql://localhost:3306/tpi_pedido_envio");
    private static final String DB_USER = System.getenv().getOrDefault("DB_USER", "root");
    private static final String DB_PASS = System.getenv().getOrDefault("DB_PASS", "");

    private static final int TEST_PEDIDO_ID  = 1;
    private static final int PROD_A = 1;
    private static final int PROD_B = 2;

    private static final int MAX_RETRIES = 5;
    private static final long BASE_DELAY_MS = 300; // para backoff exponencial

    public static void main(String[] args) {
        System.out.println("Conectando a: " + DB_URL);

        CountDownLatch ready = new CountDownLatch(2);
        CountDownLatch start = new CountDownLatch(1);

        Thread tA = new Thread(() -> runSession("A", true, ready, start));
        Thread tB = new Thread(() -> runSession("B", false, ready, start));

        tA.start();
        tB.start();

        try { ready.await(); } catch (InterruptedException ignored) {}
        start.countDown();

        try { tA.join(); tB.join(); } catch (InterruptedException ignored) {}

        System.out.println("\n================ INNODB: LATEST DETECTED DEADLOCK ================");
        printLatestDeadlock();
        System.out.println("==================================================================");
    }

    private static void runSession(String tag, boolean isA, CountDownLatch ready, CountDownLatch start) {
        int attempt = 0;
        boolean done = false;

        while (!done && attempt < MAX_RETRIES) {
            attempt++;
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                conn.setAutoCommit(false);
                conn.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);

                ready.countDown();
                start.await();

                System.out.printf("[%s][Try %d] START TRANSACTION%n", tag, attempt);

                if (isA) {
                    // Sesión A: primero PEDIDO_PRODUCTO, luego PRODUCTO
                    lockPedidoProducto(conn, tag);
                    sleep(1000);
                    updateProducto(conn, tag);
                } else {
                    // Sesión B: primero PRODUCTO, luego PEDIDO_PRODUCTO
                    lockProducto(conn, tag);
                    sleep(1000);
                    updatePedidoProducto(conn, tag);
                }

                conn.commit();
                System.out.printf("[%s][Try %d] COMMIT OK%n", tag, attempt);
                done = true;

            } catch (SQLException e) {
                if (isDeadlock(e)) {
                    System.err.printf("[%s][Try %d] DEADLOCK detectado: reintentando...%n", tag, attempt);
                    sleep(BASE_DELAY_MS * (1L << (attempt - 1))); // backoff exponencial
                } else {
                    System.err.printf("[%s][Try %d] Error SQL no recuperable: %s%n", tag, attempt, e.getMessage());
                    e.printStackTrace();
                    break;
                }
            } catch (InterruptedException ie) {
                Thread.currentThread().interrupt();
                break;
            }
        }

        if (!done)
            System.err.printf("[%s] Abortado tras %d intentos%n", tag, MAX_RETRIES);
    }

    // ==== Operaciones auxiliares ====
    private static void lockPedidoProducto(Connection conn, String tag) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT id_detalle FROM PEDIDO_PRODUCTO WHERE id_pedido=? AND id_producto=? FOR UPDATE")) {
            ps.setInt(1, TEST_PEDIDO_ID);
            ps.setInt(2, PROD_A);
            ps.executeQuery();
            System.out.printf("[%s] LOCK PEDIDO_PRODUCTO (pedido=%d, producto=%d)%n", tag, TEST_PEDIDO_ID, PROD_A);
        }
    }

    private static void lockProducto(Connection conn, String tag) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT id_producto FROM PRODUCTO WHERE id_producto=? FOR UPDATE")) {
            ps.setInt(1, PROD_A);
            ps.executeQuery();
            System.out.printf("[%s] LOCK PRODUCTO id=%d%n", tag, PROD_A);
        }
    }

    private static void updateProducto(Connection conn, String tag) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE PRODUCTO SET stock_disponible = stock_disponible - 1 WHERE id_producto=?")) {
            ps.setInt(1, PROD_A);
            ps.executeUpdate();
            System.out.printf("[%s] UPDATE PRODUCTO id=%d%n", tag, PROD_A);
        }
    }

    private static void updatePedidoProducto(Connection conn, String tag) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE PEDIDO_PRODUCTO SET cantidad = cantidad + 1, subtotal = (cantidad + 1)*precio_unitario " +
                        "WHERE id_pedido=? AND id_producto=?")) {
            ps.setInt(1, TEST_PEDIDO_ID);
            ps.setInt(2, PROD_A);
            ps.executeUpdate();
            System.out.printf("[%s] UPDATE PEDIDO_PRODUCTO (pedido=%d, producto=%d)%n", tag, TEST_PEDIDO_ID, PROD_A);
        }
    }

    private static boolean isDeadlock(SQLException e) {
        return "40001".equals(e.getSQLState()) || e.getErrorCode() == 1213;
    }

    private static void sleep(long ms) {
        try { Thread.sleep(ms); } catch (InterruptedException ignored) {}
    }

    private static void printLatestDeadlock() {
        try (Connection c = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery("SHOW ENGINE INNODB STATUS")) {
            if (rs.next()) {
                String status = rs.getString("Status");
                System.out.println(status);
            }
        } catch (SQLException e) {
            System.err.println("No se pudo leer SHOW ENGINE INNODB STATUS: " + e.getMessage());
        }
    }
}
