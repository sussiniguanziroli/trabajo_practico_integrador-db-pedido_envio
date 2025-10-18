import java.util.List;

public class Main {

    public static void main(String[] args) {
        ClienteDAO clienteDAO = new ClienteDAO();
        ProductoDAO productoDAO = new ProductoDAO();
        PedidoDAO pedidoDAO = new PedidoDAO();
        PedidoProductoDAO pedidoProductoDAO = new PedidoProductoDAO();
        LocalidadDAO localidadDAO = new LocalidadDAO();

        int idClienteParaBuscar = 15;
        
        System.out.println("=============================================");
        System.out.println("BUSCANDO DATOS COMPLETOS DEL CLIENTE ID: " + idClienteParaBuscar);
        System.out.println("=============================================");

        List<Pedido> pedidosDelCliente = pedidoDAO.obtenerPedidosPorCliente(idClienteParaBuscar);

        if (pedidosDelCliente.isEmpty()) {
            System.out.println("El cliente no tiene pedidos registrados.");
        } else {
            System.out.println("Se encontraron " + pedidosDelCliente.size() + " pedidos para este cliente.");
            
            // Tomamos el primer pedido como ejemplo para mostrar su detalle
            Pedido primerPedido = pedidosDelCliente.get(0);
            
            System.out.println("\n--- Mostrando detalle del Pedido ID: " + primerPedido.getIdPedido() + " ---");
            System.out.println("Fecha: " + primerPedido.getFechaPedido());
            System.out.println("Estado: " + primerPedido.getEstadoPedido());
            System.out.println("Total: $" + primerPedido.getTotal());

            List<PedidoProducto> detalles = pedidoProductoDAO.obtenerDetallesPorPedido(primerPedido.getIdPedido());

            System.out.println("\n--- Productos en este pedido ---");
            for (PedidoProducto detalle : detalles) {
                Producto producto = productoDAO.obtenerProductoPorId(detalle.getIdProducto());
                System.out.println(
                    "-> Producto: " + producto.getNombre() + 
                    " | Cantidad: " + detalle.getCantidad() + 
                    " | Subtotal: $" + detalle.getSubtotal()
                );
            }
            System.out.println("-------------------------------------\n");
        }
    }
}