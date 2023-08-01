--- MSTR Testing --

Select * 
from DimTime;

select *
from DimCustomer

select *
from FactInternetSales

	Select t.CalendarYear,sum(s.SalesAmount) as Revenue ,sum(s.SalesAmount - s.TotalProductCost) as Profit 
	from FactInternetSales s
	join DimTime t
	on s.OrderDateKey = t.TimeKey
	group by t.CalendarYear
	order by 1;

	select t.CalendarYear,count(distinct s.SalesOrderNumber)
	from FactInternetSales s
	join DimTime t
	on s.OrderDateKey = t.TimeKey
	group by t.CalendarYear
	order by 1;

	select c.Gender,sum(s.SalesAmount - s.TotalProductCost) as Profit 
	from FactInternetSales s
	join DimCustomer c
	on s.CustomerKey = c.CustomerKey
	group by c.Gender

	select * 
	from DimCustomer
	where YearlyIncome > 150000

	select *
	from DimTime
------------------------------------------- Page 1 ----------------------------------------------------------------------------
-- KPI --
	--Revenue--
	with ct1 as
	(
	Select t.CalendarYear as Years ,sum(s.SalesAmount) as Revenue 
	from FactInternetSales s
	join DimTime t
	on s.OrderDateKey = t.TimeKey
	group by t.CalendarYear
	)
	select ct1.years as TY, ct1.Revenue as [TY Revenue], (ct1.Revenue - ct2.Revenue)*100/ct2.Revenue as Growth
	from ct1 
	join ct1 ct2
	on ct1.Years = ct2.Years + 1
	where ct1.years = 2016;

	-- Profit --
	with ct1 as
	(
	Select t.CalendarYear as Years ,sum(s.SalesAmount - s.TotalProductCost) as Profit 
	from FactInternetSales s
	join DimTime t
	on s.OrderDateKey = t.TimeKey
	group by t.CalendarYear
	)
	select ct1.years as TY, ct1.Profit as Profit, (ct1.Profit - ct2.Profit)*100/ct2.Profit as Growth
	from ct1 
	join ct1 ct2
	on ct1.Years = ct2.Years + 1
	where ct1.years = 2016;

	-- No of orders -- 

	with ct1 as
	(
	Select t.CalendarYear as Years ,count(distinct s.SalesOrderNumber) as OrderNo
	from FactInternetSales s
	join DimTime t
	on s.OrderDateKey = t.TimeKey
	group by t.CalendarYear
	)
	select ct1.years as TY, ct1.OrderNo as OrderNo, cast((ct1.OrderNo - ct2.OrderNo) as decimal(7,2))*100/cast(ct2.OrderNo as decimal(7,2)) as Growth
	from ct1 
	join ct1 ct2
	on ct1.Years = ct2.Years + 1
	where ct1.years = 2016;

