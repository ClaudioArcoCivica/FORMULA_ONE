{{ config(materialized='table', unique_key='constructor_standings_id') }}

SELECT
    cs.constructor_standings_id,
    cs.race_id,
    cs.constructor_id,
    cs.points,
    cs.position,
    cs.position_text,
    cs.wins,
    c.constructor_name,
    c.nationality AS constructor_nationality,
    ra.season_year,
    ra.round_number,
    ra.race_name,
    ci.circuit_name,
    ci.country AS circuit_country
FROM {{ ref('silver_constructor_standings') }} cs
LEFT JOIN {{ ref('dim_constructors') }} c ON cs.constructor_id = c.constructor_id
LEFT JOIN {{ ref('dim_races') }} ra ON cs.race_id = ra.race_id
LEFT JOIN {{ ref('dim_circuits') }} ci ON ra.circuit_id = ci.circuit_id
