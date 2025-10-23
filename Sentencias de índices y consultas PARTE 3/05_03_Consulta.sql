-- CTE 1
WITH TopClientes AS (
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
),

-- CTE 2
RankingProductos AS (
SELECT
P.id_cliente,
Pp.id_producto,
ROW_NUMBER() OVER(PARTITION BY p.id_cliente ORDER BY SUM(pp.cantidad) DESC) as ranking
FROM
PEDIDO p
JOIN
PEDIDO_PRODUCTO pp ON p.id_pedido = pp.id_pedido
GROUP BY
p.id_cliente, pp.id_producto
)

-- Consulta final
SELECT
Tc.cliente_nombre,
Tc.gasto_total,
prod.producto_nombre AS producto_mas_comprado
FROM
TopClientes tc
JOIN
RankingProductos rp ON tc.id_cliente = rp.id_cliente
JOIN
PRODUCTO prod ON rp.id_producto = prod.id_producto
WHERE
rp.ranking = 1 
ORDER BY
tc.gasto_total DESC;
