use international_debt_analysis;
USE international_debt_analysis;

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT country_code) AS total_countries,
    COUNT(DISTINCT indicator_code) AS total_indicators,
    MIN(year) AS first_year,
    MAX(year) AS last_year
FROM debt_observations;

SELECT
    COUNT(DISTINCT country_code) AS countries_with_data,
    ROUND(SUM(debt_value) / 1000000000, 2)
        AS total_debt_billion_usd
FROM debt_observations
WHERE indicator_code = 'DT.DOD.DECT.CD'
  AND year = 2024;