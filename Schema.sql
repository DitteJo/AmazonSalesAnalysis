-- Creates the AmazonSales table structure

CREATE TABLE AmazonSales (
	[OrderID] [varchar](50) PRIMARY KEY,
	[OrderDate] [date] NOT NULL,
	[CustomerID] [varchar](50) NOT NULL,
	[CustomerName] [varchar](50) NOT NULL,
	[ProductID] [varchar](50) NOT NULL,
	[ProductName] [varchar](50) NOT NULL,
	[Category] [varchar](50) NOT NULL,
	[Brand] [varchar](50) NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](10, 2) NOT NULL,
	[Discount] [decimal](5, 2) NOT NULL,
	[Tax] [decimal](10, 2) NOT NULL,
	[ShippingCost] [decimal](10, 2) NOT NULL,
	[TotalAmount] [decimal](10, 2) NOT NULL,
	[PaymentMethod] [varchar](50) NOT NULL,
	[OrderStatus] [varchar](50) NOT NULL,
	[City] [varchar](50) NOT NULL,
	[State] [varchar](50) NOT NULL,
);

