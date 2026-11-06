
-- Taller III - Bases de Datos I
-- Sistema de Gestion de Reservas para un Hotel
-- Script 01: Creacion inicial de tablas

-- Tabla cliente
CREATE TABLE cliente (
  id_cliente SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  correo VARCHAR(120),
  telefono VARCHAR(20),
  nacionalidad VARCHAR(60)
);

-- Tabla habitacion
CREATE TABLE habitacion (
  id_habitacion SERIAL PRIMARY KEY,
  numero VARCHAR(10) NOT NULL UNIQUE,
  tipo VARCHAR(20) NOT NULL,
  precio_noche NUMERIC(10,2) NOT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'Disponible'
);

-- Tabla reserva
CREATE TABLE reserva (
  id_reserva SERIAL PRIMARY KEY,
  id_cliente INTEGER NOT NULL,
  id_habitacion INTEGER NOT NULL,
  fecha_entrada DATE NOT NULL,
  fecha_salida DATE NOT NULL,
  FOREIGN KEY (id_cliente)
    REFERENCES cliente(id_cliente)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  FOREIGN KEY (id_habitacion)
    REFERENCES habitacion(id_habitacion)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

-- Tabla pago
CREATE TABLE pago (
  id_pago SERIAL PRIMARY KEY,
  id_reserva INTEGER NOT NULL,
  fecha_pago DATE NOT NULL,
  monto NUMERIC(10,2) NOT NULL,
  metodo VARCHAR(20) NOT NULL,
  FOREIGN KEY (id_reserva)
    REFERENCES reserva(id_reserva)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);