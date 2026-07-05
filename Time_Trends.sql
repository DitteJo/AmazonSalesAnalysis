-- Examines sales trends over time including monthly and yearly revenue, month-over-month revenue change and growth rate, running totals and best and worst performing months across the 2020-2024 period.

-- Total orders and revenue by month
SELECT
	DATENAME(Month, OrderDate) AS Month,
	MONTH(OrderDate) AS MonthNum,
	COUNT(OrderID) AS TotalOrders,
	CAST(ROUND(SUM(TotalAmount), 2) AS DECIMAL(10, 2)) AS TotalRevenue
FROM AmazonSales
WHERE OrderStatus NOT IN('Cancelled', 'Returned')
GROUP BY DATENAME(Month, OrderDate), MONTH(OrderDate)
ORDER BY MonthNum;

-- Total orders and revenue by year
SELECT
	YEAR(OrderDate) AS Year,
	COUNT(OrderID) AS TotalOrders,
	CAST(ROUND(SUM(TotalAmount), 2) AS DECIMAL(10, 2)) AS TotalRevenue
FROM AmazonSales
WHERE OrderStatus NOT IN('Cancelled', 'Returned')
GROUP BY YEAR(OrderDate)
ORDER BY YEAR(OrderDate);

-- Best 5 performing months by revenue
SELECT TOP 5
	YEAR(OrderDate) AS Year,
	DATENAME(MONTH, OrderDate) AS Month,
	CAST(ROUND(SUM(TotalAmount), 2) AS DECIMAL(10, 2)) AS TotalRevenue
FROM AmazonSales
WHERE OrderStatus NOT IN ('Cancelled', 'Returned')
GROUP BY YEAR(OrderDate), DATENAME(MONTH, OrderDate)
ORDER BY TotalRevenue DESC;

-- Worst 5 performing months by revenue
SELECT TOP 5
	YEAR(OrderDate) AS Year,
	DATENAME(MONTH, OrderDate) AS Month,
	CAST(ROUND(SUM(TotalAmount), 2) AS DECIMAL(10, 2)) AS TotalRevenue
FROM AmazonSales
WHERE OrderStatus NOT IN ('Cancelled', 'Returned')
GROUP BY YEAR(OrderDate), DATENAME(MONTH, OrderDate)
ORDER BY TotalRevenue;

-- Month-over-month revenue change
WITH MonthlyRevenue AS(
	SELECT
		YEAR(OrderDate) AS Year,
		MONTH(OrderDate) AS MonthNum,
		DATENAME(MONTH, OrderDate) AS Month,
		CAST(ROUND(SUM(TotalAmount), 2) AS DECIMAL (10, 2)) AS TotalRevenue
	FROM AmazonSales
	WHERE OrderStatus NOT IN ('Cancelled','Returned')
	GROUP BY YEAR(OrderDate), MONTH(OrderDate), DATENAME(MONTH, OrderDate)
),
WithLag AS(
	SELECT
		Year,
		Month,
		MonthNum,
		TotalRevenue AS CurrMonthRev,
		LAG(TotalRevenue) OVER(ORDER BY Year, MonthNum) AS PrevMonthRev
	FROM MonthlyRevenue
)
SELECT
	Year,
	Month,
	CurrMonthRev,
	PrevMonthRev,
	CASE
		WHEN PrevMonthRev IS NULL THEN NULL
		ELSE CurrMonthRev - PrevMonthRev 
	END AS RevChange,
	CASE
		WHEN PrevMonthRev IS NULL THEN NULL
		ELSE CAST(ROUND(100.0 * (CurrMonthRev - PrevMonthRev) / PrevMonthRev, 2) AS DECIMAL (10, 2))
	END AS MoMGrowthPct
FROM WithLag
ORDER BY Year, MonthNum;

-- Average month-over-month revenue growth rate
WITH MonthlyRevenue AS(
	SELECT
		YEAR(OrderDate) AS Year,
		MONTH(OrderDate) AS MonthNum,
		DATENAME(MONTH, OrderDate) AS Month,
		CAST(ROUND(SUM(TotalAmount), 2) AS DECIMAL (10, 2)) AS TotalRevenue
	FROM AmazonSales
	WHERE OrderStatus NOT IN ('Cancelled','Returned')
	GROUP BY YEAR(OrderDate), MONTH(OrderDate), DATENAME(MONTH, OrderDate)
),
WithLag AS(
	SELECT
		TotalRevenue AS CurrMonthRev,
		LAG(TotalRevenue) OVER(ORDER BY Year, MonthNum) AS PrevMonthRev
	FROM MonthlyRevenue
),
MoMGrowth AS(
	SELECT
		CAST(ROUND(100.0 * (CurrMonthRev - PrevMonthRev) / PrevMonthRev, 2) AS DECIMAL (10, 2)) AS MoMGrowthPct
	FROM WithLag
	WHERE PrevMonthRev IS NOT NULL
)
SELECT 
	CAST(ROUND(AVG(MoMGrowthPct), 2) AS DECIMAL (10, 2)) AS AvgMoMGrowthPct
FROM MoMGrowth;

-- Running total of revenue over time
WITH MonthlyRevenue AS(
	SELECT
		YEAR(OrderDate) AS Year,
		MONTH(OrderDate) AS MonthNum,
		DATENAME(MONTH, OrderDate) AS Month,
		CAST(ROUND(SUM(TotalAmount), 2) AS DECIMAL (10, 2)) AS TotalRevenue
	FROM AmazonSales
	WHERE OrderStatus NOT IN ('Cancelled','Returned')
	GROUP BY YEAR(OrderDate), MONTH(OrderDate), DATENAME(MONTH, OrderDate)
)
SELECT 
	Year,
	Month,
	TotalRevenue,
	CAST(ROUND(SUM(TotalRevenue) OVER(ORDER BY Year, MonthNum), 2) AS DECIMAL(10, 2)) AS RunningTotal
FROM MonthlyRevenue
ORDER BY Year, MonthNum;

-- Revenue by category broken down by year
SELECT
	Category,
	YEAR(OrderDate) AS Year,
	CAST(ROUND(SUM(TotalAmount), 2) AS DECIMAL (10, 2)) AS TotalRevenue
FROM AmazonSales
WHERE OrderStatus NOT IN ('Cancelled','Returned')
GROUP BY Category, YEAR(OrderDate)
ORDER BY Category, Year;