{{ config(materialized='view') }}

WITH equipos_circuitos AS (
    SELECT
        r.circuit_id,
        r.circuit_name,
        r.constructor_id,
        r.constructor_name AS equipo,
        COUNT(*) AS carreras_disputadas,
        SUM(CASE WHEN r.finish_position = 1 THEN 1 ELSE 0 END) AS victorias,
        SUM(CASE WHEN r.finish_position BETWEEN 1 AND 3 THEN 1 ELSE 0 END) AS podios,
        SUM(r.points) AS puntos_totales,
        ROUND(AVG(r.points), 2) AS puntos_promedio,
        MIN(r.finish_position) AS mejor_posicion
    FROM {{ ref('fct_results') }} r
    --JOIN {{ ref('dim_constructors') }} c ON r.constructor_id = c.constructor_id
    GROUP BY 1,2,3,4
)

SELECT *
FROM equipos_circuitos
