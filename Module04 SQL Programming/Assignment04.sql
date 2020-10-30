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

-- Test with this statement --
Select * from vCustomerContacts;

-- Data Request: 0302
-- Request: I want a list of customer companies and their contact people, but only the ones in US and Canada

-- Test with this statement --
Select * from vUSAandCanadaCustomerContacts;
  
-- Data Request: 0303
-- Request: I want a list of products, their standard price and their categories. 
-- Order the results by Category Name and then Product Name, in alphabetical order.

-- Test with this statement --
Select * from vProductPricesByCategories;

-- Data Request: 0304
-- Request: I want a list of products, their standard price and their categories. 
-- Order the results by Category Name and then Product Name, in alphabetical order but only for the seafood category

-- Test with this statement --
Select * from dbo.fProductPricesByCategories('seafood');

-- Data Request: 0305
-- Request: I want a list of how many orders our customers have placed each year

-- Test with this statement --
Select * from vCustomerOrderCounts

-- Data Request: 0306
-- Request: I want a list of total order dollars our customers have placed each year

-- Test with this statement --
Select * from vCustomerOrderDollars;

