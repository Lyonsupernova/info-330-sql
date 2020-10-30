--*************************************************************************--
-- Answer the following questions by writing and executing SQL code.
Use master
Select * From Northwind.Sys.Tables Where type = 'u' Order By Name;


-- Question 1: How can you show a list of category names? Order the result by the category!
Use Northwind
Select CategoryName
From Categories
Order By CategoryName
go
-- Question 2: How can you show a list of product names and the price of each product? 
-- Order the result by the product!
Select ProductName, UnitPrice 
From Products
Order By ProductName
go
-- Question 3: How can you show a list of category and product names,
-- and the price of each product? Order the result by the category and product!
Select CategoryName, ProductName, UnitPrice
From Categories Inner Join Products
On  Categories.CategoryID = Products.CategoryID
Order By CategoryName, ProductName
-- Question 4: How can you show a list of order Ids, category names, product names, and order quantities.
-- Sort the results by the Order Ids, category, product, and quantity!


Select * From [Order Details]
go
Select * From Products

Select ord.OrderID, c.CategoryName, p.ProductName, ord.Quantity
From Products as p Inner Join Categories as c
On  c.CategoryID = p.CategoryID
Inner Join [Order Details] as ord
On p.ProductID = ord.ProductID
Order By ord.OrderID, c.CategoryName, p.ProductName, ord.Quantity

-- Question 5: How can you show a list of order ids, order date, category names, 
-- product names, and order quantities the results by the order id, order date, category, product, and quantity!

Select ord.OrderID, o.OrderDate, c.CategoryName, p.ProductName, ord.Quantity
From Products as p Inner Join Categories as c
On  c.CategoryID = p.CategoryID
Inner Join [Order Details] as ord
On p.ProductID = ord.ProductID
Inner Join [Orders] as o
On o.OrderID = ord.OrderID
Order By ord.OrderID, o.OrderDate, c.CategoryName, p.ProductName, ord.Quantity
--*************************************************************************--