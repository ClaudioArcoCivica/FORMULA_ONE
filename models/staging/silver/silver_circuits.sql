{{ config(
    materialized='table',
    unique_key='circuit_id'
) }}

SELECT
    circuitid    AS circuit_id,
    circuitref   AS circuit_ref,
    INITCAP(name)      AS circuit_name,
    INITCAP(location)  AS city,
    INITCAP(country)   AS country,
    ROUND(lat, 6)      AS latitude,
    ROUND(lng, 6)      AS longitude,
    alt          AS altitude
FROM {{ source('formula1_bronze', 'circuits') }}
WHERE circuitid IS NOT NULL
