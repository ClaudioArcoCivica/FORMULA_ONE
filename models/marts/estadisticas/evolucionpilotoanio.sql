{{ config(materialized='table') }}

WITH ultima_temporada AS (
    SELECT MAX(season_year) AS anio_max
    FROM {{ ref('dim_races') }}
),
pilotos_activos AS (
    SELECT DISTINCT r.driver_id
    FROM {{ ref('fct_results') }} r
    JOIN {{ ref('dim_races') }} ra ON r.race_id = ra.race_id
    JOIN ultima_temporada ut ON ra.season_year = ut.anio_max
),
victorias_podios_anio AS (
    SELECT
        r.driver_id,
        d.first_name || ' ' || d.last_name AS piloto,
        ra.season_year AS anio,
        COUNT(CASE WHEN r.finish_position = 1 THEN 1 END) AS victorias,
        COUNT(CASE WHEN r.finish_position BETWEEN 1 AND 3 THEN 1 END) AS podios
    FROM {{ ref('fct_results') }} r
    JOIN {{ ref('dim_drivers') }} d ON r.driver_id = d.driver_id
    JOIN {{ ref('dim_races') }} ra ON r.race_id = ra.race_id
    WHERE r.driver_id IN (SELECT driver_id FROM pilotos_activos)
    GROUP BY r.driver_id, d.first_name, d.last_name, ra.season_year
)

SELECT *
FROM victorias_podios_anio
ORDER BY piloto, anio

