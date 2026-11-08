
-- Taller III - Bases de Datos I
-- Sistema de Gestion de Reservas para un Hotel
-- Script 08: Consultas basicas

-- CONSULTA 1
-- Listar todas las habitaciones disponibles.

SELECT
  id_habitacion,
  numero,
  tipo,
  precio_noche,
  estado
FROM habitacion
WHERE estado = 'Disponible'
ORDER BY numero ASC;

-- CONSULTA 2
-- Mostrar las reservas activas segun la fecha actual.

SELECT
  r.id_reserva,
  c.nombre AS cliente,
  h.numero AS habitacion,
  TO_CHAR(r.fecha_entrada, 'DD/MM/YYYY') AS fecha_entrada,
  TO_CHAR(r.fecha_salida, 'DD/MM/YYYY') AS fecha_salida,
  r.estado_reserva,
  TO_CHAR(CURRENT_DATE, 'DD/MM/YYYY') AS fecha_consulta
FROM reserva r
JOIN cliente c
  ON c.id_cliente = r.id_cliente
JOIN habitacion h
  ON h.id_habitacion = r.id_habitacion
WHERE r.estado_reserva = 'Confirmada'
  AND r.fecha_entrada <= CURRENT_DATE
  AND r.fecha_salida > CURRENT_DATE
ORDER BY h.numero ASC;


-- CONSULTA 3
-- Mostrar reservas con mas de tres noches de estadia.

SELECT
  r.id_reserva,
  c.nombre AS cliente,
  h.numero AS habitacion,
  h.tipo AS tipo_habitacion,
  TO_CHAR(r.fecha_entrada, 'DD/MM/YYYY') AS fecha_entrada,
  TO_CHAR(r.fecha_salida, 'DD/MM/YYYY') AS fecha_salida,
  (r.fecha_salida - r.fecha_entrada) AS total_noches,
  r.estado_reserva
FROM reserva r
JOIN cliente c
  ON c.id_cliente = r.id_cliente
JOIN habitacion h
  ON h.id_habitacion = r.id_habitacion
WHERE (r.fecha_salida - r.fecha_entrada) > 3
ORDER BY total_noches DESC, r.fecha_entrada ASC;
