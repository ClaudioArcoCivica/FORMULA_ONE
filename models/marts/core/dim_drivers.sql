{{ config(materialized='table', unique_key='driver_id') }}

SELECT
    driver_id,
    driver_ref,
    car_number,
    driver_code,
    first_name,
    last_name,
    date_of_birth,
    nationality

FROM {{ ref('silver_drivers') }}
WHERE driver_id IS NOT NULL