-- Visuals --

	-- Sales and Profit by Category --
	select c.EnglishProductCategoryName as Category, sum(s.SalesAmount) as Sales, sum(s.SalesAmount - s.TotalProductCost) as profit
	from FactInternetSales s
	join DimProduct p
	on s.ProductKey = p.ProductKey
	join DimProductGroup g
	on p.ProductGroupKey = g.ProductGroupKey
	join DimProductSubcategory sc
	on sc.ProductSubcategoryKey = g.ProductSubcategoryKey
	join DimProductCategory c
	on c.ProductCategoryKey = sc.ProductCategoryKey
	join DimTime t
	on t.TimeKey = s.OrderDateKey
	where t.CalendarYear = 2016
	group by c.EnglishProductCategoryName
	order by 3 desc;

	-- Sales and Profit by sub category -- 

	select sc.EnglishProductSubcategoryName as SubCategory, sum(s.SalesAmount) as Sales, sum(s.SalesAmount - s.TotalProductCost) as profit
	from FactInternetSales s
	join DimProduct p
	on s.ProductKey = p.ProductKey
	join DimProductGroup g
	on p.ProductGroupKey = g.ProductGroupKey
	join DimProductSubcategory sc
	on sc.ProductSubcategoryKey = g.ProductSubcategoryKey
	join DimProductCategory c
	on c.ProductCategoryKey = sc.ProductCategoryKey
	join DimTime t
	on t.TimeKey = s.OrderDateKey
	where t.CalendarYear = 2016 and c.EnglishProductCategoryName = 'Bikes'
	group by sc.EnglishProductSubcategoryName
	order by 3 desc;

	-- Monthly Trend for KPIs --

	
	select t.CalendarYear, max(t.EnglishMonthName) as Months , sum(s.SalesAmount) as Sales, sum(s.SalesAmount - s.TotalProductCost) as profit, count(distinct s.SalesOrderNumber) as [No of Orders]
	from FactInternetSales s
	join DimTime t
	on t.TimeKey = s.OrderDateKey
	where t.CalendarYear = 2016 
	group by t.CalendarYear, t.MonthNumberOfYear
	order by t.MonthNumberOfYear;

	-- Product Info Window --

	select max(p.EnglishProductName) as Product , sum(s.SalesAmount) as Sales
	from FactInternetSales s
	join DimProduct p
	on s.ProductKey = p.ProductKey
	join DimProductGroup g
	on p.ProductGroupKey = g.ProductGroupKey
	join DimProductSubcategory sc
	on sc.ProductSubcategoryKey = g.ProductSubcategoryKey
	join DimTime t
	on t.TimeKey = s.OrderDateKey
	where t.CalendarYear = 2016 and sc.EnglishProductSubcategoryName = 'Mountain Bikes'
	group by p.ProductKey
	order by 1;

------------------------------------------------------------------------------------------------------------------------------




