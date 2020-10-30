-- Create Database MyLabsDB_LLu; -- As Needed
go
Use MyLabsDB_LLu; 
go
CREATE -- Drop
TABLE [dbo].[DimProducts](
	[ProductKey] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[ProductID] [int] NOT NULL,
	[ProductName] [nvarchar](100) NOT NULL,
	[ProductCategoryName] [nvarchar](100) NOT NULL,
	[ProductStdPriceUSD] [nvarchar](100) NOT NULL,
	[ProductIsDiscontinued] [nchar](1) NOT NULL -- ('y or n')
)

Declare @BitTest bit = 1, @DecimalTest money = $1.99;
Select iif(@BitTest = 1, 'y', 'n'); -- Convert Bit to Character
Select Format(@DecimalTest, 'C', 'en-us'); -- Convert Character with $




Delete From DimProducts; -- Clear table of current data
go


Select 
 ProductID = ProductId
,ProductName = Cast(ProductName as nvarchar(100)) -- Convert to nVarchar(100)
,ProductCategoryName = Cast(CategoryName as nvarchar(100))-- Convert to nVarchar(100)
,ProductStdPrice = Format(UnitPrice, 'c', 'en-us')-- Convert to nVarchar(100) with $
,ProductIsDiscontinued = iif(Discontinued, 'y', 'n') -- Convert to character ('y' or 'n')
From Northwind.dbo.Products as p Join Northwind.dbo.Categories as c
 On p.CategoryID = c.CategoryID

go
Create Or Alter Procedure pETLDimTitles
/* Author: RRoot
** Desc: Processes Flush and Fill ETL on DimTitles
** Change Log: When,Who,What
** 2017-01-01,RRoot,Created Sproc.
*/

AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --

     -- Step 1: Clear the Old Data
      Delete From DimProducts;

     -- Step 2: Load Current Data
    Insert Into DimProducts 
    (ProductID,ProductName, ProductCategoryName, ProductStdPriceUSD, ProductIsDiscontinued)
    Select 
        ProductID = p.ProductId,
        ProductName = Cast(p.ProductName as nvarchar(100)), -- Convert to nVarchar(100)
        ProductCategoryName = Cast(c.CategoryName as nvarchar(100)),-- Convert to nVarchar(100)
        ProductStdPriceUSD = Format(p.UnitPrice, 'c', 'en-us'),-- Convert to nVarchar(100) with $
        ProductIsDiscontinued = iif(Discontinued = 0, 'y', 'n') -- Convert to character ('y' or 'n')
    From Northwind.dbo.Products as p Join Northwind.dbo.Categories as c
    On p.CategoryID = c.CategoryID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
Exec pETLDimTitles;
go
Select * From [DimProducts];
