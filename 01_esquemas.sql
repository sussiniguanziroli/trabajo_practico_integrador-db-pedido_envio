DROP SCHEMA IF EXISTS tpi_pedido_envio;
CREATE SCHEMA tpi_pedido_envio;
USE tpi_pedido_envio;

DROP TABLE IF EXISTS ENVIO;
DROP TABLE IF EXISTS PEDIDO_PRODUCTO;
DROP TABLE IF EXISTS PEDIDO;
DROP TABLE IF EXISTS PRODUCTO;
DROP TABLE IF EXISTS CLIENTE;
DROP TABLE IF EXISTS LOCALIDADES;

CREATE TABLE LOCALIDADES (
	id_localidad INT AUTO_INCREMENT PRIMARY KEY,
	ciudad VARCHAR(50) NOT NULL,
    provincia VARCHAR(50) NOT NULL,
    codigo_postal VARCHAR(10),
    CONSTRAINT uk_ciudad UNIQUE (ciudad),
    CONSTRAINT chk_localidad_ciudad CHECK (LENGTH(ciudad) >= 2),
    CONSTRAINT chk_localidad_provincia CHECK (LENGTH(provincia) >= 2)
);

CREATE TABLE CLIENTE (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    cliente_nombre VARCHAR(100) NOT NULL,
    cliente_email VARCHAR(100) NOT NULL,
    cliente_telefono VARCHAR(20),
    direccion_entrega VARCHAR(200) NOT NULL,
    id_localidad INT NOT NULL,
    CONSTRAINT fk_cliente_localidad FOREIGN KEY (id_localidad) 
        REFERENCES LOCALIDADES(id_localidad)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_cliente_email CHECK (cliente_email LIKE '%@%'),
    CONSTRAINT chk_cliente_nombre CHECK (LENGTH(cliente_nombre) >= 3)
);

CREATE TABLE PRODUCTO (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    producto_nombre VARCHAR(100) NOT NULL,
    producto_codigo VARCHAR(50) NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    stock_disponible INT NOT NULL DEFAULT 0,
    CONSTRAINT uk_producto_codigo UNIQUE (producto_codigo),
    CONSTRAINT chk_producto_precio CHECK (precio_unitario >= 0),
    CONSTRAINT chk_producto_stock CHECK (stock_disponible >= 0)
);

CREATE TABLE PEDIDO (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado_pedido VARCHAR(20) NOT NULL DEFAULT 'Pendiente',
    total DECIMAL(10,2) NOT NULL,
    observaciones TEXT,
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) 
        REFERENCES CLIENTE(id_cliente)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_pedido_estado CHECK (
        estado_pedido IN ('Pendiente', 'Confirmado', 'En Preparacion', 'Despachado', 'Entregado', 'Cancelado')
    ),
    CONSTRAINT chk_pedido_total CHECK (total >= 0)
);

CREATE TABLE PEDIDO_PRODUCTO (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_detalle_pedido FOREIGN KEY (id_pedido) 
        REFERENCES PEDIDO(id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto) 
        REFERENCES PRODUCTO(id_producto)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_detalle_cantidad CHECK (cantidad > 0),
    CONSTRAINT chk_detalle_precio CHECK (precio_unitario >= 0),
    CONSTRAINT chk_detalle_subtotal CHECK (subtotal >= 0),
    CONSTRAINT chk_detalle_calculo CHECK (ABS(subtotal - (cantidad * precio_unitario)) < 0.01)
);

CREATE TABLE ENVIO (
    id_envio INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    fecha_despacho DATETIME,
    fecha_entrega DATETIME,
    numero_seguimiento VARCHAR(50) NOT NULL,
    estado_envio VARCHAR(20) NOT NULL DEFAULT 'En Preparacion',
    costo_envio DECIMAL(8,2) NOT NULL,
    CONSTRAINT fk_envio_pedido FOREIGN KEY (id_pedido) 
        REFERENCES PEDIDO(id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT uk_envio_seguimiento UNIQUE (numero_seguimiento),
    CONSTRAINT uk_envio_pedido UNIQUE (id_pedido),
    CONSTRAINT chk_envio_estado CHECK (
        estado_envio IN ('En Preparacion', 'En Transito', 'En Reparto', 'Entregado', 'Fallido', 'Devuelto')
    ),
    CONSTRAINT chk_envio_costo CHECK (costo_envio >= 0),
    CONSTRAINT chk_envio_fechas CHECK (fecha_entrega >= fecha_despacho)
);
