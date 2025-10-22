/*
package tpi_bases_de_datos1;
import java.sql.*;
public class dbConnection {
    static  String url ="jdbc:mysql://localhost:3306/tpi_pedido_envio";
    static String user = "user_ventas";
    static String pass = "1234";

    
    public static Connection conectar()
    {
        Connection con=null;
        try
        {
        con=DriverManager.getConnection(url,user,pass);
            System.out.println("Conexion exitosa");
         
        }catch(SQLException e)
        {
            e.printStackTrace();
        }
         
        
        return con;
    }
}
*/