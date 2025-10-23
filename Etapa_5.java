
package etapa_5;
import java.sql.*;

public class Etapa_5 {

    
    public static void main(String[] args) {
        
        String url = "jdbc:mysql://localhost:3306/tpi_pedido_envio";
        String user = "admin_db";
        String pass = "0000";
        
        int retries = 0; 
        boolean success = false;
        
        // mientras los intento sean menores a 2 
        while (retries < 2 && !success) {
             try  (Connection conn = DriverManager.getConnection(url, user, pass)) {
                conn.setAutoCommit(false);  //inicia transaccion
                
                PreparedStatement ps1 = conn.prepareStatement(
                        "UPDATE PEDIDO SET total = total + ? WHERE id_pedido = ?");
                
                ps1.setDouble(1, 10);
                ps1.setInt(2, 1);
                ps1.executeUpdate();
                
                Thread.sleep(1000); //simula espera concurrente
                
                ps1.setDouble(1, 20);
                ps1.setInt(2, 2);
                ps1.executeUpdate();
                
                
                conn.commit();
                success = true;
                System.out.println("Transacción completa correctamente");
                
            } catch (SQLException e) {
                if (e.getErrorCode() == 1213) { //deadlock
                    retries++;
                    System.out.println("Deadlock detectado, reintentado.. intento #" + retries);
                    try  { Thread.sleep(500 * retries); } catch (InterruptedException ie) {}  
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
