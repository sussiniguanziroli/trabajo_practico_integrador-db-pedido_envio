USE tpi_pedido_envio;
START TRANSACTION;

-- Bloquea primer pedido
UPDATE PEDIDO SET total = total + 10 WHERE id_pedido = 7; -- 1

-- Espera antes de intentar bloquear otro recurso
SELECT SLEEP(10);

-- Luego intenta bloquear otro pedido
UPDATE PEDIDO SET total = total + 60 WHERE id_pedido = 5;

COMMIT;


SET autocommit = 0;

USE tpi_pedido_envio;
-- Pestaña B
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
UPDATE PEDIDO SET total = total + 5 WHERE id_pedido = 2 ;
-- deja abierta sin COMMIT

USE tpi_pedido_envio;

-----
UPDATE PEDIDO SET total = total + 15 WHERE id_pedido = 1;
COMMIT;
