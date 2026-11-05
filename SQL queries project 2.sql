use international_debt_analysis;
##Basic 1: Retrieve country names
select distinct
c.country_name
from countries as c
join debt_observations as d
on c.country_code=d.country_code
order by
c.country_name;

-- basic2:count countries with observations
select count(distinct country_code) as
total_countries
from debt_observations;

-- basic 3:count distinct indicators
select count(distinct indicator_code) as
total_indicators
from debt_observations;

-- basic 4:display the first 10 records

select* from debt_observations
order by country_code,
indicator_code, year limit 10;

## basic 5: total external debt for 2024 in billion USD

select round(sum(debt_value)/1000000000,2)as
total_debt_billion_usd
from debt_observations
where indicator_code='DT.DOD.DECT.CD'
and year=2024;

-- basic 6: list unique indicator names
select distinct
i.indicator_name
from indicators as i
join debt_observations as d
on i.indicator_code=d.indicator_code
order by
i.indicator_name;

-- basic 7: number of records for each country
select
c.country_code,
c.country_name,
count(*) as
total_records
from countries as c
join debt_observations as d
on c.country_code=d.country_code
group by
c.country_code,
c.country_name
order by total_records
desc,c.country_name;

-- Basic 8: Total external debt above 1 billion USD
SELECT
    c.country_name,
    d.year,
    d.debt_value
FROM debt_observations AS d
JOIN countries AS c
    ON d.country_code = c.country_code
WHERE d.indicator_code = 'DT.DOD.DECT.CD'
  AND d.debt_value > 1000000000
ORDER BY d.debt_value DESC, c.country_name, d.year;

-- Basic 9: Debt statistics for 2024 in billion USD
SELECT
    ROUND(MIN(debt_value) / 1000000000, 2) AS minimum_debt_bn,
    ROUND(MAX(debt_value) / 1000000000, 2) AS maximum_debt_bn,
    ROUND(AVG(debt_value) / 1000000000, 2) AS average_debt_bn
FROM debt_observations
WHERE indicator_code = 'DT.DOD.DECT.CD'
  AND year = 2024;
  
  -- Basic 10: Total number of records
SELECT COUNT(*) AS total_records
FROM debt_observations;

-- Intermediate 1: External debt per country in 2024
SELECT
    c.country_name,
    ROUND(SUM(d.debt_value) / 1000000000, 2)
        AS total_debt_billion_usd
FROM debt_observations AS d
JOIN countries AS c
    ON d.country_code = c.country_code
WHERE d.indicator_code = 'DT.DOD.DECT.CD'
  AND d.year = 2024
GROUP BY c.country_code, c.country_name
ORDER BY total_debt_billion_usd DESC, c.country_name;

-- Intermediate 2: Top 10 countries by external debt in 2024
SELECT
    c.country_name,
    ROUND(SUM(d.debt_value) / 1000000000, 2)
        AS total_debt_billion_usd
FROM debt_observations AS d
JOIN countries AS c
    ON d.country_code = c.country_code
WHERE d.indicator_code = 'DT.DOD.DECT.CD'
  AND d.year = 2024
GROUP BY c.country_code, c.country_name
ORDER BY total_debt_billion_usd DESC, c.country_name limit 10;

-- Intermediate 3: Average annual external debt per country
SELECT
    c.country_name,
    COUNT(*) AS years_with_data,
    ROUND(AVG(d.debt_value) / 1000000000, 2)
        AS average_debt_billion_usd
FROM debt_observations AS d
JOIN countries AS c
    ON d.country_code = c.country_code
WHERE d.indicator_code = 'DT.DOD.DECT.CD'
  AND d.year BETWEEN 2000 AND 2024
GROUP BY c.country_code, c.country_name
ORDER BY average_debt_billion_usd DESC, c.country_name;

