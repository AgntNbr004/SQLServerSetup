/*
Created by	: Brent C. Rockwell
Written on	: 2018-06-19
Description	: This is a simple script that creates triggers that perform simple data validation and logging.
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

-- Creating a trigger for logging changes to Customer Information
CREATE TRIGGER PROD.trg_CustomersChange
ON PROD.Customers
AFTER UPDATE, DELETE
AS
BEGIN
	INSERT INTO PROD.ChangeLog
		(
		ChangeSource_id,
		ChangeType_fk,
		ChangeFrom_XML,
		ChangeTo_XML,
		Create_dt
		)
	SELECT 
		OBJECT_ID('PROD.Customers'),
		CASE
			WHEN
				(
				SELECT COUNT(1) Count_nb
				FROM inserted I WITH (NOLOCK)
				) > 0 THEN 'UPDATE'
			ELSE 'DELETE'
			END ChangeType_tx,
		(
			SELECT
				D_XML.*
			FROM deleted D_XML WITH (NOLOCK)
			WHERE D_XML.[Key_id] = D.[Key_id]
			FOR XML RAW
		) deleted_XML,
		(
			SELECT
				I_XML.*
			FROM inserted I_XML WITH (NOLOCK)
			WHERE I_XML.[Key_id] = D.[Key_id]
			FOR XML RAW
		) inserted_XML,
		GETUTCDATE() Change_dt
	FROM deleted D WITH (NOLOCK)
END

GO

-- Creating a trigger for logging changes to Customer Addresses
CREATE TRIGGER PROD.trg_ContactAddressChange
ON PROD.ContactAddress
AFTER UPDATE, DELETE
AS
BEGIN
	INSERT INTO PROD.ChangeLog
		(
		ChangeSource_id,
		ChangeType_fk,
		ChangeFrom_XML,
		ChangeTo_XML,
		Create_dt
		)
	SELECT 
		OBJECT_ID('PROD.ContactAddress'),
		CASE
			WHEN
				(
				SELECT COUNT(1) Count_nb
				FROM inserted I WITH (NOLOCK)
				) > 0 THEN 'UPDATE'
			ELSE 'DELETE'
			END ChangeType_tx,
		(
			SELECT
				D_XML.*
			FROM deleted D_XML WITH (NOLOCK)
			WHERE D_XML.[Key_id] = D.[Key_id]
			FOR XML RAW
		) deleted_XML,
		(
			SELECT
				I_XML.*
			FROM inserted I_XML WITH (NOLOCK)
			WHERE I_XML.[Key_id] = D.[Key_id]
			FOR XML RAW
		) inserted_XML,
		GETUTCDATE() Change_dt
	FROM deleted D WITH (NOLOCK)
END

GO

-- Creating a trigger for logging changes to Customer Emails
CREATE TRIGGER PROD.trg_ContactEmailChange
ON PROD.ContactEmail
AFTER UPDATE, DELETE
AS
BEGIN
	INSERT INTO PROD.ChangeLog
		(
		ChangeSource_id,
		ChangeType_fk,
		ChangeFrom_XML,
		ChangeTo_XML,
		Create_dt
		)
	SELECT 
		OBJECT_ID('PROD.ContactEmail'),
		CASE
			WHEN
				(
				SELECT COUNT(1) Count_nb
				FROM inserted I WITH (NOLOCK)
				) > 0 THEN 'UPDATE'
			ELSE 'DELETE'
			END ChangeType_tx,
		(
			SELECT
				D_XML.*
			FROM deleted D_XML WITH (NOLOCK)
			WHERE D_XML.[Key_id] = D.[Key_id]
			FOR XML RAW
		) deleted_XML,
		(
			SELECT
				I_XML.*
			FROM inserted I_XML WITH (NOLOCK)
			WHERE I_XML.[Key_id] = D.[Key_id]
			FOR XML RAW
		) inserted_XML,
		GETUTCDATE() Change_dt
	FROM deleted D WITH (NOLOCK)
END

GO

-- Creating a trigger for logging changes to Customer Phone Numbers
CREATE TRIGGER PROD.trg_ContactPhoneChange
ON PROD.ContactPhone
AFTER UPDATE, DELETE
AS
BEGIN
	INSERT INTO PROD.ChangeLog
		(
		ChangeSource_id,
		ChangeType_fk,
		ChangeFrom_XML,
		ChangeTo_XML,
		Create_dt
		)
	SELECT 
		OBJECT_ID('PROD.ContactPhone'),
		CASE
			WHEN
				(
				SELECT COUNT(1) Count_nb
				FROM inserted I WITH (NOLOCK)
				) > 0 THEN 'UPDATE'
			ELSE 'DELETE'
			END ChangeType_tx,
		(
			SELECT
				D_XML.*
			FROM deleted D_XML WITH (NOLOCK)
			WHERE D_XML.[Key_id] = D.[Key_id]
			FOR XML RAW
		) deleted_XML,
		(
			SELECT
				I_XML.*
			FROM inserted I_XML WITH (NOLOCK)
			WHERE I_XML.[Key_id] = D.[Key_id]
			FOR XML RAW
		) inserted_XML,
		GETUTCDATE() Change_dt
	FROM deleted D WITH (NOLOCK)
END

GO

-- Creating a trigger for logging changes to Products
CREATE TRIGGER PROD.trg_ProductsChange
ON PROD.Products
AFTER UPDATE, DELETE
AS
BEGIN
	INSERT INTO PROD.ChangeLog
		(
		ChangeSource_id,
		ChangeType_fk,
		ChangeFrom_XML,
		ChangeTo_XML,
		Create_dt
		)
	SELECT 
		OBJECT_ID('PROD.Products'),
		CASE
			WHEN
				(
				SELECT COUNT(1) Count_nb
				FROM inserted I WITH (NOLOCK)
				) > 0 THEN 'UPDATE'
			ELSE 'DELETE'
			END ChangeType_tx,
		(
			SELECT
				D_XML.*
			FROM deleted D_XML WITH (NOLOCK)
			WHERE D_XML.[Key_id] = D.[Key_id]
			FOR XML RAW
		) deleted_XML,
		(
			SELECT
				I_XML.*
			FROM inserted I_XML WITH (NOLOCK)
			WHERE I_XML.[Key_id] = D.[Key_id]
			FOR XML RAW
		) inserted_XML,
		GETUTCDATE() Change_dt
	FROM deleted D WITH (NOLOCK)
END

GO

-- Creating a trigger for logging changes to Customer Orders
CREATE TRIGGER PROD.trg_OrdersChange
ON PROD.Orders
AFTER UPDATE, DELETE
AS
BEGIN
	INSERT INTO PROD.ChangeLog
		(
		ChangeSource_id,
		ChangeType_fk,
		ChangeFrom_XML,
		ChangeTo_XML,
		Create_dt
		)
	SELECT 
		OBJECT_ID('PROD.Orders'),
		CASE
			WHEN
				(
				SELECT COUNT(1) Count_nb
				FROM inserted I WITH (NOLOCK)
				) > 0 THEN 'UPDATE'
			ELSE 'DELETE'
			END ChangeType_tx,
		(
			SELECT
				D_XML.*
			FROM deleted D_XML WITH (NOLOCK)
			WHERE D_XML.[Key_id] = D.[Key_id]
			FOR XML RAW
		) deleted_XML,
		(
			SELECT
				I_XML.*
			FROM inserted I_XML WITH (NOLOCK)
			WHERE I_XML.[Key_id] = D.[Key_id]
			FOR XML RAW
		) inserted_XML,
		GETUTCDATE() Change_dt
	FROM deleted D WITH (NOLOCK)
END

GO

-- Creating a trigger for performing data validation.
CREATE TRIGGER TEMP.trg_TableValidation
ON TEMP.PersistentObjects
AFTER INSERT, UPDATE
AS
BEGIN
	-- Setup
	DECLARE @Exceptions TABLE
		(
		[Key_id] uniqueidentifier
		)
	
	DECLARE
		@ExceptionCount INT,
		@ExceptionList NVARCHAR(MAX),
		@ErrorMsg NVARCHAR(MAX),
		@TAB CHAR = CHAR(9),
		@CRLF CHAR = CHAR(13) + CHAR(10)

	-- Validation Check #01: Ensure date is not "permanent"
	INSERT INTO @Exceptions
	SELECT I.[Key_id]
	FROM inserted I WITH (NOLOCK)
	WHERE I.Expiration_dt > DATEADD(MM, 6, GETUTCDATE())

	SET @ExceptionList =
		(
		SELECT I.Name_tx + ' (' + I.Type_fk + '),'
		FROM inserted I WITH (NOLOCK)
		WHERE EXISTS
			(
			SELECT *
			FROM @Exceptions E
			WHERE E.[Key_id] = I.[Key_id]
			)
		FOR XML PATH('')
		)
	SET @ExceptionList = @TAB + REPLACE(LEFT(@ExceptionList, LEN(@ExceptionList) - 1), ',', ',' + @CRLF + @TAB)

	SELECT @ExceptionCount = COUNT(1)
	FROM @Exceptions

	IF @ExceptionCount > 0 BEGIN
		SET @ErrorMsg = 
			'These ' + CAST(@ExceptionCount AS NVARCHAR(12)) + ' objects have expiration dates too far out:' + @CRLF 
			+ @ExceptionList + @CRLF 
			+ 'They will be updated to have the maximum allowed!'
		RAISERROR(@ErrorMsg, 16, 1)

		UPDATE PO
		SET Expiration_dt = DATEADD(MM, 6, GETUTCDATE())
		FROM TEMP.PersistentObjects PO
			JOIN @Exceptions E
				ON PO.Key_id = E.Key_id
	END ELSE
		PRINT('Records updated successfully!')
	
	-- Validation Check #02: Does the table exist
	DELETE FROM @Exceptions

	INSERT INTO @Exceptions
	SELECT I.[Key_id]
	FROM sys.objects O WITH (NOLOCK)
		RIGHT JOIN inserted I WITH (NOLOCK)
			ON O.[name] = I.Name_tx
			AND SCHEMA_NAME(O.schema_id) = 'TEMP'
	WHERE O.create_date is NULL

	SELECT @ExceptionCount = COUNT(1)
	FROM @Exceptions

	SET @ExceptionList =
		(
		SELECT I.Name_tx + ' (' + I.Type_fk + '),'
		FROM inserted I WITH (NOLOCK)
		WHERE EXISTS
			(
			SELECT *
			FROM @Exceptions E
			WHERE E.[Key_id] = I.[Key_id]
			)
		FOR XML PATH('')
		)
	SET @ExceptionList = @TAB + REPLACE(LEFT(@ExceptionList, LEN(@ExceptionList) - 1), ',', ',' + @CRLF + @TAB)

	IF @ExceptionCount > 0 BEGIN
		SET @ErrorMsg = 
			'These ' + CAST(@ExceptionCount AS NVARCHAR(12)) + ' objects do not exist:' + @CRLF 
			+ @ExceptionList + @CRLF 
			+ 'They will be removed from TEMP.PersistentObjects!'
		RAISERROR(@ErrorMsg, 16, 1)

		DELETE PO
		FROM TEMP.PersistentObjects PO
			JOIN @Exceptions E
				ON PO.Key_id = E.Key_id
	END ELSE
		PRINT('Records added successfully!')

	-- Validation Check #03: Raise warning if the date is in the past
	DELETE FROM @Exceptions
	
	INSERT INTO @Exceptions
	SELECT I.[Key_id]
	FROM inserted I WITH (NOLOCK)
	WHERE I.Expiration_dt <= GETUTCDATE()

	SET @ExceptionList =
		(
		SELECT I.Name_tx + ' (' + I.Type_fk + '),'
		FROM inserted I WITH (NOLOCK)
		WHERE EXISTS
			(
			SELECT *
			FROM @Exceptions E
			WHERE E.[Key_id] = I.[Key_id]
			)
		FOR XML PATH('')
		)
	SET @ExceptionList = @TAB + REPLACE(LEFT(@ExceptionList, LEN(@ExceptionList) - 1), ',', ',' + @CRLF + @TAB)

	SELECT @ExceptionCount = COUNT(1)
	FROM @Exceptions

	IF @ExceptionCount > 0 BEGIN
		SET @ErrorMsg = 
			'These ' + CAST(@ExceptionCount AS NVARCHAR(12)) + ' objects have expiration dates in the PAST:' + @CRLF 
			+ @ExceptionList + @CRLF 
			+ 'They will be dropped when the next cleanup runs!'
		RAISERROR(@ErrorMsg, 16, 1)
	END
END

GO


