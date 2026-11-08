
-- Taller III - Bases de Datos I
-- Sistema de Gestion de Reservas para un Hotel
-- Script 10: Consultas de agrupacion

-- CONSULTA 6
-- Mostrar las habitaciones reservadas
-- mas de cinco veces.

SELECT
  h.id_habitacion,
  h.numero AS habitacion,
  h.tipo,
  COUNT(r.id_reserva) AS total_reservas
FROM habitacion h
JOIN reserva r
  ON r.id_habitacion = h.id_habitacion
GROUP BY
  h.id_habitacion,
  h.numero,
  h.tipo
HAVING COUNT(r.id_reserva) > 5
ORDER BY total_reservas DESC;


-- CONSULTA 7
-- Total de reservas y montos por tipo de habitacion.

WITH resumen_reservas AS (
  SELECT
    h.tipo,
    r.id_reserva,
    r.estado_reserva,
    (r.fecha_salida - r.fecha_entrada)
      * h.precio_noche AS valor_estancia,
    COALESCE((
      SELECT SUM(p.monto)
      FROM pago p
      WHERE p.id_reserva = r.id_reserva
    ), 0) AS monto_pagado
  FROM reserva r
  JOIN habitacion h
    ON h.id_habitacion = r.id_habitacion
)
SELECT
  tipo AS tipo_habitacion,
  COUNT(*) AS total_reservas,
  COUNT(*) FILTER (
    WHERE estado_reserva = 'Confirmada'
  ) AS confirmadas,
  COUNT(*) FILTER (
    WHERE estado_reserva = 'Cancelada'
  ) AS canceladas,
  COALESCE(SUM(valor_estancia) FILTER (
    WHERE estado_reserva = 'Confirmada'
  ), 0) AS monto_total_estancias,
  SUM(monto_pagado) AS monto_total_recaudado
FROM resumen_reservas
GROUP BY tipo
ORDER BY total_reservas DESC, tipo ASC;


-- CONSULTA 8
-- Obtener el total de ingresos generados por mes.

SELECT
  TO_CHAR(
    DATE_TRUNC('month', fecha_pago),
    'MM/YYYY'
  ) AS mes,
  COUNT(*) AS cantidad_pagos,
  SUM(monto) AS total_ingresos
FROM pago
GROUP BY DATE_TRUNC('month', fecha_pago)
ORDER BY DATE_TRUNC('month', fecha_pago) ASC;

-- CONSULTA 9
-- Numero de reservas realizadas por cada cliente.

SELECT
  c.id_cliente,
  c.nombre AS cliente,
  c.nacionalidad,
  COUNT(r.id_reserva) AS total_reservas,
  COUNT(r.id_reserva) FILTER (
    WHERE r.estado_reserva = 'Confirmada'
  ) AS reservas_confirmadas,
  COUNT(r.id_reserva) FILTER (
    WHERE r.estado_reserva = 'Cancelada'
  ) AS reservas_canceladas
FROM cliente c
LEFT JOIN reserva r
  ON r.id_cliente = c.id_cliente
GROUP BY
  c.id_cliente,
  c.nombre,
  c.nacionalidad
ORDER BY total_reservas DESC, c.nombre ASC;

-- CONSULTA 10
-- Clientes con el mayor gasto total acumulado.

SELECT
  c.id_cliente,
  c.nombre AS cliente,
  c.nacionalidad,
  COUNT(DISTINCT r.id_reserva) AS reservas_con_pago,
  COUNT(p.id_pago) AS cantidad_pagos,
  SUM(p.monto) AS gasto_total_acumulado
FROM cliente c
JOIN reserva r
  ON r.id_cliente = c.id_cliente
JOIN pago p
  ON p.id_reserva = r.id_reserva
GROUP BY
  c.id_cliente,
  c.nombre,
  c.nacionalidad
ORDER BY
  gasto_total_acumulado DESC,
  c.nombre ASC
LIMIT 5;

-- CONSULTA 11
-- Clientes que utilizaron mas de un metodo de pago.

SELECT
  c.id_cliente,
  c.nombre AS cliente,
  COUNT(DISTINCT p.metodo) AS cantidad_metodos,
  STRING_AGG(
    DISTINCT p.metodo,
    ', ' ORDER BY p.metodo
  ) AS metodos_utilizados,
  COUNT(p.id_pago) AS cantidad_pagos,
  SUM(p.monto) AS total_pagado
FROM cliente c
JOIN reserva r
  ON r.id_cliente = c.id_cliente
JOIN pago p
  ON p.id_reserva = r.id_reserva
GROUP BY
  c.id_cliente,
  c.nombre
HAVING COUNT(DISTINCT p.metodo) > 1
ORDER BY
  cantidad_metodos DESC,
  c.nombre ASC;

-- CONSULTA 12
-- Promedio de noches reservadas por tipo de habitacion.

SELECT
  h.tipo AS tipo_habitacion,
  COUNT(r.id_reserva) AS total_reservas,
  SUM(
    r.fecha_salida - r.fecha_entrada
  ) AS total_noches,
  ROUND(
    AVG(r.fecha_salida - r.fecha_entrada),
    2
  ) AS promedio_noches
FROM habitacion h
LEFT JOIN reserva r
  ON r.id_habitacion = h.id_habitacion
GROUP BY h.tipo
ORDER BY promedio_noches DESC;

-- CONSULTA 13
-- Tres clientes con mas noches reservadas en total.

SELECT
  c.id_cliente,
  c.nombre AS cliente,
  c.nacionalidad,
  COUNT(r.id_reserva) AS total_reservas,
  SUM(
    r.fecha_salida - r.fecha_entrada
  ) AS total_noches
FROM cliente c
JOIN reserva r
  ON r.id_cliente = c.id_cliente
WHERE r.estado_reserva = 'Confirmada'
GROUP BY
  c.id_cliente,
  c.nombre,
  c.nacionalidad
ORDER BY
  total_noches DESC,
  c.nombre ASC
LIMIT 3;

-- CONSULTA 14
-- Ingreso total por cada metodo de pago.

SELECT
  metodo AS metodo_pago,
  COUNT(id_pago) AS cantidad_pagos,
  SUM(monto) AS ingreso_total,
  ROUND(
    AVG(monto),
    2
  ) AS promedio_pago
FROM pago
GROUP BY metodo
ORDER BY ingreso_total DESC;

-- CONSULTA 15
-- Clientes que reservaron mas de una habitacion diferente.

SELECT
  c.id_cliente,
  c.nombre AS cliente,
  COUNT(DISTINCT r.id_habitacion)
    AS habitaciones_diferentes,
  COUNT(r.id_reserva) AS total_reservas,
  STRING_AGG(
    DISTINCT h.numero,
    ', ' ORDER BY h.numero
  ) AS habitaciones_reservadas
FROM cliente c
JOIN reserva r
  ON r.id_cliente = c.id_cliente
JOIN habitacion h
  ON h.id_habitacion = r.id_habitacion
GROUP BY
  c.id_cliente,
  c.nombre
HAVING COUNT(DISTINCT r.id_habitacion) > 1
ORDER BY
  habitaciones_diferentes DESC,
  c.nombre ASC;
