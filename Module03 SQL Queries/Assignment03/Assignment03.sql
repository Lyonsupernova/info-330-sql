--*************************************************************************--
-- Title: Assignment03
-- Author: LLu
-- Desc: This file demonstrates how to select data from a database
-- Change Log: 04/16/2020, LLu, Created File
--**************************************************************************--


/********************************* Questions and Answers *********************************/
-- Data Request: 0301
-- Date: 1/1/2020
-- From: Jane Encharge CEO
-- Request: I want a list of customer companies and their contact people
-- Needed By: ASAP

Use Northwind -- Use Northwind database
go
Select * From Northwind.Sys.Tables Where type = 'u' Order By Name; -- to check all databases
go
Select * From Customers; -- to choose customers table included with customer companies and contact people
go
Select c.CompanyName, c.ContactName
From Customers as c;  -- to choose columns
go

-- Data Request: 0302
-- Date: 1/2/2020
-- From: Jane Encharge CEO
-- Request: I want a list of customer companies and their contact people, but only the ones in US and Canada
-- Needed By: ASAP

Select * From Customers; -- to choose table
go
Select c.CompanyName, c.ContactName
From Customers as c;  -- to choose columns
go
Select c.CompanyName, c.ContactName
From Customers as c
Where c.Country in ('USA', 'Canada'); -- to filter the country 
go

-- Data Request: 0303
-- Date: 1/2/2020
-- From: Jane Encharge CEO
-- Request: I want a list of products, their standard price and their categories. Order the results by Category Name 
-- and then Product Name, in alphabetical order
-- Needed By: ASAP

Select * From Northwind.Sys.Tables Where type = 'u' Order By Name; -- to check all databases
go
Select * From Products; -- to choose table 
go
Select ProductName, UnitPrice
From Products; -- to choose columns 
go 
Select c.CategoryName, p.ProductName, p.UnitPrice
From Products as p Join Categories as c
On p.CategoryID = c.CategoryID; -- to join
go
Select c.CategoryName, p.ProductName, p.UnitPrice
From Products as p Join Categories as c
On p.CategoryID = c.CategoryID
Order By c.CategoryName, p.ProductName;  -- to order by
go

-- Data Request: 0304
-- Date: 1/3/2020
-- From: Jane Encharge CEO
-- Request: I want a list of how many customers we have in the US
-- Needed By: ASAP

Select * From Customers; -- to choose the table
go
Select Country
From Customers; -- to choose the column
go 
Select Country
From Customers
Where Country = 'USA'; -- to filter the customers from USA
go
Select [Count] = Count(Country)
From Customers
Where Country = 'USA'; -- to count the customers from USA
go
Select [Count] = Count(Country),  Country = 'USA'
From Customers
Where Country = 'USA'; -- to add with the country column 
go

-- Data Request: 0305
-- Date: 1/4/2020
-- From: Jane Encharge CEO
-- Request: I want a list of how many customers we have in the US and Canada, with subtotals for each
-- Needed By: ASAP

Select * From Customers; -- to choose the table
go
Select Country
From Customers; -- to choose the column
go 
Select Country
From Customers
Where Country in ('USA', 'Canada'); -- to filter the country in USA and Canada
go
Select [Count] = Count(Country)
From Customers
Where Country in ('USA', 'Canada')
Group By Country; -- to count th subtotal and to group by
go
Select [Count] = Count(Country), Country
From Customers
Where Country in ('USA', 'Canada')
Group By Country; -- to choose with column

/***************************************************************************************/