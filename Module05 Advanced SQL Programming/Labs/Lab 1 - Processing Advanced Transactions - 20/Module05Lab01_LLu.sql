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

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * from Categories;
go
Select * from Products;
go
-- Question 1: How would you add data to the Categories table?
Begin Try 
    Begin Tran 
        Insert Into dbo.Categories(CategoryName)
        Values('Hello World')
    Commit Tran
End Try 
Begin Catch
print '**********************Insert Fails***********'
print Error_Message()
Rollback Tran
End Catch 
Select * From Categories
-- Question 2: How would you add data to the Products table?
Begin  Try 
    Begin Tran 
        Insert Into dbo.Products(ProductName, CategoryID, UnitPrice) 
        Values ('notebook', 2, 50)
    Commit Tran 
End Try 
Begin Catch
    print '**********************Insert Fails***********'
    print Error_Message()
    Rollback Tran 
End Catch
Select * From Products
-- Question 3: How would you update data in the Products table?

Update Products
    Set ProductName = 'Muji Notebook'
    Where ProductName = 'Notebook'

Begin Try
    Begin Tran 
        Update Products
        Set ProductName = 'Muji Notebook'
        Where ProductName = 'Notebook'
        if(@@ROWCOUNT > 1) RaisError('Do not change more than one row', 15, 1)
    Commit Tran 
End Try 
Begin Catch
    print '**********************Update Fails***********'
    print Error_Message()
    Rollback 
End Catch 
-- Question 4: How would you delete data from the Categories table?
Delete From Categories
Where CategoryId = 1;


Begin Try
    Begin Tran 
        Delete From Products Where CategoryID = 1;
        Delete From Categories Where CategoryID = 1;
        if(@@ROWCOUNT > 1) RaisError('Do not change more than one row', 15, 1)
    Commit Tran 
End Try 
Begin Catch 
    print Error_Message();
    print '**********************Delete Fails***********'
    Rollback Tran 
End Catch 
