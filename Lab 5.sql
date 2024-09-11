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
		LastName VARCHAR(50)  NOT NULL,
		Telephone INT NULL,
		Email VARCHAR(50) NULL,
		PerLocID INT NOT NULL,
		DateOfBirth DATETIME NULL,
		Title CHAR(2) NULL,		
		CONSTRAINT PK_Person PRIMARY KEY (PersonId),
		CONSTRAINT FK_Location FOREIGN KEY (PerLocID) REFERENCES Location(LocationId),
		CONSTRAINT CHK_PersonTitle CHECK (Title IN ('Mr', 'Ms'))
	)

CREATE TABLE Dealership
	(
		DealershipId INT IDENTITY (1, 1) NOT NULL,
		LocationID INT NOT NULL,
		Name VARCHAR(50) NOT NULL,
		Phone INT NOT NULL,		
		CONSTRAINT PK_Dealership PRIMARY KEY (DealershipId),
		CONSTRAINT FK_Location_D FOREIGN KEY (LocationID) REFERENCES Location(LocationId)
	)

CREATE TABLE Employee
	(
		EmployeeId INT IDENTITY (1, 1) NOT NULL,
		EmpDealID INT NOT NULL,
		HireDate DATETIME NOT NULL,
		Role VARCHAR(50) NOT NULL,	
		ManagerID INT NOT NULL,
		CONSTRAINT PK_Employee PRIMARY KEY (EmployeeId),
		CONSTRAINT FK_EmpDeal FOREIGN KEY (EmpDealID) REFERENCES Dealership(DealershipId)
	)

CREATE TABLE Customer
	(
		CustomerId INT IDENTITY (1, 1) NOT NULL,
		RegistrationDate DATETIME NOT NULL,
		CONSTRAINT PK_Customer PRIMARY KEY (CustomerId)
	)
CREATE TABLE SalaryEmployee
	(
		EmployeeId INT IDENTITY (1, 1) NOT NULL,
		salary FLOAT DEFAULT '0.00' NOT NULL,
		CONSTRAINT FK_Salary FOREIGN KEY (EmployeeId) REFERENCES Employee(EmployeeID),
		CHECK (salary>0 AND salary >=1000)
	)

CREATE TABLE CommissionEmployee
	(
		EmployeeId INT IDENTITY (1, 1) NOT NULL,
		Commission INT NOT NULL,
		CONSTRAINT FK_CommissionEmployee FOREIGN KEY (EmployeeId) REFERENCES Employee(EmployeeID),
		CHECK (Commission >= 10)
	)
CREATE TABLE Orders
    (
		OrderId INT IDENTITY (1, 1) NOT NULL,
		OrderCusID INT NOT NULL,
		OrdEmpID INT NOT NULL,
		OrderDate DATETIME NOT NULL,
		OrdDealID INT NOT NULL,
		CONSTRAINT PK_Order PRIMARY KEY (OrderId),
		CONSTRAINT FK_OrderCus FOREIGN KEY (OrderCusID) REFERENCES Customer(CustomerID),
		CONSTRAINT FK_OrderEmp FOREIGN KEY (OrdEmpID) REFERENCES Employee(EmployeeID),
		CONSTRAINT FK_OrderDeal FOREIGN KEY (OrdDealID) REFERENCES Dealership(DealershipID)
	)

CREATE TABLE Order_Item
	(
		OrderId INT IDENTITY (1, 1) NOT NULL,
		VehicleID INT NOT NULL,
		FinalSalePrice FLOAT DEFAULT '0.00' NOT NULL,
		CONSTRAINT PK_Order PRIMARY KEY (OrderId,VehicleID),
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
		CONSTRAINT FK_CustomerAccount FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
		CHECK (AccountBalance > 0)
	)

CREATE NONCLUSTERED INDEX ix_first_name
ON Person(FirstName);  
CREATE NONCLUSTERED INDEX ix_last_name
ON Person(LastName);  

GO