--======================================================================================
-- SQL PROJECT - VESNA POP-DIMITRIJOSKA
--======================================================================================

--=========================================================================
--Creates database SqlProject_VesnaPopDimitrijoska 
--=========================================================================

USE [Master]
GO

DROP DATABASE IF EXISTS SqlProject_VesnaPopDimitrijoska
CREATE DATABASE SqlProject_VesnaPopDimitrijoska
GO

USE SqlProject_VesnaPopDimitrijoska
GO

--=========================================================================
--Creates Tables - deletes the table if it exists
--=========================================================================

DROP TABLE IF EXISTS dbo.SeniorityLevel
CREATE TABLE dbo.SeniorityLevel
(
	ID int IDENTITY(1,1) NOT NULL,
	[Name] nvarchar(100) NOT NULL,
	CONSTRAINT PK_SeniorityLevel PRIMARY KEY CLUSTERED (ID ASC)
)
GO

DROP TABLE IF EXISTS dbo.[Location]
CREATE TABLE dbo.[Location]
(
	ID int IDENTITY(1,1) NOT NULL,
	CountryName nvarchar(100) NULL,
	Continent nvarchar(100) NULL,
	Region nvarchar(100) NULL,
	CONSTRAINT PK_Location PRIMARY KEY CLUSTERED (ID ASC)
)
GO

DROP TABLE IF EXISTS dbo.Department
CREATE TABLE dbo.Department
(
	ID int IDENTITY(1,1) NOT NULL,
	[Name] nvarchar(100) NOT NULL,
	CONSTRAINT PK_Department PRIMARY KEY CLUSTERED (ID ASC)
)
GO

DROP TABLE IF EXISTS dbo.Employee
CREATE TABLE dbo.Employee
(
	ID int IDENTITY(1,1) NOT NULL,
	FirstName nvarchar(100) NOT NULL,
	LastName nvarchar(100) NOT NULL,
	LocationID int NOT NULL,
	SeniorityLevelID int NOT NULL,
	DepartmentID int NOT NULL,
	CONSTRAINT PK_Employee PRIMARY KEY CLUSTERED (ID ASC)
)
GO

DROP TABLE IF EXISTS dbo.Salary
CREATE TABLE dbo.Salary
(
	ID bigint IDENTITY(1,1) NOT NULL,
	EmployeeID int NOT NULL,
	[Month] smallint NOT NULL,
	[Year] smallint NOT NULL,
	GrossAmount decimal(18,2) NOT NULL,
	NetAmount decimal(18,2) NOT NULL,
	RegularWorkAmount decimal(18,2) NOT NULL,
	BonusAmount decimal(18,2) NOT NULL,
	OvertimeAmount decimal(18,2) NOT NULL,
	VacationDays smallint NOT NULL, 
	SickLeaveDays smallint NOT NULL
	CONSTRAINT PK_Salary PRIMARY KEY CLUSTERED (ID ASC)
)
GO

--=========================================================================
--Creates Table Constraints - FK
--=========================================================================

ALTER TABLE dbo.Employee
ADD CONSTRAINT FK_Employee_SeniorityLevel 
FOREIGN KEY (SeniorityLevelID)
REFERENCES dbo.SeniorityLevel (ID)
GO
--ALTER TABLE dbo.Employee DROP CONSTRAINT FK_SeniorityLevel_Employee
--GO

ALTER TABLE dbo.Employee
ADD CONSTRAINT FK_Employee_Location 
FOREIGN KEY (LocationID)
REFERENCES dbo.[Location] (ID)
GO
--ALTER TABLE dbo.Employee DROP CONSTRAINT FK_Location_Employee
--GO

ALTER TABLE dbo.Employee
ADD CONSTRAINT FK_Employee_Department 
FOREIGN KEY (DepartmentID)
REFERENCES dbo.Department (ID)
GO
--ALTER TABLE dbo.Employee DROP CONSTRAINT FK_Department_Employee
--GO

ALTER TABLE dbo.Salary
ADD CONSTRAINT FK_Salary_Employee 
FOREIGN KEY (EmployeeID)
REFERENCES dbo.Employee (ID)
GO
--ALTER TABLE dbo.Salary DROP CONSTRAINT FK_Employee_Salary
--GO

--=========================================================================
--Table load
--=========================================================================

INSERT INTO dbo.SeniorityLevel ([Name])
VALUES	
	('Junior'), 
	('Intermediate'), 
	('Senior'), 
	('Lead'), 
	('Project Manager'), 
	('Division Manager'), 
	('Office Manager'), 
	('CEO'), 
	('CTO'), 
	('CIO')
GO

INSERT INTO dbo.[Location](CountryName, Continent, Region)
SELECT c.CountryName, c.Continent, c.Region
FROM WideWorldImporters.[Application].Countries as c
GO

