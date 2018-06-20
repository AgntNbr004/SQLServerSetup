/*
Created by	: Brent C. Rockwell
Written on	: 2018-06-19
Description	: This is a series of simple scripts that allow you to view the data in the different PROD tables.
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

-- View customer names
SELECT TOP 1000
	C.*
FROM PROD.Customers C WITH (NOLOCK)

GO

-- View Customer Address Types
SELECT
	CAT.*
FROM PROD.ContactAddressType CAT WITH (NOLOCK)

GO

-- View Customer Address population
SELECT
	tC.Count_nb AddressPopulation_nb,
	COUNT(1) Count_nb
FROM (
	SELECT
		C.[Key_id],
		SUM(CASE
			WHEN CA.Key_id is NOT NULL THEN 1
			ELSE 0
			END) Count_nb
	FROM PROD.Customers C WITH (NOLOCK)
		LEFT JOIN PROD.ContactAddress CA WITH (NOLOCK)
			ON C.[Key_id] = CA.Customer_id
	GROUP BY C.[Key_id]
	) tC
GROUP BY tC.Count_nb
ORDER BY AddressPopulation_nb

GO

-- View Customer Addresses
SELECT TOP 1000
	CA.*
FROM PROD.ContactAddress CA WITH (NOLOCK)

GO

-- View Customer Email Types
SELECT
	CET.*
FROM PROD.ContactEmailType CET WITH (NOLOCK)

GO

-- View Customer Address population
SELECT
	tC.Count_nb EmailPopulation_nb,
	COUNT(1) Count_nb
FROM (
	SELECT
		C.[Key_id],
		SUM(CASE
			WHEN CA.Key_id is NOT NULL THEN 1
			ELSE 0
			END) Count_nb
	FROM PROD.Customers C WITH (NOLOCK)
		LEFT JOIN PROD.ContactEmail CA WITH (NOLOCK)
			ON C.[Key_id] = CA.Customer_id
	GROUP BY C.[Key_id]
	) tC
GROUP BY tC.Count_nb
ORDER BY EmailPopulation_nb

GO

-- Vite Customer Emails
SELECT TOP 1000
	CE.*
FROM PROD.ContactEmail CE WITH (NOLOCK)

GO

-- View Customer Contact Phone Number Types
SELECT
	CPT.*
FROM PROD.ContactPhoneType CPT WITH (NOLOCK)

GO

-- View Customer Phone population
SELECT
	tC.Count_nb PhonePopulation_nb,
	COUNT(1) Count_nb
FROM (
	SELECT
		C.[Key_id],
		SUM(CASE
			WHEN CA.Key_id is NOT NULL THEN 1
			ELSE 0
			END) Count_nb
	FROM PROD.Customers C WITH (NOLOCK)
		LEFT JOIN PROD.ContactPhone CA WITH (NOLOCK)
			ON C.[Key_id] = CA.Customer_id
	GROUP BY C.[Key_id]
	) tC
GROUP BY tC.Count_nb
ORDER BY PhonePopulation_nb

-- View Customer Phone Numbers
SELECT TOP 1000
	CP.*
FROM PROD.ContactPhone CP WITH (NOLOCK)

GO

-- View company Products
SELECT
	P.*
FROM PROD.Products P WITH (NOLOCK)

GO

-- View Customer Order population
SELECT
	tC.Count_nb OrderPopulation_nb,
	COUNT(1) Count_nb
FROM (
	SELECT
		C.[Key_id],
		SUM(CASE
			WHEN CA.Key_id is NOT NULL THEN 1
			ELSE 0
			END) Count_nb
	FROM PROD.Customers C WITH (NOLOCK)
		LEFT JOIN PROD.Orders CA WITH (NOLOCK)
			ON C.[Key_id] = CA.Customer_id
	GROUP BY C.[Key_id]
	) tC
GROUP BY tC.Count_nb
ORDER BY OrderPopulation_nb

-- View the Customer Orders
SELECT TOP 1000
	O.*
FROM PROD.Orders O WITH (NOLOCK)

GO

-- See records from the view.
SELECT
	vPP.*
FROM PROD.vw_ProductPopularity vPP WITH (NOLOCK)

GO

-- See records from the view.
SELECT
	vRB.*
FROM PROD.vw_RevenueBreakdown vRB WITH (NOLOCK)

GO

-- See records from the view.
SELECT
	vTHC.*
FROM PROD.vw_TopHundredCustomers vTHC WITH (NOLOCK)

GO

-- See records from the view.
SELECT
	vOF.*
FROM PROD.vw_OrderFrequency vOF WITH (NOLOCK)

GO

SELECT
	POT.*
FROM TEMP.PersistentObjectTypes POT WITH (NOLOCK)

GO

SELECT
	PO.*
FROM TEMP.PersistentObjects PO WITH (NOLOCK)

GO


