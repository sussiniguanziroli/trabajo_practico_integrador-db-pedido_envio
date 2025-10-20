-- CTE 1: Calcula el total vendido por provincia y filtra las que superan los $100,000.
WITH VentasPorProvincia AS (
   SELECT
        l.provincia,
        SUM(p.total) AS total_ventas
    FROM
        LOCALIDADES l
    JOIN
        CLIENTE c ON l.id_localidad = c.id_localidad
    JOIN
        PEDIDO p ON c.id_cliente = p.id_cliente
    GROUP BY
        l.provincia
    HAVING
        SUM(p.total) > 100000
),

-- CTE 2: Ranking de los productos más vendidos dentro de cada provincia.
RankingProductosProvincia AS (
    SELECT
        l.provincia,
        pr.producto_nombre,
        ROW_NUMBER() OVER(PARTITION BY l.provincia ORDER BY SUM(pp.cantidad) DESC) as ranking
    FROM
        LOCALIDADES l
    JOIN
        CLIENTE c ON l.id_localidad = c.id_localidad
    JOIN
        PEDIDO p ON c.id_cliente = p.id_cliente
    JOIN
        PEDIDO_PRODUCTO pp ON p.id_pedido = pp.id_pedido
    JOIN
        PRODUCTO pr ON pp.id_producto = pr.id_producto
    GROUP BY
        l.provincia, pr.producto_nombre
)

-- Consulta Final: Une las provincias con altas ventas con su producto #1.
SELECT
    vpp.provincia,
    vpp.total_ventas,
    rpp.producto_nombre AS producto_mas_vendido
FROM
    VentasPorProvincia vpp
JOIN
    RankingProductosProvincia rpp ON vpp.provincia = rpp.provincia
WHERE
    rpp.ranking = 1
ORDER BY
    vpp.total_ventas DESC;

