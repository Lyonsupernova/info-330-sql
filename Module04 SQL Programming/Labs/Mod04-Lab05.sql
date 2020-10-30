--*************************************************************************--
-- Title: Mod04-Lab05 Lab Code
-- Author: LLu
-- Desc: This file demonstrates how to create basic sprocs
-- Change Log: When,Who,What
-- 2017-01-01,RRoot,Created File
--**************************************************************************--
--Step 1: Review the Database Table
--Run the following code in a SQL query editor and review the table's data you will work with.
Use [MyLabsDB_LLu];
Select * From Northwind.dbo.[Order Details] Order By ProductID;

--Step 2: Create an Aggregated Result
--Add code to a script to create a select statement
-- that shows only the top 10 ProductIDs and the total sum of sales dollars for each. 
 
Select * From Northwind.dbo.[Order Details]
go
Select ProductID, [Total Sum] = Sum(UnitPrice)
From Northwind.dbo.[Order Details]
Group By ProductID
Order By ProductID
go


--Step 3: Create a KPI Result
--Add code to a script to create a select statement that shows only the top 10 
--ProductIDs and the total sum of sales dollars for each, and a KPI based on a medium sum
-- of sales dollars being between $250 and $500. 
 Select TOP 10 
        ProductID,
        [Total Sum] = Sum(UnitPrice),
        [Unit Price KPI] = Case When Sum(UnitPrice) < 250 Then -1 
                           When Sum(UnitPrice) Between 250 And 500 Then 0
                           When Sum(UnitPrice) > 250 Then 1
                           End 
From Northwind.dbo.[Order Details]
Group By ProductID
Order By ProductID

--Step 4: Review Your Work
--Now, you will review your work with your instructor.
