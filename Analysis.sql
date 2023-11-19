create database projects;

use projects;

select * from cleaned_dataset;

-- 1. Count the distinct countries
SELECT COUNT(DISTINCT country) AS num_countries
FROM cleaned_dataset;

-- 2. Calculate the total loan amount for each project
SELECT
    `Country`,
    `Project Name`,
    SUM(`Original Principal Amount`) AS total_loan_amount
FROM
    cleaned_dataset
GROUP BY
    `Country`,
    `Project Name`;
    
-- 3 Calculate the total original principal amount for all projects
SELECT
    SUM(`Original Principal Amount`) AS total_original_principal_amount
FROM
    cleaned_dataset;
    
-- 4. Calculate the total original principal amount for each distinct country
SELECT
    `Country`,
    SUM(`Original Principal Amount`) AS total_original_principal_amount
FROM
    cleaned_dataset
GROUP BY
    `Country`;
    
-- 5. Calculate the average Repaid to IDA for each region
SELECT
    `Region`,
    AVG(`Repaid to IDA`) AS AvgRepaidToIDA
FROM
    cleaned_dataset
GROUP BY
    `Region`;
    
-- 6. Find the country with the highest ratio of Repaid to IDA to Original Principal Amount for Fully Repaid projects
SELECT
    `Country`,
    MAX(`Repaid to IDA` / `Original Principal Amount`) AS MaxRepaidToPrincipalRatio
FROM
    cleaned_dataset
WHERE
    `Credit Status` = 'Fully Repaid'
GROUP BY
    `Country`;
    
-- 7. Count the number of projects with different Credit Status values for each country
SELECT
    `Country`,
    `Credit Status`,
    COUNT(*) AS NumberOfProjects
FROM
    cleaned_dataset
GROUP BY
    `Country`,
    `Credit Status`;
    
-- 8. Calculate the number of countries in each region that have taken a loan from the World Bank
SELECT
    `Region`,
    COUNT(DISTINCT `Country`) AS NumberOfCountriesWithLoans
FROM
    cleaned_dataset
GROUP BY
    `Region`;
    
-- 9. Calculate the total number of fully repaid projects for each region
SELECT
    `Region`,
    SUM(CASE WHEN `Credit Status` = 'Fully Repaid' THEN 1 ELSE 0 END) AS TotalFullyRepaidProjects
FROM
    cleaned_dataset
GROUP BY
    `Region`;
    
-- 10. Find projects with the highest Due to IDA and their corresponding Country and Effective Date
SELECT
    `Country`,
    `Project Name`,
    `Effective Date`,
    CONCAT('$', ROUND(`Due to IDA`, 2)) AS `Due to IDA Amount`
FROM
    cleaned_dataset
ORDER BY
    `Due to IDA` DESC
LIMIT 5;
    
-- 11. Find the top 5 countries with the highest ratio of Repaid to IDA to Original Principal Amount for projects not fully repaid
SELECT
    `Country`,
    CASE
        WHEN SUM(CASE WHEN `Credit Status` != 'Fully Repaid' THEN `Original Principal Amount` ELSE 0 END) = 0 THEN '$0'
        ELSE CONCAT('$', FORMAT(
            COALESCE(
                SUM(CASE WHEN `Credit Status` != 'Fully Repaid' THEN `Repaid to IDA` ELSE 0 END) /
                SUM(CASE WHEN `Credit Status` != 'Fully Repaid' THEN `Original Principal Amount` ELSE 0 END), 0
            ), 4))
    END AS `Ratio Repaid to Original Principal Amount`
FROM
    cleaned_dataset
WHERE
    `Credit Status` != 'Fully Repaid'
GROUP BY
    `Country`
ORDER BY
    `Ratio Repaid to Original Principal Amount` DESC
LIMIT 5;

-- 12. Top 5 Countries with the highest Loan amount
SELECT
    `country`,
    CONCAT('$', ROUND(
            (SUM(CAST(REPLACE(`Original Principal Amount`, ',', '') AS DECIMAL(10,2))) -
            SUM(CAST(REPLACE(`Cancelled Amount`, ',', '') AS DECIMAL(10,2)))) / 1000000000, 2), 'B') AS `All Loan Amount`
FROM
    cleaned_dataset
GROUP BY
    `country`
ORDER BY
    `All Loan Amount` DESC
LIMIT 5;

-- 13. Top 5 Countries with the highest Due amount
SELECT
    `country`,
    CONCAT('$', ROUND(SUM(CAST(REPLACE(`Due to IDA`, ',', '') AS DECIMAL(10,2))) / 1000000000, 2), 'B') AS `Due Loan Amount`
FROM
    cleaned_dataset
GROUP BY
    `country`
ORDER BY
    SUM(CAST(REPLACE(`Due to IDA`, ',', '') AS DECIMAL(10,2))) DESC
LIMIT 5;