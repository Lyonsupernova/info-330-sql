--*************************************************************************--
-- Title: Assignment04
-- Author: LLu
-- Desc: This file demonstrates how to create SQL views that answers several requests 
-- Change Log:
--              2020-04-23,LLu,Created File
--**************************************************************************--
Use Master;
go

If Exists(Select Name from SysDatabases Where Name = 'Assignment04DB_LLu')
 Begin 
  Alter Database [Assignment04DB_LLu] set Single_user With Rollback Immediate;
  Drop Database Assignment04DB_LLu;
 End
go

Create Database Assignment04DB_LLu;
go

Use Assignment04DB_LLu;
go

-- Add Your Code Below ---------------------------------------------------------------------

-- Data Request: 0301
-- Request: I want a list of customer companies and their contact people

Select * From Northwind.dbo.Customers; -- see the data in tables.
go 

Select CompanyName, ContactName -- choose the columns 
From Northwind.dbo.Customers;
go

Create Or Alter View vCustomerContacts -- create the view
As 
    Select CompanyName,
           ContactName
    From Northwind.dbo.Customers;
go

-- Test with this statement --
Select * from vCustomerContacts;
go 

-- Data Request: 0302
-- Request: I want a list of customer companies and their contact people, but only the ones in US and Canada

Select * From Northwind.dbo.Customers; -- see the data in the tables
go

Select CompanyName, ContactName -- choose the columns 
From Northwind.dbo.Customers; 
go

Select CompanyName, ContactName, Country -- filter the data
From Northwind.dbo.Customers
Where [Country] = 'USA' or [Country] = 'Canada'
Order By Country, CompanyName; -- to order by 
go

Create Or Alter View vUSAandCanadaCustomerContacts -- create the view
As
    Select Top 10000000
           CompanyName,
           ContactName,
           Country
    From Northwind.dbo.Customers
    Where [Country] = 'USA' or [Country] = 'Canada'
    Order By Country, CompanyName; 
go

-- Test with this statement --
Select * from vUSAandCanadaCustomerContacts;
go
-- Data Request: 0303
-- Request: I want a list of products, their standard price and their categories. 
-- Order the results by Category Name and then Product Name, in alphabetical order.

Select * From Northwind.dbo.Products; -- see the data in database
go

Select * From Northwind.dbo.Categories; -- see the data in database
go


Select p.ProductName, p.UnitPrice, c.CategoryName -- choose and join the columns 
From Northwind.dbo.Products as p Inner Join Northwind.dbo.Categories as c
On p.CategoryID = c.CategoryID
go

Select p.ProductName, [StandardPrice] = Format(p.UnitPrice, 'c'), c.CategoryName -- format unitprice
From Northwind.dbo.Products as p Inner Join Northwind.dbo.Categories as c
On p.CategoryID = c.CategoryID
Order By c.CategoryName, p.ProductName; -- order the columns alphabetically
go

Create Or Alter View vProductPricesByCategories -- create view
As 
    Select Top 10000000
           c.CategoryName,
           p.ProductName,
           [StandardPrice] = Format(p.UnitPrice, 'c')
    From Northwind.dbo.Products as p Inner Join Northwind.dbo.Categories as c
    On p.CategoryID = c.CategoryID
    Order By c.CategoryName, p.ProductName; 
go
-- Test with this statement --
Select * from vProductPricesByCategories;

-- Data Request: 0304
-- Request: I want a list of products, their standard price and their categories. 
-- Order the results by Category Name and then Product Name, 
-- in alphabetical order but only for the seafood category

Select * From Northwind.dbo.Products; -- see the data in database
go 

Select * From Northwind.dbo.Categories; -- see the data in database
go 

Select c.CategoryName, p.ProductName, [StandardPrice] = Format(UnitPrice, 'c') -- format 
From Northwind.dbo.Products as p Join Northwind.dbo.Categories as c
On p.CategoryID = c.CategoryID; -- join two tables
go

Select c.CategoryName, p.ProductName, [StandardPrice] = Format(UnitPrice, 'c')
From Northwind.dbo.Products as p Join Northwind.dbo.Categories as c
On p.CategoryID = c.CategoryID
Order By c.CategoryName, p.ProductName;
go

