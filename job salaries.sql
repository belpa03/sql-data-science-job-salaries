USE ds;
SELECT * FROM ds_salaries;
-- apakah ada nilai yang nol?
SELECT *
FROM ds_salaries
WHERE work_year IS NULL
OR experience_level IS NULL
OR employment_type IS NULL
OR job_title IS NULL
OR salary IS NULL
OR salary_currency IS NULL
OR salary_in_usd IS NULL
OR employee_residence IS NULL
OR remote_ratio IS NULL
OR company_location IS NULL
OR company_size IS NULL;

-- job tittle yang tersedia
SELECT DISTINCT job_title 
FROM ds_salaries 
ORDER BY job_title;

-- data analyst job
SELECT DISTINCT job_title
FROM ds_salaries 
WHERE job_title LIKE "%data analyst%"
ORDER BY job_title;

-- AVG data analyst salary
SELECT AVG(salary_in_usd) 
FROM ds_salaries;

-- gaji rata-rata per bulan dalam rupiah dengan asumsi 1 USD = Rp15.000
SELECT (AVG(salary_in_usd)*15000)/12 
AS avg_sal_rp_monthly
FROM ds_salaries;


-- AVG Salaries Based on Experience level
SELECT company_location,
  AVG(salary_in_usd) avg_sal_in_usd
WHERE job_title LIKE "%data analyst%"
  AND employment_type = "FT"
  AND experience_level IN ("EN", "MI")
GROUP BY company_location
-- yang memiliki gaji >=2000
HAVING avg_sal_in_usd >=2000;


-- Salary Growth Over Time (Mid vs Senior)
WITH ds_1 AS (
  SELECT 
    work_year, 
    AVG(salary_in_usd) AS sal_in_usd_ex
  FROM ds_salaries
  WHERE
    employment_type = 'FT'
    AND experience_level = 'EX'
    AND job_title LIKE '%data analyst%'
  GROUP BY work_year
),
ds_2 AS (
  SELECT 
    work_year, 
    AVG(salary_in_usd) AS sal_in_usd_mi
  FROM ds_salaries
  WHERE
    employment_type = 'FT'
    AND experience_level = 'MI'
    AND job_title LIKE '%data analyst%'
  GROUP BY work_year
)
SELECT 
  ds_1.work_year, 
  ds_1.sal_in_usd_ex, 
  ds_2.sal_in_usd_mi,
  (ds_1.sal_in_usd_ex - ds_2.sal_in_usd_mi) AS differences
FROM ds_1
LEFT JOIN ds_2  
  ON ds_1.work_year = ds_2.work_year;

SELECT company_size, 
       COUNT(*) AS total_employees,
       ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM ds_salaries
GROUP BY company_size
ORDER BY avg_salary DESC;

SELECT remote_ratio,
       COUNT(*) AS total_jobs,
       ROUND(AVG(salary_in_usd), 2) AS avg_salary
FROM ds_salaries
GROUP BY remote_ratio
ORDER BY avg_salary DESC;
