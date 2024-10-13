-- Selecting all records from the running table
SELECT * 
FROM running.dbo.cleanedupRUNNING;

-- Unique states count
SELECT COUNT(DISTINCT State) AS distinct_count
FROM running.dbo.cleanedupRUNNING;

-- Average running time by gender
SELECT Gender, AVG(Total_minutes) AS avg_time
FROM running.dbo.cleanedupRUNNING
GROUP BY Gender;

-- Youngest and oldest runner by gender
SELECT Gender,
       MIN(age) AS youngest,
       MAX(age) AS oldest
FROM running.dbo.cleanedupRUNNING
GROUP BY Gender;  -- Added missing GROUP BY

-- Average time by each age group
WITH age_buckets AS (
    SELECT total_minutes,
           CASE 
               WHEN age < 30 THEN 'age_20-29'
               WHEN age < 40 THEN 'age_30-39'
               WHEN age < 50 THEN 'age_40-49'
               WHEN age < 60 THEN 'age_50-59'
               WHEN age < 70 THEN 'age_60-69'
               ELSE 'age_70+' 
           END AS age_group
    FROM running.dbo.cleanedupRUNNING
)
SELECT age_group, AVG(total_minutes) AS avg_race_time  -- Fixed column alias typo
FROM age_buckets
GROUP BY age_group;

-- Selecting top 3 runners for each gender
WITH gender_rank AS (
    SELECT RANK() OVER (PARTITION BY Gender ORDER BY total_minutes ASC) AS gender_rank,
           fullname,
           Gender,
           total_minutes
    FROM running.dbo.cleanedupRUNNING
)
SELECT *
FROM gender_rank
WHERE gender_rank <= 3;  -- Filter to only show the top 3 for each gender
