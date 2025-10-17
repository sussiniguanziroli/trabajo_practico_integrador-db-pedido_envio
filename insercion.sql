USE tpi_pedido_envio;

INSERT INTO LOCALIDADES (ciudad, provincia, codigo_postal)
VALUES ('Buenos Aires', 'Buenos Aires', '1406'), ('Córdoba', 'Córdoba', '5000'), ('Rosario', 'Santa Fe', '2000');

INSERT INTO CLIENTE (cliente_nombre, cliente_email, cliente_telefono, direccion_entrega, id_localidad)
VALUES ('Juan Pérez', 'juan.perez@email.com', '11-4567-8900', 'Av. Rivadavia 1234', 1);

-- INSERT INTO CLIENTE (cliente_nombre, cliente_email, cliente_telefono, direccion_entrega, id_localidad)
-- VALUES ('Ramon Juarez', 'ramon.juarez_email.com', '11-8231-7620', 'Av. Siempre Viva 14', 2); -- ERROR CHECK '@'

INSERT INTO PRODUCTO (producto_nombre, producto_codigo, precio_unitario, stock_disponible)
VALUES ('Notebook Lenovo IdeaPad', 'NB-LEN-001', 450000.00, 15), ('Mouse Logitech M185', 'MS-LOG-185', 8500.00, 50), ('Mouse Logitech G203', 'MS-LOG-203', 3500.00, 30);

INSERT INTO PEDIDO (id_cliente, fecha_pedido, estado_pedido, total, observaciones)
VALUES (1, '2024-10-15 10:30:00', 'Confirmado', 37000.00, 'Entrega en horario comercial'), (1, '2024-10-16 09:15:30', 'Despachado', 50000.00, 'Entregar en porteria');

-- INSERT INTO PEDIDO_PRODUCTO (id_pedido, id_producto, cantidad, precio_unitario, subtotal)
-- VALUES (1, 3, 1, 450000.00, 450000.00), (2, 2, 2, 9000.00, 17000.00);  -- ERROR VALIDACION SUBTOTAL - (PRECIO_UNITARIO * CANTIDAD) DEBE SER 0

INSERT INTO PEDIDO_PRODUCTO (id_pedido, id_producto, cantidad, precio_unitario, subtotal)
VALUES (1, 1, 1, 450000.00, 450000.00), (2, 2, 2, 8500.00, 17000.00);

INSERT INTO ENVIO (id_pedido, fecha_despacho, fecha_entrega, numero_seguimiento, estado_envio, costo_envio)
VALUES (1, '2024-10-16 09:00:00', '2024-10-18 14:30:00', 'AND-2024-001234', 'En Transito', 4500.00);

-- INSERT INTO ENVIO (id_pedido, fecha_despacho, fecha_entrega, numero_seguimiento, estado_envio, costo_envio)
-- VALUES (3, '2024-10-16 09:00:00', '2024-10-18 14:30:00', 'AND-2024-001234', 'Pendiente', 4500.00); -- 'Pendiente' no es un valor valido