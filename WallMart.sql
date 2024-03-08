CREATE DATABASE WalMart_Sales_Analysis;
CREATE TABLE sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

SELECT *FROM sales;

/*Adding time_of_day Column*/

SELECT TIME ,(CASE 
WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
ELSE "Evening" END) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE sales SET time_of_day = ( CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);


/*Add day_name column*/
SELECT DATE, dayname(date) FROM sales;
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
UPDATE sales SET day_name =dayname(date);

/* Add month_name column*/
SELECT DATE, monthname(date) FROM sales;
ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
UPDATE sales set month_name = monthname(date);

						/*PRODUCTS*/
-- How many unique product lines does the data have?

SELECT DISTINCT(product_line) FROM sales;

-- What is the most selling product line
SELECT SUM(quantity) as Quantity, product_line FROM sales
GROUP BY product_line
ORDER BY Quantity DESC;

-- What is the total revenue by month
SELECT month_name AS Month, SUM(total) AS Total_Revenue FROM sales
GROUP BY month_name
ORDER BY Total_Revenue;

-- What month had the largest COGS?
SELECT month_name AS Month, SUM(cogs) AS COGS from sales
GROUP BY month_name
ORDER BY COGS;

-- What product line had the largest revenue?
SELECT product_line, Sum(total) AS Revenue from sales
GROUP BY product_line
ORDER BY Revenue DESC;

-- What is the city with the largest revenue?
SELECT branch, city, SUM(total) AS Revenue FROM sales
GROUP BY branch, city
ORDER BY Revenue DESC;

-- What product line had the largest VAT?
SELECT product_line as Products, AVG(tax_pct) as Average_VAT FROM sales
GROUP BY product_line
ORDER BY Average_VAT DESC;

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales
SELECT AVG(quantity) AS avg_qnty FROM sales;
SELECT product_line, CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS Remark
FROM sales
GROUP BY product_line;

-- Which branch sold more products than average product sold?
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- What is the most common product line by gender
SELECT gender, product_line, COUNT(gender) as Total_count from sales
GROUP BY gender, product_line
ORDER BY Total_count DESC;

-- What is the average rating of each product line
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

								/*CUSTOMERS*/
                                
-- How many unique customer types does the data have?
SELECT DISTINCT(customer_type) FROM sales;

-- How many unique payment methods does the data have?
SELECT DISTINCT(payment) FROM sales;

-- What is the most common customer type?
SELECT customer_type, count(*) as Count from sales
GROUP BY customer_type
ORDER BY Count DESC;

-- Which customer type buys the most?
SELECT customer_type, COUNT(*) Count FROM  sales
GROUP BY customer_type;

-- What is the gender of most of the customers?
SELECT gender, count(*) as Count from sales
GROUP BY gender
ORDER BY Count DESC;

-- What is the gender distribution per branch?
SELECT
	gender, branch,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender, branch 
ORDER BY branch, gender_cnt DESC;

-- Which time of the day do customers give most ratings?
SELECT time_of_day, AVG(rating) as Rating from sales
GROUP BY time_of_day
ORDER BY Rating DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT time_of_day, AVG(rating) as Rating, branch from sales
GROUP BY time_of_day,branch
ORDER BY branch,Rating DESC;

-- Which day fo the week has the best avg ratings?
SELECT day_name, AVG(rating) AS Average_Rating FROM sales
GROUP BY day_name
ORDER BY Average_Rating DESC;

-- Which day of the week has the best average ratings per branch?
SELECT day_name,COUNT(day_name) total_sales FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;

								/*Sales*/

-- Number of sales made in each time of the day per weekday 
SELECT time_of_day, COUNT(*) AS Total_Sales FROM sales
where day_name ="Sunday"
GROUP BY time_of_day
ORDER BY Total_Sales DESC;

-- Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS Revenue FROM sales
GROUP BY customer_type
ORDER BY Revenue DESC;

-- Which city has the largest tax/VAT percent?
SELECT city, ROUND(AVG(tax_pct), 2) AS avg_tax_pct FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT customer_type, AVG(tax_pct) AS total_tax FROM sales
GROUP BY customer_type
ORDER BY total_tax;





