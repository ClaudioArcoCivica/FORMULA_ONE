{{
  config(
    materialized='incremental',
    unique_key='result_id', 
  )
}}

WITH cleaned AS (
    SELECT
        resultId AS result_id,
        raceId AS race_id,
        driverId AS driver_id,
        constructorId AS constructor_id,
        number AS car_number,
        grid AS grid_position,
        position AS finish_position,
        positionText AS finish_position_text,
        positionOrder AS finish_position_order,
        points AS points,
        laps AS laps_completed,
        time AS race_time,
        milliseconds AS race_time_ms,
        fastestLap AS fastest_lap_number,
        rank AS fastest_lap_rank,
        fastestLapTime AS fastest_lap_time,
        fastestLapSpeed AS fastest_lap_speed,
        statusId AS status_id
    FROM {{ source('formula1_bronze', 'results') }}
    WHERE resultId IS NOT NULL
    {% if is_incremental() %}
      AND result_id > (SELECT MAX(result_id) FROM {{ this }})
    {% endif %}
)

SELECT * FROM cleaned
