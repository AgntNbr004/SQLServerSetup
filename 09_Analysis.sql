/*
Created by	: Brent C. Rockwell
Written on	: 2018-06-19
Description	: This script is various analysis that might need to be done on a generic company dataset.
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

-- Create a pivot of all product sales
SELECT
	PVT.Product_tx,
	PVT.[2017 - Q1],
	PVT.[2017 - Q2],
	PVT.[2017 - Q3],
	PVT.[2017 - Q4],
	PVT.[2018 - Q1],
	PVT.[2018 - Q2]
FROM 
	(
	SELECT 
		P.Product_tx,
		CAST(YEAR(O.Create_dt) AS NVARCHAR(8)) + ' - Q'
			+ CAST(DATEPART(QQ, O.Create_dt) AS NVARCHAR(2)) YearQuater_tx,
		O.Quantity_nb
	FROM PROD.Orders O WITH (NOLOCK)
	JOIN PROD.Products P WITH (NOLOCK)
		ON O.Product_fk = P.[Key_id]
	) sD
PIVOT
	(
		SUM(sD.Quantity_nb)
		FOR sD.YearQuater_tx in
			(
			[2017 - Q1],
			[2017 - Q2],
			[2017 - Q3],
			[2017 - Q4],
			[2018 - Q1],
			[2018 - Q2]
			)
	) PVT

GO

-- Ensure that the changelog is working with a UPDATE to CUSTOMERS
SELECT
	CL.*
FROM PROD.ChangeLog CL WITH (NOLOCK)
-- 0 record

DECLARE @RandomCustomer NVARCHAR(50)

SELECT TOP 1
	@RandomCustomer = C.Key_id
FROM PROD.Customers C WITH (NOLOCK)
ORDER BY NEWID()

SELECT *
FROM PROD.Customers C WITH (NOLOCK)
WHERE C.Key_id = @RandomCustomer

UPDATE PROD.Customers
SET
	FirstName_tx = 'Brent',
	MiddleName_tx = 'Christian',
	LastName_tx = 'Rockwell'
WHERE Key_id = @RandomCustomer

SELECT
	CL.*
FROM PROD.ChangeLog CL WITH (NOLOCK)
-- 1 record

GO

-- Ensure that the changelog is working with a DELETE from ORDERS
SELECT
	CL.*
FROM PROD.ChangeLog CL WITH (NOLOCK)
-- 1 record

DECLARE @RandomOrder NVARCHAR(50)

SELECT TOP 1
	@RandomOrder = C.Key_id
FROM PROD.Orders C WITH (NOLOCK)
ORDER BY NEWID()

SELECT *
FROM PROD.Orders C WITH (NOLOCK)
WHERE C.Key_id = @RandomOrder

DELETE
FROM PROD.Orders
WHERE Key_id = @RandomOrder

SELECT
	CL.*
FROM PROD.ChangeLog CL WITH (NOLOCK)
-- 2 record

GO


