USE [MyAdventureWorksDW2019c]
GO
-- Step 1 write query and test it

	DECLARE @FirstName VARCHAR(100),
			@LastName VARCHAR(100),
			@SalesTerritoryAK INT,
			@Year CHAR(4)

	SET @FirstName = ''
	SET @LastName = ''
	SET @SalesTerritoryAK = 5
	SET @Year = '2011'

	SELECT 
		FirstName, 
		LastName, 
		EmailAddress, 
		SalesOrderNumber, 
		OrderQuantity, 
		UnitPrice, 
		TotalProductCost, 
		SalesAmount, 
		TaxAmount, 
		SalesTerritoryAK,
		SalesTerritoryName,
		OrderDateSK,
		[Year],
		[FullDate],
		[MonthName],
		[WeekOfYear],
		[CalendarQuarter]
		-- , *
	FROM Dim_Customer C
		JOIN [dbo].[Fact_InternetSales] F ON C.CustomerSK = F.CustomerSK
		JOIN dbo.Dim_SalesTerritory T ON F.SalesTerritorySK = T.SalesTerritorySK
		JOIN dbo.Dim_Date ON [OrderDateSK] = DateSK
	WHERE (FirstName = @FirstName OR @FirstName = '')
		AND (LastName = @LastName OR @LastName = '')
		AND (SalesTerritoryAK = @SalesTerritoryAK OR @SalesTerritoryAK IS NULL)
		AND ([Year] = @Year OR @Year IS NULL)




-- Step 2 create procedure 
USE [MyAdventureWorksDW2019c]
GO

	
	/*
		EXEC dbo.spGetCustomerSalesByTerritory '', '', NULL, NULL
		EXEC dbo.spGetCustomerSalesByTerritory '', '', NULL, 2011		
	*/
	ALTER PROCEDURE dbo.spGetCustomerSalesByTerritory
	(
		@FirstName VARCHAR(100),
		@LastName VARCHAR(100),
		@SalesTerritoryAK INT,
		@Year CHAR(4)
	)
	AS
	BEGIN

	SELECT 
		FirstName, 
		LastName, 
		EmailAddress, 
		SalesOrderNumber, 
		OrderQuantity, 
		UnitPrice, 
		TotalProductCost, 
		SalesAmount, 
		TaxAmount, 
		SalesTerritoryAK,
		SalesTerritoryName,
		OrderDateSK,
		[Year],
		[FullDate],
		[MonthName],
		[WeekOfYear],
		[CalendarQuarter]
		-- , *
	FROM Dim_Customer C
		JOIN [dbo].[Fact_InternetSales] F ON C.CustomerSK = F.CustomerSK
		JOIN dbo.Dim_SalesTerritory T ON F.SalesTerritorySK = T.SalesTerritorySK
		JOIN dbo.Dim_Date ON [OrderDateSK] = DateSK
		WHERE (FirstName LIKE '%' + @FirstName + '%' OR @FirstName = '')
			AND (LastName LIKE '%' + @LastName + '%' OR @LastName = '')
			AND (SalesTerritoryAK = @SalesTerritoryAK OR @SalesTerritoryAK IS NULL)
			AND ([Year] = @Year OR @Year IS NULL)
		ORDER BY FirstName, LastName

	END


GO


-- Create view and use it in stored procedure 

-- Step 3 create view


USE [MyAdventureWorksDW2019c]
GO

	ALTER VIEW dbo. vwGetCustomerSalesByTerritory 
	AS
		SELECT 
			FirstName, 
			LastName, 
			EmailAddress, 
			SalesOrderNumber, 
			OrderQuantity, 
			UnitPrice, 
			TotalProductCost, 
			SalesAmount, 
			TaxAmount, 
			SalesTerritoryAK,
			SalesTerritoryName,
			OrderDateSK,
			[Year],
			[FullDate],
			[MonthName],
			[WeekOfYear],
			[CalendarQuarter]
			-- , *
		FROM Dim_Customer C
			JOIN [dbo].[Fact_InternetSales] F ON C.CustomerSK = F.CustomerSK
			JOIN dbo.Dim_SalesTerritory T ON F.SalesTerritorySK = T.SalesTerritorySK
			JOIN dbo.Dim_Date ON [OrderDateSK] = DateSK

GO


-- Test view

	DECLARE @FirstName VARCHAR(100),
			@LastName VARCHAR(100), 
			@SalesTerritoryAK INT,
			@Year CHAR(4)

	SET @FirstName = ''
	SET @LastName = ''
	SET @SalesTerritoryAK = 10

	SELECT *
	FROM vwGetCustomerSalesByTerritory
	WHERE (FirstName LIKE '%' + @FirstName + '%' OR @FirstName = '')
			AND (LastName LIKE '%' + @LastName + '%' OR @LastName = '')
			AND (SalesTerritoryAK = @SalesTerritoryAK OR @SalesTerritoryAK IS NULL)
			AND ([Year] = @Year OR @Year IS NULL)
	ORDER BY FirstName, LastName

GO

-- Step 4 use view in stored procedure 

USE [MyAdventureWorksDW2019c]
GO

	
	/*
		EXEC dbo.spGetCustomerSalesByTerritory '', '', NULL, NULL
		EXEC dbo.spGetCustomerSalesByTerritory '', '', NULL, '2011'
		EXEC dbo.spGetCustomerSalesByTerritory 'Aa', '', NULL, NULL
	*/
	ALTER PROCEDURE dbo.spGetCustomerSalesByTerritory
	(
		@FirstName VARCHAR(100),
		@LastName VARCHAR(100),
		@SalesTerritoryAK INT,
		@Year CHAR(4)
	)
	AS
	BEGIN

		SELECT *
		FROM vwGetCustomerSalesByTerritory
		WHERE (FirstName LIKE '%' + @FirstName + '%' OR @FirstName = '')
				AND (LastName LIKE '%' + @LastName + '%' OR @LastName = '')
				AND (SalesTerritoryAK = @SalesTerritoryAK OR @SalesTerritoryAK IS NULL)
				AND ([Year] = @Year OR @Year IS NULL)
		ORDER BY FirstName, LastName

	END


GO



	

