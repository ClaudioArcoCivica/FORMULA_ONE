{{ config(
    materialized='view',
    unique_key='qualify_id'
) }}

WITH cleaned AS (
    SELECT
        qualifyid AS qualify_id,
        raceid AS race_id,
        driverid AS driver_id,
        constructorid AS constructor_id,
        number AS car_number,
        position AS qualifying_position
    FROM {{ source('formula1_bronze', 'qualifying') }}
    WHERE qualifyid IS NOT NULL
)

SELECT * FROM cleaned
