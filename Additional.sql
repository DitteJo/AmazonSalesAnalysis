-- Additional analysis to answer supporting objectives such as cancellations and discounting.

-- Rank categories by total revenue per year
WITH AnnualRevenue AS(
	SELECT
		Category,
		YEAR(OrderDate) AS Year,
		CAST(ROUND(SUM(TotalAmount), 2) AS DECIMAL (10, 2)) AS TotalRevenue
	FROM AmazonSales
	WHERE OrderStatus NOT IN ('Cancelled','Returned')
	GROUP BY Category, YEAR(OrderDate)
)
SELECT
	Category,
	Year,
	RANK() OVER(PARTITION BY Year ORDER BY TotalRevenue DESC) AS Rank,
	TotalRevenue
FROM AnnualRevenue
ORDER BY Year, Rank;

-- Top spending customers per state
WITH CustomerRev AS(
	SELECT
		State,
		CustomerName,
		CAST(ROUND(SUM(TotalAmount), 2) AS DECIMAL(10, 2)) AS TotalRevenue
	FROM AmazonSales
	WHERE OrderStatus NOT IN ('Cancelled','Returned')
	GROUP BY State, CustomerName
),
RankedCustomer AS(
	SELECT
		State,
		CustomerName,
		TotalRevenue,
		RANK() OVER(PARTITION BY State ORDER BY TotalRevenue DESC) AS CustomerRank
	FROM CustomerRev
)
SELECT
	State,
	CustomerName,
	TotalRevenue
FROM RankedCustomer
WHERE  CustomerRank = 1
ORDER BY State;

-- Overall cancellation rate
SELECT
	COUNT(OrderID) AS TotalOrders,
	SUM(CASE WHEN OrderStatus ='Cancelled' THEN 1 ELSE 0 END) AS CancelledOrders,
	CAST(ROUND(100.0 * SUM(CASE WHEN OrderStatus ='Cancelled' THEN 1 ELSE 0 END) / COUNT(OrderID), 2) AS DECIMAL (10, 2)) AS CancellationRate
FROM AmazonSales;

-- Cancellation rate by category
WITH CategoryCancellations AS(
	SELECT
		Category,
		COUNT(OrderID) AS TotalOrders,
		SUM(CASE WHEN OrderStatus = 'Cancelled' THEN 1 ELSE 0 END) AS CancelledOrders
	FROM AmazonSales
	GROUP BY Category
)
SELECT
	Category,
	TotalOrders,
	CancelledOrders,
	CAST(ROUND((CancelledOrders * 100.0) / TotalOrders, 2) AS DECIMAL(10, 2)) AS CancellationRate
FROM CategoryCancellations
ORDER BY CancellationRate DESC;

-- Cancellation rate by state
WITH StateCancellations AS(
	SELECT
		State,
		COUNT(OrderID) AS TotalOrders,
		SUM(CASE WHEN OrderStatus = 'Cancelled' THEN 1 ELSE 0 END) AS CancelledOrders
	FROM AmazonSales
	GROUP BY State
)
SELECT
	State,
	TotalOrders,
	CancelledOrders,
	CAST(ROUND((CancelledOrders * 100.0) / TotalOrders, 2) AS DECIMAL(10, 2)) AS CancellationRate
FROM StateCancellations
ORDER BY CancellationRate DESC;

-- Discount tier breakdown and average order value per tier
WITH DiscountBreakdown AS(
	SELECT
		Discount,
		TotalAmount,
		OrderID,
		CASE
			WHEN Discount = 0 THEN 'None'
			WHEN Discount <= 0.10 THEN 'Low'
			WHEN Discount <= 0.20 THEN 'Medium'
			ELSE 'High'
		END AS DiscountTier
	FROM AmazonSales
	WHERE OrderStatus NOT IN ('Cancelled','Returned')
)
SELECT
	COUNT(OrderID) AS TotalOrders,
	CAST(ROUND(AVG(TotalAmount), 2) AS DECIMAL (10, 2)) AS AvgOrderValue,
	CAST(ROUND(AVG(Discount), 2) AS DECIMAL (10, 2)) AS AvgDiscount,
	CAST(ROUND(SUM(TotalAmount), 2) AS DECIMAL (10, 2)) AS TotalRevenue,
	DiscountTier
FROM DiscountBreakdown
GROUP BY DiscountTier
ORDER BY AvgOrderValue DESC;

-- Average shipping cost by state
SELECT
	State,
	CAST(ROUND(AVG(ShippingCost), 2) AS DECIMAL (10, 2)) AS AvgShippingCost
FROM AmazonSales
WHERE OrderStatus NOT IN ('Cancelled', 'Returned')
GROUP BY State
ORDER BY AvgShippingCost DESC;