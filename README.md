# Project Description:
This project was developed as individual assignment at Brainster Data Science Academy.  Designing an SQL database for Salary management for the employees across the globe of one commercial bank.

The assignment was to prepare database that will be used to store and manage basic information about the employees and additionally manage monthly salary for each employee. 

Following information should exists in the database:
1.	Seniority level
Columns:
  -	Id
  -	Name
Data:
Seniority levels should be inserted manually.
Table should contain 10 records after import.

2.	Location
Columns:
  -	Id
  -	CountryName
  -	Continent
  -	Region 
Data:
List of locations should be imported from Application.Countries table in WideWorldImporters database.
Table should contain 190 records after import.

3.	Department
Columns:
  -	Id
  -	Name
Data:
Departments should be inserted manually.
Table should contain 10 records after import.

4.	Employee
Columns:
  -	Id
  -	FirstName
  -	LastName
  -	Location
  -	Seniority level
  -	Department
Data:
List of employees should be imported from Application.People table in WideWorldImporters database.
Table should contain 1111 records after import.

How to populate Location, Seniority and Department data: 
  -	Seniority level:
  o	We have 10 different seniority levels, so all employees should be divided in almost equal groups and ~10% of employees should have ‘Junior’ seniority, 10% “Intermediate” and so on.
  -	Departments:
  o	We have 10 different departments, so all employees should be divided in almost equal groups and ~10% of employees should belong to ‘Personal Banking & Operations’ department, ~10% “Treasury” department and and so on.
  -	Location
  o	We have 190 different departments, so all employees should be divided in almost equal groups and we need to have approx. 5-6 employees on each location.
  o	Example: Employee 1,2,3,4,5,6 should be on location 1, Employees 7,8,9,10,11,12 should be on location 2 etc.

5.	Salary
Columns:
  -	Id
  -	EmployeeId
  -	Month
  -	Year
  -	GrossAmount
  -	NetAmount
  -	RegularWorkAmount
  -	BonusAmount
  -	OvertimeAmount
  -	VacationDays
  -	SickLeaveDays
Data:
Salary data should be generated with SQL Script.
Following data should be inserted:
  -	Salary data for the past 20 years, starting from 01.2001 to 12.2020 
  -	Gross amount should be random data between 30.000 and 60.000 
  -	Net amount should be 90% of the gross amount
  -	RegularWorkAmount sould be 80% of the total Net amount for all employees and months
  -	Bonus amount should be the difference between the NetAmount and RegularWorkAmount for every Odd month (January,March,..), else 0
  -	OvertimeAmount  should be the difference between the NetAmount and RegularWorkAmount for every Even month (February,April,…), else 0
  -	All employees use 10 vacation days in July and 10 Vacation days in December
  -	Additionally random vacation days and sickLeaveDays should be generated.
  -	Additionally, vacation days should be between 20 and 30



![image](https://github.com/VesnaPop-Dimitrijoska/SQL_Project/assets/144008804/8ff84f94-45b9-4138-98e5-37d73c32d6d8)

# License
MIT License
#
