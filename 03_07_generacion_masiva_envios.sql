USE tpi_pedido_envio;

INSERT INTO ENVIO (id_pedido, fecha_despacho, fecha_entrega, numero_seguimiento, estado_envio, costo_envio)
SELECT 
    p.id_pedido,
    DATE_ADD(p.fecha_pedido, INTERVAL FLOOR(1 + RAND() * 3) DAY) AS fecha_despacho,
    DATE_ADD(p.fecha_pedido, INTERVAL FLOOR(4 + RAND() * 7) DAY) AS fecha_entrega,
    CONCAT('ENV-', YEAR(p.fecha_pedido), '-', LPAD(p.id_pedido, 8, '0')) AS numero_seguimiento,
    CASE 
        WHEN p.estado_pedido = 'Despachado' THEN 'En Transito'
        WHEN p.estado_pedido = 'Entregado' THEN 'Entregado'
    END AS estado_envio,
    ROUND(500 + RAND() * 2000, 2) AS costo_envio
FROM PEDIDO p
WHERE p.estado_pedido IN ('Despachado', 'Entregado');