--------------------------------------- Page 2 --------------------------------------------------------------------------------
	-- top customer and order no kpi --
	select top 1 max(c.FirstName) as FirstName,max(c.LastName) as LastName,count(distinct s.SalesOrderNumber) as Ordernumbers
	from FactInternetSales s
	join DimCustomer c
	on s.CustomerKey = c.CustomerKey
	join DimTime t
	on t.TimeKey = s.OrderDateKey
	where t.CalendarYear = 2016
	group by c.CustomerKey
	order by 3  desc;
	 

	 -- Sales amount --

	select top 1 max(c.FirstName) as FirstName,max(c.LastName) as LastName,sum(s.SalesAmount) as Sales
	from FactInternetSales s
	join DimCustomer c
	on s.CustomerKey = c.CustomerKey
	join DimTime t
	on t.TimeKey = s.OrderDateKey
	where t.CalendarYear = 2016
	group by c.CustomerKey
	order by count(distinct s.SalesOrderNumber)  desc;

	-- Orders by occupation--

	select c.EnglishOccupation,count(distinct s.SalesOrderNumber) as Ordernumbers
	from FactInternetSales s
	join DimCustomer c
	on s.CustomerKey = c.CustomerKey
	join DimTime t
	on t.TimeKey = s.OrderDateKey
	where t.CalendarYear = 2016
	group by c.EnglishOccupation
	order by 2 desc;

	select c.EnglishOccupation,sum(s.SalesAmount) as Sales
	from FactInternetSales s
	join DimCustomer c
	on s.CustomerKey = c.CustomerKey
	join DimTime t
	on t.TimeKey = s.OrderDateKey
	where t.CalendarYear = 2016
	group by c.EnglishOccupation
	order by 2 desc;



	---- Orders by income --

	select case when yearlyincome > '150000' then 'very high'
	when yearlyincome > '100000' then 'high'
	when yearlyincome > '50000' then 'average'
	else 'low'
	end as [income level],
	count(distinct(salesordernumber)) [orders]
	from dimtime dt
	inner join factinternetsales fs
	on dt.timekey=fs.orderdatekey
	inner join dimcustomer dc
	on fs.customerkey=dc.customerkey
	where calendaryear=2016
	group by 
	case when yearlyincome > '150000' then 'very high'
	when yearlyincome > '100000' then 'high'
	when yearlyincome > '50000' then 'average'
	else 'low' end
	order by 2 desc


	select case when yearlyincome > '150000' then 'very high'
	when yearlyincome > '100000' then 'high'
	when yearlyincome > '50000' then 'average'
	else 'low'
	end as [income level],
	sum(salesamount) [revenue]
	from dimtime dt
	inner join factinternetsales fs
	on dt.timekey=fs.orderdatekey
	inner join dimcustomer dc
	on fs.customerkey=dc.customerkey
	where calendaryear=2016
	group by 
	case when yearlyincome > '150000' then 'very high'
	when yearlyincome > '100000' then 'high'
	when yearlyincome > '50000' then 'average'
	else 'low' end
	order by 2 desc




	---


	select case when Year(GETDATE())- year(BirthDate) between 40 and 55 then '40 to 55'
	when year(getdate())- year(birthdate) between 56 and 70 then '56 to 70'
	when year(getdate())- year(birthdate) between 71 and 85 then '71 to 85'
	when year(getdate())- year(birthdate) between 86 and 100 then '86 to 100'
	else 'above 100'
	end as [age group], 
	sum(salesamount) as sales,
	count(distinct(salesordernumber)) as orders
	from dimtime dt
	inner join factinternetsales fs
	on dt.timekey=fs.orderdatekey
	inner join dimcustomer dc
	on fs.customerkey=dc.customerkey
	where calendaryear=2016
	group by (
	case when year(getdate())- year(birthdate) between 40 and 55 then '40 to 55'
	when year(getdate())- year(birthdate) between 56 and 70 then '56 to 70'
	when year(getdate())- year(birthdate) between 71 and 85 then '71 to 85'
	when year(getdate())- year(birthdate) between 86 and 100 then '86 to 100'
	else 'above 100'
	end)
	order by 1

	-- Order and revenue by customer --

	select max(concat(c.FirstName,' ',c.LastName)) as names ,count(distinct(salesordernumber)) as orders,sum(s.SalesAmount) as Sales
	from FactInternetSales s
	join DimCustomer c
	on s.CustomerKey = c.CustomerKey
	join DimTime t
	on t.TimeKey = s.OrderDateKey
	where t.CalendarYear = 2016
	group by c.CustomerKey
	order by 3 desc;

		-- Orders by gender--

	select c.Gender,count(distinct s.SalesOrderNumber) as Ordernumbers
	from FactInternetSales s
	join DimCustomer c
	on s.CustomerKey = c.CustomerKey
	join DimTime t
	on t.TimeKey = s.OrderDateKey
	where t.CalendarYear = 2016
	group by c.Gender
	order by 2 desc;

	select c.Gender,sum(s.SalesAmount) as Sales
	from FactInternetSales s
	join DimCustomer c
	on s.CustomerKey = c.CustomerKey
	join DimTime t
	on t.TimeKey = s.OrderDateKey
	where t.CalendarYear = 2016
	group by c.Gender
	order by 2 desc;



	select *
	from DimProduct
	where EnglishProductName like 'Mountain-100%'


	select concat(FirstName,' ',case 
									when MiddleName is null then 'NULL'
									else MiddleName
								end
									,' ',
							LastName)
	from DimCustomer


	select t.CalendarYear,max(p.EnglishProductName) as [Product Name],sum(s.SalesAmount) as Sales
	from FactInternetSales s
	join DimProduct p
	on s.ProductKey = p.ProductKey
	join DimProductGroup g
	on p.ProductGroupKey = g.ProductGroupKey
	join DimProductSubcategory sc
	on sc.ProductSubcategoryKey = g.ProductSubcategoryKey
	join DimTime t
	on t.TimeKey = s.OrderDateKey
	where sc.EnglishProductSubcategoryName = 'Mountain Bikes'
	group by p.ProductKey,t.CalendarYear
	order by 2 asc, 1;


	select * 
	from DimProductSubcategory
	where ProductCategoryKey = 162

	select *
	from DimProductCategory


	
	Select t.CalendarYear,sum(s.SalesAmount) as Revenue 
	from FactInternetSales s
	join DimTime t
	on s.OrderDateKey = t.TimeKey
	group by t.CalendarYear
	order by 1;

	Select t.MonthKey,sum(s.SalesAmount) as Revenue, sum(s.SalesAmount - s.TotalProductCost) as profit, count(distinct s.SalesOrderNumber) as [No of Orders]
	from FactInternetSales s
	join DimTime t
	on s.OrderDateKey = t.TimeKey
	where t.CalendarYear = 2016
	group by t.MonthKey	
	order by 1;


	select max(c.FirstName) as fNames,max(c.LastName) as LNames ,sum(s.SalesAmount) as Sales ,count(distinct s.SalesOrderNumber) as Orders
	from FactInternetSales s
	join DimCustomer c
	on s.CustomerKey = c.CustomerKey 
	join DimTime t
	on t.TimeKey = s.OrderDateKey
	where t.CalendarYear = 2016
	group by c.CustomerKey
	order by 4 desc

	select c.Gender,sum(s.SalesAmount)
	from FactInternetSales s
	 join DimCustomer c
	 on s.CustomerKey = c.CustomerKey
	 group by c.Gender;


	 select *
	 from ViewMonth


