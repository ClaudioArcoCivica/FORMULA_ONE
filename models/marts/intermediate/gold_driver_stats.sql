{{ config(
    materialized='view',
    unique_key='driver_stat_id'
) }}

WITH 
raw_results AS (
  SELECT
    resultid AS result_id,
    raceid AS race_id,
    driverid AS driver_id,
    constructorid AS constructor_id,
    grid AS starting_grid,
    position AS finish_position,
    points AS points
  FROM {{ source('formula1_bronze', 'results') }}
),

cleaned_races AS (
  SELECT
    raceid AS race_id,
    year AS race_year
  FROM {{ source('formula1_bronze', 'races') }}
),

driver_info AS (
  SELECT
    driverid AS driver_id,
    CONCAT(INITCAP(forename), ' ', INITCAP(surname)) AS driver_name,
    nationality AS driver_nationality
  FROM {{ source('formula1_bronze', 'drivers') }}
),

joined_data AS (
  SELECT
    r.result_id,
    cr.race_year,
    di.driver_id,
    di.driver_name,
    di.driver_nationality,
    r.starting_grid,
    r.finish_position,
    r.points
  FROM raw_results r
  JOIN cleaned_races cr ON r.race_id = cr.race_id
  JOIN driver_info di ON r.driver_id = di.driver_id
),

calculated_stats AS (
  SELECT
    driver_id,
    race_year,
    COUNT(*) AS races_entered,
    SUM(points) AS total_points,
    SUM(CASE WHEN finish_position = 1 THEN 1 ELSE 0 END) AS wins,
    SUM(CASE WHEN finish_position BETWEEN 1 AND 3 THEN 1 ELSE 0 END) AS podiums,
    SUM(CASE WHEN starting_grid = 1 THEN 1 ELSE 0 END) AS pole_positions,
    AVG(finish_position) AS avg_finish_position,
    CURRENT_TIMESTAMP() AS loaded_at
  FROM joined_data
  GROUP BY 1,2
)

SELECT
  MD5(CONCAT(driver_id, race_year)) AS driver_stat_id,
  *,
  ROUND(wins::FLOAT / races_entered * 100, 2) AS win_percentage,
  ROUND(podiums::FLOAT / races_entered * 100, 2) AS podium_percentage
FROM calculated_stats
