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

--PIVOT THIS DATA!
SELECT
	P.Product_tx,
	YEAR(O.Create_dt) YearOrdered_nb,
	DATEPART(QQ, O.Create_dt) QuarterOrdered_nb,
	SUM(O.Quantity_nb) TotalSold_nb
FROM PROD.Orders O WITH (NOLOCK)
	JOIN PROD.Products P WITH (NOLOCK)
		ON O.Product_fk = P.[Key_id]
GROUP BY
	P.Product_tx,
	YEAR(O.Create_dt),
	DATEPART(QQ, O.Create_dt)
ORDER BY
	P.Product_tx,
	YEAR(O.Create_dt),
	DATEPART(QQ, O.Create_dt)


GO


