Use master
Create Database [MyLabsDB_LLu];
go
Use [MyLabsDB_LLu];
go
-- Question 1: How can you create a view to show a list of customers names and their locations.
-- Use the IsNull() function to display null region names as the name of the customer's country? 
-- Call the view vCustomersByLocation.


Select * From Northwind.dbo.Customers;
go

Create Or Alter View vCustomersByLocation
As 
Select c.CompanyName as CustomerName, c.Address, c.City, IsNull(c.region, c.country) as Region, c.Country
From Northwind.dbo.Customers as c
go

Select * From vCustomersByLocation Order By CustomerName;

-- Question 2: How can you create a view to show a list of customer names, 
-- their locations, and the number of orders they have placed (hint: use the count() function)? 
-- Call the view vNumberOfCustomerOrdersByLocation.
Select * From Northwind.dbo.Customers;
go 
Select [CustomerName] = CompanyName, Address, City, Region, PostalCode, Country
From Northwind.dbo.Customers;
go 
Select [CustomerName] = CompanyName, Address, City, Region, PostalCode, Country
From Northwind.dbo.Customers
Select * From Northwind.dbo.Orders;
go
Select [CustomerName] = c.CompanyName, c.Address, c.City, c.Region, c.PostalCode, c.Country, COUNT(o.OrderID) as [Total Orders]
From Northwind.dbo.Customers as c Inner Join Northwind.dbo.Orders as o
On c.CustomerID = o.CustomerID
Group By c.CompanyName, c.Address, c.City, c.Region, c.PostalCode, c.Country
go 
Select [CustomerName] = CompanyName, Address, City, Region, PostalCode, Country
From Northwind.dbo.Customers
Select * From Northwind.dbo.Orders;
go
Create Or Alter View vNumberOfCustomerOrdersByLocation
As 
Select [CustomerName] = c.CompanyName, 
c.Address, 
c.City, 
[Region] = IsNull(c.Region, c.country), 
c.PostalCode,
c.Country,
COUNT(o.OrderID) as [Total Orders]
From Northwind.dbo.Customers as c Inner Join Northwind.dbo.Orders as o
On c.CustomerID = o.CustomerID
Group By c.CompanyName, c.Address, c.City, c.Region, c.PostalCode, c.Country
go 

Select * From vNumberOfCustomerOrdersByLocation Order By CustomerName;
go
-- Question 3: How can you create a view to shows a list of customer names, their locations, 
-- and the number of orders they have placed (hint: use the count() function)
-- on a given year (hint: use the year() function)? Call the view vNumberOfCustomerOrdersByLocationAndYears.
Select [Order Year] = Year(OrderDate)
From Northwind.dbo.Orders;
go 

Create Or Alter View vNumberOfCustomerOrdersByLocationAndYears
As 
Select [CustomerName] = c.CompanyName, 
c.Address, 
c.City, 
[Region] = IsNull(c.Region, c.country), 
c.PostalCode,
c.Country,
COUNT(o.OrderID) as [Total Orders],
Year(o.OrderDate) as [OrderYear]
From Northwind.dbo.Customers as c Inner Join Northwind.dbo.Orders as o
On c.CustomerID = o.CustomerID
Group By c.CompanyName, c.Address, c.City, c.Region, c.PostalCode, c.Country, Year(o.OrderDate)
go




Select * From vNumberOfCustomerOrdersByLocationAndYears Order By CustomerName, OrderYear;