INSERT INTO dbo.Department([Name])
VALUES 
	('Personal Banking & Operation'), 
	('Digital Banking Department'), 
	('Retail Banking & Marketing Department'),
	('Wealth Management & Third Party Products'), 
	('International Banking Devision & DFB'), 
	('Treasury'), 
	('Information Technology'),
	('Corporate Communications'), 
	('Support Services & Branch Expansion'), 
	('Human Resources')
GO

INSERT INTO dbo.Employee (FirstName, LastName, LocationID, SeniorityLevelID, DepartmentID)
SELECT 	
	LEFT (p.FullName, CHARINDEX (' ', p.FullName)-1) as FirstName,
	RIGHT (p.FullName, LEN (p.FullName) - LEN (LEFT (p.FullName, (CHARINDEX (' ', p.FullName)-1)))-1) as LastName,
	NTILE(190) OVER (ORDER BY p.EmailAddress) as LocationID, 
	NTILE(10) OVER (ORDER BY p.FullName) as SeniorityLeverID,
	NTILE(10) OVER (ORDER BY p.PersonID) as DepartmentID
FROM WideWorldImporters.[Application].People as p
WHERE p.PersonID <> 1
GO

-- Polnenje na [Month] i [Year] koloni
IF OBJECT_ID('tempdb..#Calendar') IS NOT NULL DROP TABLE #Calendar
CREATE TABLE #Calendar
(
	CalendarDate date NOT NULL, 
	[Month] smallint NOT NULL,
	[Year] smallint NOT NULL
)
GO

DECLARE @StartDate date = '2000-01-01'
DECLARE @EndDate date = '2019-12-31'
WHILE @StartDate <= @EndDate
	BEGIN
		INSERT INTO #Calendar (CalendarDate, [Month], [Year])
		SELECT @StartDate, MONTH (@StartDate), YEAR (@StartDate)
		SET @StartDate = DATEADD(MM, 1, @StartDate)
     END
GO
-- Polnenje na EmployeeID kolona so cross join so [Month] i [Year] koloni za da se dobijat site mozni kombinacii
INSERT INTO dbo.Salary (EmployeeID, [Month], [Year], GrossAmount, NetAmount, RegularWorkAmount, BonusAmount, OvertimeAmount, VacationDays, SickLeaveDays)
SELECT e.ID, c.[Month], c.[Year], 0, 0, 0, 0, 0, 0, 0
FROM 
	#Calendar as c
	CROSS JOIN dbo.Employee as e
GO

-- Polnenje na GrossAmount kolona so random vrednosti
UPDATE s 
SET 
	s.GrossAmount = 30000 + ABS(CHECKSUM(NewID())) % 30001  
FROM dbo.Salary s
GO

-- Polnenje na NetAmount kolona so 90% od vrednosta na GrossAmount
UPDATE s 
SET s.NetAmount = s.GrossAmount * 0.9
FROM dbo.Salary s
GO

-- Polnenje na RegularWorkAmount kolona so 80% od vrednosta na NetAmount
UPDATE s 
SET s.RegularWorkAmount = s.NetAmount * 0.8
FROM dbo.Salary s
GO

-- Polnenje na BonusAmount kolona kako razlika na NetAmount i RegularWorkAmount za neparni meseci
UPDATE s 
SET s.BonusAmount = s.NetAmount - s.RegularWorkAmount
FROM dbo.Salary s
WHERE s.[Month] % 2 = 1
GO

-- Polnenje na OvertimeAmount kolona kako razlika na NetAmount i RegularWorkAmount za parni meseci
UPDATE s 
SET s.OvertimeAmount = s.NetAmount - s.RegularWorkAmount
FROM dbo.Salary s
WHERE s.[Month] % 2 = 0
GO

-- Polnenje na VacationDays kolona - 10 dena vo Juli, 10 dena vo Dekemvri
UPDATE s 
SET s.VacationDays = 10
FROM dbo.Salary s
WHERE s.[Month] = 7 OR s.[Month] = 12
GO

-- Dopolnitelni VacationDays se generirani so dadenata skripta
UPDATE s
SET s.VacationDays = s.VacationDays + (s.EmployeeID % 2)
FROM dbo.Salary s
WHERE (s.EmployeeID + [Month] + [Year]) % 5 = 1
GO

-- Popolnuvanje na SickLeaveDays so dadenata skripta
UPDATE s
SET s.SickLeaveDays = s.EmployeeID % 8, s.VacationDays = s.VacationDays + (s.EmployeeID % 3)
FROM dbo.Salary s
WHERE (s.EmployeeID + [Month] + [Year]) % 5 = 2
GO

SELECT * FROM dbo.SeniorityLevel
SELECT * FROM dbo.[Location]
SELECT * FROM dbo.Department
SELECT * FROM dbo.Employee
SELECT * FROM dbo.Salary 



