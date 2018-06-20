/*
Created by	: Brent C. Rockwell
Written on	: 2018-06-19
Description	: This is a simple script that sets up production and sandbox tables for a generic company.
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

-- Create a table for Customer Address Types
CREATE TABLE PROD.ChangeLogType
(
	ChangeType_fk NVARCHAR(50) PRIMARY KEY,
	Create_dt DATETIME NOT NULL DEFAULT GETUTCDATE(),
	Modified_dt DATETIME NOT NULL DEFAULT GETUTCDATE()
)

GO

-- Create a table to store changes that occur to various tables
CREATE TABLE PROD.ChangeLog
(
	[Key_id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	ChangeSource_id BIGINT NOT NULL,
	ChangeType_fk NVARCHAR(50) NOT NULL,
	ChangeFrom_XML XML NOT NULL,
	ChangeTo_XML XML NOT NULL,
	Create_dt DATETIME NOT NULL DEFAULT GETUTCDATE(),
	CONSTRAINT FK_ChangeLogType FOREIGN KEY
	(
		ChangeType_fk
	)
	REFERENCES PROD.ChangeLogType
	(
		ChangeType_fk
	)
)

GO

-- Create the Customers table
CREATE TABLE PROD.Customers
(
	[Key_id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	FirstName_tx NVARCHAR(50) NOT NULL,
	MiddleName_tx NVARCHAR(50) NULL,
	LastName_tx NVARCHAR(50) NOT NULL,
	Active_fg BIT NOT NULL,
	Create_dt DATETIME NOT NULL DEFAULT GETUTCDATE(),
	Modified_dt DATETIME NOT NULL DEFAULT GETUTCDATE()
)

GO

-- Create a table for Customer Address Types
CREATE TABLE PROD.ContactAddressType
(
	AddressType_fk NVARCHAR(50) PRIMARY KEY,
	Create_dt DATETIME NOT NULL DEFAULT GETUTCDATE(),
	Modified_dt DATETIME NOT NULL DEFAULT GETUTCDATE()
)

GO

-- Create a table for Customer Addresses
CREATE TABLE PROD.ContactAddress
(
	[Key_id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	Customer_id UNIQUEIDENTIFIER NOT NULL,
	AddressType_fk NVARCHAR(50) NOT NULL,
	AddressLine1_tx NVARCHAR(100) NOT NULL,
	AddressLine2_tx NVARCHAR(100) NOT NULL,
	City_tx NVARCHAR(50) NOT NULL,
	State_tx NVARCHAR(20) NOT NULL,
	PostalCode_tx NVARCHAR(10) NOT NULL,
	Primary_fg BIT NOT NULL,
	Create_dt DATETIME NOT NULL DEFAULT GETUTCDATE(),
	Modified_dt DATETIME NOT NULL DEFAULT GETUTCDATE(),
	CONSTRAINT FK_ContactAddressType FOREIGN KEY
	(
		AddressType_fk
	)
	REFERENCES PROD.ContactAddressType
	(
		AddressType_fk
	)
)

GO

-- Create a table to store Customer Email Types
CREATE TABLE PROD.ContactEmailType
(
	EmailType_fk NVARCHAR(50) PRIMARY KEY,
	Create_dt DATETIME NOT NULL DEFAULT GETUTCDATE(),
	Modified_dt DATETIME NOT NULL DEFAULT GETUTCDATE()
)

GO

-- Create a table for Customer Email Addresses
CREATE TABLE PROD.ContactEmail
(
	[Key_id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	Customer_id UNIQUEIDENTIFIER NOT NULL,
	EmailType_fk NVARCHAR(50) NOT NULL,
	Email_tx NVARCHAR(100) NOT NULL,
	Primary_fg BIT NOT NULL,
	Create_dt DATETIME NOT NULL DEFAULT GETUTCDATE(),
	Modified_dt DATETIME NOT NULL DEFAULT GETUTCDATE(),
	CONSTRAINT FK_ContactEmailType FOREIGN KEY
	(
		EmailType_fk
	)
	REFERENCES PROD.ContactEmailType
	(
		EmailType_fk
	)
)

GO

-- Create a table to store Customer Phone Number Types
CREATE TABLE PROD.ContactPhoneType
(
	PhoneType_fk NVARCHAR(50) PRIMARY KEY,
	Create_dt DATETIME NOT NULL DEFAULT GETUTCDATE(),
	Modified_dt DATETIME NOT NULL DEFAULT GETUTCDATE()
)

GO

-- Create a table for Customer Phone Numbers
CREATE TABLE PROD.ContactPhone
(
	[Key_id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	Customer_id UNIQUEIDENTIFIER NOT NULL,
	PhoneType_fk NVARCHAR(50) NOT NULL,
	PhoneNumber_tx NVARCHAR(20) NOT NULL,
	Primary_fg BIT,
	Create_dt DATETIME NOT NULL DEFAULT GETUTCDATE(),
	Modified_dt DATETIME NOT NULL DEFAULT GETUTCDATE(),
	CONSTRAINT FK_ContactPhoneType FOREIGN KEY 
	(
		PhoneType_fk
	) 
	REFERENCES PROD.ContactPhoneType
	(
		PhoneType_fk
	)
)

GO

-- Create a table to store Company Products
CREATE TABLE PROD.Products
(
	[Key_id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	Product_tx NVARCHAR(100) NOT NULL,
	Description_tx NVARCHAR(510),
	Price_amt MONEY NOT NULL,
	Offered_fg BIT NOT NULL,
	Create_dt DATETIME NOT NULL DEFAULT GETUTCDATE(),
	Modified_dt DATETIME NOT NULL DEFAULT GETUTCDATE()
)

GO

-- Create a table to store Customer Orders
CREATE TABLE PROD.Orders
(
	[Key_id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	Customer_fk UNIQUEIDENTIFIER NOT NULL,
	Product_fk UNIQUEIDENTIFIER NOT NULL,
	Price_amt MONEY NOT NULL,
	Quantity_nb INT NOT NULL,
	cal_TotalCost_amt AS Price_amt * Quantity_nb,
	Create_dt DATETIME NOT NULL DEFAULT GETUTCDATE(),
	Modified_dt DATETIME NOT NULL DEFAULT GETUTCDATE(),
	CONSTRAINT FK_Customer FOREIGN KEY
	(
		Customer_fk
	)
	REFERENCES PROD.Customers
	(
		[Key_id]
	),
	CONSTRAINT FK_Product FOREIGN KEY
	(
		Product_fk
	)
	REFERENCES PROD.Products
	(
		[Key_id]
	)
)

GO

-- Create a table for storing types of non-droppable tables
CREATE TABLE TEMP.PersistentObjectTypes
(
	Type_fk VARCHAR(50) PRIMARY KEY NOT NULL,
	Create_dt DATETIME NOT NULL DEFAULT GETUTCDATE(),
	Modified_dt DATETIME NOT NULL DEFAULT GETUTCDATE()
)

GO

-- Create a table for storing non-droppable tables
CREATE TABLE TEMP.PersistentObjects
(
	[Key_id] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	Name_tx VARCHAR(255) PRIMARY KEY,
	Type_fk VARCHAR(50) NOT NULL ,
	Expiration_dt DATETIME NOT NULL,
	Create_dt DATETIME NOT NULL DEFAULT GETUTCDATE(),
	CONSTRAINT FK_TypeTx FOREIGN KEY
	(
		Type_fk
	)
	REFERENCES TEMP.PersistentObjectTypes
	(
		Type_fk
	)
)

GO


