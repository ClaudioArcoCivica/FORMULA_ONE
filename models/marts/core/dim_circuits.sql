{{ config(materialized='table', unique_key='circuit_id') }}

SELECT
    circuit_id,
    circuit_ref,
    circuit_name,
    city,
    country,
    latitude,
    longitude,
    altitude
   
FROM {{ ref('silver_circuits') }}
WHERE circuit_id IS NOT NULL
