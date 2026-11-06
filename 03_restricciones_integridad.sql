
-- Taller III - Bases de Datos I
-- Sistema de Gestion de Reservas para un Hotel
-- Script 03: Restricciones de integridad

-- Restricciones de la tabla habitacion

ALTER TABLE habitacion
  ADD CONSTRAINT ck_habitacion_tipo
  CHECK (tipo IN ('Sencilla', 'Doble', 'Suite'));

ALTER TABLE habitacion
  ADD CONSTRAINT ck_habitacion_precio
  CHECK (precio_noche > 0);

ALTER TABLE habitacion
  ADD CONSTRAINT ck_habitacion_estado
  CHECK (estado IN ('Disponible', 'Ocupada', 'Mantenimiento'));


-- Restricciones de la tabla reserva

ALTER TABLE reserva
  ADD CONSTRAINT ck_reserva_fechas
  CHECK (fecha_salida > fecha_entrada);

ALTER TABLE reserva
  ADD CONSTRAINT ck_reserva_estado
  CHECK (estado_reserva IN ('Confirmada', 'Cancelada'));


-- Restricciones de la tabla pago

ALTER TABLE pago
  ADD CONSTRAINT ck_pago_monto
  CHECK (monto > 0);

ALTER TABLE pago
  ADD CONSTRAINT ck_pago_metodo
  CHECK (metodo IN ('Tarjeta', 'Efectivo', 'Transferencia'));
