import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class PruebaConexion {

    private static final String URL = "jdbc:mysql://localhost:3306/tpi_pedido_envio";

    private static final String USER = "root";

    private static final String PASSWORD = "";

    public static void main(String[] args) {
        Connection conexion = null;

        try {
            System.out.println("🔧 Intentando conectar a la base de datos...");

            conexion = DriverManager.getConnection(URL, USER, PASSWORD);

            if (conexion != null && !conexion.isClosed()) {
                System.out.println("✅ ¡Conexión exitosa a la base de datos!");
            }

        } catch (SQLException e) {
            System.err.println("❌ Error al conectar a la base de datos:");

            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("ErrorCode: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace();
        } finally {

            if (conexion != null) {
                try {
                    System.out.println("🚪 Cerrando la conexión...");
                    conexion.close();
                    System.out.println("✔️ Conexión cerrada.");
                } catch (SQLException e) {
                    System.err.println("❌ Error al cerrar la conexión:");
                    e.printStackTrace();
                }
            }
        }
    }
}