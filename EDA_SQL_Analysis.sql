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
    AVG(CAST(experience_years AS FLOAT)) AS avg_experience
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

-- Salary correlation with experience years
SELECT 
    experience_years,
    COUNT(*) AS count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY experience_years
ORDER BY experience_years;

-- Experience distribution by percentiles
SELECT 
    MIN(experience_years) AS min_experience,
    MAX(experience_years) AS max_experience,
    AVG(CAST(experience_years AS FLOAT)) AS avg_experience,
    STDEV(experience_years) AS experience_stddev
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
    AVG(salary) AS avg_salary,
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
    CASE 
        WHEN experience_years = 0 THEN 1
        WHEN experience_years BETWEEN 1 AND 5 THEN 2
        WHEN experience_years BETWEEN 6 AND 10 THEN 3
        WHEN experience_years BETWEEN 11 AND 15 THEN 4
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

-- 9. REMOTE WORK ANALYSIS
-- ============================================================================

-- Salary by remote work option (Yes/No)
SELECT 
    remote_work,
    COUNT(*) AS count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    STDEV(salary) AS salary_stddev,
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
    skills,
    COUNT(*) AS count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    STDEV(salary) AS salary_stddev
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY skills
ORDER BY avg_salary DESC;

-- Skills distribution
SELECT 
    skills,
    COUNT(*) AS count,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[job_salary_prediction_dataset]) AS DECIMAL(5, 2)) AS percentage_distribution
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY skills
ORDER BY count DESC;

-- 11. CERTIFICATIONS ANALYSIS
-- ============================================================================

-- Salary by certifications count
SELECT 
    certifications,
    COUNT(*) AS count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    STDEV(salary) AS salary_stddev
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY certifications
ORDER BY avg_salary DESC;

-- Certifications distribution
SELECT 
    certifications,
    COUNT(*) AS count,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[job_salary_prediction_dataset]) AS DECIMAL(5, 2)) AS percentage_distribution
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY certifications
ORDER BY count DESC;

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

-- Salary by location and remote work
SELECT 
    location,
    remote_work,
    COUNT(*) AS count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY location, remote_work
ORDER BY avg_salary DESC;

-- Salary by experience years, certifications and remote work
SELECT 
    experience_years,
    certifications,
    remote_work,
    COUNT(*) AS count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY experience_years, certifications, remote_work
ORDER BY avg_salary DESC;

-- 13. OUTLIER & ANOMALY DETECTION
-- ============================================================================

-- Identify high salary outliers (top 5%)
SELECT TOP 50
    job_title,
    education_level,
    experience_years,
    industry,
    location,
    remote_work,
    certifications,
    salary,
    'High Salary' AS outlier_type
FROM [dbo].[job_salary_prediction_dataset]
WHERE salary > (SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY salary) FROM [dbo].[job_salary_prediction_dataset])
ORDER BY salary DESC;

-- Identify low salary outliers (bottom 5%)
SELECT TOP 50
    job_title,
    education_level,
    experience_years,
    industry,
    location,
    remote_work,
    certifications,
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

-- 15. CORRELATION & RELATIONSHIP ANALYSIS
-- ============================================================================

-- Average salary metrics by multiple dimensions
SELECT 
    job_title,
    industry,
    company_size,
    AVG(salary) AS avg_salary,
    COUNT(*) AS count,
    AVG(CAST(experience_years AS FLOAT)) AS avg_experience,
    AVG(CAST(skills AS FLOAT)) AS avg_skills,
    AVG(CAST(certifications AS FLOAT)) AS avg_certifications
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY job_title, industry, company_size
HAVING COUNT(*) >= 5
ORDER BY avg_salary DESC;

-- Experience and certifications impact on salary
SELECT 
    experience_years,
    certifications,
    COUNT(*) AS count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY experience_years, certifications
ORDER BY experience_years, certifications;

-- Remote work advantage analysis
SELECT 
    remote_work,
    job_title,
    AVG(salary) AS avg_salary,
    COUNT(*) AS count
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY remote_work, job_title
HAVING COUNT(*) >= 3
ORDER BY remote_work, avg_salary DESC;

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
    AVG(CAST(experience_years AS FLOAT)) AS avg_exp,
    AVG(CAST(certifications AS FLOAT)) AS avg_certs
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY job_title, education_level
ORDER BY avg_salary DESC;

-- Geographic and company performance summary
SELECT 
    location,
    company_size,
    COUNT(*) AS positions,
    AVG(salary) AS avg_salary,
    MAX(salary) AS max_salary,
    MIN(salary) AS min_salary,
    AVG(CAST(experience_years AS FLOAT)) AS avg_experience
FROM [dbo].[job_salary_prediction_dataset]
GROUP BY location, company_size
HAVING COUNT(*) >= 3
ORDER BY avg_salary DESC;

-- ============================================================================
-- END OF EDA ANALYSIS
-- ============================================================================
