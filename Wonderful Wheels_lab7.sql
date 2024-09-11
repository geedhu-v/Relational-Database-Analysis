--LAB 5 SCRIPTS
CREATE DATABASE WonderfulWheels

USE WonderfulWheels
GO
-- Person title should be restricted to: Mr and Ms

CREATE TABLE Location
(
LocationId INT IDENTITY (1, 1) NOT NULL,
StreetAddress VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL,
Province VARCHAR(50) NOT NULL,
PostalCode VARCHAR(50) NOT NULL,
CONSTRAINT PK_Location PRIMARY KEY (LocationId)
)
CREATE TABLE Person
(
PersonId INT IDENTITY (1000, 1) NOT NULL,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Telephone VARCHAR(50) NULL,
Email VARCHAR(50) NULL,
PerLocID INT NOT NULL,
DateOfBirth DATETIME NULL,
Title CHAR(2) NULL,
CONSTRAINT PK_Person PRIMARY KEY (PersonId),
CONSTRAINT FK_PersonLocation FOREIGN KEY (PerLocID) REFERENCES Location(LocationId),
CONSTRAINT CHK_PersonTitle CHECK (Title IN ('Mr','Ms'))
)
CREATE TABLE Dealership
(
DealershipId INT IDENTITY (1, 1) NOT NULL,
LocationID INT NOT NULL,
Name VARCHAR(50) NOT NULL,
Phone VARCHAR(50) NOT NULL,
CONSTRAINT PK_Dealership PRIMARY KEY (DealershipId),
CONSTRAINT FK_Dealership_Location FOREIGN KEY (LocationID) REFERENCES
Location(LocationId)
)


CREATE TABLE Employee
(
EmployeeId INT IDENTITY (1, 1) NOT NULL,
EmpDealID INT NOT NULL,
HireDate DATETIME NULL,
Role VARCHAR(50) NOT NULL,
ManagerID INT NULL,
CONSTRAINT PK_Employee PRIMARY KEY (EmployeeId),
CONSTRAINT PK_Employee1 FOREIGN KEY (EmployeeId) REFERENCES Person(PersonID),
CONSTRAINT FK_EmpDeal FOREIGN KEY (EmpDealID) REFERENCES
Dealership(DealershipId)
)
CREATE TABLE Customer
(
CustomerId INT IDENTITY (1, 1) NOT NULL,
RegistrationDate DATETIME NULL,
CONSTRAINT PK_Customer PRIMARY KEY (CustomerId),
CONSTRAINT PK_Customer1 FOREIGN KEY (CustomerId) REFERENCES Person(PersonID)
)
CREATE TABLE SalaryEmployee
(
EmployeeId INT IDENTITY (1, 1) NOT NULL,
salary FLOAT DEFAULT '0.00' NOT NULL,
CONSTRAINT FK_Salary FOREIGN KEY (EmployeeId) REFERENCES
Employee(EmployeeID),
CHECK (salary > 0 AND salary >=1000)
)
CREATE TABLE CommissionEmployee
(
EmployeeId INT IDENTITY (1, 1) NOT NULL,
Commission INT NOT NULL,
CONSTRAINT FK_CommissionEmployee FOREIGN KEY (EmployeeId) REFERENCES
Employee(EmployeeID),
CHECK (Commission >= 10)
)
CREATE TABLE Orders
(
OrderId INT IDENTITY (1, 1) NOT NULL,
OrderCusID INT NOT NULL,
OrdEmpID INT NOT NULL,
OrderDate DATETIME NULL,
OrdDealID INT NOT NULL,
CONSTRAINT PK_Order PRIMARY KEY (OrderId),
CONSTRAINT FK_OrderCus FOREIGN KEY (OrderCusID) REFERENCES
Customer(CustomerID),
CONSTRAINT FK_OrderEmp FOREIGN KEY (OrdEmpID) REFERENCES
Employee(EmployeeID),
CONSTRAINT FK_OrderDeal FOREIGN KEY (OrdDealID) REFERENCES
Dealership(DealershipID)
)
CREATE TABLE Order_Item
(
OrderId INT IDENTITY (1, 1) NOT NULL,
VehicleID INT NOT NULL,
FinalSalePrice FLOAT DEFAULT '0.00' NOT NULL,
CONSTRAINT PK_OrderItem PRIMARY KEY (OrderId,VehicleID),
CONSTRAINT FK_Customer1 FOREIGN KEY (OrderId) REFERENCES Orders(OrderID),
CONSTRAINT FK_Customer2 FOREIGN KEY (VehicleId) REFERENCES Vehicle(VehicleId),
CHECK (FinalSalePrice >=1)
)
CREATE TABLE Vehicle
(
VehicleId INT IDENTITY (1, 1) NOT NULL,
Make INT NOT NULL,
Model VARCHAR(50) NOT NULL,
Year DATETIME NOT NULL,
Colour VARCHAR(50) NOT NULL,
km INT NOT NULL,
Price FLOAT DEFAULT '0.00' NOT NULL,
CONSTRAINT PK_Vehicle PRIMARY KEY (VehicleId),
CHECK (Price >= 1)
)
CREATE TABLE Account
(
AccountId INT IDENTITY (1, 1) NOT NULL,
CustomerID INT NOT NULL,
AccountBalance FLOAT DEFAULT '0.00' NOT NULL,
LastPaymentAmount FLOAT NOT NULL,
LastPaymentDate DATETIME NULL,
CONSTRAINT PK_Account PRIMARY KEY (AccountId),
CONSTRAINT FK_CustomerAccount FOREIGN KEY (CustomerID) REFERENCES
Customer(CustomerID),
CHECK (AccountBalance > 0)
)
CREATE NONCLUSTERED INDEX ix_first_name
ON Person(FirstName);
CREATE NONCLUSTERED INDEX ix_last_name
ON Person(LastName);

