{{ config(materialized='table', unique_key='constructor_id') }}

SELECT
    constructor_id,
    constructor_ref,
    constructor_name,
    nationality
FROM {{ ref('silver_constructors') }}
WHERE constructor_id IS NOT NULL
