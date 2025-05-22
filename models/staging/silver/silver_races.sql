{{ config(
    materialized='view',
    unique_key='raceId'
) }}

WITH cleaned AS (
    SELECT
        raceId AS race_id,
        year AS season_year,
        round AS round_number,
        circuitId AS circuit_id,
        name AS race_name,
        date AS race_date,
        time AS race_time
    FROM {{ source('formula1_bronze', 'races') }}
    WHERE raceId IS NOT NULL
)

SELECT * FROM cleaned
