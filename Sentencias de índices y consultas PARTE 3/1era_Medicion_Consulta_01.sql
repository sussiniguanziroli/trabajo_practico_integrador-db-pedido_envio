use tpi_pedido_envio;
use tpi_pedido_envio;
SET PROFILING = 1;
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
SHOW PROFILES;