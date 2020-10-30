/***************************************************************************
Title: info330
Section: C
Desc: This file is for info330 assignment1 database script
Dev: LLu
Change Log: 4/2/20, LLu, created Assignment01DB_LLu
****************************************************************************/
-- Change the branch to master to create database Assignment01DB_LLu
Use master;
go
If Exists (Select Name From SysDatabases Where Name = 'Assignment01DB_LLu')
	Drop Database Assignment01DB_LLu;
go
Create Database Assignment01DB_LLu;
go
-- change the branch to Assignment01DB_LLu
Use Assignment01DB_LLu;
gO
-- create projects table which includes project's name and description
Create Table Projects	(
	ProjectId int Primary Key,
	ProjectName varchar(50) ,
	ProjectDescription varchar(50), 
);
-- create employees table which includes employee's first name and last name
Create Table Employees	(
	EmployeeId int Primary Key,
	FirstName varchar(50) ,
	LastName varchar(50)
);
-- create the bridge table connects the employees and projects table 
Create Table ProjectDetails	(
	ProjectDetailId int Primary Key,
	ProjectId int,
	EmployeeId int,
	ProjectDetailDate DATETIME, 
    ProjectDetailHours DECIMAL(2, 2),
);
