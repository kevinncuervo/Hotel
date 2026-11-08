-- Taller III - Bases de Datos I
-- Parte 6: NL2SQL con controles de seguridad
-- Pregunta 1: Reservas confirmadas con saldo pendiente
-- Codigo generado mediante ChatGPT
-- Version original sin modificaciones

SELECT
    r.id_reserva,
    c.nombre AS cliente,
    h.numero AS habitacion,
    (r.fecha_salida - r.fecha_entrada) * h.precio_noche AS valor_total,
    COALESCE(p.total_pagado, 0) AS total_pagado,
    (
        (r.fecha_salida - r.fecha_entrada) * h.precio_noche
        - COALESCE(p.total_pagado, 0)
    ) AS saldo_pendiente
FROM reserva r
INNER JOIN cliente c
    ON r.id_cliente = c.id_cliente
INNER JOIN habitacion h
    ON r.id_habitacion = h.id_habitacion
LEFT JOIN (
    SELECT
        id_reserva,
        SUM(monto) AS total_pagado
    FROM pago
    GROUP BY id_reserva
) p
    ON r.id_reserva = p.id_reserva
WHERE LOWER(r.estado_reserva) = 'confirmada'
    AND (
        (r.fecha_salida - r.fecha_entrada) * h.precio_noche
        - COALESCE(p.total_pagado, 0)
    ) > 0
ORDER BY saldo_pendiente DESC;

-- PREGUNTA 2
-- Porcentaje de ingresos por nacionalidad.
-- Codigo original generado por ChatGPT.
-- Sin modificaciones.

SELECT
    c.nacionalidad,
    COUNT(p.id_pago) AS cantidad_pagos,
    SUM(p.monto) AS ingreso_total_recaudado,
    ROUND(
        100.0 * SUM(p.monto) /
        NULLIF(SUM(SUM(p.monto)) OVER (), 0),
        2
    ) AS porcentaje_ingresos
FROM pago p
INNER JOIN reserva r
    ON p.id_reserva = r.id_reserva
INNER JOIN cliente c
    ON r.id_cliente = c.id_cliente
GROUP BY c.nacionalidad
ORDER BY ingreso_total_recaudado DESC;

-- PREGUNTA 3
-- Dias libres entre reservas confirmadas consecutivas.
-- Codigo original generado mediante ChatGPT.
-- Version original sin modificaciones.

WITH reservas_confirmadas AS (
    SELECT
        r.id_habitacion,
        h.numero AS numero_habitacion,
        r.id_reserva AS id_reserva_siguiente,
        r.fecha_entrada AS fecha_entrada_siguiente,

        LAG(r.id_reserva) OVER (
            PARTITION BY r.id_habitacion
            ORDER BY r.fecha_entrada, r.id_reserva
        ) AS id_reserva_anterior,

        LAG(r.fecha_salida) OVER (
            PARTITION BY r.id_habitacion
            ORDER BY r.fecha_entrada, r.id_reserva
        ) AS fecha_salida_anterior

    FROM reserva r
    INNER JOIN habitacion h
        ON r.id_habitacion = h.id_habitacion
    WHERE r.estado_reserva = 'Confirmada'
)
SELECT
    id_habitacion,
    numero_habitacion,
    id_reserva_anterior,
    TO_CHAR(
        fecha_salida_anterior, 'DD/MM/YYYY'
    ) AS fecha_salida_anterior,
    id_reserva_siguiente,
    TO_CHAR(
        fecha_entrada_siguiente, 'DD/MM/YYYY'
    ) AS fecha_entrada_siguiente,
    (
        fecha_entrada_siguiente - fecha_salida_anterior
    ) AS dias_libres
FROM reservas_confirmadas
WHERE id_reserva_anterior IS NOT NULL
ORDER BY
    numero_habitacion,
    fecha_entrada_siguiente,
    id_reserva_siguiente;
