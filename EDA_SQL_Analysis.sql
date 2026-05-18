-- ============================================================================
-- EXPLORATORY DATA ANALYSIS (EDA) FOR JOB SALARY PREDICTION DATASET
-- ============================================================================
-- Purpose: Comprehensive analysis of job_salary_prediction_dataset table
-- Date: 2026-05-11
-- Updated column names to match actual database schema
-- ============================================================================

-- 1. BASIC DATASET OVERVIEW
-- ============================================================================

-- Check total number of records
SELECT 
    COUNT(*) AS total_records,
    COUNT(DISTINCT job_title) AS unique_jobs,
    COUNT(DISTINCT education_level) AS unique_education_levels,
    COUNT(DISTINCT skills) AS unique_skills,
    COUNT(DISTINCT industry) AS unique_industries,
    COUNT(DISTINCT company_size) AS unique_company_sizes,
    COUNT(DISTINCT location) AS unique_locations,
    COUNT(DISTINCT remote_work) AS unique_remote_work,
    COUNT(DISTINCT certifications) AS unique_certifications
FROM [dbo].[job_salary_prediction_dataset];

-- Display sample data to understand structure
SELECT TOP 20
    job_title,
    experience_years,
    education_level,
    skills,
    industry,
    company_size,
    location,
    remote_work,
    certifications,
    salary
FROM [dbo].[job_salary_prediction_dataset];

-- 2. SALARY STATISTICS & DISTRIBUTION
-- ============================================================================

-- Overall salary statistics - using simple aggregates and subqueries
WITH salary_quartiles AS (
    SELECT 
        salary,
        NTILE(4) OVER (ORDER BY salary) AS quartile
    FROM [dbo].[job_salary_prediction_dataset]
)
SELECT 
    CASE 
        WHEN quartile = 1 THEN 'Q1 (0-25%)'
        WHEN quartile = 2 THEN 'Q2 (25-50%)'
        WHEN quartile = 3 THEN 'Q3 (50-75%)'
        WHEN quartile = 4 THEN 'Q4 (75-100%)'
    END AS salary_quartile,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    COUNT(*) AS record_count,
    ROUND(AVG(CAST(salary AS FLOAT)), 0) AS avg_salary
FROM salary_quartiles
GROUP BY quartile
ORDER BY quartile;

-- 3. JOB TITLE ANALYSIS
-- ============================================================================

-- Salary statistics by job title
SELECT TOP 20
    job_title,
    COUNT(*) AS job_count,
    ROUND(AVG(CAST(salary AS FLOAT)),0) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    ROUND(AVG(CAST(experience_years AS FLOAT)),0) AS avg_experience
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY job_title
ORDER BY avg_salary DESC;

-- Count of jobs by title
SELECT TOP 15
    job_title,
    COUNT(*) AS job_count,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[job_salary_prediction_dataset]) AS DECIMAL(5, 2)) AS percentage
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY job_title
ORDER BY job_count DESC;

-- 4. EDUCATION LEVEL ANALYSIS
-- ============================================================================

-- Salary by education level
SELECT 
    education_level,
    COUNT(*) AS record_count,
    AVG(CAST(salary AS FLOAT)) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[job_salary_prediction_dataset]) AS DECIMAL(5, 2)) AS percentage
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY education_level
ORDER BY avg_salary DESC;

-- 5. EXPERIENCE ANALYSIS
-- ============================================================================

-- Salary correlation with experience years
SELECT 
    experience_years,
    COUNT(*) AS count,
    ROUND(AVG(CAST(salary AS FLOAT)),0) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY experience_years
ORDER BY experience_years;

-- Experience distribution by percentiles
SELECT 
    MIN(experience_years) AS min_experience,
    MAX(experience_years) AS max_experience,
    ROUND(AVG(CAST(experience_years AS FLOAT)),0) AS avg_experience,
    ROUND(STDEV(CAST(experience_years AS FLOAT)),2) AS experience_stddev
