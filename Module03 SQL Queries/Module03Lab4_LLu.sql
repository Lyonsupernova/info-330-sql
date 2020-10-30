--*************************************************************************--
-- Title: Module03_Lab04
-- Author: LLu
-- Desc: This file demonstrates how to select data from a database
-- Change Log: When,Who,What
-- 2017-01-01,LLu,Created File
--**************************************************************************--
Use Master;
go

If Exists(Select Name from SysDatabases Where Name = 'MyLabsDB_LLu')
 Begin 
  Alter Database [MyLabsDB_LLu] set Single_user With Rollback Immediate;
  Drop Database MyLabsDB_LLu;
 End
go

Create Database MyLabsDB_LLu;
go

Use MyLabsDB_LLu;
go

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Alter Table Categories 
 Add Constraint pkCategories 
  Primary Key (CategoryId);
go

Alter Table Categories 
 Add Constraint ukCategories 
  Unique (CategoryName);
go

Alter Table Products 
 Add Constraint pkProducts 
  Primary Key (ProductId);
go

Alter Table Products 
 Add Constraint ukProducts 
  Unique (ProductName);
go

Alter Table Products 
 Add Constraint fkProductsToCategories 
  Foreign Key (CategoryId) References Categories(CategoryId);
go

Alter Table Products 
 Add Constraint ckProductUnitPriceZeroOrHigher 
  Check (UnitPrice >= 0);
go

Alter Table Inventories 
 Add Constraint pkInventories 
  Primary Key (InventoryId);
go

Alter Table Inventories
 Add Constraint dfInventoryDate
  Default GetDate() For InventoryDate;
go

Alter Table Inventories
 Add Constraint fkInventoriesToProducts
  Foreign Key (ProductId) References Products(ProductId);
go

Alter Table Inventories 
 Add Constraint ckInventoryCountZeroOrHigher 
  Check ([Count] >= 0);
go

Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Inventories
(InventoryDate, ProductID, [Count])
Select '20170101' as InventoryDate, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
UNION
Select '20170201' as InventoryDate, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
UNION
Select '20170302' as InventoryDate, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Order By 1, 2
go

-- Show all of the data in the Categories, Products, and Inventories Tables
Select * from Categories;
go
Select * from Products;
go
Select * from Inventories;
go
 
-- Question 1: Select the Category Id and Category Name of the Category 'Seafood'.
Select * From Categories;
go
Select CategoryID, CategoryName From Categories;
go
Select CategoryID, CategoryName From Categories Where CategoryName = 'Seafood';
go

-- Question 2:  Select the Product Id, Product Name, and Product Price of all 
-- Products with the Seafood's Category Id. Ordered By the Products Price 
-- highest to the lowest 
Select * From Products;
go 
Select ProductID, ProductName, UnitPrice From Products;
go 
Select ProductID, ProductName, UnitPrice From Products Where CategoryID = 8;
go
Select ProductID, ProductName, UnitPrice
From Products
Where CategoryID = (Select CategoryID From Categories Where CategoryName = 'Seafood')
Order By UnitPrice Desc;
go

-- Question 3:  Select the Product Id, Product Name, and Product Price
-- Ordered By the Products Price highest to the lowest. 
-- Show only the products that have a price greater than $100. 
Select ProductID, ProductName, UnitPrice
From Products
Where UnitPrice > 100
Order By UnitPrice Desc;

-- Question 4:  Select the CATEGORY NAME, product name, and Product Price
-- from both Categories and Products. Order the results by 
-- Category Name and then Product Name, in alphabetical order.
-- (Hint: Join Products to Category)
Select CategoryName, ProductName, UnitPrice
From Categories Join Products
On Categories.CategoryID = Products.CategoryID
Order By CategoryName, ProductName;
go

--  Question 5:  Select the Product Id and Number of Products in 
-- Inventory for the Month of JANUARY. Order the results by the ProductIDs. 
Select * From Inventories;
go 
Select ProductID, Count
From Inventories
Where Month(InventoryDate) = '1'
Order By ProductID

-- Question 6: Select the Category Name, Product Name, and Product Price 
-- from both Categories and Products. Order the results by price highest
-- to lowest. Show only the products that have a PRICE FROM $10 TO $20. 

Select * From Categories
Select * From Products
Select CategoryName, ProductName, UnitPrice
From Categories Join Products
On Categories.CategoryID = Products.CategoryID
Where UnitPrice Between 10 And 20
Order By UnitPrice Desc


-- Question 7: Select the Product Id and Number of Products in Inventory 
-- for the Month of JANUARY. Order the results by the ProductIDs and where
-- the ProductID are only the ones in the seafood category 
-- (Hint: Use a subquery to get the list of productIds with a category ID of 8)
-- (Note: Quantities may vary, since I use a random function to create the data!)
Select * From Inventories;
go 
Select ProductID, [Count]
From Inventories;
go 
Select ProductID, [Count]
From Inventories
Where Month(InventoryDate) = 1;
go
Select ProductID, [Count]
From Inventories
Where Month(InventoryDate) = 1 And ProductID in (Select ProductID From Products Where CategoryID = '8')
Order By ProductID;

-- Question 8: Select the PRODUCT NAME and Number of Products in Inventory for the Month of January.
-- Order the results by the Product Names and where the ProductID as only the ones in the seafood category 
-- (Hint: Use a Join between Inventories and Products to get the Name)
Select * From Inventories
go
Select * From Products
go

Select ProductName, [Count]
From Inventories Join Products
On Inventories.ProductID = Products.ProductID
Where Month(InventoryDate) = 1 And Inventories.ProductID in (Select [ProductID] From [Products] Where CategoryID = '8')
Order By ProductName

-- Question 9: Select the Product Name and Number of Products in Inventory for both JANUARY and FEBURARY.
-- Show what the MAXIMUM AMOUNT IN INVENTORY was and where the productID as only the ones in the seafood
-- category and Order the results by the Product Names. 
-- (Hint: If Jan count was 5, but Feb count was 15, show 15) 
-- (Note: Quantities may vary, since I use a random function to create the data!)
Select ProductName, [Count] = Max([Count])
From Products Join Inventories
On Products.ProductID = Inventories.ProductID
Where Month(InventoryDate) in (1,2) And Inventories.ProductID in (Select ProductID From Products Where CategoryID = 8)
Group By ProductName
Order By ProductName

-- Question 10: Select the Product Name and Number of Products in Inventory 
-- for both JANUARY and FEBURARY.
-- Show what the MAX AMOUNT IN INVENTORY was and
-- where the ProductID as only the ones in the seafood category
-- and Order the results by the Product Names. Restrict the results to rows with a MAXIMUM COUNT OF 10 OR
-- HIGHER. (Note: Quantities may vary, since I use a random function to create the data!)
Select ProductName, max([Count]) as MaxAmountInInventory
From Inventories Join Products 
On Inventories.ProductID = Products.ProductID
Where Month(InventoryDate) in (1, 2) And
 Inventories.ProductID in (Select ProductID From Products Where CategoryID = 8) 
Group By ProductName
Having max([Count])  >= 10 
Order By ProductName


-- Select the CATEGORY NAME, Product Name and Number of Products in Inventory 
-- for both JANUARY and FEBURARY. Show what the MAX AMOUNT IN INVENTORY was
--  and where the ProductID as only the ones in the seafood category and Order
--  the results by the Product Names. Restrict the results to rows with
--  a maximum count of 10 or higher
-- (Note: Quantities may vary, since I use a random function to create the data!)
Select * From Inventories
Select * From Products
Select * From Categories

Select CategoryName,ProductName, max([Count]) as MaxAmountInInventory
From Inventories Join Products 
On Inventories.ProductID = Products.ProductID
Join Categories 
On Categories.CategoryID = Products.CategoryID
Where Month(InventoryDate) in (1, 2) And
 Inventories.ProductID in (Select ProductID From Products Where CategoryID = 8) 
Group By Category, ProductName
Having max([Count])  >= 10 
Order By ProductName