SELECT
C.id_cliente,
C.cliente_nombre,
SUM(p.total) AS gasto_total
FROM
CLIENTE c
JOIN
PEDIDO p ON c.id_cliente = p.id_cliente
GROUP BY
c.id_cliente, c.cliente_nombre
ORDER BY
gasto_total DESC
LIMIT 5
