--*************************************************************************--
-- Title: Module03_Lab04
-- Author: Lyons Lu
-- Desc: This file demonstrates how to process data in a database
-- Change Log: 04/13/20, LLu, created file
--**************************************************************************--
Use Northwind
Select * From Northwind.Sys.Tables Where type = 'u' Order By Name;
-- add with comments

Select CategoryID From Categories Where CategoryName = 'Seafood';
-- 2-1
Select * From Products
Select ProductId, ProductName, UnitPrice
From Products
Where CategoryID = 8
Order By UnitPrice Desc;

-- 2.2
Select ProductID, ProductName, UnitPrice
From Products
Where UnitPrice > 100
Order By UnitPrice Desc

-- 2.3
Select CategoryName, ProductName, UnitPrice
From Products Join Categories
On Categories.CategoryID = Products.CategoryID
Order By CategoryName, ProductName

-- 2.4
Select CategoryName, ProductName, UnitPrice
From Categories JOIN Products
On Products.CategoryID = Categories.CategoryID
Where UnitPrice Between 10 And 20
Order By UnitPrice Desc


-- 3.1

Select * From Products;
go
Select ProductName From Products;
go
Select * From [Order Details];
go
Select Quantity From [Order Details];
go
Select ProductName, Quantity
From Products
Join [Order Details]
On Products.ProductID = [Order Details].ProductID;
go
Select ProductName, Quantity, Sum
From Products
Join [Order Details]
On Products.ProductID = [Order Details].ProductID
Order By ProductName;
go

SELECT Stor_id, Title_id, SUM(qty) AS 'Quantity'
  FROM Pubs.dbo.Sales
  Where stor_id > 8000
  GROUP BY Stor_id,Title_id
  HAVING sum(Qty) > 10
  ORDER BY Stor_id, Title_id
