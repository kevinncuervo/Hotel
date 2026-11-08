
-- Taller III - Bases de Datos I
-- Sistema de Gestion de Reservas para un Hotel
-- Script 12: Vistas del hotel

-- VISTA 1
-- Reservas activas con datos del cliente y habitacion.

CREATE OR REPLACE VIEW vista_reservas_activas AS
SELECT
  r.id_reserva,
  c.nombre AS cliente,
  c.nacionalidad,
  h.numero AS habitacion,
  h.tipo AS tipo_habitacion,
  r.fecha_entrada,
  r.fecha_salida,
  r.estado_reserva
FROM reserva r
JOIN cliente c
  ON c.id_cliente = r.id_cliente
JOIN habitacion h
  ON h.id_habitacion = r.id_habitacion
WHERE r.estado_reserva = 'Confirmada'
  AND CURRENT_DATE >= r.fecha_entrada
  AND CURRENT_DATE < r.fecha_salida;
-- VERIFICACION DE LA VISTA 1

SELECT
  id_reserva,
  cliente,
  nacionalidad,
  habitacion,
  tipo_habitacion,
  TO_CHAR(fecha_entrada, 'DD/MM/YYYY') AS fecha_entrada,
  TO_CHAR(fecha_salida, 'DD/MM/YYYY') AS fecha_salida,
  estado_reserva
FROM vista_reservas_activas
ORDER BY habitacion ASC;

-- VISTA 2
-- Ingresos mensuales del hotel.

CREATE OR REPLACE VIEW vista_ingresos_mensuales AS
SELECT
  DATE_TRUNC('month', p.fecha_pago)::DATE AS inicio_mes,
  TO_CHAR(
    DATE_TRUNC('month', p.fecha_pago),
    'MM/YYYY'
  ) AS mes,
  COUNT(p.id_pago) AS cantidad_pagos,
  SUM(p.monto) AS total_ingresos
FROM pago p
GROUP BY DATE_TRUNC('month', p.fecha_pago);

-- VERIFICACION DE LA VISTA 2

SELECT
  mes,
  cantidad_pagos,
  total_ingresos
FROM vista_ingresos_mensuales
ORDER BY inicio_mes ASC;

