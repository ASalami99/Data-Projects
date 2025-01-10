CREATE DATABASE IF NOT EXISTS WalmartSalesData;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
	branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
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




-- ---------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------- FEATURE ENGINEERING ---------------------------------------------------------


-- Tine Of Day
-- Testing time-of-day column (morning 00:00 to 12:00, afternoon 12:00 to 16:00, evening the rest) -- 
SELECT time,
	(
    CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END
    ) AS time_of_day
 FROM sales;
 
-- Creating new column
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- Inserting values column
UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END
);


-- Day Name
SELECT
	date,
		DAYNAME(date) AS day_name
FROM sales;

-- Creating new Column
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

-- Inserting values column
UPDATE sales
SET day_name = DAYNAME(date);


-- Month Name
SELECT date, MONTHNAME(date) AS month_name FROM sales;

-- Creating the new column
ALTER TABLE sales ADD COLUMN month_name VARCHAR(15);

-- Inserting Values
UPDATE sales
SET month_name = MONTHNAME(date);

SELECT * FROM sales;

-- ---------------------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------- BUSINESS QUESTIONS ---------------------------------------------------------

-- GENERIC QUESTIONS
-- 1. How many unique cities does the data have?
SELECT COUNT(DISTINCT(city)) as UNIQUE_CITIES FROM sales;

-- 2. In which city is each branch?
SELECT DISTINCT(branch), city FROM sales;


-- PRODUCT QUESTIONS
-- 1. How many unique product lines does the data have?
SELECT COUNT(DISTINCT(product_line)) as Product_Lines FROM sales;

-- 2. What is the must common payment method?
SELECT payment, COUNT(payment) AS Count FROM sales GROUP BY payment ORDER BY Count DESC;

-- 3. What is the most selling product line?
SELECT product_line, COUNT(product_line) AS Count FROM saLes GROUP BY product_line ORDER BY Count DESC;

-- 4. What is the total revenue by month?
SELECT month_name AS Month, SUM(total) AS Total_Revenue FROM sales GROUP BY month_name ORDER BY Total_Revenue DESC;

-- 5. What month had the largest COGS (Cost Of Goods Sold)?
SELECT month_name, SUM(cogs) AS Cost_Of_Goods_Sold FROM sales GROUP BY month_name ORDER BY Cost_Of_Goods_Sold DESC; 

-- 6. What product line had the largest revenue?
SELECT product_line, SUM(total) AS Revenue FROM sales GROUP BY product_line ORDER BY Revenue DESC;

-- 7. What is the city with the largest revenue?
SELECT city, SUM(total) AS Revenue FROM sales GROUP BY city ORDER BY Revenue DESC;

-- 8. What product line had the largest VAT?
SELECT product_line, AVG(tax_pct) as Avg_Tax FROM sales GROUP BY product_line ORDER BY Avg_Tax DESC;

-- 9. Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) as Qty FROM sales GROUP BY branch HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- 10. What is the most common product line by gender?
SELECT gender, product_line, COUNT(gender) AS total_count FROM sales GROUP BY gender, product_line ORDER BY total_count DESC;

-- 11. What is the average rating of each product line?
SELECT product_line, ROUND(AVG(rating), 2) AS Average_Rating FROM sales GROUP BY product_line ORDER BY Average_Rating DESC;



-- Sales Questions
-- 1. What is the number of sales made in each time of the day per weekday?
SELECT day_name, time_of_day, COUNT(invoice_id) AS Number_Of_Sales FROM sales GROUP BY day_name, time_of_day ORDER BY day_name DESC;

-- 2. Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS Revenue FROM sales GROUP BY customer_type ORDER BY Revenue DESC; 

-- 3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
SELECT city, AVG(tax_pct) AS Tax_Percentage FROM sales GROUP BY city ORDER BY Tax_Percentage DESC;

-- 4. Which customer type pays the most in VAT?
SELECT customer_type, AVG(tax_pct) AS Tax_Percentage FROM sales GROUP BY customer_type ORDER BY Tax_Percentage DESC;


-- Customer Questions
-- 1. How many unique customer types does the data have?
SELECT COUNT(DISTINCT(customer_type)) AS Number_Of_Customer_Types FROM sales;

-- 2. How many unique payment methods does the data have?
SELECT COUNT(DISTINCT(payment)) AS Number_Of_Payments FROM sales;

-- 3. What is the most common customer type?
SELECT customer_type, COUNT(customer_type) AS Numbers FROM sales GROUP BY customer_type ORDER BY NUmbers DESC;

-- 4. Which customer type buys the most?
SELECT customer_type, SUM(quantity) AS Quantity_bought FROM sales GROUP BY customer_type ORDER BY Quantity_bought DESC;

-- 5. What is the gender of most of the customers?
SELECT gender, COUNT(gender) AS Number_Of_Gender FROM sales GROUP BY gender ORDER BY Number_Of_Gender DESC;

-- 6. What is the gender distribution per branch?
SELECT branch, gender, COUNT(gender) AS Gender FROM sales GROUP BY branch, gender ORDER BY branch, Gender DESC;

-- 7. Which time of the day do customers give most ratings?
SELECT time_of_day, COUNT(rating) AS Number_Of_Ratings FROM sales GROUP BY time_of_day ORDER BY Number_Of_Ratings DESC;

-- 8. Which time of the day do customers give most ratings per branch?
SELECT branch, time_of_day, COUNT(rating) AS Number_Of_Ratings FROM sales GROUP BY branch, time_of_day ORDER BY branch, Number_Of_Ratings DESC;

-- 9. Which day of the week has the best avg ratings?
SELECT day_name, ROUND(AVG(rating), 2) AS Avg_Rating FROM sales GROUP BY day_name ORDER BY Avg_Rating DESC;

-- 10. Which day of the week has the best average ratings per branch?
SELECT branch, day_name, ROUND(AVG(rating), 2) AS Avg_Rating FROM sales GROUP BY branch, day_name ORDER BY branch, Avg_Rating DESC;