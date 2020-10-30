--**********************************************************************************************--
-- Title: Assigment06 
-- Author: LLu
-- Desc: This file demonstrates how to design and create; 
--       tables, constraints, views, stored procedures, and permissions
-- Change Log: 
-- 2020-05-05, LLu, Created File
--***********************************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment06DB_LLu')
	 Begin 
	  Alter Database [Assignment06DB_LLu] set Single_user With Rollback Immediate;
	  Drop Database Assignment06DB_LLu;
	 End
	Create Database Assignment06DB_LLu;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment06DB_LLu;

-- Create Tables (Module 01)-- 

-- Create courses tables
Create Table Courses(
	CourseID Int Not Null Identity,
	CourseName nvarchar(100) Not Null,
	CourseStartDate Date Null,
	CourseEndDate Date Null,
	CourseStartTime Time Null,
	CourseEndTime Time Null,
	CouresWeekDays nvarchar(100) Null,
	CourseCurrentPrice Money Null,
)
go

-- Create students tables
Create Table Students(
	StudentID int Not Null Identity,
	StudentNumber nvarchar(100) Not Null,
	StudentFirstName nvarchar(100) Not Null,
	StudentLastName nvarchar(100) Not Null,
	StudentEmail nvarchar(100) Not Null,
	StudentPhone nvarchar(100) Null,
	StudentAddress1 nvarchar(100) Not Null,
	StudentAddress2 nvarchar(100) Null,
	StudentCity nvarchar(100) Not Null,
	StudentStateCode nvarchar(100) Not Null,
	StudentZipCode nvarchar(100) Not Null,
)
go

-- Create Enrollments tables

Create Table Enrollments(
	EnrollmentID int Not Null Identity,
	StudentID int Not Null,
	CourseID int Not Null,
	EnrollmentDateTime Datetime Not Null,
	EnrollmentPrice Money Not Null
)

-- Add Constraints (Module 02) -- 

-- add constraint for courses tables
-- primary key: courseID
-- unique key: courseName
-- check: courseEndDate
--		  courseEndTime

Alter Table Courses
Add Constraint pkCourseID Primary Key(CourseID),
	Constraint uqCourseName Unique(CourseName),
	Constraint ckCourseEndDate Check(CourseEndDate > CourseStartDate),
	Constraint ckCourseEndTime Check(CourseEndTime > CourseStartTime)
go 

