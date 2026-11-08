
-- Taller III - Bases de Datos I
-- Sistema de Gestion de Reservas para un Hotel
-- Script 09: Consultas mediante JOIN

-- CONSULTA 4
-- Mostrar los clientes que reservaron una Suite.

SELECT DISTINCT
  c.id_cliente,
  c.nombre AS cliente,
  c.nacionalidad
FROM cliente c
JOIN reserva r
  ON r.id_cliente = c.id_cliente
JOIN habitacion h
  ON h.id_habitacion = r.id_habitacion
WHERE h.tipo = 'Suite'
ORDER BY c.nombre ASC;


-- CONSULTA 5
-- Mostrar los clientes colombianos
-- que realizaron al menos una reserva.

SELECT DISTINCT
  c.id_cliente,
  c.nombre AS cliente,
  c.nacionalidad
FROM cliente c
JOIN reserva r
  ON r.id_cliente = c.id_cliente
WHERE c.nacionalidad = 'Colombia'
ORDER BY c.nombre ASC;
