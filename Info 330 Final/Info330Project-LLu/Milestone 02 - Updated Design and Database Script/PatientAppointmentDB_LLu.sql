--**********************************************************************************************--
-- Title: Assigment08
-- Author: LLu
-- Desc: This file demonstrates how to design and create; 
--       tables, constraints, views, stored procedures, and permissions
-- Change Log: 
-- 2020-05-20, LLu, Created File
--***********************************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'PatientAppointmentsDB_LLu')
	 Begin 
	  Alter Database [PatientAppointmentsDB_LLu] set Single_user With Rollback Immediate;
	  Drop Database PatientAppointmentsDB_LLu;
	 End
	Create Database PatientAppointmentsDB_LLu;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use PatientAppointmentsDB_LLu;

-- create the clinic tables
Create Table Clinics(
    ClinicID int Constraint pkClinicID Primary Key Identity,
    ClinicName nVarchar(100) Not Null,
    ClinicPhoneNumber nVarchar(100) Not Null,
    ClinicAddress nVarchar(100) Not Null,
    ClinicCity nVarchar(100) Not Null,
    ClinicState nchar(2) Not Null,
    ClinicZipCode nVarchar(10) Not Null
)
go

-- create the patients table
Create Table Patients(
    PatientID int Constraint pkPatientID Primary Key Identity,
    PatientFirstName nVarchar(100) Not Null,
    PatientLastName nVarchar(100) Not Null,
    PatientPhoneNumber nVarchar(100) Not Null,
    PatientAddress nVarchar(100) Not Null,
    PatientCity nVarchar(100) Not Null,
    PatientState nchar(2) Not Null,
    PatientZipCode nVarchar(10) Not Null
)
go

-- create the doctors table
Create Table Doctors(
    DoctorID int Constraint pkDoctorID Primary Key Identity, 
    DoctorFirstName nVarchar(100) Not Null,
    DoctorLastName nVarchar(100) Not Null,
    DoctorPhoneNumber nVarchar(100) Not Null,
    DoctorAddress nVarchar(100) Not Null,
    DoctorCity nVarchar(100) Not Null,
    DoctorState nchar(2) Not Null,
    DoctorZipCode nVarchar(10) Not Null
)
go

-- create the appointment table
Create Table Appointments(
    AppointmentID int Constraint pkAppointmentID Primary Key Identity,
    AppointmentDateTime datetime Not Null,
    AppointmentPatientID int Not Null,
    AppointmentDoctorID int Not Null,
    AppointmentClinicID int Not Null
)
go

-- alter the clinic tables 
-- add constraint ClinicName unique
--                ClinicPhoneNumber check phone pattern
--                ClinicZipCode check zipcode pattern

