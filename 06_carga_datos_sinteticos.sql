
-- Taller III - Bases de Datos I
-- Sistema de Gestion de Reservas para un Hotel
-- Script 06: Carga de datos sinteticos

-- Verificar los registros existentes
-- antes de iniciar la carga de datos.

SELECT
  (SELECT COUNT(*) FROM cliente) AS total_clientes,
  (SELECT COUNT(*) FROM habitacion) AS total_habitaciones,
  (SELECT COUNT(*) FROM reserva) AS total_reservas,
  (SELECT COUNT(*) FROM pago) AS total_pagos;


-- PARTE 3: DATOS SINTETICOS
-- Generacion de 20 clientes ficticios
-- Datos generados con apoyo de inteligencia artificial

BEGIN;

INSERT INTO cliente (
  nombre,
  correo,
  telefono,
  nacionalidad
)
VALUES
  ('Ana Duarte', 'ana.duarte@example.com',
   '3000001001', 'Colombia'),

  ('Luis Cardenas', 'luis.cardenas@example.com',
   '3000001002', 'Colombia'),

  ('Sofia Herrera', 'sofia.herrera@example.com',
   '3000001003', 'Colombia'),

  ('Mateo Rios', 'mateo.rios@example.com',
   '3000001004', 'Colombia'),

  ('Valentina Morales', 'valentina.morales@example.com',
   '3000001005', 'Colombia'),

  ('Daniel Castro', 'daniel.castro@example.com',
   '3000001006', 'Colombia'),

  ('Camila Pardo', 'camila.pardo@example.com',
   '3000001007', 'Colombia'),

  ('Gabriel Vega', 'gabriel.vega@example.com',
   '3000001008', 'Colombia'),

  ('Lucia Salazar', 'lucia.salazar@example.com',
   '0000001009', 'Mexico'),

  ('Pedro Mendoza', 'pedro.mendoza@example.com',
   NULL, 'Peru'),

  ('Elena Soto', 'elena.soto@example.com',
   '0000001011', 'Chile'),

  ('Nicolas Torres', 'nicolas.torres@example.com',
   '0000001012', 'Argentina'),

  ('Paula Rivas', 'paula.rivas@example.com',
   '0000001013', 'Ecuador'),

  ('Andres Acosta', 'andres.acosta@example.com',
   '0000001014', 'Venezuela'),

  ('Beatriz Lima', 'beatriz.lima@example.com',
   NULL, 'Brasil'),

  ('Javier Molina', 'javier.molina@example.com',
   '0000001016', 'Espana'),

  ('Clara Foster', 'clara.foster@example.com',
   '0000001017', 'Estados Unidos'),

  ('Emma Laurent', 'emma.laurent@example.com',
   NULL, 'Canada'),

  ('Mariana Mora', NULL,
   '0000001019', 'Panama'),

  ('Daniela Cruz', 'daniela.cruz@example.com',
   '0000001020', 'Costa Rica')

RETURNING
  id_cliente,
  nombre,
  correo,
  telefono,
  nacionalidad;

-- Confirmar la transaccion despues de revisar
-- que las 20 inserciones sean correctas.
COMMIT;

-- Verificar la cantidad final de clientes.
SELECT COUNT(*) AS total_clientes
FROM cliente;


-- CARGA DE 10 HABITACIONES SINTETICAS
-- Datos generados con apoyo de inteligencia artificial

BEGIN;

INSERT INTO habitacion (
  numero,
  tipo,
  precio_noche,
  estado
)
VALUES
  ('101', 'Sencilla', 140000.00, 'Disponible'),
  ('102', 'Doble', 220000.00, 'Disponible'),
  ('103', 'Suite', 420000.00, 'Disponible'),
  ('104', 'Sencilla', 155000.00, 'Disponible'),
  ('105', 'Doble', 245000.00, 'Disponible'),
  ('106', 'Suite', 480000.00, 'Disponible'),
  ('107', 'Doble', 275000.00, 'Disponible'),
  ('108', 'Sencilla', 165000.00, 'Disponible'),
  ('109', 'Suite', 510000.00, 'Mantenimiento'),
  ('110', 'Doble', 235000.00, 'Ocupada')
RETURNING
  id_habitacion,
  numero,
  tipo,
  precio_noche,
  estado;

-- Confirmar la transaccion despues de revisar los datos.
COMMIT;

-- Verificar la cantidad de habitaciones.
SELECT COUNT(*) AS total_habitaciones
FROM habitacion;


-- CARGA DE 30 RESERVAS SINTETICAS
-- Datos generados con apoyo de inteligencia artificial
-- Fechas de entrada y salida en formato DD/MM/AAAA

BEGIN;

