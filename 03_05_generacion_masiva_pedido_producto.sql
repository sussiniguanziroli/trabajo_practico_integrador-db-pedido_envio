USE tpi_pedido_envio;

-- Primera línea: TODOS los pedidos tienen al menos 1 producto
INSERT INTO PEDIDO_PRODUCTO (id_pedido, id_producto, cantidad, precio_unitario, subtotal)
SELECT 
    p.id_pedido,
    ((p.id_pedido * 17) % 5000) + 1 AS id_producto,
    ((p.id_pedido % 5) + 1) AS cantidad,
    pr.precio_unitario,
    ROUND(((p.id_pedido % 5) + 1) * pr.precio_unitario, 2) AS subtotal
FROM PEDIDO p
JOIN PRODUCTO pr ON pr.id_producto = ((p.id_pedido * 17) % 5000) + 1;

-- Segunda línea: 70% de pedidos
INSERT INTO PEDIDO_PRODUCTO (id_pedido, id_producto, cantidad, precio_unitario, subtotal)
SELECT 
    p.id_pedido,
    ((p.id_pedido * 23) % 5000) + 1 AS id_producto,
    ((p.id_pedido % 3) + 1) AS cantidad,
    pr.precio_unitario,
    ROUND(((p.id_pedido % 3) + 1) * pr.precio_unitario, 2) AS subtotal
FROM PEDIDO p
JOIN PRODUCTO pr ON pr.id_producto = ((p.id_pedido * 23) % 5000) + 1
WHERE (p.id_pedido % 10) < 7;

-- Tercera línea: 30% de pedidos
INSERT INTO PEDIDO_PRODUCTO (id_pedido, id_producto, cantidad, precio_unitario, subtotal)
SELECT 
    p.id_pedido,
    ((p.id_pedido * 31) % 5000) + 1 AS id_producto,
    ((p.id_pedido % 2) + 1) AS cantidad,
    pr.precio_unitario,
    ROUND(((p.id_pedido % 2) + 1) * pr.precio_unitario, 2) AS subtotal
FROM PEDIDO p
JOIN PRODUCTO pr ON pr.id_producto = ((p.id_pedido * 31) % 5000) + 1
WHERE (p.id_pedido % 10) < 3;