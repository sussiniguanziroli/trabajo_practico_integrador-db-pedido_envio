-- Consulta para indice vs plain
SELECT * FROM PEDIDO WHERE id_cliente = 15000;
-- Indice para testear la misma consulta luego
CREATE INDEX idx_pedido_cliente ON PEDIDO(id_cliente);
-- Volvemos a testear la misma consulta
SELECT * FROM PEDIDO WHERE id_cliente = 15000;
