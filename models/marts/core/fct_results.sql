{{ config(materialized='table', unique_key='result_id') }}

SELECT
    r.result_id,
    r.race_id,
    r.driver_id,
    r.constructor_id,
    r.car_number,
    r.grid_position,
    r.finish_position,
    r.finish_position_text,
    r.finish_position_order,
    r.points,
    r.laps_completed,
    r.race_time,
    r.race_time_ms,
    r.fastest_lap_number,
    r.fastest_lap_rank,
    r.fastest_lap_time,
    r.fastest_lap_speed,
    d.first_name,
    d.last_name,
    d.nationality AS driver_nationality,
    c.constructor_name,
    c.nationality AS constructor_nationality,
    ra.season_year,
    ra.round_number,
    ra.race_name,
    ra.circuit_id,          
    ci.circuit_name,
    ci.country AS circuit_country
FROM {{ ref('silver_results') }} r
LEFT JOIN {{ ref('dim_drivers') }} d ON r.driver_id = d.driver_id
LEFT JOIN {{ ref('dim_constructors') }} c ON r.constructor_id = c.constructor_id
LEFT JOIN {{ ref('dim_races') }} ra ON r.race_id = ra.race_id
LEFT JOIN {{ ref('dim_circuits') }} ci ON ra.circuit_id = ci.circuit_id
