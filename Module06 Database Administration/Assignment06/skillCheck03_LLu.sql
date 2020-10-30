--*************************************************************************
-- Title: SkillCheck03
-- Author: LLu
-- Desc: This file demonstrates how to create a database
-- Change Log: When,Who,What
-- 2020-01-01,LLu,Created File
--**************************************************************************
-- Create a database based on this design: (Developers) 1 ---- N (Projects)
-- All table need at least an ID and Name columns, but may have others too.
If Exists(Select Name From SysDatabases Where Name = 'SkillCheck03_LLu')
	  Drop Database Assignment06DB_LLu;
go
Create Database SkillCheck03_LLu;
go 
Use SkillCheck03_LLu;

Create Table Developers(
    DeveloperID int Constraint pkDeveloperID Primary Key Identity,
    DeveloperFirstName NVARCHAR(100), 
    DeveloperLastName NVARCHAR(100)
)
go
Create Table Projects(
    ProjectID int Constraint pkProjectID Primary Key Identity,
    ProjectName NVARCHAR(100) Constraint uqProjectName Unique(ProjectName),
    DeveloperID int Constraint fkDeveloperID Foreign Key(DeveloperID) References Developers(DeveloperID)
)
go

Create Or Alter View vDeveloper
    As Select DeveloperID ,
              DeveloperFirstName, 
              DeveloperLastName
From Developers
go 

Create Or Alter View vProjects
    As Select  ProjectID,
               ProjectName,
               DeveloperID
From Projects
go
-- Stored Procedures (10 mins)--

Create Or Alter Procedure pInsDevelopers(
    @DeveloperFirstName NVARCHAR(100), 
    @DeveloperLastName NVARCHAR(100)
)
/* Author: Lyons Lu
** Desc: Processes insert into students
** Change Log: 
** 2020-05-05, Lyons Lu, Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	    Insert Into Developers(DeveloperFirstName, DeveloperLastName)
		Values (@DeveloperFirstName, @DeveloperLastName)
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- Permissions (5 mins) --
Deny Select, Update, Insert, Delete On Projects to Public;
Grant Select on vProjects to Public;
Grant Exec on pInsDevelopers to Public;