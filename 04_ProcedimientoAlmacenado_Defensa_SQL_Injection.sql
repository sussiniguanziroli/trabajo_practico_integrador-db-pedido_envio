DELIMITER //

CREATE DEFINER = `root`@`localhost`
PROCEDURE sp_ConsultarPedidos_Min(
  IN  p_id_cliente  INT,        -- NULL = todos
  IN  p_fecha_desde DATETIME,   -- NULL = sin límite inferior
  IN  p_fecha_hasta DATETIME    -- NULL = sin límite superior
)
SQL SECURITY DEFINER
BEGIN
  -- Validaciones simples (evitan entradas lógicas inadecuadas)
  IF p_id_cliente IS NOT NULL AND p_id_cliente <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'id_cliente inválido (debe ser > 0 o NULL)';
  END IF;

  IF p_fecha_desde IS NOT NULL AND p_fecha_hasta IS NOT NULL THEN
    IF p_fecha_desde > p_fecha_hasta THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Rango de fechas inválido: fecha_desde > fecha_hasta';
    END IF;
  END IF;

  -- Consulta ESTÁTICA y segura: NO concatenación dinámica
  SELECT
    id_pedido,
    id_cliente,
    fecha_pedido,
    estado_pedido,
    total,
    observaciones
  FROM PEDIDO
  WHERE (p_id_cliente  IS NULL OR id_cliente  = p_id_cliente)
    AND (p_fecha_desde IS NULL OR fecha_pedido >= p_fecha_desde)
    AND (p_fecha_hasta IS NULL OR fecha_pedido <= p_fecha_hasta)
  ORDER BY fecha_pedido DESC;
END;
//

DELIMITER ;

CALL sp_ConsultarPedidos_Min(12970, "20254-10-16 00:00:00; DROP TABLE pedidos; --",'2025-10-18 00:00:00');
SHOW WARNINGS;

CALL sp_ConsultarPedidos_Min(483, "20254-10-16 00:00:00",'2025-10-18 00:00:00');