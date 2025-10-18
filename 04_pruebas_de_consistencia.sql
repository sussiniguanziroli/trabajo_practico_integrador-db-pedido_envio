-- ============================================
-- PRUEBAS DE CONSISTENCIA - ETAPA 2
-- ============================================
USE tpi_pedido_envio;

-- VERIFICACIÓN 1: CONTEO TOTAL DE REGISTROS
SELECT 'LOCALIDADES' AS Tabla, COUNT(*) AS Registros FROM LOCALIDADES
UNION ALL
SELECT 'CLIENTE', COUNT(*) FROM CLIENTE
UNION ALL
SELECT 'PRODUCTO', COUNT(*) FROM PRODUCTO
UNION ALL
SELECT 'PEDIDO', COUNT(*) FROM PEDIDO
UNION ALL
SELECT 'PEDIDO_PRODUCTO', COUNT(*) FROM PEDIDO_PRODUCTO
UNION ALL
SELECT 'ENVIO', COUNT(*) FROM ENVIO
UNION ALL
SELECT '=== TOTAL ===', 
    (SELECT SUM(cnt) FROM (
        SELECT COUNT(*) AS cnt FROM LOCALIDADES
        UNION ALL SELECT COUNT(*) FROM CLIENTE
        UNION ALL SELECT COUNT(*) FROM PRODUCTO
        UNION ALL SELECT COUNT(*) FROM PEDIDO
        UNION ALL SELECT COUNT(*) FROM PEDIDO_PRODUCTO
        UNION ALL SELECT COUNT(*) FROM ENVIO
    ) t);


-- VERIFICACIÓN 2: FOREIGN KEYS HUÉRFANAS (Resultado esperado: 0)
SELECT 'CLIENTE → LOCALIDADES' AS Relación, COUNT(*) AS FK_Huérfanas
FROM CLIENTE c
LEFT JOIN LOCALIDADES l ON c.id_localidad = l.id_localidad
WHERE l.id_localidad IS NULL

UNION ALL

SELECT 'PEDIDO → CLIENTE', COUNT(*)
FROM PEDIDO p
LEFT JOIN CLIENTE c ON p.id_cliente = c.id_cliente
WHERE c.id_cliente IS NULL

UNION ALL

SELECT 'PEDIDO_PRODUCTO → PEDIDO', COUNT(*)
FROM PEDIDO_PRODUCTO pp
LEFT JOIN PEDIDO p ON pp.id_pedido = p.id_pedido
WHERE p.id_pedido IS NULL

UNION ALL

SELECT 'PEDIDO_PRODUCTO → PRODUCTO', COUNT(*)
FROM PEDIDO_PRODUCTO pp
LEFT JOIN PRODUCTO pr ON pp.id_producto = pr.id_producto
WHERE pr.id_producto IS NULL

UNION ALL

SELECT 'ENVIO → PEDIDO', COUNT(*)
FROM ENVIO e
LEFT JOIN PEDIDO p ON e.id_pedido = p.id_pedido
WHERE p.id_pedido IS NULL;


-- VERIFICACIÓN 3: CARDINALIDADES - Todos los pedidos tienen productos (Resultado esperado: 0)
SELECT 
    'Pedidos SIN productos' AS Verificación,
    COUNT(*) AS Cantidad_Incorrecta
FROM PEDIDO p
LEFT JOIN PEDIDO_PRODUCTO pp ON p.id_pedido = pp.id_pedido
WHERE pp.id_pedido IS NULL;


-- VERIFICACIÓN 4: CARDINALIDADES - Distribución productos por pedido
/*
Considerando la logica aplicada al momento de crear las tabals,
el resultado esperado es sperado: 1 producto ~30%, 2 productos ~40%, 3 productos ~30%
*/
SELECT 
    productos_por_pedido AS 'Productos/Pedido',
    COUNT(*) AS Cantidad_Pedidos,
    CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM PEDIDO), 1), '%') AS Porcentaje
FROM (
    SELECT id_pedido, COUNT(*) AS productos_por_pedido
    FROM PEDIDO_PRODUCTO
    GROUP BY id_pedido
) dist
GROUP BY productos_por_pedido
ORDER BY productos_por_pedido;

-- VERIFICACIÓN 5: CARDINALIDADES - Solo Despachados/Entregados tienen envío (Resultado esperado: 0)
SELECT 
    'Envíos con estado inválido' AS Verificación,
    COUNT(*) AS Cantidad_Incorrecta
FROM ENVIO e
JOIN PEDIDO p ON e.id_pedido = p.id_pedido
WHERE p.estado_pedido NOT IN ('Despachado', 'Entregado');

-- VERIFICACIÓN 6: RANGOS DE DOMINIO - Precios válidos (Resultado esperado: 0)
SELECT 
    'Productos con precio < 500' AS Verificación,
    COUNT(*) AS Cantidad
FROM PRODUCTO
WHERE precio_unitario < 500

UNION ALL

SELECT 
    'Productos con precio > 50000',
    COUNT(*)
FROM PRODUCTO
WHERE precio_unitario > 50000;


-- VERIFICACIÓN 7: INTEGRIDAD - Totales de pedidos correctos (Resultado esperado: 0)
SELECT 
    'Pedidos con total incorrecto' AS Verificación,
    COUNT(*) AS Cantidad_Incorrecta
FROM PEDIDO p
WHERE ABS(p.total - COALESCE((
    SELECT SUM(pp.subtotal)
    FROM PEDIDO_PRODUCTO pp
    WHERE pp.id_pedido = p.id_pedido
), 0)) > 0.01;


-- VERIFICACIÓN 8: INTEGRIDAD - Fechas de envío coherentes (Resultado esperado: 0)
SELECT 
    'Envíos con fecha_entrega < fecha_despacho' AS Verificación,
    COUNT(*) AS Cantidad_Incorrecta
FROM ENVIO
WHERE fecha_entrega < fecha_despacho;