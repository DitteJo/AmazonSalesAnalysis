-- Analyzes revenue across key columns including product categories, brands, states, payment methods and top performing products.

-- Total revenue, total orders and average order value
SELECT
	SUM(TotalAmount) AS TotalRevenue,
	COUNT(*) AS TotalOrders,
	CAST(ROUND(AVG(TotalAmount), 2) AS DECIMAL (10, 2)) AS AvgOrderValue
FROM AmazonSales
WHERE OrderStatus NOT IN ('Cancelled', 'Returned');

-- Total order amount and average order value by order status
SELECT
	OrderStatus,
	COUNT(*) AS TotalOrders,
	ROUND(AVG(TotalAmount), 2) AS AvgOrderValue
FROM AmazonSales
GROUP BY OrderStatus
ORDER BY TotalOrders DESC;

-- Total revenue by category
SELECT
	Category,
	SUM(TotalAmount) AS TotalRevenue
FROM AmazonSales
WHERE OrderStatus NOT IN ('Cancelled', 'Returned')
GROUP BY Category
ORDER BY TotalRevenue DESC;

-- Total revenue by state
SELECT 
	State,
	SUM(TotalAmount) AS TotalRevenue
FROM AmazonSales
WHERE OrderStatus NOT IN ('Cancelled', 'Returned')
GROUP BY State
ORDER BY TotalRevenue DESC;

-- Total units sold by category
SELECT
	Category,
	SUM(Quantity) AS TotalUnitsSold
FROM AmazonSales
WHERE OrderStatus NOT IN ('Cancelled', 'Returned')
GROUP BY Category
ORDER BY TotalUnitsSold DESC;

-- Top 10 products by units sold
SELECT
	TOP 10 ProductName,
	SUM(Quantity) AS UnitsSold,
	SUM(TotalAmount) AS TotalRevenue
FROM AmazonSales
WHERE OrderStatus NOT IN ('Cancelled', 'Returned')
GROUP BY ProductName
ORDER BY UnitsSold DESC;

-- Top 10 products by total revenue
SELECT
	TOP 10 ProductName,
	SUM(Quantity) AS UnitsSold,
	SUM(TotalAmount) AS TotalRevenue
FROM AmazonSales
WHERE OrderStatus NOT IN ('Cancelled', 'Returned')
GROUP BY ProductName
ORDER BY TotalRevenue DESC;

-- Total Revenue by payment method
SELECT
	PaymentMethod,
	COUNT(*) AS TotalOrders,
	SUM(TotalAmount) AS TotalRevenue
FROM AmazonSales
WHERE OrderStatus NOT IN ('Cancelled', 'Returned')
GROUP BY PaymentMethod
ORDER BY TotalRevenue DESC;

-- Total revenue by brand
SELECT
	Brand,
	COUNT(*) AS TotalOrders,
	SUM(TotalAmount) AS TotalRevenue
FROM AmazonSales
WHERE OrderStatus NOT IN ('Cancelled', 'Returned')
GROUP BY Brand
ORDER BY TotalRevenue DESC;

-- Average order value by category
SELECT
	Category,
	CAST(ROUND(AVG(TotalAmount), 2) AS DECIMAL(10, 2)) AS AvgOrderValue
FROM AmazonSales
WHERE OrderStatus NOT IN ('Cancelled', 'Returned')
GROUP BY Category
ORDER BY AvgOrderValue DESC;

-- Average order value by state
SELECT
	State,
	CAST(ROUND(AVG(TotalAmount), 2) AS DECIMAL(10, 2)) AS AvgOrderValue
FROM AmazonSales
WHERE OrderStatus NOT IN ('Cancelled', 'Returned')
GROUP BY State
ORDER BY AvgOrderValue DESC;

-- Revenue contribution percentage per category out of total revenue
WITH CategoryRev AS (
	SELECT
		Category,
		SUM(TotalAmount) AS TotalRevenue
	FROM AmazonSales
	WHERE OrderStatus NOT IN ('Cancelled', 'Returned')
	GROUP BY Category
),
TotalRev AS (
	SELECT
		SUM(TotalRevenue) AS GrandTotal
	FROM CategoryRev
)
SELECT
	Category,
	TotalRevenue,
	CAST(ROUND((TotalRevenue * 100.0) / GrandTotal, 2) AS DECIMAL(10, 2)) AS RevContribution
FROM CategoryRev
CROSS JOIN TotalRev
ORDER BY RevContribution DESC;