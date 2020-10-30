--**********************************************************************************************--
-- Title: Assigment09
-- Author: LLu
-- Desc: This file creates report views 
-- Change Log: 
-- 2020-05-27, LLu, Created File
--***********************************************************************************************--

Use PatientAppointmentsDB_LLu
go

-- create view to see the number of doctors in each clinic in total appointments in each year.

Create Or Alter View vClinicDoctors
As 
    Select Top(100000)
           c.ClinicName,
           AppointmentYear = Year(a.AppointmentDateTime),
           [DoctorCount] = Count(d.DoctorID)
    From Doctors as d Join Appointments as a
    On d.DoctorID = a.AppointmentDoctorID
    Join Clinics as c 
    On a.AppointmentClinicID = c.ClinicID
    Group By c.ClinicName, Year(a.AppointmentDateTime)
go

-- create view to see the number of patients in each state in each year

Create Or Alter View vStatePatients
As
    Select Top(100000)
           c.ClinicState,
           AppointmentYear = Year(a.AppointmentDateTime),
           [PatientCount] = Count(p.PatientID)
    From Clinics as c Join Appointments as a 
    On c.ClinicID = a.AppointmentClinicID
    Join Patients as p
    On a.AppointmentPatientID = p.PatientID
    Group By c.ClinicState, Year(a.AppointmentDateTime)
    Order By 1 
go 
