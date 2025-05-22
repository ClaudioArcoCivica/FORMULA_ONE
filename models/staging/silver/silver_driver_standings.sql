{{ config(
    materialized='table',
    unique_key='driverStandingsId'
) }}

WITH cleaned AS (
  SELECT
    driverStandingsId AS driver_standings_id,
    raceId AS race_id,
    driverId AS driver_id,
    -- points ya es numérico en el CSV, lo dejamos tal cual
    points AS points,
    -- position puede venir como texto o número, CAST para asegurar tipo INTEGER
    CAST(position AS INTEGER) AS position,
    positionText AS position_text,
    -- wins puede venir como texto o número, CAST para asegurar tipo INTEGER
    CAST(wins AS INTEGER) AS wins
  FROM {{ source('formula1_bronze', 'driver_standings') }}
  WHERE driverStandingsId IS NOT NULL
)

SELECT * FROM cleaned

