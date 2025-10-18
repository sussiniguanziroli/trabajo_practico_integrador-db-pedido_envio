USE tpi_pedido_envio;

-- Generar 100,000 pedidos
INSERT INTO PEDIDO (id_cliente, fecha_pedido, estado_pedido, total, observaciones)
SELECT 
    FLOOR(1 + RAND() * 30000) AS id_cliente, -- FK aleatoria a clientes
    DATE_SUB(CURRENT_DATE, INTERVAL FLOOR(RAND() * 365) DAY) AS fecha_pedido, -- Último año
    CASE FLOOR(RAND() * 6)
        WHEN 0 THEN 'Pendiente'
        WHEN 1 THEN 'Confirmado'
        WHEN 2 THEN 'En Preparacion'
        WHEN 3 THEN 'Despachado'
        WHEN 4 THEN 'Entregado'
        ELSE 'Cancelado'
    END AS estado_pedido,
    0.00 AS total, -- Se actualizará después
    CASE WHEN RAND() < 0.3 THEN 'Envío urgente' ELSE NULL END AS observaciones
FROM 
    (
        -- Generador: 1 a 100,000
        SELECT (t1.n + t2.n*10 + t3.n*100 + t4.n*1000 + t5.n*10000) AS num
        FROM 
            (SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
             UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
            (SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
             UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
            (SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
             UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t3,
            (SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
             UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t4,
            (SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
             UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t5
    ) gen
LIMIT 100000;