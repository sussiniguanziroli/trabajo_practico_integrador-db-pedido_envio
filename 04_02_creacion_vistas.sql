USE tpi_pedido_envio;
SHOW FULL TABLES IN tpi_pedido_envio WHERE TABLE_TYPE = 'VIEW';
show tables;
-- Vista de clientes pública (sin email ni direccion)
DROP VIEW IF EXISTS tpi_pedido_envio.vista_clientes_publicos;
CREATE SQL SECURITY DEFINER VIEW tpi_pedido_envio.vista_clientes_publicos AS
SELECT
  id_cliente,
  cliente_nombre,
  cliente_telefono,
  id_localidad
FROM tpi_pedido_envio.CLIENTE;

-- Vista resumen de pedidos (sin direccion_entrega ni datos de seguimiento)
DROP VIEW IF EXISTS tpi_pedido_envio.vista_pedidos_resumen;
CREATE SQL SECURITY DEFINER VIEW tpi_pedido_envio.vista_pedidos_resumen AS
SELECT
  p.id_pedido,
  p.id_cliente,
  c.cliente_nombre,
  p.fecha_pedido,
  p.estado_pedido,
  p.total,
  p.observaciones
FROM tpi_pedido_envio.PEDIDO p
JOIN tpi_pedido_envio.CLIENTE c ON p.id_cliente = c.id_cliente;


-- para observar las vistas
SELECT * FROM vista_pedidos_resumen;
SELECT * FROM vista_clientes_publicos;