-- Intermediate 4: Total by debt stock indicator in 2024
SELECT
    i.indicator_code,
    i.indicator_name,
    COUNT(*) AS countries_with_data,
    ROUND(SUM(d.debt_value) / 1000000000, 2)
        AS total_debt_billion_usd
FROM debt_observations AS d
JOIN indicators AS i
    ON d.indicator_code = i.indicator_code
WHERE d.year = 2024
  AND i.indicator_name LIKE 'External debt stocks,%'
  AND i.indicator_name LIKE '%current US$%'
GROUP BY i.indicator_code, i.indicator_name
ORDER BY total_debt_billion_usd DESC;

-- Intermediate 5: Debt stock indicator with the highest total in 2024
SELECT
    i.indicator_code,
    i.indicator_name,
    COUNT(*) AS countries_with_data,
    ROUND(SUM(d.debt_value) / 1000000000, 2)
        AS total_debt_billion_usd
FROM debt_observations AS d
JOIN indicators AS i
    ON d.indicator_code = i.indicator_code
WHERE d.year = 2024
  AND i.indicator_name LIKE 'External debt stocks,%'
  AND i.indicator_name LIKE '%current US$%'
GROUP BY i.indicator_code, i.indicator_name
ORDER BY total_debt_billion_usd DESC,i.indicator_code limit 1;

-- Intermediate 6: Country with the lowest external debt in 2024
SELECT
    c.country_name,
    ROUND(d.debt_value / 1000000000, 2)
        AS total_debt_billion_usd
FROM debt_observations AS d
JOIN countries AS c
    ON d.country_code = c.country_code
WHERE d.indicator_code = 'DT.DOD.DECT.CD'
  AND d.year = 2024
ORDER BY d.debt_value ASC, c.country_name
LIMIT 1;

-- Intermediate 7: Debt by country and stock indicator in 2024
SELECT
    c.country_name,
    i.indicator_code,
    i.indicator_name,
    ROUND(SUM(d.debt_value) / 1000000000, 2)
        AS total_debt_billion_usd
FROM debt_observations AS d
JOIN countries AS c
    ON d.country_code = c.country_code
JOIN indicators AS i
    ON d.indicator_code = i.indicator_code
WHERE d.year = 2024
  AND i.indicator_name LIKE 'External debt stocks,%'
  AND i.indicator_name LIKE '%current US$%'
GROUP BY
    c.country_code, c.country_name,
    i.indicator_code, i.indicator_name
ORDER BY c.country_name, i.indicator_code;

-- Intermediate 8: Number of indicators per country
SELECT
    c.country_name,
    COUNT(DISTINCT d.indicator_code) AS total_indicators
FROM debt_observations AS d
JOIN countries AS c
    ON d.country_code = c.country_code
GROUP BY c.country_code, c.country_name
ORDER BY total_indicators DESC, c.country_name;

-- Intermediate 9: Countries above average external debt in 2024
SELECT
    c.country_name,
    ROUND(d.debt_value / 1000000000, 2)
        AS total_debt_billion_usd
FROM debt_observations AS d
JOIN countries AS c
    ON d.country_code = c.country_code
WHERE d.indicator_code = 'DT.DOD.DECT.CD'
  AND d.year = 2024
  AND d.debt_value > (
      SELECT AVG(debt_value)
      FROM debt_observations
      WHERE indicator_code = 'DT.DOD.DECT.CD'
        AND year = 2024
  )
ORDER BY d.debt_value DESC, c.country_name;

-- Intermediate 10: Rank countries by external debt in 2024
SELECT
    c.country_name,
    ROUND(d.debt_value / 1000000000, 2)
        AS total_debt_billion_usd,
    RANK() OVER (
        ORDER BY d.debt_value DESC
    ) AS debt_rank
FROM debt_observations AS d
JOIN countries AS c
    ON d.country_code = c.country_code
WHERE d.indicator_code = 'DT.DOD.DECT.CD'
  AND d.year = 2024
ORDER BY debt_rank, c.country_name;

