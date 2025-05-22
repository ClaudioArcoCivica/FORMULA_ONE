{{ config(materialized='view') }}

WITH pilotos_circuitos AS (
    SELECT
        r.driver_id,
        r.first_name || ' ' || r.last_name AS piloto,
        r.circuit_id,  -- Usa el circuit_id de fct_results
        r.circuit_name,
        COUNT(*) AS carreras_disputadas,
        SUM(CASE WHEN r.finish_position = 1 THEN 1 ELSE 0 END) AS victorias,
        SUM(CASE WHEN r.finish_position BETWEEN 1 AND 3 THEN 1 ELSE 0 END) AS podios,
        SUM(r.points) AS puntos_totales,
        ROUND(AVG(r.points), 2) AS puntos_promedio,
        MIN(r.finish_position) AS mejor_posicion
    FROM {{ ref('fct_results') }} r
    --JOIN {{ ref('dim_drivers') }} d ON r.driver_id = d.driver_id
    
    GROUP BY 1,2,3,4
)

SELECT
    *,
    RANK() OVER (PARTITION BY circuit_id ORDER BY victorias DESC) AS ranking_victorias
FROM pilotos_circuitos
