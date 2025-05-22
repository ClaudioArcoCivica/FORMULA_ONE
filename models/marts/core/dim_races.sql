{{ config(materialized='table', unique_key='race_id') }}

SELECT
    race_id,
    season_year,
    round_number,
    circuit_id,
    race_name,
    race_date,
    race_time
    
FROM {{ ref('silver_races') }}
WHERE race_id IS NOT NULL
