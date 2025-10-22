
package tpi_bases_de_datos1;

import java.sql.*;

public class dbConnection_anti_inyeccion {
    
    public static void main(String[] args) {
        
        String url_anti_inyec = "jdbc:mysql://localhost:3306/tpi_pedido_envio";
        String user_anti_inyec = "admin_db";
        String pass_anti_inyec = "0000";
    
        String sql = "INSERT INTO PEDIDO_PRODUCTO (id_pedido, id_producto, cantidad, precio_unitario, subtotal)" + "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DriverManager.getConnection(url_anti_inyec, user_anti_inyec, pass_anti_inyec);
                PreparedStatement ps = conn.prepareStatement(sql)) {
        
                ps.setInt(1, 1);
                ps.setInt(2,1);
                ps.setInt(3, 2);
                ps.setBigDecimal(4, new java.math.BigDecimal("100.00"));
                ps.setBigDecimal(5, new java.math.BigDecimal("200.00"));
                
                ps.executeUpdate();
                System.out.println("Insercion legitima OK");
                
                String malicioso = "1; DROP TABLE PRODUCTO; --";
                String sql2 = "INSERT INTO PRODUCTO (producto_nombre, producto_codigo, precio_unitario, stock_disponible) " + "VALUES (?, ?, ?, ?)";
                
                try (PreparedStatement ps2 = conn.prepareStatement(sql2)) {
                    ps2.setString(1, "NombreMalicioso");
                    ps2.setString(2, malicioso);
                    ps2.setBigDecimal(3, new java.math.BigDecimal("1.00"));
                    ps2.setInt(4, 1);
                    ps2.executeUpdate();
                    System.out.println("Insercion con contenido malicioso como datos)");
                  }   
        }catch (SQLException e) {
            e.printStackTrace();
        }
    }
    }
    
 
