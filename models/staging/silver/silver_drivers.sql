{{ config(
    materialized='view',
    unique_key='driverId'
) }}

WITH pre_cleaned AS (
    SELECT
        driverId AS driver_id,
        driverRef AS driver_ref,
        number AS raw_car_number,
        code AS driver_code,
        INITCAP(forename) AS first_name,
        INITCAP(surname) AS last_name,
        dob AS date_of_birth,
        INITCAP(nationality) AS nationality,
        url AS wikipedia_url
    FROM {{ source('formula1_bronze', 'drivers') }}
    WHERE driverId IS NOT NULL
),
cleaned AS (
    SELECT
        driver_id,
        driver_ref,
        CASE
            WHEN TRIM(raw_car_number) = '' THEN NULL
            ELSE CAST(raw_car_number AS INTEGER)
        END AS car_number,
        driver_code,
        first_name,
        last_name,
        date_of_birth,
        nationality
    FROM pre_cleaned
)

SELECT * FROM cleaned
