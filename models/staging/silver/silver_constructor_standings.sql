{{ config(
    materialized='view',
    unique_key='constructorStandingsId'
) }}

WITH cleaned AS (
  SELECT
    constructorStandingsId AS constructor_standings_id,
    raceId AS race_id,
    constructorId AS constructor_id,
    -- points puede venir como número o texto, pero en F1 suelen ser decimales
    CAST(points AS FLOAT) AS points,
    -- posición en el campeonato tras esa carrera
    CAST(position AS INTEGER) AS position,
    -- posición en texto (puede tener valores especiales, como "E" o "R")
    positionText AS position_text,
    -- victorias acumuladas hasta esa carrera
    CAST(wins AS INTEGER) AS wins
  FROM {{ source('formula1_bronze', 'constructors_standings') }}
  WHERE constructorStandingsId IS NOT NULL
)

SELECT * FROM cleaned
