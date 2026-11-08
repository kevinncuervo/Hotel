
-- Taller III - Bases de Datos I
-- Sistema de Gestion de Reservas para un Hotel
-- Script 11: Subconsultas y comparaciones

-- CONSULTA 16
-- Habitaciones con precio superior al promedio.

SELECT
  h.id_habitacion,
  h.numero AS habitacion,
  h.tipo,
  h.precio_noche,
  h.estado,
  (
    SELECT ROUND(AVG(precio_noche), 2)
    FROM habitacion
  ) AS precio_promedio
FROM habitacion h
WHERE h.precio_noche > (
  SELECT AVG(precio_noche)
  FROM habitacion
)
ORDER BY h.precio_noche DESC;

-- CONSULTA 17
-- Cliente que realizo la reserva mas costosa.

SELECT
  c.id_cliente,
  c.nombre AS cliente,
  h.numero AS habitacion,
  h.tipo AS tipo_habitacion,
  TO_CHAR(r.fecha_entrada, 'DD/MM/YYYY') AS fecha_entrada,
  TO_CHAR(r.fecha_salida, 'DD/MM/YYYY') AS fecha_salida,
  (r.fecha_salida - r.fecha_entrada) AS total_noches,
  h.precio_noche,
  (r.fecha_salida - r.fecha_entrada)
    * h.precio_noche AS valor_total_reserva,
  r.estado_reserva
FROM reserva r
JOIN cliente c
  ON c.id_cliente = r.id_cliente
JOIN habitacion h
  ON h.id_habitacion = r.id_habitacion
WHERE (r.fecha_salida - r.fecha_entrada)
    * h.precio_noche = (
  SELECT MAX(
    (r2.fecha_salida - r2.fecha_entrada)
      * h2.precio_noche
  )
  FROM reserva r2
  JOIN habitacion h2
    ON h2.id_habitacion = r2.id_habitacion
)
ORDER BY c.nombre ASC;

-- CONSULTA 18
-- Mostrar las habitaciones que nunca han sido reservadas.

SELECT
  h.id_habitacion,
  h.numero AS habitacion,
  h.tipo,
  h.precio_noche,
  h.estado
FROM habitacion h
WHERE NOT EXISTS (
  SELECT 1
  FROM reserva r
  WHERE r.id_habitacion = h.id_habitacion
)
ORDER BY h.numero ASC;

-- CONSULTA 19
-- Reservas que no tienen pagos registrados.

SELECT
  r.id_reserva,
  c.nombre AS cliente,
  h.numero AS habitacion,
  h.tipo AS tipo_habitacion,
  TO_CHAR(r.fecha_entrada, 'DD/MM/YYYY')
    AS fecha_entrada,
  TO_CHAR(r.fecha_salida, 'DD/MM/YYYY')
    AS fecha_salida,
  (r.fecha_salida - r.fecha_entrada)
    AS total_noches,
  (r.fecha_salida - r.fecha_entrada)
    * h.precio_noche AS valor_reserva,
  r.estado_reserva
FROM reserva r
JOIN cliente c
  ON c.id_cliente = r.id_cliente
JOIN habitacion h
  ON h.id_habitacion = r.id_habitacion
WHERE NOT EXISTS (
  SELECT 1
  FROM pago p
  WHERE p.id_reserva = r.id_reserva
)
ORDER BY r.id_reserva ASC;

-- CONSULTA 20
-- Habitacion mas costosa reservada por cada cliente.

SELECT DISTINCT
  c.id_cliente,
  c.nombre AS cliente,
  h.numero AS habitacion,
  h.tipo AS tipo_habitacion,
  h.precio_noche AS precio_mas_alto
FROM cliente c
JOIN reserva r
  ON r.id_cliente = c.id_cliente
JOIN habitacion h
  ON h.id_habitacion = r.id_habitacion
WHERE h.precio_noche = (
  SELECT MAX(h2.precio_noche)
  FROM reserva r2
  JOIN habitacion h2
    ON h2.id_habitacion = r2.id_habitacion
  WHERE r2.id_cliente = c.id_cliente
)
ORDER BY
  c.nombre ASC,
  h.numero ASC;
