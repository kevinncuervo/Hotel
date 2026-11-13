
-- Taller III - Bases de Datos I
-- Sistema de Gestion de Reservas para un Hotel
-- Script 04: Control de reservas superpuestas

-- Habilitar comparaciones de igualdad mediante GiST

BEGIN;

CREATE EXTENSION IF NOT EXISTS btree_gist;

-- Impedir reservas confirmadas superpuestas
-- para una misma habitacion

ALTER TABLE reserva
  ADD CONSTRAINT ex_reserva_sin_superposicion
  EXCLUDE USING gist (
    id_habitacion WITH =,
    daterange(fecha_entrada, fecha_salida, '[)') WITH &&
  )
  WHERE (estado_reserva = 'Confirmada');

COMMIT;