-- add constraint for students tables
-- primary key: studentID
-- unique key: studentNumber
--			   studentEmail
-- check: studentPhone
--		  studentZipCode
Alter Table Students
Add Constraint pkStudentID Primary Key(StudentID),
	Constraint uqStudentNumber Unique(StudentNumber),
	Constraint uqStudentEmail Unique(StudentEmail),
	Constraint ckStudentPhone Check(
	StudentPhone like '([0-9][0-9][0-9])-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
	Constraint ckStudentZipCode Check(StudentZipCode like '[0-9][0-9][0-9][0-9][0-9]')
go 

--  function in the enrollments
-- the class start date function
Create Function dbo.fClassStartDate(@CourseID int)
Returns Datetime
As 
	Begin 
		Return(
			Select CourseStartDate
			From Courses
			Where CourseID = @CourseID
			)
	End
go

-- add constraint for enrollments tables
-- primary key: EnrollmentID
-- foreign key: studentID
--			    courseID
-- default: EnrollmentDateTime
-- check: EnrollmentDateTime
Alter Table Enrollments
Add Constraint pkEnrollmentID Primary Key(EnrollmentID),
	Constraint fkStudentID Foreign Key(StudentID) References Students(StudentID),
	Constraint fkcourseID Foreign Key(CourseID) References Courses(CourseID),
	Constraint dfEnrollmentDateTime Default GetDate() For EnrollmentDateTime,
    Constraint ckEnrollmentDateTime Check(EnrollmentDateTime < dbo.fClassStartDate(CourseID))
go 

-- Add Views (Module 03 and 04) -- 

-- create view for courses
Create or Alter View vCourses
As Select CourseID,
		  CourseName,
 		  Format(CourseStartDate, 'd', 'en-us') as CourseStartDate,
		  Format(CourseEndDate, 'd', 'en-us') as CourseEndDate,
		  CourseStartTime,
		  CourseEndTime,
		  CouresWeekDays,
		  CourseCurrentPrice
From Courses
go 

-- create view for students
Create or Alter View vStudents
As Select StudentID,
		  StudentNumber,
		  StudentFirstName,
		  StudentLastName,
		  StudentEmail,
		  StudentPhone,
		  StudentAddress1,
		  StudentAddress2,
		  StudentCity,
		  StudentStateCode,
		  StudentZipCode
From Students
go 

-- create view for enrollments
Create Or Alter View vEnrollments
As Select EnrollmentID,
		  StudentID,
		  CourseID,
		  Format(Cast(EnrollmentDateTime as date) , 'd', 'en-us') as EnrollmentDateTime,
		  EnrollmentPrice
From Enrollments
go

-- create views for reporting views
Create Or Alter View vCoursesEnrollmentStudents
As SELECT [Course] = c.CourseName,
 		  [Dates] = cast(c.CourseStartDate as nvarchar(100)) + ' to ' + cast(c.CourseEndDate as nvarchar(100)),
		  [Start] = c.CourseStartTime,
		  [End] = c.CourseEndTime,
		  [Days] = c.CouresWeekDays,
		  [Price] = c.CourseCurrentPrice,
		  [Student] = s.StudentFirstName + ' ' + s.StudentLastName,
		  [Number] = s.StudentNumber,
		  [Email] = s.StudentEmail,
		  [Phone] = s.StudentPhone,
		  [Address] = s.StudentAddress2 + ' ' + s.StudentAddress1 + '.' + s.StudentCity + ', ' + s.StudentStateCode + '., ' + s.StudentZipCode,
		  [Signup Date] = e.EnrollmentDateTime,
		  [Paid] = e.EnrollmentPrice
From vCourses as c Join vEnrollments as e
On c.CourseID = e.CourseID
Join vStudents as s
On e.StudentID = s.StudentID
go 

-- Add Stored Procedures (Module 04 and 05) --

-- Courses: 
-- Create stored procedures for insert
Create Or Alter Procedure pInsCourses(
	@CourseName nvarchar(100),
	@CourseStartDate Date,
	@CourseEndDate Date,
	@CourseStartTime Time,
	@CourseEndTime Time,
	@CouresWeekDays nvarchar(100),
	@CourseCurrentPrice Money)
/* Author: Lyons Lu
** Desc: Processes insert into courses 
** Change Log: 
** 2020-05-05, Lyons Lu, Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	    Insert Into Courses(CourseName,
	  					CourseStartDate,
						CourseEndDate,
						CourseStartTime,
						CourseEndTime,
						CouresWeekDays,
						CourseCurrentPrice)
		Values (@CourseName,
	  		    @CourseStartDate,
				@CourseEndDate,
				@CourseStartTime,
				@CourseEndTime,
				@CouresWeekDays,
				@CourseCurrentPrice)
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

-- Create stored procedures for update
Create Or Alter Procedure pUpdCourses(
	@CourseID int,
	@CourseName nvarchar(100),
	@CourseStartDate Date,
	@CourseEndDate Date,
	@CourseStartTime Time,
	@CourseEndTime Time,
	@CouresWeekDays nvarchar(100),
	@CourseCurrentPrice Money)
/* Author: Lyons Lu
** Desc: Processes update into courses 
** Change Log: 
** 2020-05-05, Lyons Lu, Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	    Update Courses
		Set CourseName = @CourseName,
	  		CourseStartDate = @CourseStartDate,
			CourseEndDate =	@CourseEndDate,
			CourseStartTime = @CourseStartTime,
			CourseEndTime =	@CourseEndTime,
			CouresWeekDays = @CouresWeekDays,
			CourseCurrentPrice = @CourseCurrentPrice
		Where CourseID = @CourseID
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

-- Create stored procedures for delete
Create Or Alter Procedure pDelCourses(@CourseID int)
/* Author: Lyons Lu
** Desc: Processes delete 
** Change Log: 
** 2020-05-05, Lyons Lu, Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	    Delete Courses
		Where CourseID = @CourseID
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

-- Students: 
-- Create stored procedures for insert
Create Or Alter Procedure pInsStudents(
	@StudentNumber nvarchar(100),
	@StudentFirstName nvarchar(100),
	@StudentLastName nvarchar(100),
	@StudentEmail nvarchar(100),
	@StudentPhone nvarchar(100),
	@StudentAddress1 nvarchar(100),
	@StudentAddress2 nvarchar(100),
	@StudentCity nvarchar(100),
	@StudentStateCode nvarchar(100),
	@StudentZipCode nvarchar(100))
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
	    Insert Into Students(StudentNumber,
							StudentFirstName,
							StudentLastName,
							StudentEmail,
							StudentPhone,
							StudentAddress1,
							StudentAddress2,
							StudentCity,
							StudentStateCode,
							StudentZipCode)
		Values (@StudentNumber,
				@StudentFirstName,
				@StudentLastName,
				@StudentEmail,
				@StudentPhone,
				@StudentAddress1,
				@StudentAddress2,
				@StudentCity,
				@StudentStateCode,
				@StudentZipCode)
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

-- Create stored procedures for update
Create Or Alter Procedure pUpdStudents(
	@StudentID int,
	@StudentNumber nvarchar(100),
	@StudentFirstName nvarchar(100),
	@StudentLastName nvarchar(100),
	@StudentEmail nvarchar(100),
	@StudentPhone nvarchar(100),
	@StudentAddress1 nvarchar(100),
	@StudentAddress2 nvarchar(100),
	@StudentCity nvarchar(100),
	@StudentStateCode nvarchar(100),
	@StudentZipCode nvarchar(100))
/* Author: Lyons Lu
** Desc: Processes update into students
** Change Log: 
** 2020-05-05, Lyons Lu, Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	    Update Students
		Set StudentNumber = @StudentNumber,
			StudentFirstName = @StudentFirstName,
			StudentLastName = @StudentLastName,
			StudentEmail = @StudentEmail,
			StudentPhone = @StudentPhone,
			StudentAddress1	= @StudentAddress1,
			StudentAddress2 = @StudentAddress2,
			StudentCity = @StudentCity,
			StudentStateCode = @StudentStateCode,
			StudentZipCode = @StudentZipCode
		Where StudentID = @StudentID
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

-- Create stored procedures for delete
Create Or Alter Procedure pDelStudents(@StudentID int)
/* Author: Lyons Lu
** Desc: Processes delete
** Change Log: 
** 2020-05-05, Lyons Lu, Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	    Delete Students
		Where StudentID = @StudentID
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


-- Enrollments: 
-- Create stored procedures for insert
Create Or Alter Procedure pInsEnrollment(
	@StudentID int,
	@CourseID int,
	@EnrollmentDateTime Datetime,
	@EnrollmentPrice Money)
/* Author: Lyons Lu
** Desc: Processes insert into enrollment
** Change Log: 
** 2020-05-05, Lyons Lu, Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	    Insert Into Enrollments(StudentID,
								CourseID,
								EnrollmentDateTime,
								EnrollmentPrice)
		Values (@StudentID,
				@CourseID,
				@EnrollmentDateTime,
				@EnrollmentPrice)
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

-- Create stored procedures for update
Create Or Alter Procedure pUpdEnrollments(
	@EnrollmentID int,
	@StudentID int,
	@CourseID int,
	@EnrollmentDateTime Datetime,
	@EnrollmentPrice Money)
/* Author: Lyons Lu
** Desc: Processes update into enrollments
** Change Log: 
** 2020-05-05, Lyons Lu, Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	    Update Enrollments
		Set StudentID = @StudentID,
			CourseID = @CourseID,
			EnrollmentDateTime = @EnrollmentDateTime,
			EnrollmentPrice = @EnrollmentPrice 
		Where EnrollmentID = @EnrollmentID
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

-- Create stored procedures for delete
Create Or Alter Procedure pDelEnrollment(@EnrollmentID int)
/* Author: Lyons Lu
** Desc: Processes delete
** Change Log: 
** 2020-05-05, Lyons Lu, Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	    Delete Enrollments
		Where EnrollmentID = @EnrollmentID
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

-- Set Permissions (Module 06) --
Deny Select, Update, Insert, Delete On Courses to Public;
Deny Select, Update, Insert, Delete On Students to Public;
Deny Select, Update, Insert, Delete On Enrollments to Public;
Grant Select on vCourses to Public;
Grant Select on vStudents to Public;
Grant Select on vEnrollments to Public;
Grant Select on vCoursesEnrollmentStudents to Public
Grant Exec on pInsCourses to Public;
Grant Exec on pInsEnrollment to Public;
Grant Exec on pInsStudents to Public;
Grant Exec on pUpdCourses to Public;
Grant Exec on pUpdEnrollments to Public;
Grant Exec on pUpdStudents to Public;
Grant Exec on pDelCourses to Public;
Grant Exec on pDelEnrollment to Public;
Grant Exec on pDelStudents to Public;

--< Test Views and Sprocs >-- 

-- Courses Table
-- insert
-- Testing Code: 

 Declare @Status int;
 Exec @Status = pInsCourses
@CourseName = 'Info330',
@CourseStartDate = '2020/03/30',
@CourseEndDate = '2020/06/26',
@CourseStartTime = '3:30',
@CourseEndTime = '5:50',
@CouresWeekDays = null,
@CourseCurrentPrice = null
 Select [The Return Case was] = @Status;
Select Case @Status
When +1 Then 'Insert Was successful!'
When -1 Then 'Insert failed! Common Issues: Duplicate data'
End as [Status]
Select [The New ID was] = @@Identity
Select * From vCourses -- test the view of course
go 

-- Students Table
-- insert
-- Testing Code: 

 Declare @Status int;
 Exec @Status = pInsStudents
@StudentNumber = 1036832,
@StudentFirstName = 'Daoyi',
@StudentLastName = "Lu",
@StudentEmail = 'lyons124@uw.edu',
@StudentPhone = '(206)-354-8223',
@StudentAddress1 = '5000 University Way NE',
	@StudentAddress2 = 'A 701',
	@StudentCity = 'Seattle',
	@StudentStateCode = 'WA',
	@StudentZipCode = 98105
 Select [The Return Case was] = @Status;
Select Case @Status
When +1 Then 'Insert Was successful!'
When -1 Then 'Insert failed! Common Issues: Duplicate data or check the constraint'
End as [Status]
Select [The New ID was] = @@Identity
Select * From vStudents -- test the view of students
go 

-- Enrollments Table
-- insert
-- Testing Code: 

 Declare @Status int;
 Declare @NewStudentID int = Ident_Current('Students');
 Declare @NewCourseID int = Ident_Current('Courses');
 Exec @Status = pInsEnrollment
@StudentID = @NewStudentID,
@CourseID = @NewCourseID,
@EnrollmentDateTime = '2019/05/12',
@EnrollmentPrice = 1050
 Select [The Return Case was] = @Status;
Select Case @Status
When +1 Then 'Insert Was successful!'
When -1 Then 'Insert failed! Common Issues: Duplicate data or check the constraint'
End as [Status]
Select [The New ID was] = @@Identity
Select * From vEnrollments-- test the view of enrollments
go 
Select * From vCoursesEnrollmentStudents -- test the view of reporting views 
go 

-- Courses Table
-- Update
-- Testing Code:

Declare @Status int;
Declare @NewID int = Ident_Current('Courses')
Exec @Status = pUpdCourses
@CourseID = @NewID,
@CourseName = 'Info340',
@CourseStartDate = '2020/03/30',
@CourseEndDate = '2020/06/26',
@CourseStartTime = '3:30',
@CourseEndTime = '5:50',
@CouresWeekDays = null,
@CourseCurrentPrice = null
Select [The Return Case was] = @Status;
Select Case @Status
When +1 Then 'Update Was successful!'
When -1 Then 'Update failed! Common Issues: Check Values'
End as [Status]
Select * From vCourses -- test the view of course
go

-- Students Table
-- Update
-- Testing Code:
Declare @Status int;
Declare @NewID int = Ident_Current('Students')
Exec @Status = pUpdStudents
@StudentID = @NewID,
@StudentNumber = 1036832,
@StudentFirstName = 'Ruixi',
@StudentLastName = 'Zhang',
@StudentEmail = 'lyons124@uw.edu',
@StudentPhone = '(206)-354-8223',
@StudentAddress1 = '5000 University Way NE',
@StudentAddress2 = '713',
@StudentCity = 'Seattle',
@StudentStateCode = 'WA',
@StudentZipCode = 98105
Select [The Return Case was] = @Status;
Select Case @Status
When +1 Then 'Update Was successful!'
When -1 Then 'Update failed! Common Issues: Check Values'
End as [Status]
Select * From vStudents -- test the view of students
go

-- Enrollments Table
-- Update
-- Testing Code:
Declare @Status int;
Declare @NewEnrollmentID int = Ident_Current('Enrollments');
Declare @NewStudentID int = Ident_Current('Students');
Declare @NewCourseID int = Ident_Current('Courses');
Exec @Status = pUpdEnrollments
@EnrollmentID = @NewEnrollmentID,
@StudentID = @NewStudentID,
@CourseID = @NewCourseID,
@EnrollmentDateTime = '2018/05/12',
@EnrollmentPrice = 2100
Select [The Return Case was] = @Status;
Select Case @Status
When +1 Then 'Update Was successful!'
When -1 Then 'Update failed! Common Issues: Check Values'
End as [Status]
Select * From vEnrollments -- test the view of enrollments
go
Select * From vCoursesEnrollmentStudents -- test the view of reporting views 
go 

-- Enrollments Table
-- Delete
-- Testing Code:
Declare @Status int;
Declare @NewID int = Ident_Current('Enrollments');
Exec @Status = pDelEnrollment
@EnrollmentID = @NewID
Select [The Return Case was] = @Status;
Select Case @Status
When +1 Then 'Delete Was successful!'
When -1 Then 'Delete failed! Common Issues: Foreign Key Exists'
End as [Status]
Select * From vEnrollments -- test the view of EnrollmentID
go

-- Courses Table
-- Delete
-- Testing Code:

Declare @Status int;
Declare @NewID int = Ident_Current('Courses')
Exec @Status = pDelCourses
@CourseID = @NewID
Select [The Return Case was] = @Status;
Select Case @Status
When +1 Then 'Delete Was successful!'
When -1 Then 'Delete failed! Common Issues: Foreign Key Exists'
End as [Status]
Select * From vCourses -- test the view of course
go

-- Students Table
-- Delete
-- Testing Code:

Declare @Status int;
Declare @NewID int = Ident_Current('Students');
Exec @Status = pDelStudents
@StudentID = @NewID
Select [The Return Case was] = @Status;
Select Case @Status
When +1 Then 'Delete Was successful!'
When -1 Then 'Delete failed! Common Issues: Foreign Key Exists'
End as [Status]
Select * From vStudents -- test the view of students
go
Select * From vCoursesEnrollmentStudents -- test the view of reporting views 
go


-- Use Insert Stored Procedures to add the data from the spreadsheet into the tables
DBCC CHECKIDENT('Courses', RESEED, 0) -- reset the index from 1
DBCC CHECKIDENT('Students', RESEED, 0) -- reset the index from 1
DBCC CHECKIDENT('Enrollments', RESEED, 0) -- reset the index from 1
Exec pInsCourses 'SQL1 - Winter 2017'
, '1/10/2017'
, '1/24/2017 '
, '6PM'
, '8:50PM'
, 'T'
, 399
go
Exec pInsCourses 'SQL2 - Winter 2017'
,'1/31/2017'
, '2/14/2017'
, '6PM'
, '8:50PM'
, 'T'
, 399
go 
Exec pInsStudents 
'B-Smith-071'
, 'Bob'
, 'Smith'
, 'Bsmith@HipMail.com'
, '(206)-111-2222'
, 'Main St'
, '123'
, 'Seattle'
, 'WA'
, '98001'
Exec pInsStudents 
'S-Jones-003'
, 'Sue'
, 'Jones'
, 'SueJones@YaYou.com'
, '(206)-231-4321'
, '1st Ave'
, '333'
, 'Seattle'
, 'WA'
, '98001'
Exec pInsEnrollment
1
, 1
, '1/3/2017'
, 399
Exec pInsEnrollment
2
, 1
, '12/14/2016'
, 349
Exec pInsEnrollment
2
, 2
, '12/14/2016'
, 349
Exec pInsEnrollment
1
, 2
, '1/12/2017'
, 399


Select * From vCoursesEnrollmentStudents
/**************************************************************************************************/