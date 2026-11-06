
-- Taller III - Bases de Datos I
-- Sistema de Gestion de Reservas para un Hotel
-- Script 02: Modificacion de la tabla reserva

-- Agregar el estado de la reserva
ALTER TABLE reserva
  ADD COLUMN estado_reserva VARCHAR(20)
  NOT NULL DEFAULT 'Confirmada';
