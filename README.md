# SQL Server Setup:
This is a series of scripts I wrote up to set up a generic company database.
The following things will be done in order to set up this new "BrentRockwell" database:
1. Create schemas for production and temporary objects. Nothing is worse than a database where you can't tell which objects are supposed to be there and which were created by an analyst or developer and then forgotten about.
2. Create tables to store the following information:
   - Customer Information
   - Customer Addresses
   - Customer Phone Numbers
   - Customer Email addresses
   - Company Products
   - Customer Orders
   - ChangeLog
   - Tables for persisting TEMP objects
   - Type Lookup Tables
3. Create indices on the tables for faster joins, filtering, and general querying. This is normally done after initial data is inserted.
4. Add triggers to store changes / deletes and to perform basic data validation.
5. Create some basic functions for stripping data and performing string manipulations.
6. Create a stored procedure for deleting objects from the TEMP schema.
7. Create views for looking into various data points and reviewing orders, etc.
8. Load all the tables with junk data so that analysis and testing can be done.
9. Perform some basic analysis and a pivot.
10. Create a job for cleaning the TEMP schema nightly.
11. Several Selects to review all the garbage data inserted.

### Todo:
These are some action items in order to make some of these scripts better.
1. Change this from a generic company to a gaming company.
