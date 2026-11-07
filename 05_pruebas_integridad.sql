
-- Taller III - Bases de Datos I
-- Sistema de Gestion de Reservas para un Hotel
-- Script 05: Pruebas de integridad

-- PRUEBA POSITIVA 1
-- Verificar que PostgreSQL permite insertar
-- un cliente con datos validos.

BEGIN;

INSERT INTO cliente (
  nombre,
  correo,
  telefono,
  nacionalidad
)
VALUES (
  'Carlos Ramirez',
  'carlos.prueba@example.com',
  '3001234567',
  'Colombia'
)
RETURNING id_cliente, nombre, correo, telefono, nacionalidad;

-- Finalizar la prueba sin conservar los datos.
ROLLBACK;

-- Verificar que el cliente de prueba no permanezca.
SELECT COUNT(*) AS clientes_prueba_restantes
FROM cliente
WHERE correo = 'carlos.prueba@example.com';

-- PRUEBA POSITIVA 2
-- Verificar que PostgreSQL permite registrar
-- una habitacion con datos validos.

BEGIN;

INSERT INTO habitacion (
  numero,
  tipo,
  precio_noche,
  estado
)
VALUES (
  'PR901',
  'Doble',
  220000.00,
  'Disponible'
)
RETURNING id_habitacion, numero, tipo,
          precio_noche, estado;

-- Revertir la insercion de prueba.
ROLLBACK;

-- Comprobar que no quedaron registros.
SELECT COUNT(*) AS habitaciones_prueba_restantes
FROM habitacion
WHERE numero = 'PR901';


-- PRUEBA POSITIVA 3
-- Registrar una reserva valida con cliente y habitacion existentes.

BEGIN;

-- Crear un cliente temporal.
INSERT INTO cliente (
  nombre, correo, telefono, nacionalidad
)
VALUES (
  'Laura Torres',
  'laura.reserva.prueba@example.com',
  '3009876543',
  'Colombia'
);

-- Crear una habitacion temporal.
INSERT INTO habitacion (
  numero, tipo, precio_noche, estado
)
VALUES (
  'PR902',
  'Suite',
  350000.00,
  'Disponible'
);

-- Registrar una reserva utilizando las claves
-- de los registros creados anteriormente.
INSERT INTO reserva (
  id_cliente,
  id_habitacion,
  fecha_entrada,
  fecha_salida
)
SELECT
  c.id_cliente,
  h.id_habitacion,
  TO_DATE('20/11/2026', 'DD/MM/YYYY'),
  TO_DATE('23/11/2026', 'DD/MM/YYYY')
FROM cliente c
CROSS JOIN habitacion h
WHERE c.correo = 'laura.reserva.prueba@example.com'
  AND h.numero = 'PR902'
RETURNING
  id_reserva,
  id_cliente,
  id_habitacion,
  TO_CHAR(fecha_entrada, 'DD/MM/YYYY') AS fecha_entrada,
  TO_CHAR(fecha_salida, 'DD/MM/YYYY') AS fecha_salida,
  estado_reserva;

-- Revertir todos los registros temporales.
ROLLBACK;

-- Comprobar que la prueba no dejo registros.
SELECT
  (SELECT COUNT(*) FROM cliente
   WHERE correo = 'laura.reserva.prueba@example.com')
    AS clientes_restantes,

  (SELECT COUNT(*) FROM habitacion
   WHERE numero = 'PR902')
    AS habitaciones_restantes,

  (SELECT COUNT(*) FROM reserva
   WHERE id_habitacion IN (
     SELECT id_habitacion
     FROM habitacion
     WHERE numero = 'PR902'
   )) AS reservas_restantes;


-- PRUEBA NEGATIVA 1
-- Intentar registrar una reserva con fechas incorrectas.

BEGIN;

-- Crear un cliente temporal.
INSERT INTO cliente (
  nombre, correo, telefono, nacionalidad
)
VALUES (
  'Diego Mendoza',
  'diego.fecha.prueba@example.com',
  '3001112233',
  'Colombia'
);

-- Crear una habitacion temporal.
INSERT INTO habitacion (
  numero, tipo, precio_noche, estado
)
VALUES (
  'PR903',
  'Sencilla',
  150000.00,
  'Disponible'
);

-- Intentar crear una reserva con salida
-- anterior a la entrada. Debe generar un error.
INSERT INTO reserva (
  id_cliente,
  id_habitacion,
  fecha_entrada,
  fecha_salida
)
SELECT
  c.id_cliente,
  h.id_habitacion,
  TO_DATE('25/11/2026', 'DD/MM/YYYY'),
  TO_DATE('23/11/2026', 'DD/MM/YYYY')
FROM cliente c
CROSS JOIN habitacion h
WHERE c.correo = 'diego.fecha.prueba@example.com'
  AND h.numero = 'PR903';

-- Revertir la transaccion despues del error.
ROLLBACK;

