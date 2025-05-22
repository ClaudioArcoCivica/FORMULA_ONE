{{ config(materialized='table', unique_key='driver_standings_id') }}

SELECT
    ds.driver_standings_id,
    ds.race_id,
    ds.driver_id,
    ds.points,
    ds.position,
    ds.position_text,
    ds.wins,
    d.first_name,
    d.last_name,
    d.nationality AS driver_nationality,
    ra.season_year,
    ra.round_number,
    ra.race_name,
    ci.circuit_name,
    ci.country AS circuit_country
FROM {{ ref('silver_driver_standings') }} ds
LEFT JOIN {{ ref('dim_drivers') }} d ON ds.driver_id = d.driver_id
LEFT JOIN {{ ref('dim_races') }} ra ON ds.race_id = ra.race_id
LEFT JOIN {{ ref('dim_circuits') }} ci ON ra.circuit_id = ci.circuit_id
