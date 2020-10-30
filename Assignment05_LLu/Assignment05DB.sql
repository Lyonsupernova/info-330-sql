--*************************************************************************--
-- Title: Assignment05
-- Author: LLu
-- Desc: This file demonstrates how to create stored procedure and tests
-- Change Log: 
-- 2020-04-29,LLu, Created File
--**************************************************************************--
-- Step 1: Create the assignment database
Use Master;
go

If Exists(Select Name from SysDatabases Where Name = 'Assignment05DB_LLu')
 Begin 
  Alter Database [Assignment05DB_LLu] set Single_user With Rollback Immediate;
  Drop Database Assignment05DB_LLu;
 End
go

Create Database Assignment05DB_LLu;
go

Use Assignment05DB_LLu;
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


-- Show the Current data in the Categories, Products, and Inventories Tables
Select * from Categories;
go
Select * from Products;
go
Select * from Inventories;
go

-- Step 2: Add some starter data to the database

/* Add the following data to this database using inserts:
Category	Product	Price	Date		Count
Beverages	Chai	18.00	2017-01-01	61
Beverages	Chang	19.00	2017-01-01	17

Beverages	Chai	18.00	2017-02-01	13
Beverages	Chang	19.00	2017-02-01	12

Beverages	Chai	18.00	2017-03-02	18
Beverages	Chang	19.00	2017-03-02	12
*/

Begin Transaction
Insert Into Categories(CategoryName) Values('Beverages');
Commit Transaction
go

Begin Transaction
Insert Into Products(ProductName, CategoryID, UnitPrice) Values('Chai', 1, 18.00);
Insert Into Products(ProductName, CategoryID, UnitPrice) Values('Chang', 1, 19.00);
Commit Transaction

Begin Transaction
Insert Into Inventories(InventoryDate, ProductID, Count) Values('2017-01-01', 1, 61);
Insert Into Inventories(InventoryDate, ProductID, Count) Values('2017-01-01', 2, 17);
Insert Into Inventories(InventoryDate, ProductID, Count) Values('2017-02-01', 1, 13);
Insert Into Inventories(InventoryDate, ProductID, Count) Values('2017-02-01', 2, 12);
Insert Into Inventories(InventoryDate, ProductID, Count) Values('2017-03-02', 1, 18);
Insert Into Inventories(InventoryDate, ProductID, Count) Values('2017-03-02', 2, 12);
Commit Transaction
go

-- Step 3: Create transactional stored procedures for each table using the proviced template:

-- Category Tables: 

-- Insert: 

