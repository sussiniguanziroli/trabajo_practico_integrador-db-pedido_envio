import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PedidoDAO {

    public List<Pedido> obtenerPedidosPorCliente(int idCliente) {
        String sql = "SELECT * FROM PEDIDO WHERE id_cliente = ?";
        List<Pedido> pedidos = new ArrayList<>();

        try (Connection conn = ConexionManager.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idCliente);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Pedido pedido = new Pedido();
                    pedido.setIdPedido(rs.getInt("id_pedido"));
                    pedido.setIdCliente(rs.getInt("id_cliente"));
                    pedido.setFechaPedido(rs.getTimestamp("fecha_pedido").toLocalDateTime());
                    pedido.setEstadoPedido(rs.getString("estado_pedido"));
                    pedido.setTotal(rs.getBigDecimal("total"));
                    pedido.setObservaciones(rs.getString("observaciones"));
                    pedidos.add(pedido);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener pedidos por cliente: " + e.getMessage());
            e.printStackTrace();
        }

        return pedidos;
    }
}