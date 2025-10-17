INSERT INTO PRODUCTO (producto_nombre, producto_codigo, precio_unitario, stock_disponible)
SELECT
    -- 1. Generar un nombre de producto ficticio y variado
    CONCAT('Producto Genérico ', CHAR(65 + FLOOR(RAND() * 26)), '-', n.numero) AS producto_nombre,
    
    -- 2. Generar un código de producto único (SKU)
    CONCAT('SKU-', LPAD(n.numero, 7, '0')) AS producto_codigo,
    
    -- 3. Generar un precio unitario aleatorio entre 500.00 y 95500.00
    ROUND(500 + RAND() * 95000, 2) AS precio_unitario,
    
    -- 4. Generar un stock disponible aleatorio entre 0 y 500
    FLOOR(RAND() * 501) AS stock_disponible
FROM
    -- Generador de números del 1 al 10000
    (
        SELECT a.N + b.N * 10 + c.N * 100 + d.N * 1000 + 1 AS numero
        FROM 
            (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a,
            (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b,
            (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c,
            (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d
    ) AS n
WHERE n.numero <= 10000; -- Límite de 10,000 productos