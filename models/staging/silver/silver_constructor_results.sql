{{ config(
    materialized='table',
    unique_key='constructorResultsId'
) }}

WITH cleaned AS (
  SELECT
    constructorResultsId AS constructor_results_id,
    raceId AS race_id,
    constructorId AS constructor_id,
    CAST(points AS FLOAT) AS points
  FROM {{ source('formula1_bronze', 'constructor_results') }}
  WHERE constructorResultsId IS NOT NULL
)

SELECT * FROM cleaned
