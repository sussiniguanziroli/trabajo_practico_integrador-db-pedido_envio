UPDATE PEDIDO p
JOIN (
    SELECT id_pedido, SUM(subtotal) AS total_calculado
    FROM PEDIDO_PRODUCTO
    GROUP BY id_pedido
) pp ON pp.id_pedido = p.id_pedido
SET p.total = pp.total_calculado;