-- SQL Retail Sales Analysis - P1

--Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales 
	(
		transactions_id	INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id	INT,
		gender VARCHAR(15),
		age	INT,
		category VARCHAR(15),
		quantiy INT,
		price_per_unit	FLOAT,
		cogs	FLOAT,
		total_sale FLOAT
);

--TOP 10 Records
SELECT *
FROM retail_sales 
Limit 10;

-- Total Records
SELECT COUNT(*) 
FROM retail_sales;

-- DATA CLEANING

--Change Column name
ALTER TABLE retail_sales
RENAME quantiy to quantity;

-- Check FOR NULL VALUES
SELECT * 
FROM retail_sales
WHERE transactions_id IS NULL

SELECT *
FROM retail_sales
WHERE sale_date IS NULL

-- Excluding age, we check which other columns have null values
SELECT *
FROM retail_sales
WHERE 
	transactions_id IS NULL 
	OR
	sale_date IS NULL 
	OR
	sale_time IS NULL 
	OR
	customer_id IS NULL 
	OR
	gender IS NULL 
	OR
	category IS NULL 
	OR
	quantity IS NULL 
	OR
	price_per_unit IS NULL 
	OR
	cogs IS NULL 
	OR
	total_sale IS NULL

-- Deleting rows that have null values (3 records had quantity, price_per_unit, cogs as null)
Delete From retail_sales
Where quantity IS NULL
OR
price_per_unit IS NULL
OR 
cogs IS NULL;


-- DATA EXPLORATION

--How many customers did we have?
SELECT COUNT(DISTINCT customer_id) as Customer_count
FROM retail_sales

--How many items did we sell?
SELECT COUNT(*) as total_sale
FROM retail_sales

--How many unique caregories do we have?
SELECT DISTINCT Category
FROM retail_sales

-- ANALYSIS

--Q1. Write a query to retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date='2022-11-05'

--Q2. Write a query to retrieve all transactions where the category is clothing and the quantity sold is more than 4 in Nov 2022
SELECT *
FROM retail_sales
WHERE category='Clothing'
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND quantity >= 4

--Q3. Write a query to calculate total sales for each category
SELECT Category, SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY Category

--Q4. Write a query to find the avg age of customers who purchased items from the "Beauty" category. Round it off to the nearest integer
SELECT FLOOR(AVG(Age)) as average_age
FROM retail_sales
WHERE category='Beauty'

--Q5. Write a query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale>1000
ORDER BY total_sale DESC

--Q6. Write a query to find the total number of transactions made by each gender in each category
SELECT Gender, Category, COUNT(transactions_id) as total_trans
FROM retail_sales
GROUP BY GENDER, CATEGORY
ORDER BY total_trans DESC

--Q7. Write a query to calculate the average sale for each month. Find out the best selling month in each year
Select * FROM
(
	SELECT EXTRACT(YEAR FROM sale_date) AS year, 
			EXTRACT(MONTH FROM sale_date) AS month, 
			AVG(total_sale) as avg_sale,
			RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	FROM retail_sales
	GROUP BY year, month
) AS t1
WHERE RANK = 1

--Q8. Write a query to find the top 5 customers based on the highest total sales
SELECT customer_id, SUM(total_sale) as total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;

--Q9. Write a query to find the number of unique customers who purchased items from each category
SELECT Category, COUNT(DISTINCT customer_id) as unique_cust_count
FROM retail_sales
GROUP BY Category
ORDER BY unique_cust_count DESC

--Q10. Write a query to create each shift and number of orders (Example: Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH shift_details AS
(
SELECT *, 
		 CASE WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			  WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 Then 'Afternoon'
			  Else 'Evening'
		 End AS Shift
FROM retail_sales
)
SELECT Shift, Count(transactions_id) as total_transactions
FROM shift_details
GROUP BY Shift
ORDER BY total_transactions DESC


-- END OF PROJECT







