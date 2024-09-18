
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
		INSERT INTO  Orders (OrderID,OrderCusID,OrdEmpID,OrdDealID)
		VALUES (100,1007,1004,2),(101,1008,1004,2),(102,1004,1005,2);

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

--1) Display all dealerships
select * from Dealership

--2) Display all inventory/vehicles. Sort data by price where most expensive car is on the top. 
select * from Vehicle order by Price desc;

--3) Display all customers. Order data by first then last name in ascending order. 
SELECT * FROM CUSTOMER C JOIN PERSON P ON C.CustomerId=P.PersonId order by P.FirstName,P.LastName asc;

--4) Display all employees. Order data by first then last name in ascending order.
SELECT * FROM EMPLOYEE E JOIN PERSON P ON E.EmployeeId=P.PersonId order by P.FirstName,P.LastName asc;

--5) Display all addresses , Sort data by city.
SELECT * FROM LOCATION order by City desc;

--6) Update Tracy Spencer commission. Set it to 9. Based on requirements from lab 5 you should not be able to do this.

--THIS SHOULDNT WORK AS WE HAVE GIVEN CHECK CONSTRAINT
UPDATE CommissionEmployee 
SET Commission = 9
WHERE EmployeeId = 1004;

--7) Update Tracy Spencer title to “Mz”. Based on requirements from lab 5 you should not be able to do this

UPDATE Person
SET Title = 'Mz'
WHERE PersonId = 1004;

--8) Display vehicles that are not sold. These vehicles will be listed on dealership web site. 
--Customers should be able to search only available vehicles.

SELECT * FROM Vehicle where VehicleId not in (select VehicleId from Order_Item);

--9) Display employee sales info. Include all employees including those who did not sell any cars. Dealership, 
--Employee Name, Employee Manger (Bonus), Customer name, Phone, Email, Date of Birth, Age, 
--Address (Street, City, Province, and postal code) and Car info (Make, Model, Year, Color, Mileage and Final Sales Price).
select D.Name,concat(P.Firstname,' ', P.LastName) as EmployeeName,E.ManagerID,CE.Commission,
concat(P.Firstname,' ', P.LastName) as CustomerName,P.Telephone,P.Email,P.DateOfBirth,
DATEDIFF(YY,p.DateOfBirth,GETDATE()) as Age,
L.StreetAddress as Street,L.City,L.Province,L.PostalCode,
V.Make,V.Model,V.Year,V.Colour,V.km as Milege,Ot.FinalSalePrice
from Employee E Left join Person P on E.EmployeeId = P.PersonId
Left join CommissionEmployee CE on E.EmployeeId = CE.EmployeeId
Left join Customer C on C.CustomerId = P.PersonId
Left join Location L on L.LocationId=P.PerLocID
Left join Dealership D on D.Name = L.City
Left join Orders O on E.EmployeeId = O.OrdEmpID
Left join Order_Item OT on O.OrderId = OT.OrderId
Left join Vehicle V on OT.VehicleID = V.VehicleId 

