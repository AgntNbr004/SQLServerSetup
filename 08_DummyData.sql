/*
Created by	: Brent C. Rockwell
Written on	: 2018-06-19
Description	: This script generates garbage data into all the tables on the PROD schema.
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

-- Populate Change Log Types
INSERT INTO PROD.ChangeLogType
	(
	ChangeType_fk
	)
VALUES
	('UPDATE'),
	('DELETE')

GO

-- Populate Customers table with 1MM records consisting of random strings for names
DECLARE @Count BIGINT = 1

WHILE @Count <= 1000000
BEGIN
	INSERT INTO PROD.Customers
		(
		FirstName_tx,
		MiddleName_tx,
		LastName_tx,
		Active_fg,
		Create_dt
		)
	VALUES
		(
		PROD.svf_ReturnAlphaOnly(NEWID()),
		PROD.svf_ReturnAlphaOnly(NEWID()),
		PROD.svf_ReturnAlphaOnly(NEWID()),
		1,
		DATEADD(DD, (ABS(CHECKSUM(NEWID())) % DATEDIFF(DD, '2017-01-01', GETUTCDATE())), '2017-01-01')
		)
	SET @Count = @Count + 1
END
-- Execution time: 6 min, 31 seonds

GO

-- Populate Customer Address Types
INSERT INTO PROD.ContactAddressType
	(
	AddressType_fk
	)
VALUES
	('HOME'),
	('OFFICE'),
	('OTHER')

GO

-- Populate Customer Address
INSERT INTO PROD.ContactAddress
	(
	Customer_id,
	AddressType_fk,
	AddressLine1_tx,
	AddressLine2_tx,
	City_tx,
	State_tx,
	PostalCode_tx,
	Primary_fg
	)
SELECT TOP 90 PERCENT
	C.[Key_id],
	CASE ABS(CHECKSUM(NEWID())) % 3
		WHEN 0 THEN 'HOME'
		WHEN 1 THEN 'OFFICE'
		ELSE 'OTHER'
		END,
	PROD.svf_ReturnAlphaOnly(NEWID()) AddressLine1_tx,
	PROD.svf_ReturnAlphaOnly(NEWID()) AddressLine2_tx,
	PROD.svf_ReturnAlphaOnly(NEWID()) City_tx,
	LEFT(PROD.svf_ReturnAlphaOnly(NEWID()), 20) State_tx,
	LEFT(PROD.svf_ReturnAlphaOnly(NEWID()), 10) PostalCode_tx,
	ABS(CHECKSUM(NEWID())) % 2 Primary_fg
FROM PROD.Customers C WITH (NOLOCK)
ORDER BY NEWID()
-- Execution Time: 7 min, 26 sec

INSERT INTO PROD.ContactAddress
	(
	Customer_id,
	AddressType_fk,
	AddressLine1_tx,
	AddressLine2_tx,
	City_tx,
	State_tx,
	PostalCode_tx,
	Primary_fg
	)
SELECT TOP 30 PERCENT
	C.[Key_id],
	CASE ABS(CHECKSUM(NEWID())) % 3
		WHEN 0 THEN 'HOME'
		WHEN 1 THEN 'OFFICE'
		ELSE 'OTHER'
		END,
	PROD.svf_ReturnAlphaOnly(NEWID()) AddressLine1_tx,
	PROD.svf_ReturnAlphaOnly(NEWID()) AddressLine2_tx,
	PROD.svf_ReturnAlphaOnly(NEWID()) City_tx,
	LEFT(PROD.svf_ReturnAlphaOnly(NEWID()), 20) State_tx,
	LEFT(PROD.svf_ReturnAlphaOnly(NEWID()), 10) PostalCode_tx,
	ABS(CHECKSUM(NEWID())) % 2 Primary_fg
FROM PROD.Customers C WITH (NOLOCK)
ORDER BY NEWID()
-- Execution Time: 2 min, 31 sec

INSERT INTO PROD.ContactAddress
	(
	Customer_id,
	AddressType_fk,
	AddressLine1_tx,
	AddressLine2_tx,
	City_tx,
	State_tx,
	PostalCode_tx,
	Primary_fg
	)
SELECT TOP 5 PERCENT
	C.[Key_id],
	CASE ABS(CHECKSUM(NEWID())) % 3
		WHEN 0 THEN 'HOME'
		WHEN 1 THEN 'OFFICE'
		ELSE 'OTHER'
		END,
	PROD.svf_ReturnAlphaOnly(NEWID()) AddressLine1_tx,
	PROD.svf_ReturnAlphaOnly(NEWID()) AddressLine2_tx,
	PROD.svf_ReturnAlphaOnly(NEWID()) City_tx,
	LEFT(PROD.svf_ReturnAlphaOnly(NEWID()), 20) State_tx,
	LEFT(PROD.svf_ReturnAlphaOnly(NEWID()), 10) PostalCode_tx,
	ABS(CHECKSUM(NEWID())) % 2 Primary_fg
FROM PROD.Customers C WITH (NOLOCK)
ORDER BY NEWID()
-- Execution Time: 26 sec

GO

-- Populate Customer Email Types
INSERT INTO PROD.ContactEmailType
	(
	EmailType_fk
	)
VALUES
	('PERSONAL'),
	('WORK'),
	('OTHER')

GO

-- Populate Customer Email Addresses
INSERT INTO PROD.ContactEmail
	(
	Customer_id,
	EmailType_fk,
	Email_tx,
	Primary_fg
	)
SELECT TOP 95 PERCENT
	C.[Key_id] Customer_id,
	CASE ABS(CHECKSUM(NEWID())) % 3
		WHEN 0 THEN 'PERSONAL'
		WHEN 1 THEN 'WORK'
		ELSE 'OTHER'
		END EmailType_fk,
	PROD.svf_ReturnAlphaOnly(NEWID()) + '@' + PROD.svf_ReturnAlphaOnly(NEWID()) + '.com' Email_tx,
	ABS(CHECKSUM(NEWID())) % 2 Primary_fg
FROM PROD.Customers C WITH (NOLOCK)
ORDER BY NEWID()
-- Execution Time: 3 min, 12 sec

INSERT INTO PROD.ContactEmail
	(
	Customer_id,
	EmailType_fk,
	Email_tx,
	Primary_fg
	)
SELECT TOP 25 PERCENT
	C.[Key_id] Customer_id,
	CASE ABS(CHECKSUM(NEWID())) % 3
		WHEN 0 THEN 'PERSONAL'
		WHEN 1 THEN 'WORK'
		ELSE 'OTHER'
		END EmailType_fk,
	PROD.svf_ReturnAlphaOnly(NEWID()) + '@' + PROD.svf_ReturnAlphaOnly(NEWID()) + '.com' Email_tx,
	ABS(CHECKSUM(NEWID())) % 2 Primary_fg
FROM PROD.Customers C WITH (NOLOCK)
ORDER BY NEWID()
-- Execution Time: 53 sec

GO

-- Populate Customer Phone Number Types
INSERT INTO PROD.ContactPhoneType
	(
	PhoneType_fk
	)
VALUES
	('HOME'),
	('CELL'),
	('WORK'),
	('OTHER')

GO

-- Populate Customer Phone Numbers
INSERT INTO PROD.ContactPhone
	(
	Customer_id,
	PhoneType_fk,
	PhoneNumber_tx,
	Primary_fg
	)
SELECT TOP 85 PERCENT
	C.[Key_id] Customer_id,
	CASE ABS(CHECKSUM(NEWID())) % 4
		WHEN 0 THEN 'HOME'
		WHEN 1 THEN 'CELL'
		WHEN 2 THEN 'WORK'
		ELSE 'OTHER'
		END PhoneType_fk,
	LEFT(PROD.svf_ReturnNumericOnly(NEWID()), 3) + '-'
		+ LEFT(PROD.svf_ReturnNumericOnly(NEWID()), 3) + '-'
		+ LEFT(PROD.svf_ReturnNumericOnly(NEWID()), 4) PhoneNumber_tx,
	ABS(CHECKSUM(NEWID())) % 2 Primary_fg
FROM PROD.Customers C WITH (NOLOCK)
ORDER BY NEWID()
-- Execution Time: 2 min, 56 sec

INSERT INTO PROD.ContactPhone
	(
	Customer_id,
	PhoneType_fk,
	PhoneNumber_tx,
	Primary_fg
	)
SELECT TOP 60 PERCENT
	C.[Key_id] Customer_id,
	CASE ABS(CHECKSUM(NEWID())) % 4
		WHEN 0 THEN 'HOME'
		WHEN 1 THEN 'CELL'
		WHEN 2 THEN 'WORK'
		ELSE 'OTHER'
		END PhoneType_fk,
	LEFT(PROD.svf_ReturnNumericOnly(NEWID()), 3) + '-'
		+ LEFT(PROD.svf_ReturnNumericOnly(NEWID()), 3) + '-'
		+ LEFT(PROD.svf_ReturnNumericOnly(NEWID()), 4) PhoneNumber_tx,
	ABS(CHECKSUM(NEWID())) % 2 Primary_fg
FROM PROD.Customers C WITH (NOLOCK)
ORDER BY NEWID()
-- Execution Time: 2 min, 7 sec

GO

-- Populate company Products
INSERT INTO PROD.Products
	(
	Product_tx,
	Description_tx,
	Price_amt,
	Offered_fg
	)
VALUES
	('World of WarCraft', 'A great MMORPG by Blizzard Entertainment with over 100 levels of action-packed raids, PvP and storyline. FOR. THE. HORDE!', 29.99, 1),
	('7 Days to Die', 'A action-packed zombie survival crafting game by the Fun Pimps. Can you survive 7 days? We didn''t think so.', 19.99, 1),
	('FrostPunk', '11 bit studios brings you this post-apocolyptic city-builder tests your skills against a frozen armageddon. Good luck.', 24.99, 1),
	('Beat Saber', 'This game by Beat Games is like Fruit Ninja and Dance Dance Revolution had a child that became a Jedi. You''re welcome.', 14.99, 1),
	('They are Billions', 'It''s a zombie survival RTS brought to you by Numantian Games. Spoiler Alert: You die. HAHAHAHA!', $19.99, 1),
	('Portal: Still Alive', 'Who likes insanely clever 3D spatial puzzles using science-fiction tech and snarky AI? Valve and GLaDOS say: You.', 4.99, 1)

GO

-- Populate Customer Orders
WITH cte_Orders AS
	(
	SELECT TOP 98 PERCENT
		C.[Key_id] Customer_id,
		(
			SELECT TOP 1 P.[Key_id]
			FROM PROD.Products P WITH (NOLOCK)
			ORDER BY NEWID()
		) Product_id
	FROM PROD.Customers C WITH (NOLOCK)
	ORDER BY NEWID()
	)

INSERT INTO PROD.Orders
	(
	Customer_fk,
	Product_fk,
	Price_amt,
	Quantity_nb,
	Create_dt
	)
SELECT
	cO.*,
	P.Price_amt,
	(ABS(CHECKSUM(NEWID())) % 2) + 1 Quantity_nb,
	DATEADD(DD, (ABS(CHECKSUM(NEWID())) % DATEDIFF(DD, '2017-01-01', GETUTCDATE())), '2017-01-01') Order_dt
FROM cte_Orders cO
	JOIN PROD.Products P WITH (NOLOCK)
		ON  cO.Product_id = P.[Key_id];
-- Execution Time: 11 sec

WITH cte_Orders AS
	(
	SELECT TOP 15 PERCENT
		C.[Key_id] Customer_id,
		(
			SELECT TOP 1 P.[Key_id]
			FROM PROD.Products P WITH (NOLOCK)
			ORDER BY NEWID()
		) Product_id
	FROM PROD.Customers C WITH (NOLOCK)
	ORDER BY NEWID()
	)

INSERT INTO PROD.Orders
	(
	Customer_fk,
	Product_fk,
	Price_amt,
	Quantity_nb,
	Create_dt
	)
SELECT
	cO.*,
	P.Price_amt,
	(ABS(CHECKSUM(NEWID())) % 2) + 1 Quantity_nb,
	DATEADD(DD, (ABS(CHECKSUM(NEWID())) % DATEDIFF(DD, '2017-01-01', GETUTCDATE())), '2017-01-01') Order_dt
FROM cte_Orders cO
	JOIN PROD.Products P WITH (NOLOCK)
		ON  cO.Product_id = P.[Key_id]
-- Execution Time: 4 sec

GO

INSERT INTO TEMP.PersistentObjectTypes (Type_fk)
VALUES
	('TABLE'),
	('VIEW'),
	('TRIGGER'),
	('STORED PROCEDURE'),
	('FUNCTION');

GO

INSERT INTO TEMP.PersistentObjects (Name_tx, Type_fk, Expiration_dt)
VALUES
	('PersistentObjects', 'TABLE', '9999-12-31'),
	('SchemaCleanup', 'STORED PROCEDURE', '9999-12-31'),
	('FakeTable_01', 'TABLE', DATEADD(DD, 7, GETUTCDATE())),
	('FakeTable_02', 'TABLE', DATEADD(DD, -3, GETUTCDATE()))
/*
This should generate errors:
	1. PersistentObjects and SchemaCleanup have Expiration Dates too far out.
	2. FakeTable_01 and FakeTable_02 don't exist.
	3. FakeTable_02 has a date in the past.
*/

GO


