--*************************************************************************--
-- Title: Module03_Lab05
-- Author: Lyons Lu
-- Desc: This file demonstrates how to process data in a database
-- Change Log: 04/15/20, LLu, Created file
--**************************************************************************--


Select * From Northwind.Sys.Tables Where type = 'u' Order By Name;

-- Step 2: Create a Query
-- Question 1:  Show a list of Product names, and the price of each product, with the price 
-- formatted as US dollars? Order the result by the Product!

Select * From Products;
go 
Select ProductName, Format(UnitPrice, 'C') As 'UnitPrice' From Products
Order By ProductName

-- Question 2: Show a list of the top five Order Ids and Order Dates based on the ordered date.
-- Format the results as a US date with back-slashes.
-- Use a column alias to rename orderdate to Order Date.

Select * From Orders;
go
Select TOP 5 OrderID, Format(OrderDate, 'd', 'en-US') as 'Order Date' From Orders
Order By OrderDate
