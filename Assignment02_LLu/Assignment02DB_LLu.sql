/***************************************************************************
Title: info330
Section: C
Desc: This file is for info330 assignment2 database script
Change Log: 4/9/20, LLu, created Assignment02DB_LLu
****************************************************************************/
-- Change the branch to master to create database Assignment01DB_LLu
Use master
go
If Exists (Select Name From SysDatabases Where Name = 'Assignment02DB_LLu')
	Drop Database Assignment02DB_LLu;
go
Create Database Assignment02DB_LLu;
go
Use Assignment02DB_LLu;
go 

-- Create Category table
-- Constraint: CategoryID  Primary Key / Default (Identity)
--             CategoryName Unique

Create Table Categories(
    CategoryID int Not Null Constraint pkCategoryID 
                Primary Key(CategoryID) Identity,
    CategoryName nvarchar(100) Not Null Constraint uqCategoryName Unique(CategoryName)
)
go

-- Create SubCategories table
-- Constraint: SubCategoryID  Primary Key / Default (Identity)
--             SubCategoryName Unique
--             CategoryID Foreign Key

Create Table SubCategories(
    SubCategoryID int Not Null Constraint pkSubCategoryID 
                Primary Key(SubCategoryID) Identity,
    SubCategoryName nvarchar(100) Not Null Constraint 
                uqSubCategoryName Unique(SubCategoryName),
    CategoryID int Not Null Constraint fkCategoryID 
                Foreign Key(CategoryID) References Categories(CategoryID)
)
go 

-- Create Products table
-- Constraint: ProductID  Primary Key / Default (Identity)
--             ProductName Unique
--             SubCategory Foreign Key

Create Table Products(
    ProductID int Not Null Constraint pkProductID 
                Primary Key(ProductID) Identity,
    ProductName	nvarchar(100) Not Null Constraint 
                uqProductName Unique(ProductName),
    SubCategoryID int Not Null Constraint fkSubCategoryID 
                Foreign Key(SubCategoryID) References SubCategories(SubCategoryID)
)
go 

--Create Customers Table
-- Constraint: CustomerID Primary Key Default(Identity)

Create Table Customers(
    CustomerID int Not Null Constraint pkCustomerID 
                Primary Key(CustomerID) Identity,
    CustomerFirstName nvarchar(100) Not Null,
    CustomerLastName nvarchar(100) Not Null
)
go 

-- Create Orders table
-- Constraint: OrderID  Primary Key / Default (Identity)
--             OrderDate Check(< now) Default(GetDate)
--             CustomerID Foreign Key
Create Table Orders(
    OrderID int Not Null Constraint pkOrderID 
                Primary Key(OrderID) Identity,
    OrderDate date Not Null Constraint ckOrderDate Check(OrderDate <= GetDate()),
    CustomerID int Not Null Constraint fkCustomerID Foreign Key(CustomerID) 
                References Customers(CustomerID)
)
go 

Alter Table Orders
Add Constraint dfOrderDate Default GetDate() For OrderDate
go

-- Create OrderDetail table
-- Constraint: OrderDetailID  Primary Key / Default (Identity)
--             OrderDetailPrice Check > 0  
--             OrderID  Foreign Key
--             ProductID Foreign Key        
Create Table OrderDetail(
    OrderDetailID int Not Null Constraint pkOrderDetailID 
                Primary Key(OrderDetailID) Identity,
    OrderID int Not Null Constraint fkOrderID Foreign Key(OrderID) 
                References Orders(OrderID),
    ProductID int Not Null Constraint fkProductID Foreign Key(ProductID)
                References Products(ProductID),
    OrderDetailPrice money Not Null Constraint ckOrderDetailPrice
                Check(OrderDetailPrice >= 0),
    OrderDetailQuantity int Not Null Constraint ckOrderDetailQuantity 
                Check(OrderDetailQuantity >= 0)
)
go

-- Create view for the category
Create View vCategory
As Select 
CategoryID, 
CategoryName
From Categories
go

-- Create view for the subcategory
Create View vSubCategories
As Select 
SubCategoryID,
SubCategoryName,
CategoryID
From SubCategories
go

-- Create view for the products
Create View vProducts
As Select 
ProductID,
ProductName,
SubCategoryID
From Products
go

-- Create view for the customers
Create View vCustomers
As Select 
CustomerID,
CustomerName = CustomerFirstName + ' ' + CustomerLastName
From Customers
go

-- Create view for the orders
Create View vOrders
As Select 
OrderID,
OrderDate,
CustomerID
From Orders
go

-- Create view for the orderDetail
Create View vOrderDetail
As Select 
OrderDetailID,
OrderID,
ProductID,
OrderDetailPrice,
OrderDetailQuantity
From OrderDetail
go


