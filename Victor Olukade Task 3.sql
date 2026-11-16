--PART 1: SELECT QUERIES
-- Select queries
-- Question: What does the whole table look like?
-- Method: SELECT * returns every column and every row.
-- Finding: The table has 14 columns (OrderID, Date, Product, Quantity, UnitPrice, OrderStatus, TotalPrice and others) and 1,200 rows
SELECT *
FROM [Dataset for Data Analytics]

--Question: Can I check the data quickly without loading all rows?
-- Method: SELECT TOP 10 returns only the first 10 rows.
-- Finding: A fast way to confirm the columns and the data types look right.
SELECT TOP 10 * 
FROM [Dataset for Data Analytics]
 
--PART 2: AGGREGATIONS (COUNT, SUM, AVG)
-- Question: How many orders are there in total?
-- Method: COUNT(OrderID) counts the order IDs.
-- Finding: There are 1,200 orders.

SELECT COUNT(OrderID) AS Total_Orders
from [Dataset for Data Analytics]

-- Question: How much revenue did all orders bring in?
-- Method: SUM(TotalPrice) adds up every order value.
-- Finding: Total revenue is about 1,264,762.
SELECT
SUM(TotalPrice) as Total_Revenue
FROM [Dataset for Data Analytics]

-- Question: What is the average value of one order?
-- Method: AVG(TotalPrice) divides total revenue by the number of orders.
-- Finding: The average order is about 1,054. This is an average, so a few very big orders can pull it up
SELECT
AVG(TOTALPRICE) as Avg_Order_Value
FROM [Dataset for Data Analytics]

-- PART 3: WHERE (FILTERING ROWS)
-- Question: Which orders were cancelled?
-- Method: WHERE OrderStatus = 'CANCELLED' keeps only those rows.
-- Finding: 250 orders were cancelled. That is about 21% of all orders, which is a lot and worth looking into
SELECT *
FROM [Dataset for Data Analytics]
WHERE OrderStatus='CANCELLED'

-- Question: How many delivered orders are worth more than 1,000?
-- Method: WHERE with AND, so both conditions must be true (status is Delivered and TotalPrice is above 1,000).
-- Finding: 91 delivered orders are above 1,000, out of 231 delivered orders in total.
SELECT
COUNT(*) AS Big_delivered_Orders
FROM [Dataset for Data Analytics]
WHERE OrderStatus='DELIVERED' AND TotalPrice>1000

-- PART 4: GROUP BY (ONE ROW PER GROUP)
-- Order By
-- Question: How many orders and how much revenue does each product have?
-- Method: GROUP BY Product, then COUNT and SUM for each product.
-- Finding: Orders are spread fairly evenly. Each product has between 156 and 181 orders.
SELECT
Product,
COUNT(OrderID) as No_Of_Orders,
SUM(TotalPrice) as Total_Revenue
FROM [Dataset for Data Analytics]
GROUP BY Product

--PART 5: ORDER BY (SORTING)
-- Question: Which products earn the most, from largest to smallest?
-- Method: Same query as above, with ORDER BY Total_Revenue DESC.
-- ORDER BY can use the alias Total_Revenue because it runs last.
-- Finding: Chair (195,620) and Printer (195,613) earn the most, Phone earns the least (151,722).
SELECT
Product,
COUNT(OrderID) as No_Of_Orders,
SUM(TotalPrice) as Total_Revenue
FROM [Dataset for Data Analytics]
GROUP BY Product
ORDER BY Total_Revenue DESC

-- PART 6: TREND OVER TIME
-- Question: How do orders and revenue change from year to year?
-- Method: YEAR(Date) pulls the year out of the date. Then GROUP BY year.
-- Finding: 2023 had 510 orders (552,643), 2024 had 459 orders (480,236) and 2025 has 231 orders (231,883). Be careful: the data for 2025 stops in June, so 2025 is only half a year and cannot be compared directly with a full year.
SELECT
YEAR(DATE) AS Order_Year,
COUNT(ORDERID) AS ORDERS,
SUM(TOTALPRICE) AS REVENUE
FROM [Dataset for Data Analytics]
GROUP BY YEAR(DATE)
ORDER BY Order_Year

--PART 7: HAVING (FILTERING GROUPS)
-- Question: Which products have more than 170 orders?
-- Method: GROUP BY Product, then HAVING COUNT(ORDERID) > 170.
-- HAVING is used because the filter is on a group total.
-- WHERE only works on single rows, before grouping.
-- Finding: 4 products pass: Printer (181), Tablet (179), Chair (178) and Laptop (173). Desk has exactly 170, so it does not pass.
SELECT
Product,
COUNT(OrderID) as No_Of_Orders,
SUM(TotalPrice) as Total_Revenue
FROM [Dataset for Data Analytics]
GROUP BY Product
HAVING COUNT(ORDERID) > 170

-- Question: What share of all orders does each order status have?
-- Method: GROUP BY OrderStatus with COUNT. A subquery counts all 1,200 orders, and each group is divided by that total and multiplied by 100.
-- Finding: Cancelled (20.8%) and Returned (20.6%) are the two biggest shares, so about 41% of orders do not complete.
-- Delivered is the smallest at 19.2%.
-- The shares are all close together, so no single status dominates.
SELECT OrderStatus,
       COUNT(OrderID) AS orders,
       ROUND(100.0 * COUNT(OrderID) / (SELECT COUNT(OrderID) FROM [Dataset for Data Analytics]), 1) AS pct_of_orders
FROM [Dataset for Data Analytics]
GROUP BY OrderStatus
ORDER BY pct_of_orders DESC

-- Question: How many orders use each coupon code (or no coupon) and what is the average order value for each?
-- Method: NULLIF turns blank coupons into NULL and COALESCE replaces them with 'No Coupon'. Then GROUP BY coupon with COUNT and AVG, sorted by orders.
-- Finding: FREESHIP is used most (313 orders), then No Coupon (309), WINTER15 (292) and SAVE10 (286). Average order value is about 1,036 to 1,070 for every group,
-- so coupons do not seem to make customers spend more.
SELECT COALESCE(NULLIF(CouponCode, ''), 'No Coupon') AS coupon,
       COUNT (OrderID)        AS orders,
       AVG(TotalPrice) AS avg_order
FROM [Dataset for Data Analytics]
GROUP BY COALESCE(NULLIF(CouponCode, ''), 'No Coupon')
ORDER BY orders DESC
