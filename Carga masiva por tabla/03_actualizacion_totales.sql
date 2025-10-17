START TRANSACTION;
UPDATE PEDIDO p
JOIN (
  SELECT id_pedido, ROUND(SUM(subtotal), 2) AS total
  FROM PEDIDO_PRODUCTO
  GROUP BY id_pedido
) s ON s.id_pedido = p.id_pedido
SET p.total = s.total;
COMMIT;
