
-- Taller III - Bases de Datos I
-- Sistema de Gestion de Reservas para un Hotel
-- Script 07: Operaciones DML

-- ESCENARIO 1: CAMBIO DE ESTADO DE UNA HABITACION

-- Consultar el estado original.
SELECT
  id_habitacion,
  numero,
  tipo,
  estado
FROM habitacion
WHERE numero = '109';

-- Iniciar una transaccion.
BEGIN;

-- Actualizar la habitacion 109.
UPDATE habitacion
SET estado = 'Disponible'
WHERE numero = '109'
  AND estado = 'Mantenimiento'
RETURNING
  id_habitacion,
  numero,
  tipo,
  estado;

-- Revertir el cambio para conservar
-- los datos sinteticos originales.
ROLLBACK;

-- Verificar el estado despues del ROLLBACK.
SELECT
  id_habitacion,
  numero,
  tipo,
  estado
FROM habitacion
WHERE numero = '109';


-- ESCENARIO 2: REGISTRAR UN NUEVO PAGO

-- Verificar la reserva y su valor pendiente.
SELECT
  r.id_reserva,
  h.numero AS habitacion,
  TO_CHAR(r.fecha_entrada, 'DD/MM/YYYY') AS entrada,
  (r.fecha_salida - r.fecha_entrada)
    * h.precio_noche AS total_estancia,
  COALESCE(SUM(p.monto), 0) AS total_pagado
FROM reserva r
JOIN habitacion h
  ON h.id_habitacion = r.id_habitacion
LEFT JOIN pago p
  ON p.id_reserva = r.id_reserva
WHERE h.numero = '103'
  AND r.fecha_entrada = TO_DATE('13/11/2026', 'DD/MM/YYYY')
  AND r.estado_reserva = 'Confirmada'
GROUP BY
  r.id_reserva,
  h.numero,
  r.fecha_entrada,
  r.fecha_salida,
  h.precio_noche;

-- Iniciar la transaccion.
BEGIN;

-- Registrar un pago parcial.
INSERT INTO pago (
  id_reserva,
  fecha_pago,
  monto,
  metodo
)
SELECT
  r.id_reserva,
  TO_DATE('13/11/2026', 'DD/MM/YYYY'),
  500000.00,
  'Transferencia'
FROM reserva r
JOIN habitacion h
  ON h.id_habitacion = r.id_habitacion
WHERE h.numero = '103'
  AND r.fecha_entrada = TO_DATE('13/11/2026', 'DD/MM/YYYY')
  AND r.estado_reserva = 'Confirmada'
  AND NOT EXISTS (
    SELECT 1
    FROM pago p
    WHERE p.id_reserva = r.id_reserva
  )
RETURNING
  id_pago,
  id_reserva,
  TO_CHAR(fecha_pago, 'DD/MM/YYYY') AS fecha_pago,
  monto,
  metodo;

-- Revertir el pago temporal.
ROLLBACK;

-- Comprobar los pagos despues del ROLLBACK.
SELECT
  r.id_reserva,
  h.numero AS habitacion,
  COUNT(p.id_pago) AS cantidad_pagos,
  COALESCE(SUM(p.monto), 0) AS total_pagado
FROM reserva r
JOIN habitacion h
  ON h.id_habitacion = r.id_habitacion
LEFT JOIN pago p
  ON p.id_reserva = r.id_reserva
WHERE h.numero = '103'
  AND r.fecha_entrada = TO_DATE('13/11/2026', 'DD/MM/YYYY')
GROUP BY r.id_reserva, h.numero;


-- ESCENARIO 3: CANCELAR UNA RESERVA

-- Consultar el estado original y los pagos registrados.
SELECT
  r.id_reserva,
  h.numero AS habitacion,
  TO_CHAR(r.fecha_entrada, 'DD/MM/YYYY') AS fecha_entrada,
  TO_CHAR(r.fecha_salida, 'DD/MM/YYYY') AS fecha_salida,
  r.estado_reserva,
  (
    SELECT COALESCE(SUM(p.monto), 0)
    FROM pago p
    WHERE p.id_reserva = r.id_reserva
  ) AS total_pagado
FROM reserva r
JOIN habitacion h
  ON h.id_habitacion = r.id_habitacion
WHERE h.numero = '103'
  AND r.fecha_entrada = TO_DATE('13/11/2026', 'DD/MM/YYYY');

-- Iniciar la transaccion.
BEGIN;

-- Cambiar el estado de Confirmada a Cancelada.
UPDATE reserva r
SET estado_reserva = 'Cancelada'
FROM habitacion h
WHERE r.id_habitacion = h.id_habitacion
  AND h.numero = '103'
  AND r.fecha_entrada = TO_DATE('13/11/2026', 'DD/MM/YYYY')
  AND r.estado_reserva = 'Confirmada'
  AND NOT EXISTS (
    SELECT 1
    FROM pago p
    WHERE p.id_reserva = r.id_reserva
  )
RETURNING
  r.id_reserva,
  h.numero AS habitacion,
  r.estado_reserva;

-- Revertir la cancelacion temporal.
ROLLBACK;

-- Verificar que la reserva recupero su estado.
SELECT
  r.id_reserva,
  h.numero AS habitacion,
  r.estado_reserva
FROM reserva r
JOIN habitacion h
  ON h.id_habitacion = r.id_habitacion
WHERE h.numero = '103'
  AND r.fecha_entrada = TO_DATE('13/11/2026', 'DD/MM/YYYY');