Create Or Alter Function dbo.fProductPricesByCategories(@CategoryName nvarchar(100))
    Returns Table  -- create the function
        As 
            Return(
                Select Top 10000000 
                        c.CategoryName,
                        p.ProductName,
                        [StandardPrice] = Format(UnitPrice, 'c') 
                From Northwind.dbo.Products as p Join Northwind.dbo.Categories as c
                On p.CategoryID = c.CategoryID
                Where c.CategoryName = @CategoryName
                Order By c.CategoryName, p.ProductName 
            );
go
-- Test with this statement --
Select * from dbo.fProductPricesByCategories('seafood');

-- Data Request: 0305
-- Request: I want a list of how many orders our customers have placed each year

Select * From Northwind.dbo.Customers; -- see the data in database
go 

Select * From Northwind.dbo.Orders; -- see the data in database
go 

Select c.CompanyName, o.OrderID, o.OrderDate -- join and select the columns
From Northwind.dbo.Customers as c Join Northwind.dbo.Orders as o
On c.CustomerID = o.CustomerID

Select c.CompanyName, [NumberOfOrders] = Count(OrderID), [Order Year] = Year(o.OrderDate) 
From Northwind.dbo.Customers as c Join Northwind.dbo.Orders as o -- count the orders
On c.CustomerID = o.CustomerID -- use group by 
Group By c.CompanyName, Year(o.OrderDate)
go

Select c.CompanyName, [NumberOfOrders] = Count(OrderID), [Order Year] = Year(o.OrderDate) 
From Northwind.dbo.Customers as c Join Northwind.dbo.Orders as o 
On c.CustomerID = o.CustomerID
Group By c.CompanyName, Year(o.OrderDate)
Order By c.CompanyName 
go

Create Or Alter View vCustomerOrderCounts -- create the view
As 
    Select Top 10000000 
            c.CompanyName, [NumberOfOrders] = Count(OrderID), [Order Year] = Year(o.OrderDate) 
    From Northwind.dbo.Customers as c Join Northwind.dbo.Orders as o 
    On c.CustomerID = o.CustomerID
    Group By c.CompanyName, Year(o.OrderDate)
    Order By c.CompanyName
go
-- Test with this statement --
Select * from vCustomerOrderCounts

-- Data Request: 0306
-- Request: I want a list of total order dollars our customers have placed each year

Select * From Northwind.dbo.Customers; -- see the data in database
go 

Select * From Northwind.dbo.Orders; -- see the data in database
go 

Select * From Northwind.dbo.[Order Details]; -- see the data in database
go 

Select c.CompanyName, o.OrderDate -- join and select the columns
From Northwind.dbo.Customers as c Join Northwind.dbo.Orders as o
On c.CustomerID = o.CustomerID
Join Northwind.dbo.[Order Details] as od
On o.OrderID = od.OrderID

Select c.CompanyName, [TotalDollars] = Sum(od.UnitPrice * od.Quantity) , [Order Year] = Year(o.OrderDate) 
From Northwind.dbo.Customers as c Join Northwind.dbo.Orders as o 
On c.CustomerID = o.CustomerID -- use group by 
Join Northwind.dbo.[Order Details] as od
On o.OrderID = od.OrderID
Group By c.CompanyName, Year(o.OrderDate)
go

Select c.CompanyName, [TotalDollars] = Format(Sum(od.UnitPrice * od.Quantity), 'c') , [Order Year] = Year(o.OrderDate) 
From Northwind.dbo.Customers as c Join Northwind.dbo.Orders as o  -- add with format currency 
On c.CustomerID = o.CustomerID 
Join Northwind.dbo.[Order Details] as od
On o.OrderID = od.OrderID
Group By c.CompanyName, Year(o.OrderDate)
Order By c.CompanyName  -- order by 
go 

Create Or Alter View vCustomerOrderDollars -- create view
As
    Select Top 10000000
            c.CompanyName,
            [TotalDollars] = Format(Sum(od.UnitPrice * od.Quantity), 'c'),
            [Order Year] = Year(o.OrderDate) 
    From Northwind.dbo.Customers as c Join Northwind.dbo.Orders as o 
    On c.CustomerID = o.CustomerID 
    Join Northwind.dbo.[Order Details] as od
    On o.OrderID = od.OrderID
    Group By c.CompanyName, Year(o.OrderDate)
    Order By c.CompanyName
go

-- Test with this statement --
Select * from vCustomerOrderDollars;

