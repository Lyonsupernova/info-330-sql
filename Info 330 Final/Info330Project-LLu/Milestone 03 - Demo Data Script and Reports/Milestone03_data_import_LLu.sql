--**********************************************************************************************--
-- Title: Assigment09
-- Author: LLu
-- Desc: This file imports data into database 
-- Change Log: 
-- 2020-05-27, LLu, Created File
--***********************************************************************************************--

Use PatientAppointmentsDB_LLu

-- insert into clinic tables with data
insert into Clinics (ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode) values ('Schamberger and Sons', '225-967-3126', '86450 Ramsey Point', 'Baton Rouge', 'LA', '70883');
insert into Clinics (ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode) values ('Jast-Runolfsdottir', '509-711-8648', '8363 Buhler Court', 'Yakima', 'WA', '98907');
insert into Clinics (ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode) values ('Wisozk Group', '210-238-6480', '8694 Bultman Point', 'San Antonio', 'TX', '78255');
insert into Clinics (ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode) values ('Ullrich-Jerde', '760-451-2360', '24519 Fremont Parkway', 'Carlsbad', 'CA', '92013');
insert into Clinics (ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode) values ('Smitham-Ferry', '661-238-3760', '5034 Holy Cross Way', 'Bakersfield', 'CA', '93381');
insert into Clinics (ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode) values ('Schmidt-Pagac', '239-796-7960', '1975 Atwood Pass', 'Fort Myers', 'FL', '33913');
insert into Clinics (ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode) values ('Trantow Group', '718-932-4604', '9 Saint Paul Pass', 'Bronx', 'NY', '10464');
insert into Clinics (ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode) values ('Nader and Sons', '313-362-3317', '6996 Drewry Point', 'Detroit', 'MI', '48267');
insert into Clinics (ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode) values ('Abernathy-Hirthe', '413-820-9645', '3637 Ridgeway Avenue', 'Springfield', 'MA', '01152');
insert into Clinics (ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode) values ('Goodwin LLC', '619-476-4353', '2 Jenifer Way', 'San Diego', 'CA', '92196');

Select * From Clinics

-- insert into patients table with data

insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Kassi', 'Flobert', '520-303-1348', '89902 Old Shore Junction', 'Tucson', 'AZ', '85743');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Rasia', 'Cutford', '901-688-6000', '270 Katie Avenue', 'Memphis', 'TN', '38188');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Teena', 'Forson', '254-153-4416', '4 Dixon Parkway', 'Temple', 'TX', '76505');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Chickie', 'De Lascy', '805-121-4798', '5 Everett Place', 'Simi Valley', 'CA', '93094');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Adina', 'Wallis', '503-706-6530', '84 Paget Center', 'Portland', 'OR', '97216');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Elizabeth', 'Poncet', '940-622-6103', '65 Carey Pass', 'Denton', 'TX', '76205');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Kaia', 'Smale', '434-862-4898', '4 Warrior Street', 'Lynchburg', 'VA', '24515');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Felicio', 'Bento', '979-101-2575', '99 Caliangt Pass', 'Bryan', 'TX', '77806');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Sergent', 'Burl', '858-646-9757', '30570 Warner Alley', 'Orange', 'CA', '92668');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Pepe', 'Simmans', '617-717-2289', '53462 Hallows Alley', 'Boston', 'MA', '02203');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Flori', 'Rimmington', '515-350-6745', '65542 Lindbergh Hill', 'Des Moines', 'IA', '50335');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Darcee', 'Drydale', '202-336-2522', '3172 Rieder Alley', 'Washington', 'DC', '20022');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Read', 'Mannering', '215-176-6978', '129 Hazelcrest Court', 'Philadelphia', 'PA', '19141');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Rodi', 'Salmoni', '850-627-3488', '51774 Luster Crossing', 'Panama City', 'FL', '32405');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Brice', 'Goldstone', '804-279-5855', '30107 Everett Circle', 'Hampton', 'VA', '23663');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Joyann', 'Peeke', '716-791-4962', '6 American Circle', 'Buffalo', 'NY', '14225');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Flossie', 'Handrick', '408-618-5541', '661 Scofield Center', 'San Jose', 'CA', '95108');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Ailene', 'Knevett', '515-648-8249', '5 Londonderry Parkway', 'Des Moines', 'IA', '50305');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Roy', 'Cottom', '843-176-6372', '5543 Northview Lane', 'Charleston', 'SC', '29403');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Fayth', 'Doni', '541-617-7308', '33 Troy Hill', 'Eugene', 'OR', '97405');