-- Comprobar que los datos temporales no permanezcan.
SELECT
  (SELECT COUNT(*) FROM cliente
   WHERE correo = 'diego.fecha.prueba@example.com')
    AS clientes_restantes,
  (SELECT COUNT(*) FROM habitacion
   WHERE numero = 'PR903')
    AS habitaciones_restantes;


-- PRUEBA NEGATIVA 2
-- Intentar registrar un pago con monto negativo.

BEGIN;

-- Crear un cliente temporal.
INSERT INTO cliente (
  nombre, correo, telefono, nacionalidad
)
VALUES (
  'Andres Gomez',
  'andres.pago.prueba@example.com',
  '3002223344',
  'Colombia'
);

-- Crear una habitacion temporal.
INSERT INTO habitacion (
  numero, tipo, precio_noche, estado
)
VALUES (
  'PR904',
  'Doble',
  200000.00,
  'Disponible'
);

-- Registrar una reserva valida.
INSERT INTO reserva (
  id_cliente,
  id_habitacion,
  fecha_entrada,
  fecha_salida
)
SELECT
  c.id_cliente,
  h.id_habitacion,
  TO_DATE('03/12/2026', 'DD/MM/YYYY'),
  TO_DATE('06/12/2026', 'DD/MM/YYYY')
FROM cliente c
CROSS JOIN habitacion h
WHERE c.correo = 'andres.pago.prueba@example.com'
  AND h.numero = 'PR904'
RETURNING id_reserva, id_cliente, id_habitacion;

-- Intentar insertar un pago negativo.
-- PostgreSQL debe rechazar esta operacion.
INSERT INTO pago (
  id_reserva,
  fecha_pago,
  monto,
  metodo
)
SELECT
  r.id_reserva,
  TO_DATE('03/12/2026', 'DD/MM/YYYY'),
  -50000.00,
  'Transferencia'
FROM reserva r
JOIN cliente c ON c.id_cliente = r.id_cliente
JOIN habitacion h ON h.id_habitacion = r.id_habitacion
WHERE c.correo = 'andres.pago.prueba@example.com'
  AND h.numero = 'PR904';

-- Revertir la transaccion.
ROLLBACK;

-- Comprobar que no quedaron datos temporales.
SELECT
  (SELECT COUNT(*) FROM cliente
   WHERE correo = 'andres.pago.prueba@example.com')
    AS clientes_restantes,

  (SELECT COUNT(*) FROM habitacion
   WHERE numero = 'PR904')
    AS habitaciones_restantes,

  (SELECT COUNT(*) FROM pago
   WHERE monto = -50000.00)
    AS pagos_invalidos;


-- PRUEBA NEGATIVA 3
-- Comprobar que PostgreSQL rechaza
-- reservas confirmadas superpuestas.

BEGIN;

-- Crear un cliente temporal.
INSERT INTO cliente (
  nombre, correo, telefono, nacionalidad
)
VALUES (
  'Camila Herrera',
  'camila.superposicion@example.com',
  '3003334455',
  'Colombia'
);

-- Crear una habitacion temporal.
INSERT INTO habitacion (
  numero, tipo, precio_noche, estado
)
VALUES (
  'PR905',
  'Doble',
  250000.00,
  'Disponible'
);

-- Primera reserva: debe ser aceptada.
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
  TO_DATE('10/12/2026', 'DD/MM/YYYY'),
  TO_DATE('13/12/2026', 'DD/MM/YYYY'),
  'Confirmada'
FROM cliente c
CROSS JOIN habitacion h
WHERE c.correo = 'camila.superposicion@example.com'
  AND h.numero = 'PR905'
RETURNING
  id_reserva,
  id_habitacion,
  TO_CHAR(fecha_entrada, 'DD/MM/YYYY') AS fecha_entrada,
  TO_CHAR(fecha_salida, 'DD/MM/YYYY') AS fecha_salida,
  estado_reserva;

-- Segunda reserva: debe ser rechazada
-- porque sus fechas se superponen.
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
  TO_DATE('12/12/2026', 'DD/MM/YYYY'),
  TO_DATE('15/12/2026', 'DD/MM/YYYY'),
  'Confirmada'
FROM cliente c
CROSS JOIN habitacion h
WHERE c.correo = 'camila.superposicion@example.com'
  AND h.numero = 'PR905';

-- Revertir los registros temporales.
ROLLBACK;

-- Verificar que los datos no permanezcan.
SELECT
  (SELECT COUNT(*) FROM cliente
   WHERE correo = 'camila.superposicion@example.com')
    AS clientes_restantes,

  (SELECT COUNT(*) FROM habitacion
   WHERE numero = 'PR905')
    AS habitaciones_restantes,

  (SELECT COUNT(*) FROM reserva r
   JOIN habitacion h
     ON h.id_habitacion = r.id_habitacion
   WHERE h.numero = 'PR905')
    AS reservas_restantes;
