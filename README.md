# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Database**: `sql_project_p1`

This project is designed to demonstrate SQL skills and techniques typically used by BI and data analysts to explore, clean and analyze data. This project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions using SQL queries.

## Objectives

1. **Set up a retail sales database**
2. **Data Cleaning**
3. **Exploratory Data Analysis (EDA)**
4. **Analysis Using SQL**

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_p1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes following columns: transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
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
```

### 2. Data Exploration & Cleaning

- **Top 10 records**: Get the top 10 records to understand data. 
- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset(excluding age) and delete records with missing data.

```sql
SELECT * FROM retail_sales  Limit 10;
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

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

Delete From retail_sales
Where quantity IS NULL
OR
price_per_unit IS NULL
OR 
cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT
 *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in Nov 2022**:
```sql
SELECT
 *
FROM retail_sales
WHERE category='Clothing'
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND quantity >= 4
```

3. **Write a query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT
    Category,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY Category
```

4. **Write a query to find the average age of customers who purchased items from the 'Beauty' category. Round it off to the nearest integer.**:
```sql
SELECT
    FLOOR(AVG(Age)) as average_age
FROM retail_sales
WHERE category='Beauty'
```

5. **Write a query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT
    *
FROM retail_sales
WHERE total_sale>1000
ORDER BY total_sale DESC
```

6. **Write a query to find the total number of transactions made by each gender in each category.**:
```sql
SELECT
    Gender,
    Category,
    COUNT(transactions_id) as total_trans
FROM retail_sales
GROUP BY GENDER, CATEGORY
ORDER BY total_trans DESC
```

7. **Write a query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
Select
    *
FROM
(
	SELECT EXTRACT(YEAR FROM sale_date) AS year, 
			EXTRACT(MONTH FROM sale_date) AS month, 
			AVG(total_sale) as avg_sale,
			RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	FROM retail_sales
	GROUP BY year, month
) AS t1
WHERE RANK = 1
```

8. **Write a query to find the top 5 customers based on the highest total sales.**:
```sql
SELECT
    customer_id,
    SUM(total_sale) as total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;
```

9. **Write a query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT
    Category,
    COUNT(DISTINCT customer_id) as unique_cust_count
FROM retail_sales
GROUP BY Category
ORDER BY unique_cust_count DESC
```

10. **Write a query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

## Findings

- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.
- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.


## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.