-- to find relationship --

	 select max(pg.EnglishProductGroupName) as [Group Name],count(distinct p.ProductKey) as [No. of products]
	 from DimProduct p
	 full outer join DimProductGroup pg
	 on p.ProductGroupKey = pg.ProductGroupKey
	 group by pg.ProductGroupKey
	 order by 2 desc;


	 select max(p.EnglishProductName) as [Product Name],count(distinct pg.ProductGroupKey) as [No. of product group]
	 from DimProduct p
	 full outer join DimProductGroup pg
	 on p.ProductGroupKey = pg.ProductGroupKey
	 group by p.ProductKey
	 order by 2 desc;


	 join DimProductSubcategory psc
	 


	 select * 
	 from DimProductGroup

	 select *
	 from INFORMATION_SCHEMA.CHECK_CONSTRAINTS

	 select *
	 from INFORMATION_SCHEMA.

	 exec sp_help 'dbo.dimcustomer'

	 select rs.CalendarYear,rs.Product,rs.sales,rs.ranks
	 from(
	 select t.CalendarYear,max(ps.EnglishProductSubcategoryName) as Product, sum(s.salesamount) as sales,rank() over (partition by t.CalendarYear order by sum(salesamount) desc) as ranks
	 from FactInternetSales s
	 join DimTime t
	 on t.TimeKey = s.OrderDateKey
	 join DimProduct p
	 on p.ProductKey = s.ProductKey
	 join DimProductGroup pg
	 on p.ProductGroupKey = pg.ProductGroupKey
	 join DimProductSubcategory ps
	 on pg.ProductSubcategoryKey = ps.ProductSubcategoryKey
	 group by t.CalendarYear,ps.ProductSubcategoryKey
	 )rs
	 where rs.ranks <5


	 select *
	 from DimCustomer

	 with ct1 as
	(
	select MonthKey,ProductKey,sum(ClosingInventory) as closingi
	from FactInventory
	group by MonthKey,ProductKey
	)
	select max(t.CalendarYear) as years,max(t.EnglishMonthName) as months,max(p.EnglishProductName) as product,max(ct1.closingi) as closinginventory
	from ct1 
	join DimProduct p
	on ct1.ProductKey = p.ProductKey 
	join DimTime t
	on t.MonthKey = ct1.MonthKey
	where ct1.ProductKey = 20824
	group by ct1.MonthKey,ct1.ProductKey
	order by ct1.MonthKey;