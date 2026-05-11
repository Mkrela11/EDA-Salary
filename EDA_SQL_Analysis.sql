-- ============================================================================
-- EXPLORATORY DATA ANALYSIS (EDA) FOR JOB SALARY PREDICTION DATASET
-- ============================================================================
-- Purpose: Comprehensive analysis of job_salary_prediction_dataset table
-- Date: 2026-05-11
-- ============================================================================

-- 1. BASIC DATASET OVERVIEW
-- ============================================================================

-- Check total number of records
SELECT 
    COUNT(*) AS total_records,
    COUNT(DISTINCT job_title) AS unique_jobs,
    COUNT(DISTINCT education_level) AS unique_education_levels,
    COUNT(DISTINCT industry) AS unique_industries,
    COUNT(DISTINCT company_size) AS unique_company_sizes,
    COUNT(DISTINCT location) AS unique_locations,
    COUNT(DISTINCT work_type) AS unique_work_types
FROM [dbo].[job_salary_prediction_dataset];

-- Display sample data to understand structure
SELECT TOP 20
    job_title,
    years_of_experience,
    education_level,
    years_at_company,
    industry,
    company_size,
    location,
    work_type,
    projects_handled,
    salary
FROM [dbo].[job_salary_prediction_dataset];

-- 2. SALARY STATISTICS & DISTRIBUTION
-- ============================================================================

-- Overall salary statistics
SELECT 
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    AVG(salary) AS avg_salary,
    STDEV(salary) AS salary_stddev,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY salary) OVER () AS q1_salary,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY salary) OVER () AS median_salary,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salary) OVER () AS q3_salary
FROM [dbo].[job_salary_prediction_dataset];

-- Salary distribution by quartiles
SELECT 
    'Q1 (0-25%)' AS salary_quartile,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    COUNT(*) AS record_count,
    AVG(salary) AS avg_salary
FROM [dbo].[job_salary_prediction_dataset]
WHERE salary <= (SELECT PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY salary) FROM [dbo].[job_salary_prediction_dataset])
UNION ALL
SELECT 
    'Q2 (25-50%)',
    MIN(salary),
    MAX(salary),
    COUNT(*),
    AVG(salary)
FROM [dbo].[job_salary_prediction_dataset]
WHERE salary > (SELECT PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY salary) FROM [dbo].[job_salary_prediction_dataset])
    AND salary <= (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY salary) FROM [dbo].[job_salary_prediction_dataset])
UNION ALL
SELECT 
    'Q3 (50-75%)',
    MIN(salary),
    MAX(salary),
    COUNT(*),
    AVG(salary)
FROM [dbo].[job_salary_prediction_dataset]
WHERE salary > (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY salary) FROM [dbo].[job_salary_prediction_dataset])
    AND salary <= (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salary) FROM [dbo].[job_salary_prediction_dataset])
UNION ALL
SELECT 
    'Q4 (75-100%)',
    MIN(salary),
    MAX(salary),
    COUNT(*),
    AVG(salary)
FROM [dbo].[job_salary_prediction_dataset]
WHERE salary > (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salary) FROM [dbo].[job_salary_prediction_dataset]);

-- 3. JOB TITLE ANALYSIS
-- ============================================================================

-- Salary statistics by job title
SELECT TOP 20
    job_title,
    COUNT(*) AS job_count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    STDEV(salary) AS salary_stddev,
    AVG(CAST(years_of_experience AS FLOAT)) AS avg_experience
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
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[job_salary_prediction_dataset]) AS DECIMAL(5, 2)) AS percentage
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY education_level
ORDER BY avg_salary DESC;

-- Education level distribution
SELECT 
    education_level,
    COUNT(*) AS count,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[job_salary_prediction_dataset]) AS DECIMAL(5, 2)) AS percentage_distribution
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY education_level
ORDER BY count DESC;

-- 5. EXPERIENCE ANALYSIS
-- ============================================================================

-- Salary correlation with years of experience
SELECT 
    years_of_experience,
    COUNT(*) AS count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY years_of_experience
ORDER BY years_of_experience;

-- Experience distribution by percentiles
SELECT 
    MIN(years_of_experience) AS min_experience,
    MAX(years_of_experience) AS max_experience,
    AVG(CAST(years_of_experience AS FLOAT)) AS avg_experience,
    STDEV(years_of_experience) AS experience_stddev
