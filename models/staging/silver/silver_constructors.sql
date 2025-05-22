{{
  config(
    materialized='view',
    unique_key='constructor_id'
  )
}}

WITH cleaned AS (
    SELECT
        -- ID único del constructor (Snowflake suele reconocer el tipo automáticamente)
        constructorId AS constructor_id,
        constructorRef AS constructor_ref,
        -- Nombre del constructor, limitado a 100 caracteres por claridad (opcional)
        INITCAP(name) AS constructor_name,
        -- Nacionalidad capitalizada
        INITCAP(nationality) AS nationality,
        url AS wikipedia_url,
        -- Timestamp de carga
        CURRENT_TIMESTAMP() AS loaded_at
    FROM {{ source('formula1_bronze', 'constructors') }}
    WHERE constructorId IS NOT NULL
)

SELECT * FROM cleaned
