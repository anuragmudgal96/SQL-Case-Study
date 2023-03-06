SELECT *
FROM weekly_sales


-------------------------------------------- Data Cleasing -----------------------------------------
-- We will store clean data in clean_weekly_sales from weekly_sales data


SELECT week_date, 
       DATEPART(WEEK, week_date) AS week_number,
       DATEPART(MONTH, week_date) AS month_number,
       DATEPART(YEAR, week_date) AS calendar_year,
       region,
       platform,
       CASE WHEN segment IS NULL THEN 'Unknown' ELSE segment END AS segment,
       CASE WHEN RIGHT(segment, 1) = '1' THEN 'Young Adult'
            WHEN RIGHT(segment, 1) = '2' THEN 'Middle Age'
            WHEN RIGHT(segment, 1) IN ('3', '4') THEN 'Retirees'
            ELSE 'Unknown'
       END AS age_band,
       CASE WHEN LEFT(segment, 1) = 'C' THEN 'Couple'
            WHEN LEFT(segment, 1) = 'F' THEN 'Families'
            ELSE 'Unknown'
       END AS demographic,
       customer_type,
       transactions,
       sales,
       CAST(sales/transactions AS DECIMAL(10,2)) AS avg_transaction
INTO clean_weekly_sales
FROM weekly_sales;

select *
from clean_weekly_sales



-------------------------------------------- Data Exploration --------------------------------

/* Q 1 Which week numbers are missing from the dataset? */

-- Firstly we create a table having number 1 to 52

CREATE TABLE seq52 (
x int primary key
);

INSERT INTO seq52(x)
SELECT TOP 52
ROW_NUMBER() OVER(ORDER BY (SELECT week_number))
FROM clean_weekly_sales

SELECT *
FROM seq52

-- Now we compare the table with our existing clean_weeky_table

SELECT DISTINCT(x) AS missing_week_numbers
FROM seq52 
WHERE x NOT IN (SELECT DISTINCT week_number FROM clean_weekly_sales); 


/* Q2 How many total transactions were there for each year in the dataset? */


select calendar_year,SUM(transactions) total_transactions
from clean_weekly_sales
GROUP BY calendar_year
ORDER BY calendar_year

/* Q3 What are the total sales for each region for each month? */


SELECT region, month_number, SUM(CAST(sales AS bigint)) total_sales
FROM clean_weekly_sales
GROUP BY  region,month_number


/* Q4 What is the total count of transactions for each platform? */

SELECT *
FROM clean_weekly_sales

SELECT platform, SUM(transactions) total_transactions
FROM clean_weekly_sales
GROUP BY  platform

/* Q5  What is the percentage of sales for Retail vs Shopify for each month? */

-- Here we have created a cte after that we did (required_sum/total_sum) X 100 for retail and shopify both seperately

WITH cte_monthly_platform_sales AS (
	SELECT 
	month_number,calendar_year,platform,
	SUM(CAST(sales AS bigint)) AS monthly_sales
	FROM clean_weekly_sales
	GROUP BY month_number,calendar_year,platform
)
SELECT 
month_number, calendar_year, 
CAST( 100*MAX(CASE WHEN platform ='Retail' THEN monthly_sales ElSE NULL END)/SUM(monthly_sales)
				AS decimal(10,2)) AS retail_percentage, 
CAST( 100*MAX(CASE WHEN platform ='Shopify' THEN monthly_sales ElSE NULL END)/SUM(monthly_sales)
				AS decimal(10,2)) AS shopify_percentage
FROM cte_monthly_platform_sales
GROUP BY month_number,calendar_year
ORDER BY month_number,calendar_year


/* 6.What is the percentage of sales by demographic for each year in the dataset? */


SELECT
  calendar_year,
  demographic,
  SUM(CAST(SALES AS bigint)) AS yearly_sales,
  ROUND((100 * SUM(CAST(SALES AS bigint))/SUM(SUM(CAST(SALES AS bigint))) OVER (PARTITION BY demographic)),2) AS percentage
FROM clean_weekly_sales
GROUP BY
  calendar_year,
  demographic
ORDER BY
  calendar_year,
  demographic;



/* 7.Which age_band and demographic values contribute the most to Retail sales? */

SELECT *
FROM clean_weekly_sales

SELECT
  age_band,
  demographic,
  SUM(CAST(SALES AS bigint)) AS total_sales
FROM clean_weekly_sales
WHERE platform = 'Retail'
GROUP BY age_band, demographic
ORDER BY total_sales DESC;
