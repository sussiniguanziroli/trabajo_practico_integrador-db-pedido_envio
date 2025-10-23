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

public class DeadlockDemo {

    // ==== CONFIG ====
    // Cambiá credenciales si hace falta (o usá variables de entorno DB_URL/DB_USER/DB_PASS)
    private static final String DB_URL  = System.getenv().getOrDefault("DB_URL",  "jdbc:mysql://localhost:3306/tpi_pedido_envio");
    private static final String DB_USER = System.getenv().getOrDefault("DB_USER", "root");
    private static final String DB_PASS = System.getenv().getOrDefault("DB_PASS", "");

    // Si es tu primera corrida y no tenés datos mínimos, poné esto en true.
    private static final boolean SEED = false;

    // Caso de prueba: trabajamos con pedido=1 y producto 1/2
    private static final int TEST_PEDIDO_ID  = 1;
    private static final int PROD_A = 1;
    private static final int PROD_B = 2;

    public static void main(String[] args) {
        System.out.println("Conectando a: " + DB_URL);

        try {
            if (SEED) seedMinimalData(); // opcional: carga mínima
        } catch (SQLException se) {
            System.err.println("Error sembrando datos (podés ignorar si ya existen): " + se.getMessage());
        }

        CountDownLatch ready = new CountDownLatch(2);
        CountDownLatch start = new CountDownLatch(1);

        Thread tA = new Thread(() -> runSessionA(ready, start));
        Thread tB = new Thread(() -> runSessionB(ready, start));

        tA.start();
        tB.start();

        // Esperar que ambos se preparen
        try { ready.await(); } catch (InterruptedException ignored) {}
        // Disparar a la vez
        start.countDown();

        // Esperar fin de ambos
        try {
            tA.join();
            tB.join();
        } catch (InterruptedException ignored) {}

        // Leer el último deadlock de InnoDB (si lo hubo)
        System.out.println("\n================ INNODB: LATEST DETECTED DEADLOCK ================");
        printLatestDeadlock();
        System.out.println("==================================================================");
    }

    private static void runSessionA(CountDownLatch ready, CountDownLatch start) {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
            conn.setAutoCommit(false);
            conn.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);

            ready.countDown();
            start.await();

