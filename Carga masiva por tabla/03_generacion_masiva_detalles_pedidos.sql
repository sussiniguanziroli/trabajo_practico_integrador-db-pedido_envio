START TRANSACTION;

WITH RandomizedProducts AS (
  SELECT
    id_producto,
    precio_unitario,
    ROW_NUMBER() OVER (ORDER BY RAND()) AS rn
  FROM PRODUCTO
)
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
JOIN RandomizedProducts pr
  ON MOD(p.id_pedido + qty.k - 2, (SELECT COUNT(*) FROM PRODUCTO)) + 1 = pr.rn
WHERE
  (qty.k = 1)
  OR (qty.k = 2 AND (p.id_pedido % 100) < 65)
  OR (qty.k = 3 AND (p.id_pedido % 100) < 35);

COMMIT;