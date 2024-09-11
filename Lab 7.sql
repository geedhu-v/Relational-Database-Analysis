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