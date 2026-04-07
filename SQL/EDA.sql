
-- Checking fields

SELECT 
COUNT(distinct(city)) as uniques
FROM `practicetest.dm_temp.rstest`;

-- (6. Ok)

SELECT 
COUNT(player_id) AS Total,
City
FROM `practicetest.dm_temp.rstest`
GROUP BY ALL
ORDER BY Total DESC;

SELECT 
player_id,
year,
city,
COUNT(*) as qtd
FROM `practicetest.dm_temp.rstest`
group by all
HAVING count(*) > 1;


SELECT 
COUNT(player_id) as total,
COUNT(distinct(player_id)) as uniques,
FROM `practicetest.dm_temp.rstest`
GROUP BY ALL;

-- Total: 15000 and 51900 uniques

-- Players per year 
SELECT
year,
COUNT(DISTINCT player_id) AS uniques
FROM `practicetest.dm_temp.rstest`
GROUP BY year
ORDER BY year;

-- 39777 (2021) and 35781 (2022)

-- Now check on Prifddinas

SELECT
year,
COUNT(DISTINCT player_id) AS uniques
FROM `practicetest.dm_temp.rstest`
WHERE city = 'Prifddinas'
GROUP BY 1
ORDER BY uniques DESC;

-- 32465 (2021) and 27984 (2022)

with un as (
SELECT
player_id,
FROM `practicetest.dm_temp.rstest`
GROUP BY player_id
HAVING COUNT(DISTINCT year) = 2
)

SELECT COUNT(*) AS total
FROM un;

-- Now check on Prifddinas
CREATE OR REPLACE TABLE `practicetest.dm_temp.rstest2122` AS
WITH un AS (
SELECT
player_id
FROM `practicetest.dm_temp.rstest`
WHERE city = 'Prifddinas'
GROUP BY player_id
HAVING COUNT(DISTINCT year) = 2
)

SELECT COUNT(*) AS total
FROM un;

SELECT *
FROM `practicetest.dm_temp.rstest`
WHERE year = '2021-01-01'
AND panel_start_date > '2021-12-31';

SELECT *
FROM `practicetest.dm_temp.rstest`
WHERE year = '2022-01-01'
AND panel_start_date > '2022-12-31';

-- spent check
SELECT 
COUNT(player_spend) as total,
player_spend,
city,
year
FROM `practicetest.dm_temp.rstest`
GROUP BY ALL
ORDER BY player_spend DESC
;


SELECT
panel_start_date,
year,
city
FROM `practicetest.dm_temp.rstest`
ORDER BY panel_start_date ASC;


SELECT 
COUNT(player_id) AS total,
city,
year
FROM `practicetest.dm_temp.rstest`
GROUP BY ALL
ORDER BY TOTAL DESC;

CREATE OR REPLACE TABLE `practicetest.dm_temp.prif22` AS
SELECT
player_id
FROM `practicetest.dm_temp.rstest`
WHERE city = 'Prifddinas'
GROUP BY player_id
HAVING COUNT(DISTINCT year) = 2
;

CREATE OR REPLACE TABLE `practicetest.dm_temp.prif21` AS
SELECT
DISTINCT player_id
FROM `practicetest.dm_temp.rstest`
WHERE city = 'Prifddinas' and year = '2021-01-01';

SELECT
ROUND(COUNT(DISTINCT b.player_id) / COUNT(DISTINCT a.player_id),2) * 100 AS Retention
FROM `practicetest.dm_temp.prif21` A 
LEFT JOIN `practicetest.dm_temp.prif22` B 
ON A.player_id = B.player_id
;

CREATE OR REPLACE TABLE `practicetest.dm_temp.migs` AS 
WITH un AS (
  SELECT DISTINCT player_id,
  FROM `practicetest.dm_temp.rstest`
  WHERE city = 'Prifddinas'
    AND year = '2021-01-01'
),
doix AS (
  SELECT DISTINCT player_id,
  FROM `practicetest.dm_temp.rstest`
  WHERE city = 'Prifddinas'
    AND year = '2022-01-01'
 )

SELECT
  t.city,
  COUNT(DISTINCT un.player_id) AS migrated
FROM un 
JOIN `practicetest.dm_temp.rstest` t
  ON un.player_id = t.player_id
WHERE t.year = '2022-01-01'
  AND t.city != 'Prifddinas'
GROUP BY t.city
ORDER BY migrated DESC;






