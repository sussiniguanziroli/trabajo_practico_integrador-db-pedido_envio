import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAO {

    public Producto obtenerProductoPorId(int id) {
        String sql = "SELECT * FROM PRODUCTO WHERE id_producto = ?";
        Producto producto = null;

        try (Connection conn = ConexionManager.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id); 

            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {
                    producto = new Producto();
                    producto.setIdProducto(rs.getInt("id_producto"));
                    producto.setNombre(rs.getString("producto_nombre"));
                    producto.setCodigo(rs.getString("producto_codigo"));
                    producto.setPrecioUnitario(rs.getBigDecimal("precio_unitario"));
                    producto.setStockDisponible(rs.getInt("stock_disponible"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener producto por ID: " + e.getMessage());
            e.printStackTrace();
        }

        return producto;
    }

}