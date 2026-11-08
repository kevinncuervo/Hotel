
-- Taller III - Bases de Datos I
-- Sistema de Gestion de Reservas para un Hotel
-- Script 13: Transaccion y propiedades ACID

-- PRUEBA 1: Transaccion con ROLLBACK
-- Registro de una reserva y su pago inicial.

BEGIN;

WITH nueva_reserva AS (
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
    TO_DATE('15/01/2027', 'DD/MM/YYYY'),
    TO_DATE('18/01/2027', 'DD/MM/YYYY'),
    'Confirmada'
  FROM cliente c
  CROSS JOIN habitacion h
  WHERE c.id_cliente = 11
    AND c.nombre = 'Ana Duarte'
    AND h.numero = '101'
  RETURNING id_reserva
)
INSERT INTO pago (
  id_reserva,
  fecha_pago,
  monto,
  metodo
)
SELECT
  id_reserva,
  TO_DATE('15/01/2027', 'DD/MM/YYYY'),
  200000,
  'Tarjeta'
FROM nueva_reserva;

-- VERIFICACION ANTES DEL ROLLBACK

SELECT
  r.id_reserva,
  c.nombre AS cliente,
  h.numero AS habitacion,
  TO_CHAR(r.fecha_entrada, 'DD/MM/YYYY')
    AS fecha_entrada,
  TO_CHAR(r.fecha_salida, 'DD/MM/YYYY')
    AS fecha_salida,
  (r.fecha_salida - r.fecha_entrada)
    * h.precio_noche AS valor_reserva,
  p.monto AS pago_inicial,
  p.metodo
FROM reserva r
JOIN cliente c
  ON c.id_cliente = r.id_cliente
JOIN habitacion h
  ON h.id_habitacion = r.id_habitacion
JOIN pago p
  ON p.id_reserva = r.id_reserva
WHERE c.id_cliente = 11
  AND h.numero = '101'
  AND r.fecha_entrada =
    TO_DATE('15/01/2027', 'DD/MM/YYYY');

-- CANCELAR LA TRANSACCION DE PRUEBA

ROLLBACK;

-- VERIFICAR QUE NO QUEDARON REGISTROS

SELECT
  COUNT(DISTINCT r.id_reserva) AS reservas_prueba,
  COUNT(p.id_pago) AS pagos_prueba
FROM reserva r
JOIN habitacion h
  ON h.id_habitacion = r.id_habitacion
LEFT JOIN pago p
  ON p.id_reserva = r.id_reserva
WHERE r.id_cliente = 11
  AND h.numero = '101'
  AND r.fecha_entrada =
    TO_DATE('15/01/2027', 'DD/MM/YYYY');

-- PRUEBA 2
-- Transaccion con COMMIT.
-- Registro definitivo de una reserva y su pago inicial.

BEGIN;

WITH nueva_reserva AS (
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
    TO_DATE('15/01/2027', 'DD/MM/YYYY'),
    TO_DATE('18/01/2027', 'DD/MM/YYYY'),
    'Confirmada'
  FROM cliente c
  CROSS JOIN habitacion h
  WHERE c.id_cliente = 11
    AND c.nombre = 'Ana Duarte'
    AND h.numero = '101'
  RETURNING id_reserva
)
INSERT INTO pago (
  id_reserva,
  fecha_pago,
  monto,
  metodo
)
SELECT
  id_reserva,
  TO_DATE('15/01/2027', 'DD/MM/YYYY'),
  200000,
  'Tarjeta'
FROM nueva_reserva;

COMMIT;

-- VERIFICACION DESPUES DEL COMMIT

SELECT
  r.id_reserva,
  c.nombre AS cliente,
  h.numero AS habitacion,
  TO_CHAR(r.fecha_entrada, 'DD/MM/YYYY')
    AS fecha_entrada,
  TO_CHAR(r.fecha_salida, 'DD/MM/YYYY')
    AS fecha_salida,
  (r.fecha_salida - r.fecha_entrada)
    * h.precio_noche AS valor_reserva,
  p.monto AS pago_inicial,
  p.metodo
FROM reserva r
JOIN cliente c
  ON c.id_cliente = r.id_cliente
JOIN habitacion h
  ON h.id_habitacion = r.id_habitacion
JOIN pago p
  ON p.id_reserva = r.id_reserva
WHERE c.id_cliente = 11
  AND h.numero = '101'
  AND r.fecha_entrada =
    TO_DATE('15/01/2027', 'DD/MM/YYYY');

-- LIMPIEZA CONTROLADA
-- Eliminar la reserva 39 y su pago de prueba.

BEGIN;

-- Eliminar primero el pago asociado.

DELETE FROM pago
WHERE id_reserva = 39
  AND monto = 200000
  AND metodo = 'Tarjeta'
RETURNING id_pago, id_reserva, monto, metodo;

-- Eliminar despues la reserva de prueba.

DELETE FROM reserva
WHERE id_reserva = 39
  AND id_cliente = 11
  AND fecha_entrada =
    TO_DATE('15/01/2027', 'DD/MM/YYYY')
  AND fecha_salida =
    TO_DATE('18/01/2027', 'DD/MM/YYYY')
RETURNING id_reserva, id_cliente, id_habitacion;

-- Confirmar la eliminacion controlada.

COMMIT;

-- Verificar los registros originales.

SELECT
  (SELECT COUNT(*) FROM cliente) AS clientes,
  (SELECT COUNT(*) FROM habitacion) AS habitaciones,
  (SELECT COUNT(*) FROM reserva) AS reservas,
  (SELECT COUNT(*) FROM pago) AS pagos;
-- IMPORTANTE:
-- Este script documenta pruebas de transacciones ACID.
-- Los bloques deben ejecutarse individualmente y en orden.
-- No ejecutar todo el archivo de forma automatica.
-- La limpieza utiliza el id_reserva 39, generado
-- durante la ejecucion documentada del taller.