FROM [dbo].[job_salary_prediction_dataset];

-- Experience brackets and salary
SELECT 
    CASE 
        WHEN years_of_experience = 0 THEN '0 years'
        WHEN years_of_experience BETWEEN 1 AND 5 THEN '1-5 years'
        WHEN years_of_experience BETWEEN 6 AND 10 THEN '6-10 years'
        WHEN years_of_experience BETWEEN 11 AND 15 THEN '11-15 years'
        ELSE '15+ years'
    END AS experience_bracket,
    COUNT(*) AS count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY 
    CASE 
        WHEN years_of_experience = 0 THEN '0 years'
        WHEN years_of_experience BETWEEN 1 AND 5 THEN '1-5 years'
        WHEN years_of_experience BETWEEN 6 AND 10 THEN '6-10 years'
        WHEN years_of_experience BETWEEN 11 AND 15 THEN '11-15 years'
        ELSE '15+ years'
    END
ORDER BY 
    CASE 
        WHEN years_of_experience = 0 THEN 1
        WHEN years_of_experience BETWEEN 1 AND 5 THEN 2
        WHEN years_of_experience BETWEEN 6 AND 10 THEN 3
        WHEN years_of_experience BETWEEN 11 AND 15 THEN 4
        ELSE 5
    END;

-- 6. INDUSTRY ANALYSIS
-- ============================================================================

-- Salary by industry
SELECT TOP 20
    industry,
    COUNT(*) AS count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    STDEV(salary) AS salary_stddev,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[job_salary_prediction_dataset]) AS DECIMAL(5, 2)) AS percentage
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY industry
ORDER BY avg_salary DESC;

-- Top industries by record count
SELECT TOP 15
    industry,
    COUNT(*) AS count,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[job_salary_prediction_dataset]) AS DECIMAL(5, 2)) AS percentage
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY industry
ORDER BY count DESC;

-- 7. COMPANY SIZE ANALYSIS
-- ============================================================================

-- Salary by company size
SELECT 
    company_size,
    COUNT(*) AS count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    STDEV(salary) AS salary_stddev,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[job_salary_prediction_dataset]) AS DECIMAL(5, 2)) AS percentage
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY company_size
ORDER BY avg_salary DESC;

-- Company size distribution
SELECT 
    company_size,
    COUNT(*) AS count,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[job_salary_prediction_dataset]) AS DECIMAL(5, 2)) AS percentage_distribution
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY company_size
ORDER BY count DESC;

-- 8. LOCATION ANALYSIS
-- ============================================================================

-- Salary by location
SELECT TOP 25
    location,
    COUNT(*) AS count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    STDEV(salary) AS salary_stddev
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY location
ORDER BY avg_salary DESC;

-- Top locations by frequency
SELECT TOP 20
    location,
    COUNT(*) AS count,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[job_salary_prediction_dataset]) AS DECIMAL(5, 2)) AS percentage
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY location
ORDER BY count DESC;

-- 9. WORK TYPE ANALYSIS
-- ============================================================================

-- Salary by work type (On-site, Remote, Hybrid)
SELECT 
    work_type,
    COUNT(*) AS count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    STDEV(salary) AS salary_stddev,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[job_salary_prediction_dataset]) AS DECIMAL(5, 2)) AS percentage
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY work_type
ORDER BY avg_salary DESC;

-- Work type distribution
SELECT 
    work_type,
    COUNT(*) AS count,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[job_salary_prediction_dataset]) AS DECIMAL(5, 2)) AS percentage_distribution
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY work_type
ORDER BY count DESC;

-- 10. YEARS AT COMPANY ANALYSIS
-- ============================================================================

-- Salary by years at company
SELECT 
    years_at_company,
    COUNT(*) AS count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    STDEV(salary) AS salary_stddev
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY years_at_company
ORDER BY years_at_company;

-- Years at company statistics
SELECT 
    MIN(years_at_company) AS min_years_at_company,
    MAX(years_at_company) AS max_years_at_company,
    AVG(CAST(years_at_company AS FLOAT)) AS avg_years_at_company,
    STDEV(years_at_company) AS years_at_company_stddev
FROM [dbo].[job_salary_prediction_dataset];

-- 11. PROJECTS HANDLED ANALYSIS
-- ============================================================================

-- Salary by projects handled
SELECT 
    projects_handled,
    COUNT(*) AS count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY projects_handled
