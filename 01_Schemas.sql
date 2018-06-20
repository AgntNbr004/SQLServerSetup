/*
Created by	: Brent C. Rockwell
Written on	: 2018-06-19
Description	: This is a simple script that sets up a production schema and a sandbox schema for a generic company.
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
 
 -- Ensures that the PROD schema can be created dynamically if needed.
IF NOT EXISTS(
		SELECT S.*
		FROM sys.schemas S WITH (NOLOCK)
		WHERE S.[name] = 'PROD'
		)
	EXEC sp_executesql
		@sql=N'CREATE SCHEMA PROD'

GO

-- Ensures that the TEMP schema can be created dynamically if needed.
IF NOT EXISTS(
		SELECT S.*
		FROM sys.schemas S WITH (NOLOCK)
		WHERE S.[name] = 'TEMP'
		)
	EXEC sp_executesql
		@sql=N'CREATE SCHEMA TEMP'

GO


