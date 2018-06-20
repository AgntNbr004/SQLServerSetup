/*
Created by	: Brent C. Rockwell
Written on	: 2018-06-19
Description	: This is a simple script that creates a few functions for doing string manipulations.
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
 
-- Create a function to strip out all special characters from a string (provided)
CREATE FUNCTION PROD.svf_ReturnAlphaNumericOnly
(
	@InputString NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @SpecialChars VARCHAR(50) = '%[-,~,@,#,$,%,&,*,(,),.,!,^,?,:]%'

	WHILE PATINDEX(
		@SpecialChars,
		@InputString
		) > 0
	SET @InputString = 
			REPLACE(
				REPLACE(
					@InputString,
					SUBSTRING(
						@InputString,
						PATINDEX(
							@SpecialChars,
							@InputString
							),
							1
						),
						''
					),
					'-',
					' '
				)
	RETURN @InputString 
END

GO

-- Create a function to strip out all non-alpha characters from a string (provided)
CREATE FUNCTION PROD.svf_ReturnAlphaOnly
(
	@InputString NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @SpecialChars VARCHAR(50) = '%[0,1,2,3,4,5,6,7,8,9]%'

	SET @InputString = PROD.svf_ReturnAlphaNumericOnly(@InputString)
	WHILE PATINDEX(
		@SpecialChars,
		@InputString
		) > 0
	SET @InputString = 
			REPLACE(
				REPLACE(
					@InputString,
					SUBSTRING(
						@InputString,
						PATINDEX(
							@SpecialChars,
							@InputString
							),
							1
						),
						''
					),
					'-',
					' '
				)
	RETURN @InputString 
END

GO

-- Create a function to strip out all non-alpha characters from a string (provided)
CREATE FUNCTION PROD.svf_ReturnNumericOnly
(
	@InputString NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @SpecialChars VARCHAR(50) = '%[A-Za-z]%'

	SET @InputString = PROD.svf_ReturnAlphaNumericOnly(@InputString)
	WHILE PATINDEX(
		@SpecialChars,
		@InputString
		) > 0
	SET @InputString = 
			REPLACE(
				REPLACE(
					@InputString,
					SUBSTRING(
						@InputString,
						PATINDEX(
							@SpecialChars,
							@InputString
							),
							1
						),
						''
					),
					'-',
					' '
				)
	RETURN @InputString 
END

GO