Alter Table Clinics
    Add Constraint uqClinicName Unique(ClinicName),
        Constraint ckClinicPhoneNumber Check(ClinicPhoneNumber like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
        Constraint ckClinicZipCode Check(ClinicZipCode like '[0-9][0-9][0-9][0-9][0-9]')
go
-- alter the doctor tables 
-- add constraint DoctorPhoneNumber check phone pattern
--                DoctorZipCode check zipcode pattern

Alter Table Doctors
    Add Constraint ckDoctorPhoneNumber Check(DoctorPhoneNumber like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
        Constraint ckDoctorZipCode Check(DoctorZipCode like '[0-9][0-9][0-9][0-9][0-9]')
go

-- alter the patient tables 
-- add constraint PatientPhoneNumber check phone pattern
--                PatientZipCode check zipcode pattern

Alter Table Patients
    Add Constraint ckPatientPhoneNumber Check(PatientPhoneNumber like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
        Constraint ckPatientZipCode Check(PatientZipCode like '[0-9][0-9][0-9][0-9][0-9]')
go 

-- alter the appointment tables 
-- add constraint foreign keys
-- AppointmentPatientID
-- AppointmentDoctorID
-- AppointmentClinicID

Alter Table Appointments
    Add Constraint fkAppointmentPatientID Foreign Key(AppointmentPatientID) References Patients(PatientID),
        Constraint fkAppointmentDoctorID Foreign Key(AppointmentDoctorID) References Doctors(DoctorID),
        Constraint fkAppointmentClinicID Foreign Key(AppointmentClinicID) References Clinics(ClinicID)
go 

-- create view for clinic table

Create or Alter View vClinics
As
    Select ClinicID,
           ClinicName,
           ClinicPhoneNumber,
           ClinicAddress,
           ClinicCity,
           ClinicState,
           ClinicZipCode
    From Clinics
go 

-- create view for patient table

Create or Alter View vPatients
As 
    Select PatientID,
           PatientFirstName,
           PatientLastName,
           PatientPhoneNumber,
           PatientAddress,
           PatientCity,
           PatientState,
           PatientZipCode
    From Patients
go

-- create view for doctor table

Create or Alter view vDoctors
AS
    Select DoctorID,
           DoctorFirstName,
           DoctorLastName,
           DoctorPhoneNumber,
           DoctorAddress,
           DoctorCity,
           DoctorState,
           DoctorZipCode
    From Doctors
go 

-- create view for appointments 

Create or Alter View vAppointments
As 
    Select AppointmentID,
           AppointmentDateTime,
           AppointmentPatientID,
           AppointmentDoctorID,
           AppointmentClinicID
    From Appointments
go 

-- create final report view
Create Or Alter View vAppointmentsByPatientsDoctorsAndClinics
As
    Select a.AppointmentID,
           AppointmentDate = Format (a.AppointmentDateTime, 'd', 'en-us'),
           AppointmentTime = Format(a.AppointmentDateTime,'hh:mm'),
           p.PatientID,
           PatientName = p.PatientFirstName + ' ' + p.PatientLastName,
           p.PatientPhoneNumber,
           p.PatientAddress,
           p.PatientCity,
           p.PatientState,
           p.PatientZipCode,
           d.DoctorID,
           DoctorName = d.DoctorFirstName + ' ' + d.DoctorLastName,
           d.DoctorPhoneNumber,
           d.DoctorAddress,
           d.DoctorCity,
           d.DoctorState,
           d.DoctorZipCode,
           c.ClinicID,
           c.ClinicName,
           c.ClinicPhoneNumber,
           c.ClinicAddress,
           c.ClinicCity,
           c.ClinicState,
           c.ClinicZipCode
    From Appointments as a Join Patients as p
    On a.AppointmentPatientID = p.PatientID
    Join Doctors as d
    On a.AppointmentDoctorID = d.DoctorID
    Join Clinics as c
    On a.AppointmentClinicID = c.ClinicID
go

-- create stored procedures
-- insert clinics
Create Or Alter Procedure pInsClinics(
    @ClinicID int Output,
	@ClinicName nVarchar(100),
    @ClinicPhoneNumber nVarchar(100),
    @ClinicAddress nVarchar(100),
    @ClinicCity nVarchar(100),
    @ClinicState nVarchar(100),
    @ClinicZipCode nVarchar(10))
/* Author: Lyons Lu
** Desc: Processes insert into clinics
** Change Log: 
** 2020-05-20, Lyons Lu, Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	    Insert Into Clinics(ClinicName,
                            ClinicPhoneNumber,
                            ClinicAddress,
                            ClinicCity,
                            ClinicState,
                            ClinicZipCode)
		Values (@ClinicName,
                @ClinicPhoneNumber,
                @ClinicAddress,
                @ClinicCity,
                @ClinicState,
                @ClinicZipCode)
        Select @ClinicID = ClinicID
        From Clinics
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

-- create stored procedures
-- insert patients
Create Or Alter Procedure pInsPatients(
    @PatientID int Output,
	@PatientFirstName nVarchar(100),
    @PatientLastName nVarchar(100),
    @PatientPhoneNumber nVarchar(100),
    @PatientAddress nVarchar(100),
    @PatientCity nVarchar(100),
    @PatientState nchar(2),
    @PatientZipCode nVarchar(10))
/* Author: Lyons Lu
** Desc: Processes insert into patients
** Change Log: 
** 2020-05-20, Lyons Lu, Created stored procedure.
*/
AS
 Begin
  Begin Try
   Begin Transaction 
	    Insert Into Patients(PatientFirstName,
                             PatientLastName,
                             PatientPhoneNumber,
                             PatientAddress,
                             PatientCity,
                             PatientState,
                             PatientZipCode)
		Values (@PatientFirstName,
                @PatientLastName,
                @PatientPhoneNumber,
                @PatientAddress,
                @PatientCity,
                @PatientState,
                @PatientZipCode)
        Select @PatientID = PatientID
        From Patients
   Commit Transaction
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
  End Catch
 End
go

-- create stored procedures
-- insert doctors
Create Or Alter Procedure pInsDoctors(
    @DoctorID int Output,
	@DoctorFirstName nVarchar(100),
    @DoctorLastName nVarchar(100),
    @DoctorPhoneNumber nVarchar(100),
    @DoctorAddress nVarchar(100),
    @DoctorCity nVarchar(100),
    @DoctorState nchar(2),
    @DoctorZipCode nVarchar(10))
/* Author: Lyons Lu
** Desc: Processes insert into doctor
** Change Log: 
** 2020-05-20, Lyons Lu, Created stored procedure.
*/
AS
 Begin
  Begin Try
   Begin Transaction 
	    Insert Into Doctors(DoctorFirstName,
                            DoctorLastName,
                            DoctorPhoneNumber,
                            DoctorAddress,
                            DoctorCity,
                            DoctorState,
                            DoctorZipCode)
		Values (@DoctorFirstName,
                @DoctorLastName,
                @DoctorPhoneNumber,
                @DoctorAddress,
                @DoctorCity,
                @DoctorState,
                @DoctorZipCode)
        Select @DoctorID = DoctorID
        From Doctors
   Commit Transaction
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
  End Catch
 End
go

-- create stored procedures
-- insert appointments
Create Or Alter Procedure pInsAppointments(
    @AppointmentID int Output,
	@AppointmentDateTime datetime,
    @AppointmentPatientID int, 
    @AppointmentDoctorID int,
    @AppointmentClinicID int)
/* Author: Lyons Lu
** Desc: Processes insert into appointments
** Change Log: 
** 2020-05-20, Lyons Lu, Created stored procedure.
*/
AS
 Begin
  Begin Try
   Begin Transaction 
	    Insert Into Appointments(AppointmentDateTime,
                                 AppointmentPatientID,
                                 AppointmentDoctorID,
                                 AppointmentClinicID)
		Values (@AppointmentDateTime,
                @AppointmentPatientID,
                @AppointmentDoctorID,
                @AppointmentClinicID)
        Select @AppointmentID = AppointmentID
        From  Appointments
   Commit Transaction
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
  End Catch
 End
go

-- Create stored procedures for update clinics table
Create Or Alter Procedure pUpdClinics(
	@ClinicID int,
    @ClinicName nVarchar(100),
    @ClinicPhoneNumber nVarchar(100),
    @ClinicAddress nVarchar(100),
    @ClinicCity nVarchar(100),
    @ClinicState nchar(2),
    @ClinicZipCode nVarchar(10))
/* Author: Lyons Lu
** Desc: Processes update into clinics
** Change Log: 
** 2020-05-20, Lyons Lu, Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	    Update Clinics
		Set ClinicName = @ClinicName,
            ClinicPhoneNumber = @ClinicPhoneNumber,
            ClinicAddress = @ClinicAddress,
            ClinicCity = @ClinicCity,
            ClinicState = @ClinicState,
            ClinicZipCode = @ClinicZipCode
		Where ClinicID = @ClinicID
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

-- Create stored procedures for update patients table
Create Or Alter Procedure pUpdPatients(
	@PatientID int,
    @PatientFirstName nVarchar(100),
    @PatientLastName nVarchar(100),
    @PatientPhoneNumber nVarchar(100),
    @PatientAddress nVarchar(100),
    @PatientCity nVarchar(100),
    @PatientState nchar(2),
    @PatientZipCode nVarchar(10)) 
/* Author: Lyons Lu
** Desc: Processes update into patients
** Change Log: 
** 2020-05-20, Lyons Lu, Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	    Update Patients
		Set PatientFirstName = @PatientFirstName,
            PatientLastName = @PatientLastName,
            PatientPhoneNumber = @PatientPhoneNumber,
            PatientAddress = @PatientAddress,
            PatientCity = @PatientCity, 
            PatientState = @PatientState,
            PatientZipCode = @PatientZipCode
		Where PatientID = @PatientID
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


-- Create stored procedures for update doctors table
Create Or Alter Procedure pUpdDoctors(
	@DoctorID int,
    @DoctorFirstName nVarchar(100),
    @DoctorLastName nVarchar(100),
    @DoctorPhoneNumber nVarchar(100),
    @DoctorAddress nVarchar(100),
    @DoctorCity nVarchar(100),
    @DoctorState nchar(100),
    @DoctorZipCode nVarchar(10)) 
/* Author: Lyons Lu
** Desc: Processes update into doctors
** Change Log: 
** 2020-05-20, Lyons Lu, Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	    Update Doctors
		Set DoctorFirstName = @DoctorFirstName,
            DoctorLastName = @DoctorLastName,
            DoctorPhoneNumber = @DoctorPhoneNumber,
            DoctorAddress = @DoctorAddress,
            DoctorCity = @DoctorCity,
            DoctorState = @DoctorState,
            DoctorZipCode = @DoctorZipCode
		Where DoctorID = @DoctorID
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

-- Create stored procedures for update appointments table
Create Or Alter Procedure pUpdAppointments(
	@AppointmentID int,
    @AppointmentDateTime datetime,
    @AppointmentPatientID int,
    @AppointmentDoctorID int,
    @AppointmentClinicID int) 
/* Author: Lyons Lu
** Desc: Processes update into doctors
** Change Log: 
** 2020-05-20, Lyons Lu, Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	    Update Appointments
		Set AppointmentDateTime = @AppointmentDateTime,
            AppointmentPatientID = @AppointmentPatientID,
            AppointmentDoctorID = @AppointmentDoctorID,
            AppointmentClinicID = @AppointmentClinicID
		Where AppointmentID = @AppointmentID
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


-- Create stored procedures for delete clinics
Create Or Alter Procedure pDelClinics(@ClinicID int)
/* Author: Lyons Lu
** Desc: Processes delete
** Change Log: 
** 2020-05-20, Lyons Lu, Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	    Delete Clinics
		Where ClinicID = @ClinicID
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

-- Create stored procedures for delete patients
Create Or Alter Procedure pDelPatients(@PatientID int)
/* Author: Lyons Lu
** Desc: Processes delete
** Change Log: 
** 2020-05-20, Lyons Lu, Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	    Delete Patients
		Where PatientID = @PatientID
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

-- Create stored procedures for delete doctors
Create Or Alter Procedure pDelDoctors(@DoctorID int)
/* Author: Lyons Lu
** Desc: Processes delete
** Change Log: 
** 2020-05-20, Lyons Lu, Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	    Delete Doctors
		Where DoctorID = @DoctorID
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

-- Create stored procedures for delete appointments
Create Or Alter Procedure pDelAppointments(@AppointmentID int)
/* Author: Lyons Lu
** Desc: Processes delete
** Change Log: 
** 2020-05-20, Lyons Lu, Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	    Delete Appointments
		Where AppointmentID = @AppointmentID
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

-- set permission
Deny Select, Update, Insert, Delete On Clinics to Public;
Deny Select, Update, Insert, Delete On Patients to Public;
Deny Select, Update, Insert, Delete On Doctors to Public;
Deny Select, Update, Insert, Delete On Appointments to Public;
Grant Select on vClinics to Public;
Grant Select on vDoctors to Public;
Grant Select on vPatients to Public;
Grant Select on vAppointments to Public;
Grant Select on vAppointmentsByPatientsDoctorsAndClinics to Public;
Grant Exec on pInsClinics to Public;
Grant Exec on pUpdClinics to Public;
Grant Exec on pDelClinics to Public;
Grant Exec on pInsPatients to Public;
Grant Exec on pUpdPatients to Public;
Grant Exec on pDelPatients to Public;
Grant Exec on pInsDoctors to Public;
Grant Exec on pUpdDoctors to Public;
Grant Exec on pDelDoctors to Public;
Grant Exec on pInsAppointments to Public;
Grant Exec on pUpdAppointments to Public;
Grant Exec on pDelAppointments to Public;

--< Test Views and Sprocs >-- 
-- Clinic Tables
-- insert
-- Testing Code:

Declare @ID int;
Exec pInsClinics
@ClinicID = @ID Output,
@ClinicName = 'UW Medical Center',
@ClinicPhoneNumber = '206-354-8223',
@ClinicAddress = '5000 University Way NE',
@ClinicCity = 'Seattle',
@ClinicState = 'WA',
@ClinicZipCode = '98105'
Select Case @ID
When 1 Then 'Insert Was successful!'
else 'Insert failed! Common Issues: Duplicate data'
End as [new ID]
Select [The New ID was] = @ID
Select * From vClinics -- test the view
go 


--< Test Views and Sprocs >-- 
-- Patient Tables
-- insert
-- Testing Code:

Declare @ID int;
Exec pInsPatients
@PatientID = @ID Output,
@PatientFirstName = 'Lyons',
@PatientLastName = 'Lu',
@PatientPhoneNumber = '206-888-8888',
@PatientAddress = '1035 NE Campus NE', 
@PatientCity = 'Seattle',
@PatientState = 'WA',
@PatientZipCode = '98105'
Select Case @ID
When 1 Then 'Insert Was successful!'
else 'Insert failed! Common Issues: Duplicate data'
End as [New ID]
Select [The New ID was] = @ID
Select * From vPatients -- test the view
go 

--< Test Views and Sprocs >-- 
-- Doctor Tables
-- insert
-- Testing Code:

Declare @ID int;
Exec pInsDoctors
@DoctorID = @ID Output,
@DoctorFirstName = 'Ruixi',
@DoctorLastName = 'Zhang',
@DoctorPhoneNumber = '425-319-7739',
@DoctorAddress = 'twelve U district apartment', 
@DoctorCity = 'Seattle',
@DoctorState = 'WA',
@DoctorZipCode = '98105'
Select Case @ID
When 1 Then 'Insert Was successful!'
else 'Insert failed! Common Issues: Duplicate data'
End as [New ID]
Select [The New ID was] = @ID
Select * From vDoctors -- test the view
go 

--< Test Views and Sprocs >-- 
-- Appointment Tables
-- insert
-- Testing Code:
 Declare @ID int;
 Declare @NewClinicID int = Ident_Current('Clinics');
 Declare @NewPatientID int = Ident_Current('Patients');
 Declare @NewDoctorID int = Ident_Current('Doctors');
 Exec pInsAppointments
@AppointmentID = @ID Output,
@AppointmentDateTime = '2020/06/26',
@AppointmentPatientID = @NewPatientID,
@AppointmentDoctorID = @NewDoctorID,
@AppointmentClinicID = @NewClinicID
Select Case @ID
When +1 Then 'Insert Was successful!'
else 'Insert failed! Common Issues: Duplicate data'
End as [New ID]
Select [The New ID was] = @ID
Select * From vAppointments  -- test the view
go 

-- clinic Table
-- Update
-- Testing Code:

Declare @Status int;
Declare @NewID int = Ident_Current('Clinics')
Exec @Status = pUpdClinics
@ClinicID = @NewID,
@ClinicName = 'UW-seattle medical center downtown',
@ClinicPhoneNumber = '206-666-6666',
@ClinicAddress = '8888 University Way NE',
@ClinicCity = 'Seattle',
@ClinicState = 'WA',
@ClinicZipCode = '98105'
Select [The Return Case was] = @Status;
Select Case @Status
When +1 Then 'Update Was successful!'
When -1 Then 'Update failed! Common Issues: Check Values'
End as [Status]
Select * From vClinics -- test the view of course
go

-- patient Table
-- Update
-- Testing Code:

Declare @Status int;
Declare @NewID int = Ident_Current('Patients')
Exec @Status = pUpdPatients
@PatientID = @NewID,
@PatientFirstName = 'Michael',
@PatientLastName = 'Jordan',
@PatientPhoneNumber = '208-888-5438',
@PatientAddress = 'North Carolina - Capital Hill',
@PatientCity = 'Seattle', 
@PatientState = 'WA',
@PatientZipCode = '98105'
Select [The Return Case was] = @Status;
Select Case @Status
When +1 Then 'Update Was successful!'
When -1 Then 'Update failed! Common Issues: Check Values'
End as [Status]
Select * From vPatients -- test the view of course
go

-- doctor Table
-- Update
-- Testing Code:

Declare @Status int;
Declare @NewID int = Ident_Current('Doctors')
Exec @Status = pUpdDoctors
@DoctorID = @NewID,
@DoctorFirstName = 'Kobe',
@DoctorLastName = 'Bryant',
@DoctorPhoneNumber = '203-333-3333',
@DoctorAddress = 'LA Lakers',
@DoctorCity = 'Seattle', 
@DoctorState = 'WA',
@DoctorZipCode = '98105'
Select [The Return Case was] = @Status;
Select Case @Status
When +1 Then 'Update Was successful!'
When -1 Then 'Update failed! Common Issues: Check Values'
End as [Status]
Select * From vDoctors -- test the view of course
go

-- appointments Table
-- Update
-- Testing Code:

 Declare @Status int;
 Declare @NewClinicID int = Ident_Current('Clinics');
 Declare @NewPatientID int = Ident_Current('Patients');
 Declare @NewDoctorID int = Ident_Current('Doctors');
 Declare @NewAppointmentID int = Ident_Current('Appointments');
 Exec @Status = pUpdAppointments
@AppointmentID = @NewAppointmentID,
@AppointmentDateTime = '2020/05/20',
@AppointmentPatientID = @NewPatientID,
@AppointmentDoctorID = @NewDoctorID,
@AppointmentClinicID = @NewClinicID
 Select [The Return Case was] = @Status;
Select Case @Status
When +1 Then 'Update Was successful!'
When -1 Then 'Update failed! Common Issues: Check Values'
End as [Status]
Select [The New ID was] = @@Identity
Select * From vAppointments  -- test the view
Select * From vAppointmentsByPatientsDoctorsAndClinics
go 




-- Appointments Table
-- Delete
-- Testing Code:
Declare @Status int;
Declare @NewID int = Ident_Current('Appointments');
Exec @Status = pDelAppointments
@AppointmentID = @NewID
Select [The Return Case was] = @Status;
Select Case @Status
When +1 Then 'Delete Was successful!'
When -1 Then 'Delete failed! Common Issues: Foreign Key Exists'
End as [Status]
Select * From vAppointments -- test the view of EnrollmentID
go


-- clinic Table
-- Delete
-- Testing Code:
Declare @Status int;
Declare @NewID int = Ident_Current('Clinics');
Exec @Status = pDelClinics
@ClinicID = @NewID
Select [The Return Case was] = @Status;
Select Case @Status
When +1 Then 'Delete Was successful!'
When -1 Then 'Delete failed! Common Issues: Foreign Key Exists'
End as [Status]
Select * From vClinics -- test the view of EnrollmentID
go

-- Patient Table
-- Delete
-- Testing Code:
Declare @Status int;
Declare @NewID int = Ident_Current('Patients');
Exec @Status = pDelPatients
@PatientID = @NewID
Select [The Return Case was] = @Status;
Select Case @Status
When +1 Then 'Delete Was successful!'
When -1 Then 'Delete failed! Common Issues: Foreign Key Exists'
End as [Status]
Select * From vPatients -- test the view of EnrollmentID
go

-- Doctors Table
-- Delete
-- Testing Code:
Declare @Status int;
Declare @NewID int = Ident_Current('Doctors');
Exec @Status = pDelDoctors
@DoctorID = @NewID
Select [The Return Case was] = @Status;
Select Case @Status
When +1 Then 'Delete Was successful!'
When -1 Then 'Delete failed! Common Issues: Foreign Key Exists'
End as [Status]
Select * From vDoctors -- test the view of EnrollmentID
Select * From vAppointmentsByPatientsDoctorsAndClinics
go