-- Advanced 1: Top 5 external debt stock indicators in 2024
SELECT
    i.indicator_code,
    i.indicator_name,
    COUNT(DISTINCT d.country_code) AS countries_with_data,
    ROUND(SUM(d.debt_value) / 1000000000, 2)
        AS total_debt_billion_usd
FROM debt_observations AS d
JOIN indicators AS i
    ON d.indicator_code = i.indicator_code
WHERE d.year = 2024
  AND i.indicator_name LIKE 'External debt stocks,%'
  AND i.indicator_name LIKE '%current US$%'
GROUP BY i.indicator_code, i.indicator_name
ORDER BY SUM(d.debt_value) DESC, i.indicator_code
LIMIT 5;

-- Advanced 2: Country share of total external debt in 2024
SELECT
    c.country_name,
    ROUND(d.debt_value / 1000000000, 2)
        AS total_debt_billion_usd,
    ROUND(
        d.debt_value * 100.0
        / SUM(d.debt_value) OVER (),
        2
    ) AS debt_share_percent
FROM debt_observations AS d
JOIN countries AS c
    ON d.country_code = c.country_code
WHERE d.indicator_code = 'DT.DOD.DECT.CD'
  AND d.year = 2024
ORDER BY d.debt_value DESC, c.country_name;

-- Advanced 3: Top 3 countries for each debt stock indicator
WITH ranked_debt AS (
    SELECT
        i.indicator_code,
        i.indicator_name,
        c.country_name,
        d.debt_value,
        ROW_NUMBER() OVER (
            PARTITION BY d.indicator_code
            ORDER BY d.debt_value DESC, d.country_code
        ) AS country_rank
    FROM debt_observations AS d
    JOIN countries AS c
        ON d.country_code = c.country_code
    JOIN indicators AS i
        ON d.indicator_code = i.indicator_code
    WHERE d.year = 2024
      AND i.indicator_name LIKE 'External debt stocks,%'
      AND i.indicator_name LIKE '%current US$%'
)
SELECT
    indicator_code,
    indicator_name,
    country_name,
    ROUND(debt_value / 1000000000, 2)
        AS debt_billion_usd,
    country_rank
FROM ranked_debt
WHERE country_rank <= 3
ORDER BY indicator_code, country_rank;

-- Advanced 4: Highest minus lowest annual debt per country
SELECT
    c.country_name,
    COUNT(*) AS years_with_data,
    ROUND(MIN(d.debt_value) / 1000000000, 2)
        AS minimum_debt_bn,
    ROUND(MAX(d.debt_value) / 1000000000, 2)
        AS maximum_debt_bn,
    ROUND(
        (MAX(d.debt_value) - MIN(d.debt_value))
        / 1000000000,
        2
    ) AS debt_range_bn
FROM debt_observations AS d
JOIN countries AS c
    ON d.country_code = c.country_code
WHERE d.indicator_code = 'DT.DOD.DECT.CD'
  AND d.year BETWEEN 2000 AND 2024
GROUP BY c.country_code, c.country_name
ORDER BY
    MAX(d.debt_value) - MIN(d.debt_value) DESC,
    c.country_name;
    
    -- Advanced 5: Create a top 10 countries view
CREATE OR REPLACE VIEW top10_external_debt_2024 AS
SELECT
    c.country_code,
    c.country_name,
    d.debt_value AS debt_usd,
    ROUND(d.debt_value / 1000000000, 2)
        AS total_debt_billion_usd
FROM debt_observations AS d
JOIN countries AS c
    ON d.country_code = c.country_code
WHERE d.indicator_code = 'DT.DOD.DECT.CD'
  AND d.year = 2024
ORDER BY d.debt_value DESC, c.country_code
LIMIT 10;

SELECT *
FROM top10_external_debt_2024
ORDER BY debt_usd DESC, country_code;

