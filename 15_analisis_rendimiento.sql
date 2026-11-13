
-- Taller III - Bases de Datos I
-- Sistema de Gestion de Reservas para un Hotel
-- Script 15: Analisis del rendimiento de consultas SQL

-- ANALISIS 1
-- Consulta 10: Clientes con mayor gasto acumulado.
-- Se conserva la consulta original.
-- EXPLAIN ANALYZE permite evaluar su ejecucion.

EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
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
