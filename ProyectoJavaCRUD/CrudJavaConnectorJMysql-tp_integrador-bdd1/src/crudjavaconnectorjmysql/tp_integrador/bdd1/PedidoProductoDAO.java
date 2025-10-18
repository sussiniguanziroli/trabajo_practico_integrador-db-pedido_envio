import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PedidoProductoDAO {

    public List<PedidoProducto> obtenerDetallesPorPedido(int idPedido) {
        String sql = "SELECT * FROM PEDIDO_PRODUCTO WHERE id_pedido = ?";
        List<PedidoProducto> detalles = new ArrayList<>();

        try (Connection conn = ConexionManager.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idPedido);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PedidoProducto detalle = new PedidoProducto();
                    detalle.setIdDetalle(rs.getInt("id_detalle"));
                    detalle.setIdPedido(rs.getInt("id_pedido"));
                    detalle.setIdProducto(rs.getInt("id_producto"));
                    detalle.setCantidad(rs.getInt("cantidad"));
                    detalle.setPrecioUnitario(rs.getBigDecimal("precio_unitario"));
                    detalle.setSubtotal(rs.getBigDecimal("subtotal"));
                    detalles.add(detalle);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener detalles de pedido: " + e.getMessage());
            e.printStackTrace();
        }

        return detalles;
    }
}