GO

--LAB 6

BEGIN TRY
        BEGIN TRANSACTION

		-- Creating Log DataBase
		CREATE DATABASE EventLog
		USE EventLog
		CREATE TABLE DbErrorLog (
			Error_LogID INT PRIMARY KEY IDENTITY(1, 1),
			UserName VARCHAR(100),
			ErrorNumber INT,
			ErrorState INT,
			ErrorSeverity INT,
			ErrorLine INT,
			ErrorProcedure VARCHAR(100),
			ErrorMessage VARCHAR(MAX),
			ErrorDateTime DATETIME);

		USE WonderfulWheels

		--vehicles

		SET IDENTITY_INSERT Vehicle ON
		INSERT INTO Vehicle(vehicleID ,Make , Model , Year,Colour, Km , Price )
		VALUES 
		(100001,'Toyota','Corola',2018,'Silver',45000,18000),
		(100002, 'Toyota',	'Corola', 2016,'White',60000,15000),
		(100003,'Toyota' ,	'Corola', 2016,	'Black',65000,14000),
		(100004,'Toyota','Camry',2018,'White',35000,22000),
		(100005,'Honda','Acord',2020,'Gray',10000,24000),
		(100006,'Honda','Acord',2015,'Red',	85000,16000),
		(100007,'Honda','Acord',2000,'Gray',10000,40000),
		(100008,'Ford',	'Focus',2017,'Blue',40000,16000)
		SET IDENTITY_INSERT Vehicle OFF

		--Person
		SET IDENTITY_INSERT Person ON
		INSERT INTO Person (Title, FirstName, LastName, Telephone, Email, DateOfBirth,PerLocID)
		VALUES ('Mr', 'John', 'Smith', '519-444-3333', 'jsmtith@email.com', '1968-04-09',1),
				('Ms', 'Mary', 'Brown', '519-888-3333', 'mbrown@email.com', '1972-02-04',2),
				('Ms', 'Tracy', 'Spencer', '519-888-2222', 'tspencer@email.com', '1998-07-22',3),
				('Mr', 'James', 'Stewart', '416-888-1111', 'jstewart@email.com', '1996-11-22',4),
				('Mr', 'Paul', 'Newman', '519-888-4444', 'pnewman@email.com', '1992-09-23',5),
				('Mr', 'Tom', 'Cruise', '519-333-2222', 'tcruise@email.com', '1962-03-22',3),
				('Mr', 'Bette', 'Davis', '519-452-1111', 'bdavis@email.com', '1952-09-01',9),
				('Ms', 'Grace', 'Kelly', '416-887-2222', 'gkelly@email.com', '1973-06-09',10),
				('Ms', 'Doris', 'Day', '519-888-5456', 'dday@email.com', '1980-05-25',11);

		--Location
		INSERT INTO Location (StreetAddress, City, Province, PostalCode) 
		VALUES ('22 Queen St', 'Waterloo', 'Ontario', 'N2A48B'),
				('44 King St', 'Gulph', 'Ontario', 'G2A47U'),
				('55 Krug St', 'Kitchener', 'Ontario', 'N2A4U7'),
				('77 Lynn Ct', 'Toronto', 'Ontario', 'M7U4BA'),
				('55 Krug St', 'Kitchener', 'Ontario', 'N2A4U7'),
				('221 Kitng St W', 'Kitchner', 'Ontario', 'G8B3C6'),
				('77 Victoria St N', 'Campbridge', 'Ontario', 'N1Z8B8'),
				('100 White Oak Rd', 'London', 'Ontario', 'L9B1W2'),
				('88 King St', 'Gulph', 'Ontario', 'G2A47U'),
				('99 Lynn Ct', 'Toronto', 'Ontario', 'M7U4BA'),
				('44 Cedar St', 'Kitchener', 'Ontario', 'N2A7L6');

        -- Dealership

		INSERT INTO Dealership (Name,LocationID,Phone)
		VALUES('Kitchener',6,'555-111-8888'),
		('Cambridge',7,'666-111-9999'),
		('London',8,'222-333-5678');

		--Employee
		INSERT INTO Employee(EmployeeId,EmpDealID,Role)
		VALUES(1002,2,'Manager');
		INSERT INTO Employee(EmployeeId,EmpDealID,Role,ManagerID)
        VALUES(1003,2,'Office Admin',1002),
        (1004,2,'Sales',1002),
        (1005,2,'Sales',1002),
        (1006,2,'Sales',1002);

		--Salary Employee
		SET IDENTITY_INSERT  Employee OFF
		SET IDENTITY_INSERT  SalaryEmployee ON

		INSERT INTO SalaryEmployee(EmployeeId,salary)
		VALUES (1002,95000),(1003,65000);

		--Commission Employee
		SET IDENTITY_INSERT  SalaryEmployee OFF
		SET IDENTITY_INSERT  CommissionEmployee ON

		INSERT INTO CommissionEmployee (EmployeeId,Commission)
		VALUES(1004,13),(1005,15),(1006,10);

		--customer

		SET IDENTITY_INSERT  CommissionEmployee OFF
		SET IDENTITY_INSERT  Customer ON
		INSERT INTO Customer (CustomerId) VALUES (1007),(1008),(1004),(1009),(1010);

		--Orders

		SET IDENTITY_INSERT  Customer OFF
		SET IDENTITY_INSERT  Orders ON
		INSERT INTO  Orders (OrderID,OrderCusID,OrdEmpID,OrdDealID,OrderDate)
		VALUES (100,1007,1004,2,2023-04-10),(101,1008,1004,2,2023-05-11),(102,1004,1005,2,2023-05-12);

		--Order_Item

		SET IDENTITY_INSERT  Orders OFF
		SET IDENTITY_INSERT  Order_Item ON
		INSERT INTO Order_Item (OrderId,VehicleID,FinalSalePrice)
		VALUES (100,100001,17500), 
		(100,100004,21000),
		(101,100008,15000),
		(102,100006,15000);

		COMMIT Transaction
    END TRY
    BEGIN CATCH
	ROLLBACK TRANSACTION
		INSERT INTO EventLog.dbo.DbErrorLog (UserName, ErrorNumber, ErrorState, ErrorSeverity, ErrorLine, ErrorProcedure, ErrorMessage,ErrorDateTime)
		VALUES (USER_NAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE(),SYSDATETIME());
    END CATCH

