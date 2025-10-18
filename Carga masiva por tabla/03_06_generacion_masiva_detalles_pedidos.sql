START TRANSACTION;

-- Barajamos productos una sola vez, sin WITH
INSERT INTO PEDIDO_PRODUCTO (id_pedido, id_producto, cantidad, precio_unitario, subtotal)
SELECT
  p.id_pedido,
  pr.id_producto,
  qty.cantidad,
  pr.precio_unitario,
  ROUND(qty.cantidad * pr.precio_unitario, 2) AS subtotal
FROM PEDIDO p
CROSS JOIN (
  SELECT 1 AS k, 1 AS cantidad
  UNION ALL SELECT 2, 3
  UNION ALL SELECT 3, 4
) AS qty
JOIN (
  SELECT id_producto, precio_unitario,
         @r := @r + 1 AS rn,
         @cnt := (SELECT COUNT(*) FROM PRODUCTO)
  FROM PRODUCTO, (SELECT @r := 0) vars
  ORDER BY RAND()
) pr
  ON ((p.id_pedido + qty.k - 2) % @cnt) + 1 = pr.rn
WHERE
  (qty.k = 1)
  OR (qty.k = 2 AND (p.id_pedido % 100) < 65)
  OR (qty.k = 3 AND (p.id_pedido % 100) < 35);

COMMIT;
