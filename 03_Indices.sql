/*
Created by	: Brent C. Rockwell
Written on	: 2018-06-19
Description	: This is a simple script that sets up indices for faster joining, querying, and filtering.
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
 
-- Create indices on the Changelog
CREATE PRIMARY XML INDEX idx_NC_ChangeFrom
ON PROD.ChangeLog
(
	ChangeFrom_XML
)


CREATE INDEX idx_NC_SourceChanges
ON PROD.ChangeLog
(
	ChangeSource_id
)

CREATE INDEX idx_NC_ChangeFrequency
ON PROD.ChangeLog
(
	Create_dt
)

GO

-- Create indices on the Customers table
CREATE INDEX idx_NC_MembershipDate
ON PROD.Customers
(
	Create_dt
)

CREATE INDEX idx_NC_ActiveCustomers
ON PROD.Customers
(
	Active_fg
)

CREATE INDEX idx_NC_CustomerName
ON PROD.Customers
(
	Firstname_tx,
	MiddleName_tx,
	LastName_tx
)

GO

-- Create indices on the Customer Addresses
CREATE INDEX idx_NC_Address
ON PROD.ContactAddress
(
	AddressLine1_tx,
	AddressLine2_tx,
	City_tx,
	State_tx,
	PostalCode_tx
)

CREATE INDEX idx_NC_PrimaryAddress
ON PROD.ContactAddress
(
	Primary_fg
)

CREATE INDEX idx_NC_AddressState
ON PROD.ContactAddress
(
	State_tx
)

CREATE INDEX idx_NC_AddressType
ON PROD.ContactAddress
(
	AddressType_fk
)

GO

-- Create indices on the Customer Emails
CREATE INDEX idx_NC_EmailAddress
ON PROD.ContactEmail
(
	Email_tx
)

CREATE INDEX idx_NC_EmailType
ON PROD.ContactEmail
(
	EmailType_fk
)

CREATE INDEX idx_NC_PrimaryEmail
ON PROD.ContactEmail
(
	Primary_fg
)

GO

-- Creating indices on the Customer Phone Numbers
CREATE INDEX idx_NC_PhoneNumbers
ON PROD.ContactPhone
(
	PhoneNumber_tx
)

CREATE INDEX idx_NC_PhoneNumberTypes
ON PROD.ContactPhone
(
	PhoneType_fk
)

CREATE INDEX idx_NC_PrimaryNumbers
ON PROD.ContactPhone
(
	Primary_fg
)

GO

-- Create indices on company products
CREATE INDEX idx_NC_Product
ON PROD.Products
(
	Product_tx,
	Description_tx
)

CREATE INDEX idx_NC_Price
ON PROD.Products
(
	Price_amt
)

CREATE INDEX idx_NC_ActiveProducts
ON PROD.Products
(
	Offered_fg
)

GO

-- Create indices on Customer Orders
CREATE INDEX idx_NC_ProductsOrdered
ON PROD.Orders
(
	Product_fk
)

CREATE INDEX idx_NC_Income
ON PROD.Orders
(
	Price_amt,
	Quantity_nb
)

CREATE INDEX idx_NC_OrderTimeframe
ON PROD.Orders
(
	Create_dt
)

GO


