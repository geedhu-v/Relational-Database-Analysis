USE [MyAdventureWorksDW2019c]
GO

	SELECT NULL AS SalesTerritoryAK, '' AS SalesTerritoryName
	UNION 
	SELECT SalesTerritoryAK, SalesTerritoryName 
	FROM dbo.Dim_SalesTerritory
	ORDER BY SalesTerritoryName