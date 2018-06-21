# SQL Server Setup
This is a series of scripts I wrote up to set up a generic company database.
The following things will be done in order to set up this new "BrentRockwell" database:

#01. Create a schema for temporary objects. Nothing is worse than a database where you can't tell which objects are supposed to be there and which were created by an analyst and then forgotten about.

#02. Create a process for cleaning the temp schema. One of the major drawbacks to any sandbox is that people leave their toys in it. We will perform the following tasks in order to ensure that this temporary schema environment stays as clean as possible:
a. Create a table for persisting objects.
b. Add in some safeguards to ensure that people don't try to circumnavigate the spirit of this schema.
c. Create a stored procedure which drops objects not in the table, or who have moved past their expiration date.

#03. Create a production schema. Avoiding overuse of the dbo schema helps bolster security by a small margin, and also helps refocus definitions and increases clarity in regards to schema use.

#04. Create a new production tables for storing customer data:
a. Customer information
b. Contact information Type
c. Contact information
d. Products
e. Customer orders
f. Logging

#05. Create some views on customer information.

#06. Run some reports and generate some data on our new data.

#07. Create some jobs to ensure that reports we need regularly are automated.
