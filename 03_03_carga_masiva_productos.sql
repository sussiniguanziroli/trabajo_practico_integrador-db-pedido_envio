USE tpi_pedido_envio;

-- Generar 5,000 productos sin duplicados
INSERT INTO PRODUCTO (producto_nombre, producto_codigo, precio_unitario, stock_disponible)
SELECT 
    CONCAT(cat.categoria, ' - Modelo ', gen.num) AS producto_nombre,
    CONCAT('PROD-', LPAD(gen.num + (cat.cat_id - 1) * 500, 6, '0')) AS producto_codigo,
    ROUND(500 + RAND() * 49500, 2) AS precio_unitario,
    FLOOR(RAND() * 200) AS stock_disponible
FROM 
    (SELECT 1 AS cat_id, 'Electrónica' AS categoria
     UNION ALL SELECT 2, 'Hogar'
     UNION ALL SELECT 3, 'Deportes'
     UNION ALL SELECT 4, 'Libros'
     UNION ALL SELECT 5, 'Juguetes'
     UNION ALL SELECT 6, 'Ropa'
     UNION ALL SELECT 7, 'Alimentos'
     UNION ALL SELECT 8, 'Herramientas'
     UNION ALL SELECT 9, 'Jardín'
     UNION ALL SELECT 10, 'Oficina') cat
CROSS JOIN (
    -- Generador: 1 a 500 (sin duplicados)
    SELECT (t1.n + t2.n*10 + t3.n*100 + 1) AS num
    FROM 
        (SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
         UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
        (SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
         UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
        (SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) t3
    WHERE (t1.n + t2.n*10 + t3.n*100 + 1) <= 500
) gen
LIMIT 5000;