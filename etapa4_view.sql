-- Antes de crear un usuario, deberia ver que usuarios hay 
select * from mysql.user;
drop user user_ventas@localhost;

-- Crear usuario (cambiar contraseña por una segura en el entorno real)
CREATE USER 'user_ventas'@'localhost' IDENTIFIED BY '1234';

-- Quitar cualquier privilegio por defecto (por si)
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'user_ventas'@'localhost';

-- Conceder sólo lo necesario:
-- SELECT sobre las vistas (que crearemos abajo) 
-- INSERT sobre PEDIDO y PEDIDO_PRODUCTO para poder crear pedidos
GRANT SELECT ON tpi_pedido_envio.vista_clientes_publicos TO 'user_ventas'@'localhost';
GRANT SELECT ON tpi_pedido_envio.vista_pedidos_resumen TO 'user_ventas'@'localhost';

GRANT INSERT ON tpi_pedido_envio.PEDIDO TO 'user_ventas'@'localhost';
GRANT INSERT ON tpi_pedido_envio.PEDIDO_PRODUCTO TO 'user_ventas'@'localhost';

-- No damos UPDATE/DELETE/ALTER/DROP ni acceso directo a tablas sensibles.
FLUSH PRIVILEGES;

-- Una forma menos recomendadas es que tenga los permisos sobre las tablas y columnas de la DB.
CREATE USER 'admin_db'@'localhost' IDENTIFIED BY '0000'; -- Creacion del usuario admin_db (USAGE = sin privilegios)
GRANT ALL privileges ON *.* TO 'admin_db'@'localhost' WITH GRANT OPTION;
-- WITH GRANT OPTION permite que este usuario otorgue privilegios a otros
-- Tener en cuenta que los privilegios solo son aplicables a tpi_pedido_envio
FLUSH PRIVILEGES; -- aplica los cambios inmediatamente
