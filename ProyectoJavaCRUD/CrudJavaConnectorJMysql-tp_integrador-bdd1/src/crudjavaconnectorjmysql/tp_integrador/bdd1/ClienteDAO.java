import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {

    public List<Cliente> obtenerTodosLosClientes() {
        List<Cliente> clientes = new ArrayList<>();
        String sql = "SELECT id_cliente, cliente_nombre, cliente_email, cliente_telefono, direccion_entrega, id_localidad FROM CLIENTE LIMIT 20"; 

        try (Connection conn = ConexionManager.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Cliente cliente = new Cliente();
                cliente.setIdCliente(rs.getInt("id_cliente"));
                cliente.setNombre(rs.getString("cliente_nombre"));
                cliente.setEmail(rs.getString("cliente_email"));
                cliente.setTelefono(rs.getString("cliente_telefono"));
                cliente.setDireccion(rs.getString("direccion_entrega"));
                cliente.setIdLocalidad(rs.getInt("id_localidad"));

                clientes.add(cliente);
            }

        } catch (SQLException e) {
            System.err.println("Error al obtener los clientes: " + e.getMessage());
            e.printStackTrace();
        }

        return clientes;
    }

}