ORDER BY projects_handled;

-- Projects handled statistics
SELECT 
    MIN(projects_handled) AS min_projects,
    MAX(projects_handled) AS max_projects,
    AVG(CAST(projects_handled AS FLOAT)) AS avg_projects,
    STDEV(projects_handled) AS projects_stddev
FROM [dbo].[job_salary_prediction_dataset];

-- 12. MULTI-DIMENSIONAL ANALYSIS
-- ============================================================================

-- Salary by job title and education level
SELECT TOP 30
    job_title,
    education_level,
    COUNT(*) AS count,
    AVG(salary) AS avg_salary,
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
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY industry, company_size
ORDER BY avg_salary DESC;

-- Salary by location and work type
SELECT 
    location,
    work_type,
    COUNT(*) AS count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY location, work_type
ORDER BY avg_salary DESC;

-- 13. OUTLIER & ANOMALY DETECTION
-- ============================================================================

-- Identify high salary outliers (top 5%)
SELECT TOP 50
    job_title,
    education_level,
    years_of_experience,
    industry,
    location,
    salary,
    'High Salary' AS outlier_type
FROM [dbo].[job_salary_prediction_dataset]
WHERE salary > (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY salary) FROM [dbo].[job_salary_prediction_dataset])
ORDER BY salary DESC;

-- Identify low salary outliers (bottom 5%)
SELECT TOP 50
    job_title,
    education_level,
    years_of_experience,
    industry,
    location,
    salary,
    'Low Salary' AS outlier_type
FROM [dbo].[job_salary_prediction_dataset]
WHERE salary < (SELECT PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY salary) FROM [dbo].[job_salary_prediction_dataset])
ORDER BY salary ASC;

-- 14. DATA QUALITY CHECKS
-- ============================================================================

-- Check for null values
SELECT 
    COUNT(*) AS total_records,
    COUNT(job_title) AS non_null_job_title,
    COUNT(years_of_experience) AS non_null_experience,
    COUNT(education_level) AS non_null_education,
    COUNT(years_at_company) AS non_null_years_at_company,
    COUNT(industry) AS non_null_industry,
    COUNT(company_size) AS non_null_company_size,
    COUNT(location) AS non_null_location,
    COUNT(work_type) AS non_null_work_type,
    COUNT(projects_handled) AS non_null_projects,
    COUNT(salary) AS non_null_salary
FROM [dbo].[job_salary_prediction_dataset];

-- Check for duplicate records
SELECT 
    job_title,
    years_of_experience,
    education_level,
    years_at_company,
    industry,
    company_size,
    location,
    work_type,
    projects_handled,
    salary,
    COUNT(*) AS duplicate_count
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY 
    job_title,
    years_of_experience,
    education_level,
    years_at_company,
    industry,
    company_size,
    location,
    work_type,
    projects_handled,
    salary
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- 15. CORRELATION & RELATIONSHIP ANALYSIS
-- ============================================================================

-- Average salary metrics by multiple dimensions
SELECT 
    job_title,
    industry,
    company_size,
    AVG(salary) AS avg_salary,
    COUNT(*) AS count,
    AVG(CAST(years_of_experience AS FLOAT)) AS avg_experience,
    AVG(CAST(years_at_company AS FLOAT)) AS avg_tenure,
    AVG(CAST(projects_handled AS FLOAT)) AS avg_projects
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY job_title, industry, company_size
HAVING COUNT(*) >= 5
ORDER BY avg_salary DESC;

-- 16. SUMMARY STATISTICS
-- ============================================================================

-- Comprehensive summary by job title and education
SELECT 
    job_title,
    education_level,
    COUNT(*) AS total_positions,
    AVG(salary) AS avg_salary,
    MAX(salary) AS max_salary,
    MIN(salary) AS min_salary,
    STDEV(salary) AS salary_variance,
    AVG(CAST(years_of_experience AS FLOAT)) AS avg_exp,
    CAST(AVG(CAST(years_of_experience AS FLOAT)) * 100.0 / NULLIF((SELECT AVG(CAST(years_of_experience AS FLOAT)) FROM [dbo].[job_salary_prediction_dataset]), 0) AS DECIMAL(5, 2)) AS exp_vs_overall_pct
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY job_title, education_level
ORDER BY avg_salary DESC;

-- ============================================================================
-- END OF EDA ANALYSIS
-- ============================================================================
