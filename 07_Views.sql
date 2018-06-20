/*
Created by	: Brent C. Rockwell
Written on	: 2018-06-19
Description	: This is a simple script that creates a few views for looking into customer / order data.
*/

-- Ensure the right environment exists.
IF NOT EXISTS(
		SELECT DB.create_date
		FROM sys.databases DB WITH (NOLOCK)
		WHERE DB.[name] = 'BrentRockwell'
		) BEGIN
	RAISERROR('We want a database "BrentRockwell" to run these scripts on. Please create it and try again!', 16, 1)
	RETURN
END

-- Switch to that environment.
USE BrentRockwell

SET NOCOUNT ON

GO

-- Create a view to see a breakdown of how often all of our products are ordered, broken down by year/quarter/month.
CREATE VIEW PROD.vw_ProductPopularity
AS
SELECT
	P.Product_tx,
	P.Description_tx,
	P.Offered_fg StillAvailable_fg,
	YEAR(O.Create_dt) Year_nb,
	DATEPART(QUARTER, O.Create_dt) Quarter_nb,
	MONTH(O.Create_dt) Month_nb,
	COUNT(1) TimesOrdered_nb,
	SUM(O.Quantity_nb) ItemsSold_nb,
	SUM(O.cal_TotalCost_amt) TotalRevenue_amt
FROM PROD.Products P WITH (NOLOCK)
	JOIN PROD.Orders O WITH (NOLOCK)
		ON P.[Key_id] = O.Product_fk
GROUP BY
	P.Product_tx,
	P.Description_tx,
	P.Offered_fg,
	YEAR(O.Create_dt),
	DATEPART(QUARTER, O.Create_dt),
	MONTH(O.Create_dt)

GO

-- Create a view to see a breakdown of the revenue from customer purchases broken down by year/quarter/month.
CREATE VIEW PROD.vw_RevenueBreakdown
AS
SELECT
	YEAR(O.Create_dt) Year_nb,
	DATEPART(QUARTER, O.Create_dt) Quarter_nb,
	MONTH(O.Create_dt) Month_nb,
	SUM(O.cal_TotalCost_amt) TotalRevenue_amt
FROM PROD.Orders O WITH (NOLOCK)
GROUP BY
	YEAR(O.Create_dt),
	DATEPART(QUARTER, O.Create_dt),
	MONTH(O.Create_dt)
WITH ROLLUP

GO

-- Create a view to see which customers spend the most money.
CREATE VIEW PROD.vw_TopHundredCustomers
AS
SELECT TOP 100
	RTRIM(C.FirstName_tx + ' '
		+ ISNULL(C.MiddleName_tx, '') + ' ')
		+ C.LastName_tx CustomerName_tx,
	COUNT(1) OrdersPlaced_nb,
	SUM(O.Quantity_nb) ItemsOrdered_nb,
	SUM(O.cal_TotalCost_amt) TotalSpent_nb
FROM PROD.Customers C WITH (NOLOCK)
	JOIN PROD.Orders O WITH (NOLOCK)
		ON C.[Key_id] = O.Customer_fk
GROUP BY
	RTRIM(C.FirstName_tx + ' '
		+ ISNULL(C.MiddleName_tx, '') + ' ')
		+ C.LastName_tx
ORDER BY SUM(O.cal_TotalCost_amt) DESC

GO

-- Create a view to see how often our customers order, broken down by year/quarter/month.
CREATE VIEW PROD.vw_OrderFrequency
AS
SELECT
	ROW_NUMBER() OVER (ORDER BY YEAR(O.Create_dt), MONTH(O.Create_dt)) Order_nb,
	YEAR(O.Create_dt) Year_nb,
	DATEPART(QUARTER, O.Create_dt) Quarter_nb,
	MONTH(O.Create_dt) Month_nb,
	COUNT(1) Count_nb
FROM PROD.Orders O WITH (NOLOCK)
GROUP BY
	YEAR(O.Create_dt),
	DATEPART(QUARTER, O.Create_dt),
	MONTH(O.Create_dt)

GO


