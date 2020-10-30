--*************************************************************************--
-- Title: Module03_Lab05
-- Author: LLu
-- Desc: This file demonstrates how to process data in a database
-- Change Log: 04/15/20, Lyons Lu, created file
--**************************************************************************--
Use master 
go
If Exists(Select Name from SysDatabases Where Name = 'SC1LLU')
 Begin 
  Alter Database [SC1LLu] set Single_user With Rollback Immediate;
  Drop Database SC1LLu;
 End
go
Create Database SC1LLu
go
Use SC1LLu
go

-- Skill Check - 1
-- Create a table with the following data about people:
-- (First, Last, Date of birth, Address, City, State, Zip)
-- Bob, Smith, 1/1/2000, 123 Main Street, Seattle, WA, 98001
-- Sue, Jones, 6/6/2000, 543 1st Ave, Seattle, WA, 98001
Create Table People(
    PeopleID int Not Null Constraint pkPeopleID Primary Key Identity,
    PeopleFirstName nvarchar(100) Not Null,
    PeopleLastName nvarchar(100) Not Null,
    PeopleDateBirth Date Not Null,
    PeopleAddress nvarchar(100) Not Null,
    PeopleCity nvarchar(100) Not Null,
    PeopleState nvarchar(2) Not Null,
    PeopleZip int Not Null 
)
Insert Into People(
    PeopleFirstName,
    PeopleLastName,
    PeopleDateBirth,
    PeopleAddress,
    PeopleCity,
    PeopleState,
    PeopleZip
) Values(
    'Bob', 
    'Smith', 
    '1/1/2000', 
    '123 Main Street',
    'Seattle', 
    'WA', 
    98001
)
Insert Into People(
    PeopleFirstName,
    PeopleLastName,
    PeopleDateBirth,
    PeopleAddress,
    PeopleCity,
    PeopleState,
    PeopleZip
) Values(
    'Sue',
    'Jones', 
    '6/6/2000', 
    '543 1st Ave',
    'Seattle', 
    'WA', 
    98001
) 

-- Create a table with the following data about Employees:
-- (PersonID, Title, HireDate, Extension, Email, Current Status)
-- 1, Tech Support, 5/30/2019, 2222, BSmith@MyCo.com, Employed
 Create Table [Employees](
     EmployeeID int Not Null Constraint pkEmployeeID Primary Key Identity,
     PersonID int Not Null Constraint fkEmployeePersonID Foreign Key(EmployeeID) References People(PeopleID),
     EmployeeTitle nvarchar(100),
     EmployeeHireDate Date Not Null Constraint  ckHireDate  Check(EmployeeHireDate < GetDate()),
     EmployeeExtension int Not Null, 
     EmployeeEmail nvarchar(100) Not Null Constraint ckEmployeeEmail Check(EmployeeEmail like '%@%%'),
     EmployeeCurrentStatus nvarchar(100) Not Null
 )
go

Alter Table Employees
    Add Constraint dfOrderDate Default GetDate() For EmployeeHireDate
go

-- Create a table with the following data about Customer:
--(PersonID, Email, Phone, Contact Preference)
--2, SueJones@HeyYou.com, 206.555.5556, Email
 Create Table Customer(
     PersonID int Not Null Constraint pkCustomerPersonID Primary Key Identity, 
     CustomerEmail nvarchar(100) Not Null Constraint ckCustomerEmail Check(CustomerEmail like '%@%%'), 
     CustomerPhone int Not Null Constraint ckCustomerPhone Check(CustomerPhone like '([0-9][0-9][0-9])[0-9][0-9][0-9][0-9][0-9][0-9]'), 
     CustomerContactPreference nvarchar Not Null
 )
go
 Alter Table Customer
    Add Constraint fkCustomerPersonID Foreign Key(PersonID) References People(PeopleID)
go


-- Create a view for each table

Create View vPerson 
As Select
PeopleID,
PeopleFirstName,
PeopleLastName,
PeopleDateBirth,
PeopleAddress,
PeopleCity,
PeopleState,
PeopleZip
From People
go 

Create View vEmployee 
As Select
PersonID,
EmployeeTitle,
EmployeeHireDate,
EmployeeExtension,
EmployeeEmail,
EmployeeCurrentStatus
From Employees
go 

Create View vCustomer
As Select
PersonID, 
CustomerEmail, 
CustomerPhone, 
CustomerContactPreference 
From Customer
go


Select * From vPerson as p
Join vEmployee as eon On p.PeopleID = eon.PersonID
Join vCustomer as c On c.PersonID = p.PeopleID