Create Or Alter Procedure pInsCategories
(@CategoryName nvarchar(100))
/* Author: LLu
** Desc: Processes insert for Categories table
** Change Log: 
** 2020-04-29, LLu, Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
      Insert Into Categories(CategoryName) Values(@CategoryName);
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go

-- Update 

Create Or Alter Procedure pUpdCategories
(@CategoryID int, @CategoryName nvarchar(100))
/* Author: LLu
** Desc: Processes update for Categories table
** Change Log: 
** 2020-04-29, LLu, Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
      Update Categories
      Set CategoryName = @CategoryName
      Where CategoryID = @CategoryID;
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go

-- Delete

Create Or Alter Procedure pDelCategories
(@CategoryID int)
/* Author: LLu
** Desc: Processes delete for Categories table
** Change Log: 
** 2020-04-29, LLu, Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
      Delete Categories
      Where CategoryID = @CategoryID;
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go

-- Products Tables: 

-- Insert: 

Create Or Alter Procedure pInsProducts
(@ProductName nvarchar(100), @CategoryID int, @UnitPrice money)
/* Author: LLu
** Desc: Processes insert for Products table
** Change Log: 
** 2020-04-29, LLu, Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
      Insert Into Products(ProductName, CategoryID, UnitPrice) Values(@ProductName, @CategoryID, @UnitPrice);
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go

-- Update 

Create Or Alter Procedure pUpdProducts
(@ProductID int, @ProductName nvarchar(100), @CategoryID int, @UnitPrice money)
/* Author: LLu
** Desc: Processes update for Products table
** Change Log: 
** 2020-04-29, LLu, Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
      Update Products
      Set ProductName = @ProductName, CategoryID = @CategoryID, UnitPrice = @UnitPrice
      Where ProductID = @ProductID
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go

-- Delete

Create Or Alter Procedure pDelProducts
(@ProductID int)
/* Author: LLu
** Desc: Processes delete for Products table
** Change Log: 
** 2020-04-29, LLu, Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
      Delete Products
      Where ProductID = @ProductID
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go

-- Inventories Tables: 

-- Insert:

Create Or Alter Procedure pInsInventories
(@InventoryDate date, @ProductID int, @Count int)
/* Author: LLu
** Desc: Processes insert for Inventories table
** Change Log: 
** 2020-04-29, LLu, Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
      Insert Into Inventories(InventoryDate, ProductID, Count) Values(@InventoryDate, @ProductID, @Count)
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go

-- Update 

Create Or Alter Procedure pUpdInventories
(@InventoryID int, @InventoryDate date, @ProductID int, @Count int)
/* Author: LLu
** Desc: Processes update for Inventories table
** Change Log: 
** 2020-04-29, LLu, Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
      Update Inventories
      Set InventoryDate = @InventoryDate, ProductID = @ProductID, [Count] = @Count
      Where InventoryID = @InventoryID
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go

-- Delete

Create Or Alter Procedure pDelInventories
(@InventoryID int)
/* Author: LLu
** Desc: Processes delete for Inventories table
** Change Log: 
** 2020-04-29, LLu, Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
      Delete Inventories
      Where InventoryID = @InventoryID
   Set @RC = +1;
   Commit Transaction;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go

-- Step 4: Create code to test each transactional stored procedure. 

-- Categories Table
-- insert
-- Testing Code: 

 Declare @Status int;
 Exec @Status = pInsCategories
 @CategoryName = 'Condiments'
 Select [The Return Case was] = @Status;

Select Case @Status
When +1 Then 'Insert Was successful!'
When -1 Then 'Insert failed! Common Issues: Duplicate data'
End as [Status]

Select [The New ID was] = @@Identity

Select * From Categories
go 

-- Update
-- Testing Code:

Declare @Status int;
Declare @NewID int = Ident_Current('Categories')
Exec @Status = pUpdCategories
@CategoryID = @NewID,
@CategoryName = 'Dairy Products'
Select [The Return Case was] = @Status;

Select Case @Status
When +1 Then 'Update Was successful!'
When -1 Then 'Update failed! Common Issues: Check Values'
End as [Status]
Select * From Categories
go

-- Delete
-- Testing Code:

Declare @Status int;
Declare @NewID int = Ident_Current('Categories')
Exec @Status = pDelCategories
@CategoryID = @NewID
Select [The Return Case was] = @Status;

Select Case @Status
When +1 Then 'Delete Was successful!'
When -1 Then 'Delete failed! Common Issues: Foreign Key Exists'
End as [Status]
Select * From Categories
go
-- Products Table
-- insert
-- Testing Code: 

Declare @Status int;
Exec @Status = pInsProducts
@ProductName = 'Steeleye Stout', 
@CategoryID = 1, 
@UnitPrice = 18.0000
Select [The Return Case was] = @Status;

Select Case @Status
When +1 Then 'Insert Was successful!'
When -1 Then 'Insert failed! Common Issues: Duplicate data'
End as [Status]

Select [The New ID was] = @@Identity

Select * From Products
go 

-- Update
-- Testing Code:

Declare @Status int;
Declare @NewID int = Ident_Current('Products')
Exec @Status = pUpdProducts
@ProductID = @NewID,
@ProductName = 'Guaraná Fantástica', 
@CategoryID = 1, 
@UnitPrice = 4.5
Select [The Return Case was] = @Status;

Select Case @Status
When +1 Then 'Update Was successful!'
When -1 Then 'Update failed! Common Issues: Check Values'
End as [Status]
Select * From Products
go

-- Delete
-- Testing Code:

Declare @Status int;
Declare @NewID int = Ident_Current('Products')
Exec @Status = pDelProducts
@ProductID = @NewID
Select [The Return Case was] = @Status;

Select Case @Status
When +1 Then 'Delete Was successful!'
When -1 Then 'Delete failed! Common Issues: Foreign Key Exists'
End as [Status]
Select * From Products
go

-- Inventories Table
-- insert
-- Testing Code: 

Declare @Status int;
Exec @Status = pInsInventories
@InventoryDate = '2020-04-29',
@ProductID = 1,
@Count = 124
Select [The Return Case was] = @Status;

Select Case @Status
When +1 Then 'Insert Was successful!'
When -1 Then 'Insert failed! Common Issues: Duplicate data'
End as [Status]

Select [The New ID was] = @@Identity

Select * From Inventories
go 

-- Update
-- Testing Code:

Declare @Status int;
Declare @NewID int = Ident_Current('Inventories')
Exec @Status = pUpdInventories
@InventoryID = @NewID,
@InventoryDate = '2020-05-01',
@ProductID = 1,
@Count = 624
Select [The Return Case was] = @Status;

Select Case @Status
When +1 Then 'Update Was successful!'
When -1 Then 'Update failed! Common Issues: Check Values'
End as [Status]
Select * From Inventories
go

-- Delete
-- Testing Code:

Declare @Status int;
Declare @NewID int = Ident_Current('Inventories')

Exec @Status = pDelInventories
@InventoryID = @NewID
Select [The Return Case was] = @Status;

Select Case @Status
When +1 Then 'Delete Was successful!'
When -1 Then 'Delete failed! Common Issues: Foreign Key Exists'
End as [Status]
Select * From Inventories
go