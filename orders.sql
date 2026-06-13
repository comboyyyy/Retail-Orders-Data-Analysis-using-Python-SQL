-- Create database order_data 
USE order_data;

----  SELECT * FROM orders;
-- -- drop table orders;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    ship_mode VARCHAR(20),
    segment VARCHAR(20),
    country VARCHAR(20),
    city VARCHAR(20),
    state VARCHAR(20),
    postal_code VARCHAR(20),
    region VARCHAR(20),
    category VARCHAR(20),
    sub_category VARCHAR(20),
    product_id VARCHAR(50),
    quantity INT,
    discount DECIMAL(7 , 2 ),
    sale_price DECIMAL(7 , 2 ),
    profit DECIMAL(7 , 2 )
)


-- select * from orders

-- find top 10 highest reveue generating products 
SELECT 
    product_id, SUM(sale_price) AS sales
FROM
    orders
GROUP BY product_id
ORDER BY sales DESC
LIMIT 10;

-- find top 5 highest selling products in each region
-- with cte as (
 select 
 region, product_id, sum(sale_price) as sales 
 from orders
  group by region, product_id )
  select * from(
  select * 
  , row_number() over(partition by region order by sales desc) rn
 from cte) A where rn <= 5


 -- --find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
--  with cte as (
SELECT 
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    sum(sale_price) as sales
FROM
     orders
GROUP BY year(order_date), month(order_date))
 select order_month
 , sum(case when order_year=2022 then sales else 0 end) as sales_2022
, sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte 
 group by order_month
 order by order_month

-- for each category which month had highest sales 
-- with cte as (
 SELECT 
  category,
   date_format(order_date, "%Y/%m") as order_month,
  SUM(sale_price) AS sales 
   from orders group by category, order_month)
    select * from (
   select * , 
  row_number() over(partition by category order by sales desc) rn from cte) a where rn = 1
    
    
    -- which sub category had highest growth by profit in 2023 compare to 2022
    with cte as (
    SELECT 
    sub_category,
    YEAR(order_date) AS year,
    SUM(sale_price) AS sales
FROM
    orders
GROUP BY sub_category , year),
cte2 as (
select sub_category
, sum(case when year=2022 then sales else 0 end) as sales_2022
, sum(case when year=2023 then sales else 0 end) as sales_2023
from cte group by sub_category)
select * , (sales_2023 - sales_2022) as profitORloss from cte2
order by (sales_2023 - sales_2022) desc limit 1


    
    
    
    
    