Select * From Patients


-- insert into doctor table with data

insert into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) values ('Virge', 'Stock', '802-619-8206', '98 Muir Hill', 'Montpelier', 'VT', '05609');
insert into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) values ('Liliane', 'Rucklidge', '858-222-0305', '20 Prairie Rose Avenue', 'San Diego', 'CA', '92105');
insert into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) values ('Margie', 'Smethurst', '203-804-5191', '202 Nova Center', 'New Haven', 'CT', '06533');
insert into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) values ('Normand', 'Balnave', '321-781-5218', '67 Waxwing Circle', 'Orlando', 'FL', '32803');
insert into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) values ('Alexis', 'Mineghelli', '347-907-6724', '0 High Crossing Crossing', 'New York City', 'NY', '10004');
insert into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) values ('Ewen', 'Sale', '517-632-0886', '459 Larry Court', 'Lansing', 'MI', '48919');
insert into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) values ('Harp', 'Cowburn', '504-672-0210', '43 Lunder Hill', 'New Orleans', 'LA', '70160');
insert into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) values ('Cleopatra', 'Peschmann', '813-513-9657', '40 Crownhardt Way', 'Clearwater', 'FL', '33758');
insert into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) values ('Rani', 'Van Oort', '503-899-5850', '17 Clove Place', 'Beaverton', 'OR', '97075');
insert into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) values ('Sibley', 'Allibon', '251-477-9744', '6 Walton Drive', 'Mobile', 'AL', '36605');
Select * From Doctors
go 

-- insert  into appointments with data 
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2020-05-08 06:00:26', 2, 2, 2);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-09-13 23:42:06', 3, 2, 2);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-12-20 23:57:48', 4, 2, 2);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2020-02-05 12:18:32', 5, 3, 3);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-06-02 01:21:50', 6, 5, 3);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-11-21 19:23:28', 7, 5, 4);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-10-21 17:55:11', 8, 6, 5);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2020-03-29 04:55:22', 9, 7, 5);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2020-04-13 13:08:50', 10, 7, 5);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-07-22 11:29:44', 11, 7, 6);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2020-03-19 23:02:23', 12, 7, 7);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-11-02 23:33:02', 13, 7, 8);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-07-06 08:21:29', 14, 8, 8);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-11-03 03:21:31', 15, 8, 8);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-12-06 21:10:19', 16, 9, 9);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2020-04-18 00:34:13', 17, 9, 9);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-06-06 21:57:52', 18, 9, 9);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-10-10 22:59:30', 19, 9, 9);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2020-05-04 01:51:38', 20, 10, 10);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-12-08 14:24:18', 21, 11, 11);

insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-12-28 07:37:20', 2, 3, 2);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-06-19 22:58:26', 5, 3, 2);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2020-01-26 18:11:58', 6, 3, 3);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2020-01-20 04:13:40', 4, 4, 4);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2020-03-27 22:50:57', 8, 7, 5);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-06-29 21:44:17', 2, 7, 6);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2020-04-09 15:05:59', 8, 7, 7);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2020-05-12 12:30:18', 8, 8, 8);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-10-22 03:19:58', 9, 10, 9);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2020-01-18 22:05:26', 12, 8, 3);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-08-06 04:04:42', 12, 3, 8);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-10-29 05:58:39', 12, 3, 6);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-06-27 11:54:06', 13, 5, 2);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-11-07 10:32:39', 14, 8, 4);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2020-03-31 10:42:03', 5, 5, 9);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2020-03-29 21:47:39', 16, 9, 9);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2020-05-23 18:18:30', 17, 9, 4);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-09-19 15:34:08', 18, 10, 6);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2020-01-24 07:30:55', 19, 11, 8);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('2019-06-05 13:30:32', 20, 11, 8);

Select * From Appointments