{{ config(materialized='table') }}

WITH ranking AS (
    SELECT
        circuit_id,
        circuit_name,
        equipo,
        victorias,
        podios,
        carreras_disputadas,
        puntos_totales,
        puntos_promedio,
        mejor_posicion,
        ROW_NUMBER() OVER (
            PARTITION BY circuit_id
            ORDER BY victorias DESC, podios DESC
        ) AS ranking_victorias
    FROM {{ ref('gold_equipo_circuito') }}
    WHERE victorias > 0
)

SELECT
    circuit_id,
    circuit_name,
    equipo,
    victorias,
    podios,
    carreras_disputadas,
    puntos_totales,
    puntos_promedio,
    mejor_posicion,
    ranking_victorias
FROM ranking
WHERE ranking_victorias <= 3
ORDER BY circuit_name, ranking_victorias
