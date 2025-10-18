import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LocalidadDAO {

    public Localidad obtenerLocalidadPorId(int id) {
        String sql = "SELECT * FROM LOCALIDADES WHERE id_localidad = ?";
        Localidad localidad = null;

        try (Connection conn = ConexionManager.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    localidad = new Localidad();
                    localidad.setIdLocalidad(rs.getInt("id_localidad"));
                    localidad.setCiudad(rs.getString("ciudad"));
                    localidad.setProvincia(rs.getString("provincia"));
                    localidad.setCodigoPostal(rs.getString("codigo_postal"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener localidad por ID: " + e.getMessage());
            e.printStackTrace();
        }

        return localidad;
    }
}