            System.out.println("[A] START TRANSACTION");
            // 1) A bloquea el renglón del detalle
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT id_detalle FROM PEDIDO_PRODUCTO WHERE id_pedido=? AND id_producto=? FOR UPDATE")) {
                ps.setInt(1, TEST_PEDIDO_ID);
                ps.setInt(2, PROD_A);
                ps.executeQuery();
                System.out.println("[A] LOCK PEDIDO_PRODUCTO (pedido=" + TEST_PEDIDO_ID + ", producto=" + PROD_A + ")");
            }

            // 2) pequeña espera para que B tome el lock del PRODUCTO
            sleep(1200);

            // 3) Ahora A intenta tocar PRODUCTO (quedará esperando el lock que tomó B)
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE PRODUCTO SET stock_disponible = stock_disponible - 1 WHERE id_producto=?")) {
                ps.setInt(1, PROD_A);
                int n = ps.executeUpdate();
                System.out.println("[A] UPDATE PRODUCTO id=" + PROD_A + " (filas=" + n + ")");
            }

            conn.commit();
            System.out.println("[A] COMMIT OK");
        } catch (SQLException e) {
            handleSqlException("[A]", e);
        } catch (InterruptedException ie) {
            Thread.currentThread().interrupt();
        }
    }

    private static void runSessionB(CountDownLatch ready, CountDownLatch start) {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
            conn.setAutoCommit(false);
            conn.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);

            ready.countDown();
            start.await();

            System.out.println("[B] START TRANSACTION");
            // 1) B bloquea primero el PRODUCTO
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT id_producto FROM PRODUCTO WHERE id_producto=? FOR UPDATE")) {
                ps.setInt(1, PROD_A);
                ps.executeQuery();
                System.out.println("[B] LOCK PRODUCTO id=" + PROD_A);
            }

            // 2) pequeña espera para que A llegue al UPDATE sobre PRODUCTO
            sleep(1200);

            // 3) Ahora B intenta tocar el detalle (quedará esperando el lock que tiene A)
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE PEDIDO_PRODUCTO " +
                    "SET cantidad = cantidad + 1, subtotal = (cantidad + 1) * precio_unitario " +
                    "WHERE id_pedido=? AND id_producto=?")) {
                ps.setInt(1, TEST_PEDIDO_ID);
                ps.setInt(2, PROD_A);
                int n = ps.executeUpdate();
                System.out.println("[B] UPDATE PEDIDO_PRODUCTO (filas=" + n + ")");
            }

            conn.commit();
            System.out.println("[B] COMMIT OK");
        } catch (SQLException e) {
            handleSqlException("[B]", e);
        } catch (InterruptedException ie) {
            Thread.currentThread().interrupt();
        }
    }

    private static void handleSqlException(String tag, SQLException e) {
        System.err.println(tag + " SQLException capturada:");
        System.err.println("  Message   : " + e.getMessage());
        System.err.println("  SQLState  : " + e.getSQLState());
        System.err.println("  ErrorCode : " + e.getErrorCode());

        // En MySQL: deadlock => SQLState 40001, vendor code 1213
        if ("40001".equals(e.getSQLState()) || e.getErrorCode() == 1213) {
            System.err.println(tag + " ==> DEADLOCK detectado (ER_LOCK_DEADLOCK 1213).");
            // MySQL hace ROLLBACK automático de la transacción fallida.
        } else {
            System.err.println(tag + " ==> No parece deadlock específico; revisar traza.");
            e.printStackTrace(System.err);
        }
    }

    private static void sleep(long ms) {
        try { Thread.sleep(ms); } catch (InterruptedException ignored) {}
    }

    // ========= utilidades opcionales =========

    private static void seedMinimalData() throws SQLException {
        try (Connection c = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
            c.setAutoCommit(false);

            // Localidad mínima
            execUpd(c, "INSERT IGNORE INTO LOCALIDADES (id_localidad, ciudad, provincia, codigo_postal) " +
                       "VALUES (1,'Corrientes','Corrientes','3400')");

            // Cliente mínimo
            execUpd(c, "INSERT IGNORE INTO CLIENTE (id_cliente, cliente_nombre, cliente_email, cliente_telefono, direccion_entrega, id_localidad) " +
                       "VALUES (1,'Patricia Jimenez','patricia@example.com','379-555-000','Entre Rios 1581',1)");

            // Productos 1 y 2
            execUpd(c, "INSERT IGNORE INTO PRODUCTO (id_producto, producto_nombre, producto_codigo, precio_unitario, stock_disponible) " +
                       "VALUES (1,'Pipeta Antiparasitaria','PIP-001',1000.00,10)");
            execUpd(c, "INSERT IGNORE INTO PRODUCTO (id_producto, producto_nombre, producto_codigo, precio_unitario, stock_disponible) " +
                       "VALUES (2,'Collar Antipulgas','COL-001',800.00,20)");

            // Pedido 1
            execUpd(c, "INSERT IGNORE INTO PEDIDO (id_pedido, id_cliente, estado_pedido, total, observaciones) " +
                       "VALUES (1,1,'Pendiente',1000.00,'Test deadlock')");

            // Detalle pedido 1, producto 1
            execUpd(c, "INSERT IGNORE INTO PEDIDO_PRODUCTO (id_detalle, id_pedido, id_producto, cantidad, precio_unitario, subtotal) " +
                       "VALUES (1,1,1,1,1000.00,1000.00)");

            c.commit();
            System.out.println("[SEED] Datos mínimos creados/asegurados.");
        }
    }

    private static void execUpd(Connection c, String sql) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(sql)) { ps.executeUpdate(); }
    }

    private static void printLatestDeadlock() {
        try (Connection c = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery("SHOW ENGINE INNODB STATUS")) {

            if (rs.next()) {
                String status = rs.getString("Status");
                // Mostrar todo el status (incluye la sección LATEST DETECTED DEADLOCK)
                System.out.println(status);
            } else {
                System.out.println("(sin datos)");
            }
        } catch (SQLException e) {
            System.err.println("No se pudo leer SHOW ENGINE INNODB STATUS: " + e.getMessage());
        }
    }
}