--LAB 7 SCRIPTS

USE WonderfulWheels
CREATE DATABASE WonderfulWheelsDW;
-- Load Commission employee **
	SELECT 		
		IDENTITY(INT,1,1) AS EmployeeSK,
		p.PersonId AS EmployeeAK,
		p.FirstName,
		p.LastName,
		p.Email,
		p.DateOfBirth,
		p.Title,
		e.HireDate,
		e.Role AS EmpRole ,
		c.Commission,
		e.ManagerId
    INTO [WonderfulWheelsDW].[dbo].[Dim_Commission_Employee]
	FROM Person p left join Employee e on p.PersonId = e.EmployeeId
	left join CommissionEmployee c on e.EmployeeId = c.EmployeeId
	--primary key
	ALTER TABLE [WonderfulWheelsDW].[dbo].[Dim_Commission_Employee]
	ADD CONSTRAINT PK_employee PRIMARY KEY (EmployeeSK);
	-- Test 
	SELECT * FROM [WonderfulWheelsDW].[dbo].[Dim_Commission_Employee]


--Load customer
	SELECT 		
		IDENTITY(INT,1,1) AS CustomerSK,
		p.PersonId AS CustomerAK,
		p.FirstName,
		p.LastName,
		p.Email,
		p.DateOfBirth,
		p.Title,
		cus.RegistrationDate AS RegDate
    INTO [WonderfulWheelsDW].[dbo].[Dim_Customer]

	FROM Person p left join customer cus on p.PersonId = cus.CustomerId

	--primary key
	ALTER TABLE [WonderfulWheelsDW].[dbo].[Dim_Customer]
	ADD CONSTRAINT PK_customer PRIMARY KEY (CustomerSK);

	-- Test 
	SELECT * FROM [WonderfulWheelsDW].[dbo].[Dim_Customer];


