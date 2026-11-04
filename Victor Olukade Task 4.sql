-- Select queries
--The whole table in the dataset
SELECT *
FROM [Dataset for Data Analytics]

--Top 10 Row
SELECT TOP 10 * 
FROM [Dataset for Data Analytics]
 
--Aggregations(Count, Sum, Average)

-- Count of Total Orders
SELECT COUNT(OrderID) AS Total_Orders
from [Dataset for Data Analytics]

--Sum of Total Revenue
SELECT
SUM(TotalPrice) as Total_Revenue
FROM [Dataset for Data Analytics]

--Average Order Value
SELECT
AVG(TOTALPRICE) as Avg_Order_Value
FROM [Dataset for Data Analytics]


--WHERE
-- Cancelled Order Status
SELECT *
FROM [Dataset for Data Analytics]
WHERE OrderStatus='CANCELLED'

--Count of Delievered Order Status > 1000
SELECT
COUNT(*) AS Big_delivered_Orders
FROM [Dataset for Data Analytics]
WHERE OrderStatus='DELIVERED' AND TotalPrice>1000

--GROUP BY
--Count of Orders and Total Order Value by Product
SELECT
Product,
COUNT(OrderID) as No_Of_Orders,
SUM(TotalPrice) as Total_Revenue
FROM [Dataset for Data Analytics]
GROUP BY Product

-- Order By
--Count of Orders and Total Order Value by Product FROM largest to smallest
SELECT
Product,
COUNT(OrderID) as No_Of_Orders,
SUM(TotalPrice) as Total_Revenue
FROM [Dataset for Data Analytics]
GROUP BY Product
Order By Product desc

--Trend
--Trend by Year
SELECT
YEAR(DATE) AS Order_Year,
COUNT(ORDERID) AS ORDERS,
SUM(TOTALPRICE) AS REVENUE
FROM [Dataset for Data Analytics]
GROUP BY YEAR(DATE)
ORDER BY Order_Year

--HAVING 
--Select Count of Orders and Total Order Value by Product having >170
SELECT
Product,
COUNT(OrderID) as No_Of_Orders,
SUM(TotalPrice) as Total_Revenue
FROM [Dataset for Data Analytics]
GROUP BY Product
HAVING COUNT(ORDERID) > 170

