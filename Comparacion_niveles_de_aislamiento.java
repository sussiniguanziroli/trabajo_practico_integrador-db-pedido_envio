
package etapa_5;
import java.sql.*;

public class Comparacion_niveles_de_aislamiento {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/tpi_pedido_envio";
        String user = "admin_db";
        String pass = " ";

        int reintentos = 0;
        boolean exito = false;

        while (reintentos < 2 && !exito) {
            try (Connection conn = DriverManager.getConnection(url, user, pass)) {
                conn.setAutoCommit(false);

                PreparedStatement ps = conn.prepareStatement(
                    "UPDATE PEDIDO SET total = total + ? WHERE id_pedido = ?");
                ps.setDouble(1, 10);
                ps.setInt(2, 1);
                ps.executeUpdate();

                Thread.sleep(2000); // simula espera

                ps.setDouble(1, 20);
                ps.setInt(2, 2);
                ps.executeUpdate();

                conn.commit();
                System.out.println("Transacción completada");
                exito = true;

            } catch (SQLException e) {
                if (e.getErrorCode() == 1213) { // Deadlock
                    reintentos++;
                    System.out.println("️ Deadlock detectado, reintentando... (" + reintentos + ")");
                    try { Thread.sleep(500 * reintentos); } catch (InterruptedException ignored) {}
                } else {
                    e.printStackTrace();
                    break;
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
    
    