WITH datos (
  nombre_cliente,
  numero_habitacion,
  entrada,
  salida,
  estado
) AS (
  VALUES
  -- Habitacion 101: siete reservas
  ('Ana Duarte', '101', '01/10/2026', '03/10/2026', 'Confirmada'),
  ('Luis Cardenas', '101', '08/10/2026', '10/10/2026', 'Confirmada'),
  ('Sofia Herrera', '101', '15/10/2026', '18/10/2026', 'Confirmada'),
  ('Mateo Rios', '101', '25/10/2026', '28/10/2026', 'Confirmada'),
  ('Ana Duarte', '101', '02/11/2026', '05/11/2026', 'Confirmada'),
  ('Valentina Morales', '101', '12/11/2026', '16/11/2026', 'Confirmada'),
  ('Ana Duarte', '101', '03/12/2026', '07/12/2026', 'Confirmada'),

  -- Habitacion 102
  ('Daniel Castro', '102', '04/10/2026', '08/10/2026', 'Confirmada'),
  ('Camila Pardo', '102', '16/10/2026', '20/10/2026', 'Cancelada'),
  ('Gabriel Vega', '102', '11/11/2026', '14/11/2026', 'Confirmada'),
  ('Daniel Castro', '102', '05/12/2026', '09/12/2026', 'Confirmada'),

  -- Habitacion 103
  ('Lucia Salazar', '103', '05/10/2026', '09/10/2026', 'Confirmada'),
  ('Pedro Mendoza', '103', '13/11/2026', '18/11/2026', 'Confirmada'),
  ('Sofia Herrera', '103', '09/12/2026', '14/12/2026', 'Confirmada'),

  -- Habitacion 104
  ('Elena Soto', '104', '07/10/2026', '11/10/2026', 'Confirmada'),
  ('Nicolas Torres', '104', '10/11/2026', '15/11/2026', 'Confirmada'),
  ('Luis Cardenas', '104', '15/12/2026', '17/12/2026', 'Confirmada'),

  -- Habitacion 105
  ('Paula Rivas', '105', '09/10/2026', '12/10/2026', 'Cancelada'),
  ('Andres Acosta', '105', '12/11/2026', '17/11/2026', 'Confirmada'),
  ('Mateo Rios', '105', '19/12/2026', '23/12/2026', 'Confirmada'),

  -- Habitacion 106
  ('Beatriz Lima', '106', '18/10/2026', '22/10/2026', 'Confirmada'),
  ('Javier Molina', '106', '19/11/2026', '23/11/2026', 'Confirmada'),
  ('Valentina Morales', '106', '23/12/2026', '29/12/2026', 'Confirmada'),

  -- Habitacion 107
  ('Clara Foster', '107', '22/10/2026', '26/10/2026', 'Confirmada'),
  ('Emma Laurent', '107', '18/11/2026', '22/11/2026', 'Confirmada'),
  ('Gabriel Vega', '107', '01/12/2026', '04/12/2026', 'Confirmada'),

  -- Habitacion 108
  ('Mariana Mora', '108', '28/10/2026', '02/11/2026', 'Confirmada'),
  ('Daniela Cruz', '108', '12/12/2026', '16/12/2026', 'Confirmada'),

  -- Habitacion 109 sin reservas: mantenimiento

  -- Habitacion 110
  ('Camila Pardo', '110', '06/11/2026', '10/11/2026', 'Confirmada'),
  ('Andres Acosta', '110', '20/12/2026', '25/12/2026', 'Confirmada')
)

INSERT INTO reserva (
  id_cliente,
  id_habitacion,
  fecha_entrada,
  fecha_salida,
  estado_reserva
)
SELECT
  c.id_cliente,
  h.id_habitacion,
  TO_DATE(d.entrada, 'DD/MM/YYYY'),
  TO_DATE(d.salida, 'DD/MM/YYYY'),
  d.estado
FROM datos d
JOIN cliente c
  ON c.nombre = d.nombre_cliente
JOIN habitacion h
  ON h.numero = d.numero_habitacion
ORDER BY d.numero_habitacion,
         TO_DATE(d.entrada, 'DD/MM/YYYY')
RETURNING
  id_reserva,
  id_cliente,
  id_habitacion,
  TO_CHAR(fecha_entrada, 'DD/MM/YYYY') AS fecha_entrada,
  TO_CHAR(fecha_salida, 'DD/MM/YYYY') AS fecha_salida,
  estado_reserva;

-- Confirmar despues de validar las 30 reservas.
COMMIT;

-- Comprobar el numero de reservas.
SELECT
  COUNT(*) AS total_reservas,
  COUNT(*) FILTER (
    WHERE estado_reserva = 'Confirmada'
  ) AS confirmadas,
  COUNT(*) FILTER (
    WHERE estado_reserva = 'Cancelada'
  ) AS canceladas
FROM reserva;


-- CARGA DE 30 PAGOS SINTETICOS
-- Datos generados con apoyo de inteligencia artificial
-- Fechas en formato DD/MM/AAAA

