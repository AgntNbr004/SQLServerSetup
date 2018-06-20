/*
Created by	: Brent C. Rockwell
Written on	: 2018-06-19
Description	: This is a simple script that sets up a stored procedure for cleaning the sandbox.
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

CREATE PROCEDURE TEMP.SchemaCleanup
AS
BEGIN
	DECLARE @DropCode NVARCHAR(MAX)

	-- First: Drop Foreign Key Constraints
	SET @DropCode = 
		(
		SELECT
			'ALTER TABLE ' + SCHEMA_NAME(O.schema_id) + '.' + OBJECT_NAME(O.parent_object_id) + ' '
			+ 'DROP CONSTRAINT ' + O.name + '; '
		FROM sys.objects O WITH (NOLOCK)
		WHERE SCHEMA_NAME(O.schema_id) = 'TEMP'
		AND O.[type_desc] = 'FOREIGN_KEY_CONSTRAINT'
		AND (
			NOT EXISTS
				(
				SELECT PO.*
				FROM TEMP.PersistentObjects PO WITH (NOLOCK)
				WHERE PO.Name_tx = OBJECT_NAME(O.parent_object_id)
				)
			OR EXISTS
				(
				SELECT PO.*
				FROM TEMP.PersistentObjects PO WITH (NOLOCK)
				WHERE PO.Name_tx = OBJECT_NAME(O.parent_object_id)
				AND PO.Expiration_dt < GETUTCDATE()
				)
			)
		FOR XML PATH('')
		)
	EXEC sp_executesql
		@sql = @DropCode

	-- Last: Drop objects
	SET @DropCode =
		(
		SELECT
			'IF EXISTS(SELECT object_id(' + CAST(O.object_id AS NVARCHAR(10)) + ')) '
			+ 'DROP '
			+ CASE
				WHEN O.[type] = 'D' THEN 'CONSTRAINT'
				WHEN O.[type] = 'P' THEN 'PROCEDURE'
				WHEN O.[type] = 'U' THEN 'TABLE'
				WHEN O.[type] = 'V' THEN 'VIEW'
				WHEN O.[type] = 'TR' THEN 'TRIGGER'
				WHEN O.[type] = 'FN' THEN 'FUNCTION'
				END + ' '
			+ CAST(SCHEMA_NAME(O.schema_id) AS NVARCHAR(5)) + '.'
			+ O.[name] + '; '
		FROM sys.objects O WITH (NOLOCK)
		WHERE SCHEMA_NAME(O.schema_id) = 'TEMP'
		AND O.[type_desc] in
			('USER_TABLE', 'SQL_TRIGGER', 'SQL_SCALAR_FUNCTION')
		AND (
			NOT EXISTS
				(
				SELECT PO.*
				FROM TEMP.PersistentObjects PO WITH (NOLOCK)
				WHERE PO.Name_tx = OBJECT_NAME(O.parent_object_id)
				)
			OR EXISTS
				(
				SELECT PO.*
				FROM TEMP.PersistentObjects PO WITH (NOLOCK)
				WHERE PO.Name_tx = OBJECT_NAME(O.parent_object_id)
				AND PO.Expiration_dt < GETUTCDATE()
				)
			)
		FOR XML PATH('')
		)
	EXEC sp_executesql
		@sql = @DropCode
END

GO