FROM [dbo].[job_salary_prediction_dataset];

-- Experience brackets and salary
SELECT 
    CASE 
        WHEN experience_years = 0 THEN '0 years'
        WHEN experience_years BETWEEN 1 AND 5 THEN '1-5 years'
        WHEN experience_years BETWEEN 6 AND 10 THEN '6-10 years'
        WHEN experience_years BETWEEN 11 AND 15 THEN '11-15 years'
        ELSE '15+ years'
    END AS experience_bracket,
    COUNT(*) AS count,
    ROUND(AVG(CAST(salary AS FLOAT)),0) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY 
    CASE 
        WHEN experience_years = 0 THEN '0 years'
        WHEN experience_years BETWEEN 1 AND 5 THEN '1-5 years'
        WHEN experience_years BETWEEN 6 AND 10 THEN '6-10 years'
        WHEN experience_years BETWEEN 11 AND 15 THEN '11-15 years'
        ELSE '15+ years'
    END
ORDER BY 
 min_salary ASC

-- 6. INDUSTRY ANALYSIS
-- ============================================================================

-- Salary by industry
SELECT TOP 20
    industry,
    COUNT(*) AS count,
    AVG(CAST(salary AS FLOAT)) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    STDEV(CAST(salary AS FLOAT)) AS salary_stddev,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[job_salary_prediction_dataset]) AS DECIMAL(5, 2)) AS percentage
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY industry
ORDER BY avg_salary DESC;


-- 7. COMPANY SIZE ANALYSIS
-- ============================================================================

-- Salary by company size
SELECT 
    company_size,
    COUNT(*) AS count,
    ROUND(AVG(CAST(salary AS FLOAT)),0) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[job_salary_prediction_dataset]) AS DECIMAL(5, 2)) AS percentage
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY company_size
ORDER BY avg_salary DESC;

-- 8. LOCATION ANALYSIS
-- ============================================================================

-- Salary by location
SELECT TOP 25
    location,
    COUNT(*) AS count,
    ROUND(AVG(CAST(salary AS FLOAT)),0) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    ROUND(STDEV(CAST(salary AS FLOAT)),0) AS salary_stddev,
	CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[job_salary_prediction_dataset]) AS DECIMAL(5, 2)) AS percentage
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY location
ORDER BY avg_salary DESC;

-- 9. REMOTE WORK ANALYSIS
-- ============================================================================

-- Salary by remote work option (Yes/No)
SELECT 
    remote_work,
    COUNT(*) AS count,
    AVG(CAST(salary AS FLOAT)) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    STDEV(CAST(salary AS FLOAT)) AS salary_stddev,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[job_salary_prediction_dataset]) AS DECIMAL(5, 2)) AS percentage
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY remote_work
ORDER BY avg_salary DESC;

-- Remote work distribution
SELECT 
    remote_work,
    COUNT(*) AS count,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[job_salary_prediction_dataset]) AS DECIMAL(5, 2)) AS percentage_distribution
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY remote_work
ORDER BY count DESC;

-- 10. SKILLS ANALYSIS
-- ============================================================================

-- Salary by skills level/count
SELECT 
    skills_count,
    COUNT(*) AS count,
    ROUND(AVG(CAST(salary AS FLOAT)),0) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
	CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[job_salary_prediction_dataset]) AS DECIMAL(5, 2)) AS percentage_distribution
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY skills_count
ORDER BY avg_salary DESC;

-- 11. CERTIFICATIONS ANALYSIS
-- ============================================================================

-- Salary by certifications count
SELECT 
    experience_years,
    certifications,
    COUNT(*) AS count,
    ROUND(AVG(CAST(salary AS FLOAT)),0) AS avg_salary,
	ROUND(MIN(salary),0) AS min_salary,
    ROUND(MAX(salary),0) AS max_salary
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY experience_years, certifications
ORDER BY avg_salary DESC;


-- 12. MULTI-DIMENSIONAL ANALYSIS
-- ============================================================================

