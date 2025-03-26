-- CREATE TABLE

CREATE TABLE retail_sales
	(
		transactions_id INT PRIMARY KEY,
		sales_date DATE,
		sales_time TIME,
		customer_id INT,
		gender VARCHAR(15),
		age INT,
		category VARCHAR(15),
		quantity INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
	);

SELECT * FROM retail_sales;

-- DATA CLEANING

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sales_date IS NULL
	OR
	sales_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sales_date IS NULL
	OR
	sales_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- DATA EXPLORATION

-- How many sales we have?
SELECT count(*) as total_sale FROM retail_sales;

-- How many unique customers we have?
SELECT count(DISTINCT(customer_id)) FROM retail_sales;

-- How many categories we have?
SELECT count(DISTINCT category) from retail_sales;


-- DATA ANALYSIS & BUSINESS KEY PROBLEMS & ANSWERS

-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sales_date = '2022-11-05';


-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in 
--     the month of Nov-2022.
SELECT * FROM retail_sales
WHERE 
	category = 'Clothing' 
	AND 
	TO_CHAR(sales_date,'YYYY-MM') = '2022-11' 
	AND 
	quantity >= 4;


-- Q3. Write a SQL query to calculate the total sales(total_sale) for each category.
SELECT category, sum(total_sale) as Total_sales, count(*) as total_orders FROM retail_sales
GROUP BY category;

-- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty category'.
SELECT category, round(avg(age),2) as avg_age FROM retail_sales
WHERE category = 'Beauty'
Group BY category;

-- Q5. Write a SQL query to find all transactions where total_sale is greater than 1000.
SELECT transactions_id, total_sale FROM retail_sales
WHERE total_sale > 1000;

-- Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT gender,category,count(transactions_id) as total_no_trans FROM retail_sales
GROUP BY gender,category

-- Q7. Write a SQL query to calculate average sale for each month. Find out best selling month in each year.
SELECT 
	year,
	month,
	avg_sale
FROM 
(
SELECT 
	EXTRACT(YEAR FROM sales_date) as year, 
	EXTRACT(MONTH FROM sales_date) as month, 
	avg(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sales_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY year,month
) as t1
WHERE rank = 1


-- Q8. Write a SQL query to find top 5 customers based on the heighest total sales.
SELECT customer_id, sum(total_sale) as total_sales FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5


-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) AS unique_cs FROM retail_sales
GROUP BY category

-- Q10. Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon between 12 & 17, 
--      Evening >17)
WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sales_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sales_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as Shift
FROM retail_sales
)
SELECT
	Shift,
	count(*) as total_orders
FROM hourly_sale
GROUP BY Shift




