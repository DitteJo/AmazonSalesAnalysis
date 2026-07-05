-- Initial dataset exploration and quality checks
-- Examines dataset structure, date range, null values, duplicates and order status breakdown to validate data integrity before analysis.

-- Total row count
SELECT *
FROM AmazonSales;

-- Date ranges for orders
SELECT MIN(OrderDate) AS MinDate, MAX(OrderDate) AS MaxDate
FROM AmazonSales;

-- Count of distinct categories
SELECT DISTINCT Category, COUNT(*) AS CategoryCount
FROM AmazonSales
GROUP BY Category
ORDER BY CategoryCount DESC;

-- Count of distinct states
SELECT DISTINCT State, COUNT(*) AS StateCount
FROM AmazonSales
GROUP BY State
ORDER BY StateCount DESC;

-- Order status count breakdown
SELECT
	OrderStatus,
	COUNT(*) AS StatusCount
FROM AmazonSales
GROUP BY OrderStatus
ORDER BY StatusCount DESC;

-- Null check on key columns
SELECT
	SUM(CASE WHEN TotalAmount IS NULL THEN 1 ELSE 0 END) AS NullTotalAmount,
	SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS NullCustomerID,
	SUM(CASE WHEN ProductID IS NULL THEN 1 ELSE 0 END) AS NullProductID,
	SUM(CASE WHEN OrderID IS NULL THEN 1 ELSE 0 END) AS NullOrderID,
	SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS NULLOrderDate,
	SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS NUllCategory,
	SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS NULLState
FROM AmazonSales;

-- Duplicate order check
SELECT OrderID, COUNT(*) AS OrderIDCount
FROM AmazonSales
GROUP BY OrderID
HAVING COUNT(*) > 1;

-- Average, min and max values for TotalAmount
SELECT
	AVG(TotalAmount) AS avg_amount,
	MIN(TotalAmount) AS min_amount,
	MAX(TotalAmount) AS max_amount
FROM AmazonSales