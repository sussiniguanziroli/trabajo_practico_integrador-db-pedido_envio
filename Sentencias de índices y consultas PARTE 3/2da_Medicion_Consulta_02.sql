use tpi_pedido_envio;
SET PROFILING = 1;
SELECT
C.cliente_nombre,
COUNT(p.id_pedido) AS numero_de_pedidos
FROM
CLIENTE c
JOIN
PEDIDO p ON c.id_cliente = p.id_cliente
GROUP BY
c.cliente_nombre
HAVING
COUNT(p.id_pedido) >= 10
ORDER BY
numero_de_pedidos DESC;
SHOW PROFILES;