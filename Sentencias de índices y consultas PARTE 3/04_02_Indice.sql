-- Consulta con select de WHERE para probar sin indice
SELECT * FROM PEDIDO WHERE fecha_pedido BETWEEN '2025-01-01' AND '2025-03-31';
-- Creamos el siguiente indice
CREATE INDEX idx_pedido_fecha ON PEDIDO(fecha_pedido);
-- Ejecutamos la misma sentencia ahora con indice para ver la diferencia en tiempo
SELECT * FROM PEDIDO WHERE fecha_pedido BETWEEN '2025-01-01' AND '2025-03-31';