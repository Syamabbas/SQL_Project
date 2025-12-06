<img alt="BK" src="https://github.com/Syamabbas/SQL_Project/blob/a2a0c12531874380f01ea3fd4aca42bc8acfbae2/scripts/Presentation1.jpg">
<H1> Performance Sales Analysis </H1>

This project highlights how SQL can be applied to analyze end-to-end sales performance in an e-commerce environment. I explored the database structure, calculated key business metrics, and performed time-based, cumulative, and segmentation analyses to generate actionable insights.
</br>

<H3>What I Worked On</H3>

• 🗂️ **Database Exploration** </br>
understanding table structures & relationships using INFORMATION_SCHEMA </br>
Purpose: </br>
    - To explore the structure of the database, including the list of tables and their schemas. </br>
    - To inspect the columns and metadata for specific tables. </br>
Table Used: </br>
    - INFORMATION_SCHEMA.TABLES </br>
    - INFORMATION_SCHEMA.COLUMNS </br>
```
-- Retrieve a list of all tables in the database
SELECT 
    TABLE_CATALOG, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;

-- Retrieve all columns for a specific table (dim_customers)
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';
```
Result: </br>
<img src="Image/1 Database exploration.jpg" alt="Result" width="500"/>

• 🔎 **Dimension & Date Analysis** </br>
identifying data ranges and exploring dimensional tables </br>
Purpose: </br>
    - To explore the structure of dimension tables. </br>
	
SQL Functions Used: </br>
    - DISTINCT </br>
    - ORDER BY </br>
```
-- Retrieve a list of unique countries from which customers originate
SELECT DISTINCT 
    country 
FROM gold.dim_customers
ORDER BY country;

-- Retrieve a list of unique categories, subcategories, and products
SELECT DISTINCT 
    category, 
    subcategory, 
    product_name 
FROM gold.dim_products
ORDER BY category, subcategory, product_name;
```
Result: </br>
<img src="Image/2 Dimension.jpg" alt="Result" width="500"/>

• 📏 **Measures & Magnitude** </br> 
calculating total sales, order counts, AOV, and other core KPIs </br>
Purpose: </br>
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights. </br>
    - To identify overall trends or spot anomalies. </br>
SQL Functions Used: </br>
    - COUNT(), SUM(), AVG() </br>
```
-- Find the Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales

-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales

-- Find the average selling price
SELECT AVG(price) AS avg_price FROM gold.fact_sales

-- Find the Total number of Orders
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales

-- Find the total number of products
SELECT COUNT(product_name) AS total_products FROM gold.dim_products

-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers;

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales;

-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM gold.dim_customers;
```
Result: </br>
<img src="Image/3 Measures.jpg" alt="Result" width="500"/> </br>

• 🏆 **Ranking Analysis** </br>
identifying top products, top customers, and best-selling categories </br>
Purpose: </br>
    - To rank items (e.g., products, customers) based on performance or other metrics. </br>
    - To identify top performers or laggards. </br>

SQL Functions Used: </br>
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP </br>
    - Clauses: GROUP BY, ORDER BY </br>
```
-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- Complex but Flexibly Ranking Using Window Functions
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue;

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;

-- The 3 customers with the fewest orders placed
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders ;
```
Result: </br>
<img src="Image/4 Ranking analysis.jpg" alt="Result" width="500"/> </br>

• 📈 **Change Over Time** </br>
analyzing trends, growth patterns, and seasonality </br>
Purpose: </br>
    - To track trends, growth, and changes in key metrics over time. </br>
    - For time-series analysis and identifying seasonality. </br>
    - To measure growth or decline over specific periods. </br>
SQL Functions Used: </br>
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT() </br>
    - Aggregate Functions: SUM(), COUNT(), AVG() </br>
```
-- Analyse sales performance over time
-- Quick Date Functions
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

-- DATETRUNC()
SELECT
    DATETRUNC(month, order_date) AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);

-- FORMAT()
SELECT
    FORMAT(order_date, 'yyyy-MMM') AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM');
```
Result: </br>
<img src="Image/5 Change over time.jpg" alt="Result" width="500"/> </br>

