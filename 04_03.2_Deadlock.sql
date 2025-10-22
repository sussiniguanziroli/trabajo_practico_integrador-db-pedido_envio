-- TERMINAL 2:
USE tpi_pedido_envio;
START TRANSACTION;
UPDATE PRODUCTO SET stock_disponible = stock_disponible - 1 WHERE  id_producto = 2;
-- intenta actualizar la fila 1: esto esperara si terminal 1 tiene un lock en 1,
-- y cuando terminal 1 intente actualizar 2 se producira deadlock.
UPDATE PRODUCTO SET stock_disponible = stock_disponible - 1 WHERE id_producto = 1;
-- Prueba actualizando el producto 2 y viceversa, hasta que se genere una deadlock.
-- Error que se espera: ERRROR 1213 (40001): Deadlock found when trying to get lock; try restarting transaction