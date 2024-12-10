--Pizza Sales Analysis using SQL

--Create database sql_project_p1 at the beginning of the project

--CREATING TABLE 
DROP TABLE IF EXISTS pizza_sales;
create table pizza_sales
            (
              transactions_id INT PRIMARY KEY,
              sale_date DATE,
              sale_time	TIME,
              customer_id INT,
			  gender VARCHAR(15),
              age INT,	
              category	VARCHAR(15),
              quantity INT,
              price_per_unit FLOAT,	
              cogs FLOAT,
              total_sale FLOAT
            );
			
--check if import of data has happened
SELECT * FROM pizza_sales;
limit 10;

--verify with excel on to how many records have been imported
Select count(*) from pizza_sales;


--grouping data based on total count of male & female customers 
select gender, count(*) from pizza_sales group by gender;

--Checking for NULL values in all the COLUMNS (DATA CLEANING)
select * from pizza_sales where transactions_id is null;

select * from pizza_sales where sale_date is null;

select * from pizza_sales where sale_time is null;

select * from pizza_sales where customer_id is null;

select * from pizza_sales where gender is null;

--I find some nulls in age column 
select * from pizza_sales where age is null;

select * from pizza_sales where category is null;
select * from pizza_sales where  price_per_unit is null;
select * from pizza_sales where  cogs is null;
select * from pizza_sales where  total_sale is null;

--Instead of checking one by one we can check Null for all columns
--WE GET 13 RECORDS HAVING NULLS
SELECT * FROM pizza_sales
where
transactions_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;

--Deleting all nulls from data
DELETE FROM pizza_sales
where
transactions_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;

--verify with counting the records (13 records should have been deleted out of 2000 records)
select count(*) from pizza_sales;

--Exploring Data 
------------------

--1.HOW MANY SALES WE HAVE ?
SELECT COUNT(*) as total sales FROM pizza_sales;  --1987 sales

--2.how many customers do we have?
select count(customer_id) as total_sales from pizza_sales; --1987 sales

--3.how many unique customers are there?
select count(distinct(customer_id)) as total_sales from pizza_sales; --155 unique customers

--4.how many categories are there?
select distinct category from pizza_sales; -- 3 categories Electronics,Clothing,Beauty.


-- Data Analysis & Business Key Problems & Answers
----------------------------------------------------

-- Q.1 Write an SQL query to retrieve all columns for sales made on '2022-11-05'
select * from pizza_sales where sale_date = '2022-11-05';  --11 sales were made

-- Q.2 Write an SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
--first we will see each category and quantity sold
select category ,sum(quantity)  from pizza_sales
where category='Clothing'
group by category;   ---"Electronics"	1682,"Clothing"	1780 "Beauty"	1533


SELECT *
FROM pizza_sales
WHERE Category = 'Clothing'
  AND quantity > 3
  AND to_char(sale_date,'yyyy-mm') = '2022-11';



-- Q.3 Write an SQL query to calculate the total sales (total_sale) for each category.
select Category , 
sum(total_sale) as net_sales,
count(*) as total orders from pizza_sales 
group by Category;


-- Q.4 Write an SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select category,Round(avg(age), 2) as average_age from pizza_sales 
where category = 'Beauty'
group by category;

-- Q.5 Write an SQL query to find all transactions where the total_sale is greater than 1000.
select * from pizza_sales 
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select distinct(category),gender,count(transactions_id) from pizza_sales
group by category,gender
;
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
--Query to Calculate the Average Sale for Each Month
SELECT 
EXTRACT(YEAR FROM sale_date) AS Year,
EXTRACT(MONTH FROM sale_date) AS Month,
AVG(total_sale) AS AverageMonthlySale
FROM 
pizza_sales
GROUP BY 
EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
ORDER BY 
Year, Month;
                               --using orderby gives more readable output
--now after the above query i need one best month from 2022 and 2023
WITH MonthlySales AS (
SELECT 
EXTRACT(YEAR FROM sale_date) AS Year,
EXTRACT(MONTH FROM sale_date) AS Month,
SUM(total_sale) AS TotalMonthlySale
FROM 
pizza_sales
GROUP BY 
EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
)
SELECT 
Year,Month,TotalMonthlySale
FROM 
MonthlySales
WHERE 
TotalMonthlySale = (
SELECT 
MAX(TotalMonthlySale)
FROM 
MonthlySales AS InnerMonthlySales
WHERE 
InnerMonthlySales.Year = MonthlySales.Year
    )
ORDER BY 
Year, Month;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id,SUM(total_sale) as total_sales
FROM pizza_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category,    
COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM pizza_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM pizza_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;

----END OF THE PIZZA_SALES SQL PROJECT
