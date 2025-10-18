START TRANSACTION; -- Comienza un bloque de instrucciones

INSERT INTO ENVIO (id_pedido, fecha_despacho, fecha_entrega, numero_seguimiento, estado_envio, costo_envio)
SELECT
  p.id_pedido,
  DATE_ADD(p.fecha_pedido, INTERVAL ((p.id_pedido*3) % 72) HOUR) AS fecha_despacho,
  DATE_ADD(p.fecha_pedido, INTERVAL ((p.id_pedido*3) % 72 + 24 + ((p.id_pedido*7)%72)) HOUR) AS fecha_entrega,
  CONCAT('TRK-', LPAD(p.id_pedido, 9, '0')) AS numero_seguimiento,
  -- mapeo simple de estados
  CASE
    WHEN p.estado_pedido = 'Despachado' THEN 'En Transito'
    WHEN p.estado_pedido = 'Entregado'  THEN 'Entregado'
    ELSE 'En Preparacion'
  END AS estado_envio,
  ROUND(500 + (p.id_pedido % 1500), 2) AS costo_envio
FROM PEDIDO p
WHERE p.estado_pedido IN ('Despachado', 'Entregado');

COMMIT; -- Se guarda el bloque de instrucciones
