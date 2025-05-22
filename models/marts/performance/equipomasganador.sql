SELECT
    equipo,
    SUM(victorias) AS victorias_totales,
    SUM(podios) AS podios_totales
FROM {{ ref('gold_equipo_circuito') }}
GROUP BY equipo
ORDER BY victorias_totales DESC, podios_totales DESC
Limit 1