CREATE OR REPLACE VIEW Vista_Detalle_Envios AS
SELECT
    e.id_envio,
    e.numero_seguimiento,
    e.estado_envio,
    e.fecha_despacho,
    e.fecha_entrega,
    p.id_pedido,
    p.fecha_pedido,
    c.cliente_nombre,
    pr.producto_nombre,
    pp.cantidad,
    pp.subtotal
FROM
    ENVIO e
JOIN
    PEDIDO p ON e.id_pedido = p.id_pedido
JOIN
    CLIENTE c ON p.id_cliente = c.id_cliente
JOIN
    PEDIDO_PRODUCTO pp ON p.id_pedido = pp.id_pedido
JOIN
    PRODUCTO pr ON pp.id_producto = pr.id_producto
ORDER BY
    e.fecha_despacho DESC, e.id_envio, pr.producto_nombre;
SELECT * FROM Vista_Detalle_Envios WHERE id_envio = 1234;