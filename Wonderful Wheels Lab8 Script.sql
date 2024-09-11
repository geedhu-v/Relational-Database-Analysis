/*
SELECT e.FirstName + e.LastName AS Employee_Name, e.Email,DATEDIFF(YY,e.DateOfBirth,GETDATE()) as Age, 
e.HireDate,
DATEDIFF(YY,e.HireDate,GETDATE()) as Years_of_service,e.Commission AS Commission_Percentage,
f.Commission as Sale_Commission,
c.FirstName+c.LastName as Customer_Name,c.RegDate as Customer_Registration_Date, c.Title,
d.DealershipName,d.StreetAddress as Dealership_Street_Address,d.City as Dealership_City,
d.Province as Dealership_Province,v.Make as Vehicle_Make,v.Model,v.Year,v.Km,v.Price,
f.FinalSalePrice,YEAR(f.OrderDate) AS Sales_Year,
DATEPART(QUARTER,f.OrderDate) as Quarter, MONTH(f.OrderDate) as Month
FROM Dim_Commission_Employee e left join Dim_FactSales f on f.EmployeeSK = e.EmployeeSK
left join Dim_Customer c on f.CustomerSK = c.CustomerSK
left join Dim_Dealership d on f.DealershipSK = d.DealershipSK
left join Dim_Vehicle v on f.vehicleSK = v.VehicleSK;
*/

USE WonderfulWheelsDW
GO
--Test 1
-- Step 1 Create procedure

    ALter PROCEDURE spGetCommissionEmployee
	(
	 @FirstName VARCHAR(50),
	 @LastName VARCHAR(50),
	@DealershipCity VARCHAR(50),
	@Commission_Percentage VARCHAR(50)
	)
	AS
	BEGIN
	   SELECT e.FirstName + e.LastName AS Employee_Name, e.Email,DATEDIFF(YY,e.DateOfBirth,GETDATE()) as Age, 
              e.HireDate,DATEDIFF(YY,e.HireDate,GETDATE()) as Years_of_service,e.Commission AS Commission_Percentage,
              f.Commission as Sale_Commission,c.FirstName+c.LastName as Customer_Name,c.RegDate as Customer_Registration_Date, c.Title,
              d.DealershipName,d.StreetAddress as Dealership_Street_Address,d.City as Dealership_City,
              d.Province as Dealership_Province,v.Make as Vehicle_Make,v.Model,v.Year,v.Km,v.Price,
              f.FinalSalePrice,YEAR(f.OrderDate) AS Sales_Year,DATEPART(QUARTER,f.OrderDate) as Quarter, 
			  MONTH(f.OrderDate) as Month
              FROM Dim_Commission_Employee e left join Dim_FactSales f on f.EmployeeSK = e.EmployeeSK
              left join Dim_Customer c on f.CustomerSK = c.CustomerSK
              left join Dim_Dealership d on f.DealershipSK = d.DealershipSK
              left join Dim_Vehicle v on f.vehicleSK = v.VehicleSK
			  where (e.FirstName + e.LastName = @FirstName + @Lastname OR @FirstName + @Lastname = '')
			 AND (d.City = @DealershipCity OR @DealershipCity = '')
		AND (e.Commission = @Commission_Percentage OR @Commission_Percentage = '')

END

-- CREATE VIEW
GO
  CREATE VIEW dbo.vwCommissionEmployee
   AS
   SELECT e.FirstName + e.LastName AS Employee_Name, e.Email,DATEDIFF(YY,e.DateOfBirth,
	     GETDATE()) as Age, e.HireDate,DATEDIFF(YY,e.HireDate,GETDATE()) as Years_of_service,e.Commission AS Commission_Percentage,
         f.Commission as Sale_Commission,c.FirstName+c.LastName as Customer_Name,c.RegDate as Customer_Registration_Date, c.Title,
         d.DealershipName,d.StreetAddress as Dealership_Street_Address,d.City as Dealership_City,
        d.Province as Dealership_Province,v.Make as Vehicle_Make,v.Model,v.Year,v.Km,v.Price,
        f.FinalSalePrice,YEAR(f.OrderDate) AS Sales_Year,
        DATEPART(QUARTER,f.OrderDate) as Quarter, MONTH(f.OrderDate) as Month
        FROM Dim_Commission_Employee e left join Dim_FactSales f on f.EmployeeSK = e.EmployeeSK
        left join Dim_Customer c on f.CustomerSK = c.CustomerSK
    left join Dim_Dealership d on f.DealershipSK = d.DealershipSK
    left join Dim_Vehicle v on f.vehicleSK = v.VehicleSK;

SELECT * FROM vwCommissionEmployee;
select * from dbo.Dim_Dealership;

-- Test View
GO
DECLARE @DealershipCity VARCHAR(50),
        @Commission_Percentage INT,
		@FirstName VARCHAR(50),
	    @LastName VARCHAR(50)
	    
		SET @DealershipCity = ''
		SET @Commission_Percentage = ''
		SET @FirstName = ''
		SET @LastName = ''

	SELECT * FROM dbo.vwCommissionEmployee
	WHERE  (Dealership_City = @DealershipCity OR @DealershipCity = '')
	AND (Commission_Percentage = @Commission_Percentage OR @Commission_Percentage = '')
	AND (Employee_Name = (@FirstName + @LastName) OR (@FirstName + @LastName) = '')
	
GO
-- Test View inside Procedure
GO
ALter PROCEDURE spGetCommissionEmployee
(
        @DealershipCity VARCHAR(50),
        @Commission_Percentage INT,
		@FirstName VARCHAR(50),
	    @LastName VARCHAR(50)
 ) 
 AS
 BEGIN
 	SELECT * FROM dbo.vwCommissionEmployee
	WHERE  (Dealership_City = @DealershipCity OR @DealershipCity = '')
	AND (Commission_Percentage = @Commission_Percentage OR @Commission_Percentage = '')
	AND (Employee_Name = (@FirstName + @LastName) OR ((@FirstName + @LastName) = ''))
 END	

 -- Test 1
EXEC spGetCommissionEmployee '', '', '',''
--  Test 2
EXEC spGetCommissionEmployee 'Campbridge', '', '',''
-- Test 3
EXEC spGetCommissionEmployee '', '', 'Paul','Newman'