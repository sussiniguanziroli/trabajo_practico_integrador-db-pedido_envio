import java.math.BigDecimal;

public class Producto {

    private int idProducto;
    private String nombre;
    private String codigo;
    private BigDecimal precioUnitario; 
    private int stockDisponible;

    public int getIdProducto() { return idProducto; }
    public void setIdProducto(int idProducto) { this.idProducto = idProducto; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }
    public BigDecimal getPrecioUnitario() { return precioUnitario; }
    public void setPrecioUnitario(BigDecimal precioUnitario) { this.precioUnitario = precioUnitario; }
    public int getStockDisponible() { return stockDisponible; }
    public void setStockDisponible(int stockDisponible) { this.stockDisponible = stockDisponible; }

    @Override
    public String toString() {
        return "Producto{" + "id=" + idProducto + ", nombre='" + nombre + "', precio=" + precioUnitario + '}';
    }
}