DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
transactions_id	INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id	INT,
gender	VARCHAR(15),
age	INT,
category VARCHAR(15),	
quantiy	INT,
price_per_unit FLOAT,	
cogs FLOAT,
total_sale FLOAT
);

SELECT * FROM retail_sales;

SELECT
COUNT(*)
FROM retail_sales

--DATA CLEANING--

SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE 
customer_id IS NULL
OR
gender IS NULL
OR
category IS NULL
OR 
quantiy IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

DELETE FROM retail_sales
WHERE
customer_id IS NULL
OR
gender IS NULL
OR
category IS NULL
OR 
quantiy IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

--DATA EXPLORATION--

-How many sales we have?

SELECT COUNT (*) AS total_sale FROM retail_sales

-How many unique customers we have?

SELECT COUNT (DISTINCT customer_id) AS total_sale FROM retail_sales

SELECT DISTINCT category FROM retail_sales

--DATA ANALYSIS & BUSINESS KEY PROBLEMS

-Q1.  Write a sql query to retrive all sales made on '2022-11-05'

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-Q2. Write a sql query which retrives all the transaction where category is clothing and the quantity sold is more than 4 
in the month of November 2022

SELECT 
category,
SUM(quantiy)
FROM retail_sales
WHERE category = 'Clothing'
GROUP BY 1

SELECT 
*
FROM retail_sales
WHERE category = 'Clothing'
AND
TO_CHAR(sale_date, 'yyyy-mm') = '2022-11'
AND
quantiy >= 4

-Q.3 Write a sql query to calculate the total sales (total_sale) for each category

SELECT
category,
SUM (total_sale) AS net_sale,
COUNT (*) as total_orders
FROM retail_sales
GROUP BY 1

-Q4. Write a sql query to find the average age of customers who purchased items from
the 'beauty' category

SELECT 
ROUND (AVG(age),2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty'

-Q.5 Write a sql query to find all transactions where the total_sale is greater than 1000

SELECT * FROM retail_sales
WHERE total_sale > 1000

Q6. Write a sql query to find the total number of transactions (transactions_id) made by each gender in each category

SELECT
category,
gender,
COUNT(*) AS total_trans
FROM retail_sales
GROUP BY 
category,
gender
ORDER BY 1

-Q7. Write a sql queryto calculate the average sale for each month. Find out 
the best selling month in each year

SELECT * FROM
(
SELECT 
EXTRACT(YEAR FROM sale_date) as year,
EXTRACT (MONTH FROM sale_date) as month,
AVG(total_sale) as avg_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1,2
)AS t1
WHERE rank = 1

-Q8. Write a sql query to find the top 5 customers based on the highest total sales

SELECT
customer_id,
SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

Q9. Write a sql query to find out unique customers who purchased items from each category

SELECT
category,
COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category

-Q10. Write a sql query to create each shift and number of orders (Example morning <=12, Afternoon between 12 and 17 , Evening>17)

WITH hourly_sale
AS
(
SELECT *,
CASE
WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END as shift
FROM retail_sales
)
SELECT 
shift,
COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift

