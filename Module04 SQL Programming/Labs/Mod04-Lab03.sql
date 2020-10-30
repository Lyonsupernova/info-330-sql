--*************************************************************************--
-- Title: Module04-Lab03
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
,[UnitPrice] [mOney] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 03) -- 
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

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Order By 1, 2
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From Categories;
go
Select * From Products;
go
Select * From Employees;
go
Select * From Inventories;
go

/********************************* Questions and Answers *********************************/
Print 'NOTES------------------------------------------------------------------------------------ 
-- You can use any name you like for you views, but be descriptive and consistent!
-- Quantities may vary, since I use a random function to create the data!
-- Make sure your code is well formatted!
-- You must use the BASIC views for each table after they are created in Question 1
------------------------------------------------------------------------------------------'

-- Question 1: How can you create BASIC views to show data from each table in the database.
-- 1.	Do not use a *, list out each column!
-- 2.	Create one view per table!
-- 3.	Use SchemaBinding to protect the views from being orphaned!


 Select * From dbo.Categories
 go
 Create Or Alter View vCategories
 With SchemaBinding
 As
 	Select CategoryID, 
	 	   CategoryName
	From dbo.Categories
go
Select * From dbo.Products;
go
Create Or Alter View vProducts
 With SchemaBinding
 As
 	Select ProductID, 
	 	   ProductName,
		   CategoryID,
		   UnitPrice
	From dbo.Products
go
Select * From dbo.Inventories;
go
Create Or Alter View vInventories
With SchemaBinding 
As
	Select InventoryID, 
		   InventoryDate,
		   EmployeeID,
		   ProductID,
		   [Count]
	From dbo.Inventories
go
Select * From [dbo].[Employees]
go
Create Or Alter View vEmployees
With SchemaBinding 
As
	Select EmployeeID, 
		   EmployeeFirstName,
		   EmployeeLastName,
		   ManagerID
	From dbo.Employees
go


-- Question 2: How can you set permissions, so that the public group CANNOT select data from each table,
-- but can select data from each view?


-- Deney select from each table 
Deny Select On [dbo].[Categories] to Public;
go
Deny Select On [dbo].[Products] to Public;
go 
Deny Select On [dbo].[Inventories] to Public;
go 
Deny Select on [dbo].[Employees] to Public;
go 

-- Grant Select for each view 
Grant Select On [dbo].[vCategories] to 	Public;
go
Grant Select On [dbo].[vProducts] to Public;
go 
Grant Select on [dbo].[vInventories] to Public;
go 
Grant Select on [dbo].[vEmployees] to Public;
go 

-- Question 3: How can you create a view to show a list of Category and Product names, 
-- and the price of each product? Order the result by the Category and Product!
Select c.CategoryName, p.ProductName, p.UnitPrice
From [dbo].Products as p Inner Join [dbo].Categories as c
On p.CategoryID = c.CategoryID
Order By c.CategoryName, P.ProductName
go 
Create Or Alter View vProductsByCategories
With SchemaBinding
As
Select Top 1000000000000, c.CategoryName, p.ProductName, p.UnitPrice
From [dbo].Products as p Inner Join [dbo].Categories as c
On p.CategoryID = c.CategoryID
Order By c.CategoryName, P.ProductName
go
-- Question 4: How can you create a view to show a list of Product names and Inventory Counts on each Inventory Date?
-- Order the results by the Product, Date, and Count!
Select p.ProductName, i.[Count], i.InventoryDate
From [dbo].Products as p Inner Join [dbo].Inventories as i
On p.ProductID = i.ProductID
Order By p.ProductName, i.InventoryDate, i.[Count];
go 
Create Or Alter View vInventoriesByProductsByDates
As 
	Select Top 1000000
	p.ProductName, 
	i.[Count],
	i.InventoryDate
From [dbo].Products as p Inner Join [dbo].Inventories as i
On p.ProductID = i.ProductID
Order By p.ProductName, i.InventoryDate, i.[Count];
go 

-- Question 5: How can you create a view to show a list of Inventory Dates and the Employee that took the count?
-- Order the results by the Date and return only one row per date!
Select Distinct i.InventoryDate, e.EmployeeFirstName, e.EmployeeLastName
From [dbo].Inventories as i Inner Join [dbo].Employees as e
On i.EmployeeID = e.EmployeeID
Order By i.InventoryDate
go 
Create Or Alter View [dbo].[vInventoriesByEmployeesByDates]
As Select Distinct Top 100000 
	i.InventoryDate, 
	[EmployeeName] = e.EmployeeFirstName + ' ' + e.EmployeeLastName
From [dbo].Inventories as i Inner Join [dbo].Employees as e
On i.EmployeeID = e.EmployeeID
Order By i.InventoryDate
go 

-- Question 6: How can you create a function to show a list of Inventory Dates and the Employee that took the count?
-- Order the results by the Date and return only one row per date! 
-- Add a parameter to filer by the employee's first and last name.
Select Distinct i.InventoryDate, e.EmployeeFirstName, e.EmployeeLastName
From [dbo].Inventories as i Inner Join [dbo].Employees as e
On i.EmployeeID = e.EmployeeID
Order By i.InventoryDate
go 
Create Or Alter Function dbo.[fInventoriesByDatesPerEmployee](@EmployeeName nvarchar(100))
	Returns Table 
	As
		Return(
		Select Distinct Top 1000000
						i.InventoryDate, 
						[EmployeeName] = e.EmployeeFirstName + ' ' + e.EmployeeLastName
		From [dbo].Inventories as i Inner Join [dbo].Employees as e
		On i.EmployeeID = e.EmployeeID
		Where e.EmployeeFirstName + ' ' + e.EmployeeLastName = @EmployeeName
		Order By i.InventoryDate
		);
go



-- Test your Views and Function (NOTE: You must change the names to match yours as needed!)
Select * From [dbo].[vCategories]
Select * From [dbo].[vProducts]
Select * From [dbo].[vInventories]
Select * From [dbo].[vEmployees]

Select * From [dbo].[vProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByDates]
Select * From [dbo].[vInventoriesByEmployeesByDates]
Select * From [dbo].[fInventoriesByDatesPerEmployee]('Steven Buchanan')

/***************************************************************************************/