BEGIN;

WITH datos (
  numero_habitacion,
  entrada_reserva,
  fecha_pago,
  monto,
  metodo
) AS (
  VALUES
  -- Pagos de la habitacion 101
  ('101', '01/10/2026', '01/10/2026', 100000.00, 'Efectivo'),
  ('101', '01/10/2026', '02/10/2026', 180000.00, 'Transferencia'),
  ('101', '08/10/2026', '08/10/2026', 180000.00, 'Tarjeta'),
  ('101', '15/10/2026', '15/10/2026', 420000.00, 'Transferencia'),
  ('101', '25/10/2026', '25/10/2026', 420000.00, 'Efectivo'),
  ('101', '02/11/2026', '02/11/2026', 120000.00, 'Tarjeta'),
  ('101', '02/11/2026', '03/11/2026', 300000.00, 'Transferencia'),
  ('101', '12/11/2026', '12/11/2026', 450000.00, 'Tarjeta'),
  ('101', '03/12/2026', '03/12/2026', 560000.00, 'Transferencia'),

  -- Pagos de la habitacion 102
  ('102', '04/10/2026', '04/10/2026', 400000.00, 'Tarjeta'),
  ('102', '04/10/2026', '05/10/2026', 480000.00, 'Efectivo'),
  ('102', '11/11/2026', '11/11/2026', 300000.00, 'Transferencia'),
  ('102', '05/12/2026', '05/12/2026', 880000.00, 'Tarjeta'),

  -- Pagos de la habitacion 103
  ('103', '05/10/2026', '05/10/2026', 1680000.00, 'Transferencia'),
  ('103', '09/12/2026', '09/12/2026', 2100000.00, 'Tarjeta'),

  -- Pagos de la habitacion 104
  ('104', '07/10/2026', '07/10/2026', 620000.00, 'Efectivo'),
  ('104', '10/11/2026', '10/11/2026', 300000.00, 'Transferencia'),
  ('104', '10/11/2026', '11/11/2026', 475000.00, 'Tarjeta'),
  ('104', '15/12/2026', '15/12/2026', 310000.00, 'Efectivo'),

  -- Pagos de la habitacion 105
  ('105', '12/11/2026', '12/11/2026', 1000000.00, 'Tarjeta'),
  ('105', '19/12/2026', '19/12/2026', 980000.00, 'Transferencia'),

  -- Pagos de la habitacion 106
  ('106', '18/10/2026', '18/10/2026', 1920000.00, 'Tarjeta'),
  ('106', '19/11/2026', '19/11/2026', 1920000.00, 'Efectivo'),
  ('106', '23/12/2026', '23/12/2026', 2880000.00, 'Transferencia'),

  -- Pagos de la habitacion 107
  ('107', '22/10/2026', '22/10/2026', 1100000.00, 'Tarjeta'),
  ('107', '01/12/2026', '01/12/2026', 825000.00, 'Transferencia'),

  -- Pagos de la habitacion 108
  ('108', '28/10/2026', '28/10/2026', 250000.00, 'Efectivo'),
  ('108', '28/10/2026', '29/10/2026', 575000.00, 'Tarjeta'),

  -- Pagos de la habitacion 110
  ('110', '06/11/2026', '06/11/2026', 400000.00, 'Transferencia'),
  ('110', '06/11/2026', '07/11/2026', 540000.00, 'Tarjeta')
)

INSERT INTO pago (
  id_reserva,
  fecha_pago,
  monto,
  metodo
)
SELECT
  r.id_reserva,
  TO_DATE(d.fecha_pago, 'DD/MM/YYYY'),
  d.monto,
  d.metodo
FROM datos d
JOIN habitacion h
  ON h.numero = d.numero_habitacion
JOIN reserva r
  ON r.id_habitacion = h.id_habitacion
  AND r.fecha_entrada = TO_DATE(
    d.entrada_reserva, 'DD/MM/YYYY'
  )
WHERE r.estado_reserva = 'Confirmada'
RETURNING
  id_pago,
  id_reserva,
  TO_CHAR(fecha_pago, 'DD/MM/YYYY') AS fecha_pago,
  monto,
  metodo;

-- Confirmar despues de verificar las 30 inserciones.
COMMIT;

-- Verificar total de pagos y metodos utilizados.
SELECT
  COUNT(*) AS total_pagos,
  COUNT(DISTINCT id_reserva) AS reservas_con_pago,
  COUNT(*) FILTER (
    WHERE metodo = 'Tarjeta'
  ) AS pagos_tarjeta,
  COUNT(*) FILTER (
    WHERE metodo = 'Efectivo'
  ) AS pagos_efectivo,
  COUNT(*) FILTER (
    WHERE metodo = 'Transferencia'
  ) AS pagos_transferencia
FROM pago;