--Load Vehicle

    SELECT      
        v.VehicleId AS VehicleSK,
        v.VehicleId AS VehicleAK,
        v.Make,
        v.Model,
        v.Year,
        v.Colour,
        v.Km,
        v.Price
        
    INTO [WonderfulWheelsDW].[dbo].[Dim_Vehicle]
    FROM Vehicle v

    --primary key
	ALTER TABLE [WonderfulWheelsDW].[dbo].[Dim_Vehicle]
	ADD CONSTRAINT PK_vehicle PRIMARY KEY (VehicleSK);

	-- Test 
	SELECT * FROM [WonderfulWheelsDW].[dbo].[Dim_Vehicle]



--load Dim_Dealership
    SELECT      
        IDENTITY(INT,1,1) AS DealershipSK,
        d.DealershipId AS DealershipAK,
        d.Name AS DealershipName,
        l.StreetAddress,
        l.City,
        l.Province,
        l.PostalCode
        
    INTO [WonderfulWheelsDW].[dbo].[Dim_Dealership]
    FROM Dealership d left join Location l on d.LocationID = l.LocationId

	--primary key
	ALTER TABLE [WonderfulWheelsDW].[dbo].[Dim_Dealership]
	ADD CONSTRAINT PK_dealership PRIMARY KEY (DealershipSK);

	-- Test 
	SELECT * FROM [WonderfulWheelsDW].[dbo].[Dim_Dealership]

-- Load FactSales 
    SELECT      
        o.OrderId,
		IDENTITY(INT,1,1) AS OrderItemId,
		ce.EmployeeSK,
		c.CustomerSK,
        v.vehicleSK,
        d.DealershipSK,
		oi.FinalSalePrice,
		o.OrderDate,
		ce.Commission * oi.FinalSalePrice AS Commission      
    INTO [WonderfulWheelsDW].[dbo].[Dim_FactSales]
    FROM Orders o left join Order_Item oi on o.OrderId = oi.OrderId
	left join [WonderfulWheelsDW].[dbo].[Dim_Customer] c on o.OrderCusID = c.CustomerAK
	left join [WonderfulWheelsDW].[dbo].[Dim_Commission_Employee] ce on o.OrdEmpID = ce.EmployeeAK
	left join [WonderfulWheelsDW].[dbo].[Dim_Vehicle] v on oi.VehicleID = v.VehicleSK
	left join [WonderfulWheelsDW].[dbo].[Dim_Dealership] d on o.OrdDealID = d.DealershipAK
	--primary key
	ALTER TABLE [WonderfulWheelsDW].[dbo].[Dim_FactSales]
	ADD CONSTRAINT PK_sales PRIMARY KEY (OrderId,OrderItemId);
	--Foreign key
	ALTER TABLE [WonderfulWheelsDW].[dbo].[Dim_FactSales]
	ADD CONSTRAINT FK_sales1 FOREIGN KEY (EmployeeSK) REFERENCES [WonderfulWheelsDW].[dbo].[Dim_Commission_Employee] (EmployeeSK)
	ALTER TABLE [WonderfulWheelsDW].[dbo].[Dim_FactSales]
	ADD CONSTRAINT FK_sales2 FOREIGN KEY (CustomerSK) REFERENCES [WonderfulWheelsDW].[dbo].[Dim_Customer] (CustomerSK)
	ALTER TABLE [WonderfulWheelsDW].[dbo].[Dim_FactSales]
	ADD CONSTRAINT FK_sales3 FOREIGN KEY (vehicleSK) REFERENCES [WonderfulWheelsDW].[dbo].[Dim_Vehicle] (vehicleSK)
	ALTER TABLE [WonderfulWheelsDW].[dbo].[Dim_FactSales]
    ADD CONSTRAINT FK_sales4 FOREIGN KEY (DealershipSK) REFERENCES [WonderfulWheelsDW].[dbo].[Dim_Dealership] (DealershipSK)

	-- Test 
	SELECT * FROM [WonderfulWheelsDW].[dbo].[Dim_FactSales]

--Management would like to analyse Employee Sales and Customer Orders.
--They would like to keep track of Employee Sales and Customer Orders per day, month year and Location / Dealership.

SELECT * FROM [WonderfulWheelsDW].[dbo].[Dim_FactSales];
SELECT EmployeeSK , SUM(FinalSalePrice) AS SALES,DealershipSK, OrderDate FROM [WonderfulWheelsDW].[dbo].[Dim_FactSales]
GROUP BY EmployeeSK,OrderDate,DealershipSK;


SELECT * FROM [WonderfulWheelsDW].[dbo].[Dim_FactSales];
SELECT CustomerSK ,COUNT(OrderId) AS 'Number of Orders', OrderDate,DealershipSK  FROM [WonderfulWheelsDW].[dbo].[Dim_FactSales]
GROUP BY CustomerSK,OrderDate,DealershipSK;
