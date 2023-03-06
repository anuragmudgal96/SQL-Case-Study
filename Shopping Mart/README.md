
# Shopping Mart - Case Study

**Problem Statement:**
In June 2020, Shopping Mart underwent large scale supply changes. As a result, all of its products now utilize sustainable packaging methods at every stage, starting from the farm and continuing all the way to the customer. 

Director seeking assistance in quantifying the impact of the sustainable packaging changes on the sales performance of shopping mart and its various business areas.


The main types of attributes are:

| Column name| Data type|
| -----------| ---------|
| week_date | date |
| region | varchar(20) |
| platform | varchar(20)|
| segment | varchar(20) |
| customer | varchar(20)|
| transactions | int|
| sales | int|




**Task Performed:** Data Cleansing and data exploration.


**Data Set:** Data is available in a [csv file](https://github.com/anuragmudgal96/SQL-Case-Study/blob/main/Shopping%20Mart/weekly_sales_raw.csv).

**Tool Used:**
- Microsoft SQL Server 2019 for data analysis - [View SQL scripts](https://github.com/anuragmudgal96/SQL-Case-Study/blob/main/Shopping%20Mart/shopping_mart_SQLQuery.sql)


**Approach:**
<details>
<summary>  Data Cleansing Steps </summary>
In a single query, we performed the following operations and generate a new table named clean_weekly_sales:

- Added week_number as the second column for each week_date value, for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2, etc.
- Added month_number with the calendar month for each week_date value as the 3rd column
- Added a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values
- Added a new column called age_band after the original segment column using the following mapping on the number inside the segment value

| segment| age_band|
| -----------| ---------|
| 1 | Young Adults |
| 2 | Middle Aged |
| 3 or 4 | Retirees|

- Added a new demographic column using the following mapping for the first letter in the segment values:

| segment| demographic |
| -----------| ---------|
| F | Couples  |
| C | Families |

Have a look at [clean_weekly_sales.csv](https://github.com/anuragmudgal96/SQL-Case-Study/blob/main/Shopping%20Mart/clean_weekly_sales.csv) after cleansing process.
</details>

<details>
<summary>  Data exploration </summary>
<ol>
    <li> Which week numbers are missing from the dataset?</li>
    <li> How many total transactions were there for each year in the dataset?</li>
    <li> What are the total sales for each region for each month?</li>
    <li> What is the total count of transactions for each platform</li>
    <li> What is the percentage of sales for Retail vs Shopify for each month?</li>
    <li> What is the percentage of sales by demographic for each year in the dataset?</li>
    <li> Which age_band and demographic values contribute the most to Retail sales?</li>
</ol>
    
View my solution [here](https://github.com/anuragmudgal96/SQL-Case-Study/blob/main/Shopping%20Mart/shopping_mart_SQLQuery.sql).
</details>
