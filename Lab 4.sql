use AdventureWorks2019
GO

-- Q1. Display all columns of all products.

select * from Production.Product

-- Q2. Display primary key, product name, number, list price of all products.

select ProductID,Name,ProductNumber,ListPrice from Production.Product

-- Q3. Display product id, product name, number, list price of all products 
--where list price is $0 .00.

select ProductID,Name,ProductNumber,ListPrice from Production.Product where ListPrice = 0.00

-- Q4. Display product id, product name, number, list price of all products 
--where list price greater than $0 but less then $10.

select ProductID,Name,ProductNumber,ListPrice from Production.Product 
where ListPrice > 0.00 and ListPrice < 10.00

-- Q5. Display product id, product name, number, list price of all products 
--where list price either 9.5 or 2.29

select ProductID,Name,ProductNumber,ListPrice from Production.Product 
where ListPrice = 9.50 or ListPrice = 2.29

-- Q6. Concatenate Last Name, First Name and Middle Name from the Person table with
--appropriate commas and spaces between the data.

select concat(LastName,', ',FirstName,', ',MiddleName) as FullName from Person.Person

-- Q7. Display distinct job titles from employee table and sort them in descending order.

select distinct JobTitle from HumanResources.Employee order by JobTitle desc

-- Q8. Display employee id as “ID”, job title as “Job Title” and HireDate as “Date Hired”

select LoginID as ID,JobTitle as  "Job Title",HireDate as "Date Hired" from HumanResources.Employee

-- Q9. Display employee last and first name as “Employee Name”, job title as “Job Title”, 
--hire date as “Date Hired” and sort data by last then first name.

select concat(P.LastName,', ',P.FirstName) as "Employee Name",E.JobTitle as "Job title",
E.HireDate as "Date Hired" from Person.Person P join HumanResources.Employee E 
on P.BusinessEntityID = E.BusinessEntityID order by p.LastName,p.FirstName

-- Q10. Display employee name, job title and Age

select concat(LastName,', ',FirstName,', ',MiddleName) as "Employee Name",JobTitle,
DATEDIFF(YY,BirthDate,getdate()) as Age
from Person.Person P join HumanResources.Employee E on P.BusinessEntityID = E.BusinessEntityID

-- Q11. Display only one employee who has the most vacation hours. Display employee name, 
--job title and vacation hours.

select TOP 1 concat(LastName,', ',FirstName,', ',MiddleName) as "Employee Name",JobTitle, 
VacationHours
from Person.Person P join HumanResources.Employee E on P.BusinessEntityID = E.BusinessEntityID
order by VacationHours desc

-- Q12. Display the number of sales territories as “Number of Sales Territories”.
select count(TerritoryID) as "Number of Sales Territories" from Sales.SalesTerritory

-- Q13. Add up the sales year to date for all sales territories and display as “Sum of All Sales”.

select sum(SalesYTD) as "Sum of ALL Sales" from Sales.SalesTerritory

-- Q14. Display sum of all SalesYTD sales as “Sum of All Sales”, average sale as “Average Sale”,
--minimum sale as “Minimum Sale” and maximum sale as “Maximum Sale”.

select sum(SalesYTD) as "Sum of ALL Sales", avg(SalesYTD) as "Average Sale",
min(SalesYTD) as "Minimum Sale",max(SalesYTD) as "Maximum Sale" from Sales.SalesTerritory

-- Q15. Insert a new CountryRegion record in [Person].[CountryRegion]. Display new region that has been inserted.

insert into Person.CountryRegion (CountryRegionCode,Name) Values ('AND','Andaman and Nicobar Islands');

select * from Person.CountryRegion where CountryRegionCode = 'AND'

-- Q16.Update new country region. Display new region that has been updated.

update Person.CountryRegion set Name = 'Andaman' where Name = 'Andaman and Nicobar Islands'

select * from Person.CountryRegion where CountryRegionCode = 'AND'

-- Q17. Delete new country region. Display results of query that shows 
--that new region does not exist anymore.

DELETE FROM Person.CountryRegion where CountryRegionCode = 'AND'

select * from Person.CountryRegion where CountryRegionCode = 'AND'

--Q18. Display the current date and time as “Current date and time”.

SELECT GETDATE() AS "Current Date and Time"


--Q19. Display the current month only as “Current month”

SELECT MONTH(GETDATE()) AS "Current Month"


-- Q20. Display today’s date one year from now.

SELECT DATEADD(YEAR,+1,GETDATE()) AS "Today's date one year from now"


GO