-- Salary by job title and education level
SELECT TOP 30
    job_title,
    education_level,
    COUNT(*) AS count,
    ROUND(AVG(CAST(salary AS FLOAT)),0) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY job_title, education_level
ORDER BY avg_salary DESC;

-- Salary by industry and company size
SELECT 
    industry,
    company_size,
    COUNT(*) AS count,
    AVG(CAST(salary AS FLOAT)) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY industry, company_size
ORDER BY avg_salary DESC;

-- Salary by location and remote work
SELECT 
    location,
    remote_work,
    COUNT(*) AS count,
    AVG(CAST(salary AS FLOAT)) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY location, remote_work
ORDER BY avg_salary DESC;
-- Data quality isse since we have 8234 people from work location "Remote" but sayin "no" to remote_work

-- Since this is Generated Data set it's just worth noticing, but in reality we should cosider further investigation those recoreds from this query

SELECT 
    location,
    remote_work,
    COUNT(*) AS record_count
FROM [dbo].[job_salary_prediction_dataset]
WHERE location = 'Remote' 
    AND remote_work IN ('No', 'Hybrid')
GROUP BY location, remote_work
ORDER BY record_count DESC;

-- Salary by experience years, certifications and remote work
SELECT 
    experience_years,
    certifications,
    remote_work,
    COUNT(*) AS count,
    AVG(CAST(salary AS FLOAT)) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY experience_years, certifications, remote_work
ORDER BY avg_salary DESC;

-- 13. OUTLIER & ANOMALY DETECTION
-- ============================================================================

-- Identify high salary outliers (top 5%)
SELECT TOP 50
    j.job_title,
    j.education_level,
    j.experience_years,
    j.industry,
    j.location,
    j.remote_work,
    j.certifications,
    j.salary,
    'High Salary' AS outlier_type
FROM [dbo].[job_salary_prediction_dataset] AS j
CROSS JOIN (
    SELECT TOP 1
        PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY CAST(salary AS FLOAT)) OVER () AS p95
    FROM [dbo].[job_salary_prediction_dataset]
) AS pct
WHERE j.salary > pct.p95
ORDER BY j.salary DESC;

-- Identify low salary outliers (bottom 5%)
SELECT TOP 50
    j.job_title,
    j.education_level,
    j.experience_years,
    j.industry,
    j.location,
    j.remote_work,
    j.certifications,
    j.salary,
    'Low Sallary' AS outlier_type
FROM [dbo].[job_salary_prediction_dataset] AS j
CROSS JOIN (
    SELECT TOP 1
        PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY CAST(salary AS FLOAT)) OVER () AS p95
    FROM [dbo].[job_salary_prediction_dataset]
) AS pct
WHERE j.salary < pct.p95
ORDER BY j.salary DESC;

-- 14. DATA QUALITY CHECKS
-- ============================================================================

-- Check for null values
SELECT 
    COUNT(*) AS total_records,
    COUNT(job_title) AS non_null_job_title,
    COUNT(experience_years) AS non_null_experience,
    COUNT(education_level) AS non_null_education,
    COUNT(skills) AS non_null_skills,
    COUNT(industry) AS non_null_industry,
    COUNT(company_size) AS non_null_company_size,
    COUNT(location) AS non_null_location,
    COUNT(remote_work) AS non_null_remote_work,
    COUNT(certifications) AS non_null_certifications,
    COUNT(salary) AS non_null_salary
FROM [dbo].[job_salary_prediction_dataset];

-- Check for duplicate records
SELECT 
    job_title,
    experience_years,
    education_level,
    skills,
    industry,
    company_size,
    location,
    remote_work,
    certifications,
    salary,
    COUNT(*) AS duplicate_count
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY 
    job_title,
    experience_years,
    education_level,
    skills,
    industry,
    company_size,
    location,
    remote_work,
    certifications,
    salary
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- ============================================================================
-- END OF EDA ANALYSIS
-- ============================================================================
