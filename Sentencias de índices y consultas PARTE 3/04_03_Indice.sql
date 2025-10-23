-- Consulta que realizamos, que tiene JOIN primero sin indice
SELECT
    p.producto_nombre,
    SUM(pp.cantidad) AS total_vendido
FROM
    PRODUCTO p
JOIN
    PEDIDO_PRODUCTO pp ON p.id_producto = pp.id_producto
GROUP BY
    p.producto_nombre
ORDER BY
    total_vendido DESC
LIMIT 5;
-- Creamos el indice para ver que pasa despues
CREATE INDEX idx_pp_producto ON PEDIDO_PRODUCTO(id_producto);
-- Repetimos la consulta luego con indice creado
SELECT
    p.producto_nombre,
    SUM(pp.cantidad) AS total_vendido
FROM
    PRODUCTO p
JOIN
    PEDIDO_PRODUCTO pp ON p.id_producto = pp.id_producto
GROUP BY
    p.producto_nombre
ORDER BY
    total_vendido DESC
LIMIT 5;