• 🔁 **Cumulative Analysis** </br>
running totals, moving averages, and long-term performance tracking </br>
Purpose: </br>
    - To calculate running totals or moving averages for key metrics. </br>
    - To track performance over time cumulatively. </br>
    - Useful for growth analysis or identifying long-term trends. </br>
SQL Functions Used: </br>
    - Window Functions: SUM() OVER(), AVG() OVER() </br>
```
-- Calculate the total sales per month 
-- and the running total of sales over time 
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
	AVG(avg_price) OVER (ORDER BY order_date) AS moving_average_price
FROM
(
    SELECT 
        DATETRUNC(year, order_date) AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(year, order_date)
) t
```
Result: </br>
<img src="Image/5 Change over time.jpg" alt="Result" width="500"/> </br>

• 🎯 **Data Segmentation** </br>
customer segmentation (VIP, Regular, New) and age-based grouping </br>
Purpose: </br>
    - To group data into meaningful categories for targeted insights. </br>
    - For customer segmentation, product categorization, or regional analysis. </br>
SQL Functions Used: </br>
    - CASE: Defines custom segmentation logic. </br>
    - GROUP BY: Groups data into segments. </br>
```
/*Segment products into cost ranges and 
count how many products fall into each segment*/
WITH product_segments AS (
    SELECT
        product_key,
        product_name,
        cost,
        CASE 
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products
)
SELECT 
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
WITH customer_spending AS (
    SELECT
        c.customer_key,
        SUM(f.sales_amount) AS total_spending,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
)
SELECT 
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
    SELECT 
        customer_key,
        CASE 
            WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_spending
) AS segmented_customers
GROUP BY customer_segment
ORDER BY total_customers DESC;
```
Result: </br>
<img src="Image/7 Data Segmentation.jpg" alt="Result" width="500"/> </br>

• 📊 **Performance Reporting** </br>
compiling KPIs such as recency, total sales, quantity purchased, lifespan, and average monthly spend </br>
Purpose: </br>
    - This report consolidates key customer metrics and behaviors </br>
Highlights: </br>
    1. Gathers essential fields such as names, ages, and transaction details. </br>
	2. Segments customers into categories (VIP, Regular, New) and age groups. </br>
    3. Aggregates customer-level metrics: </br>
	   - total orders </br>
	   - total sales </br>
	   - total quantity purchased </br>
	   - total products </br>
	   - lifespan (in months) </br>
    4. Calculates valuable KPIs: </br>
	    - recency (months since last order) </br>
		- average order value </br>
		- average monthly spend </br>
```
-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS

WITH base_query AS(
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
SELECT
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
DATEDIFF(year, c.birthdate, GETDATE()) age
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
WHERE order_date IS NOT NULL)

, customer_aggregation AS (
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT product_key) AS total_products,
	MAX(order_date) AS last_order_date,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY 
	customer_key,
	customer_number,
	customer_name,
	age
)
SELECT
customer_key,
customer_number,
customer_name,
age,
CASE 
	 WHEN age < 20 THEN 'Under 20'
	 WHEN age between 20 and 29 THEN '20-29'
	 WHEN age between 30 and 39 THEN '30-39'
	 WHEN age between 40 and 49 THEN '40-49'
	 ELSE '50 and above'
END AS age_group,
CASE 
    WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
    WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
    ELSE 'New'
END AS customer_segment,
last_order_date,
DATEDIFF(month, last_order_date, GETDATE()) AS recency,
total_orders,
total_sales,
total_quantity,
total_products
lifespan,
-- Compuate average order value (AVO)
CASE WHEN total_sales = 0 THEN 0
	 ELSE total_sales / total_orders
END AS avg_order_value,
-- Compuate average monthly spend
CASE WHEN lifespan = 0 THEN total_sales
     ELSE total_sales / lifespan
END AS avg_monthly_spend
FROM customer_aggregation
```
Result: </br>
<img src="Image/11 Gold Report Customers.jpg" alt="Result" width="500"/> </br>
<img src="Image/11 Gold Report Product.jpg" alt="Result" width="500"/> </br>

💡 This project reflects my skills in: </br>
• SQL query writing </br>
• Data exploration & analytical thinking </br>
• KPI development </br>
• Business insight generation </br>