-- Advanced 6: Classify countries by external debt amount
SELECT
    c.country_name,
    ROUND(d.debt_value / 1000000000, 2)
        AS total_debt_billion_usd,
    CASE
        WHEN d.debt_value >= 100000000000 THEN 'High'
        WHEN d.debt_value >= 10000000000 THEN 'Medium'
        ELSE 'Low'
    END AS debt_category
FROM debt_observations AS d
JOIN countries AS c
    ON d.country_code = c.country_code
WHERE d.indicator_code = 'DT.DOD.DECT.CD'
  AND d.year = 2024
ORDER BY d.debt_value DESC, c.country_name;

-- Advanced 7: Running sum of annual debt balances
SELECT
    c.country_name,
    d.year,
    ROUND(d.debt_value / 1000000000, 2)
        AS annual_debt_bn,
    ROUND(
        SUM(d.debt_value) OVER (
            PARTITION BY d.country_code
            ORDER BY d.year
            ROWS BETWEEN UNBOUNDED PRECEDING
                     AND CURRENT ROW
        ) / 1000000000,
        2
    ) AS running_sum_annual_balances_bn
FROM debt_observations AS d
JOIN countries AS c
    ON d.country_code = c.country_code
WHERE d.indicator_code = 'DT.DOD.DECT.CD'
  AND d.year BETWEEN 2000 AND 2024
ORDER BY c.country_name, d.year;

-- Advanced 8: Indicator averages above the overall average
WITH stock_data AS (
    SELECT
        i.indicator_code,
        i.indicator_name,
        d.debt_value
    FROM debt_observations AS d
    JOIN indicators AS i
        ON d.indicator_code = i.indicator_code
    WHERE d.year = 2024
      AND i.indicator_name LIKE 'External debt stocks,%'
      AND i.indicator_name LIKE '%current US$%'
)
SELECT
    indicator_code,
    indicator_name,
    COUNT(*) AS countries_with_data,
    ROUND(AVG(debt_value) / 1000000000, 2)
        AS average_debt_bn
FROM stock_data
GROUP BY indicator_code, indicator_name
HAVING AVG(debt_value) > (
    SELECT AVG(debt_value)
    FROM stock_data
)
ORDER BY AVG(debt_value) DESC, indicator_code;

-- Advanced 9: Countries with more than 5% of total debt
WITH country_shares AS (
    SELECT
        c.country_name,
        d.debt_value,
        d.debt_value * 100.0
            / SUM(d.debt_value) OVER ()
            AS share_percent
    FROM debt_observations AS d
    JOIN countries AS c
        ON d.country_code = c.country_code
    WHERE d.indicator_code = 'DT.DOD.DECT.CD'
      AND d.year = 2024
)
SELECT
    country_name,
    ROUND(debt_value / 1000000000, 2)
        AS total_debt_billion_usd,
    ROUND(share_percent, 2) AS debt_share_percent
FROM country_shares
WHERE share_percent > 5
ORDER BY debt_value DESC, country_name;

-- Advanced 10: Largest debt stock component per country
WITH ranked_components AS (
    SELECT
        c.country_code,
        c.country_name,
        i.indicator_code,
        i.indicator_name,
        d.debt_value,
        RANK() OVER (
            PARTITION BY d.country_code
            ORDER BY d.debt_value DESC
        ) AS component_rank
    FROM debt_observations AS d
    JOIN countries AS c
        ON d.country_code = c.country_code
    JOIN indicators AS i
        ON d.indicator_code = i.indicator_code
    WHERE d.year = 2024
      AND i.indicator_name LIKE 'External debt stocks,%'
      AND i.indicator_name LIKE '%current US$%'
      AND d.indicator_code <> 'DT.DOD.DECT.CD'
)
SELECT
    country_name,
    indicator_code,
    indicator_name,
    ROUND(debt_value / 1000000000, 2)
        AS debt_billion_usd
FROM ranked_components
WHERE component_rank = 1
ORDER BY country_name, indicator_code;

