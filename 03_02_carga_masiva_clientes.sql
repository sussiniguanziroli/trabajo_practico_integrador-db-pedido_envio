USE tpi_pedido_envio;

-- Tabla temporal con nombres comunes
CREATE TEMPORARY TABLE nombres_temp (nombre VARCHAR(50));
INSERT INTO nombres_temp VALUES 
('Juan'),('María'),('Carlos'),('Ana'),('Pedro'),('Laura'),('Diego'),('Sofia'),
('Miguel'),('Valeria'),('Lucas'),('Camila'),('Martín'),('Florencia'),('Sebastián');

CREATE TEMPORARY TABLE apellidos_temp (apellido VARCHAR(50));
INSERT INTO apellidos_temp VALUES 
('González'),('Rodríguez'),('Fernández'),('López'),('Martínez'),('García'),
('Pérez'),('Sánchez'),('Romero'),('Torres'),('Díaz'),('Ruiz'),('Moreno');

-- Generar 30,000 clientes usando producto cartesiano
INSERT INTO CLIENTE (cliente_nombre, cliente_email, cliente_telefono, direccion_entrega, id_localidad)
SELECT 
    CONCAT(n.nombre, ' ', a.apellido, ' ', gen.num) AS cliente_nombre,
    CONCAT(LOWER(n.nombre), '.', LOWER(a.apellido), gen.num, '@email.com') AS cliente_email,
    CONCAT('11-', LPAD(FLOOR(1000 + RAND() * 8999), 4, '0'), '-', LPAD(FLOOR(1000 + RAND() * 8999), 4, '0')) AS cliente_telefono,
    CONCAT(
        CASE FLOOR(RAND() * 3)
            WHEN 0 THEN 'Av. '
            WHEN 1 THEN 'Calle '
            ELSE 'Ruta '
        END,
        FLOOR(1 + RAND() * 999), ' #', FLOOR(1 + RAND() * 9999)
    ) AS direccion_entrega,
    FLOOR(1 + RAND() * 48) AS id_localidad -- FK aleatoria entre las 48 localidades
FROM 
    nombres_temp n
    CROSS JOIN apellidos_temp a
    CROSS JOIN (
        -- Generador simple: 1 a 200
        SELECT t1.n + t2.n*10 + t3.n*100 AS num
        FROM 
            (SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
             UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
            (SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
             UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
            (SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
             UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t3
    ) gen
WHERE gen.num < 200 -- 15 nombres × 13 apellidos × 200 = ~39,000 (tomamos 30k)
LIMIT 30000;

DROP TEMPORARY TABLE nombres_temp;
DROP TEMPORARY TABLE apellidos_temp;