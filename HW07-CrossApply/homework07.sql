/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "05 - Операторы CROSS APPLY, PIVOT, UNPIVOT".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Требуется написать запрос, который в результате своего выполнения 
формирует сводку по количеству покупок в разрезе клиентов и месяцев.
В строках должны быть месяцы (дата начала месяца), в столбцах - клиенты.

Клиентов взять с ID 2-6, это все подразделение Tailspin Toys.
Имя клиента нужно поменять так чтобы осталось только уточнение.
Например, исходное значение "Tailspin Toys (Gasport, NY)" - вы выводите только "Gasport, NY".
Дата должна иметь формат dd.mm.yyyy, например, 25.12.2019.

Пример, как должны выглядеть результаты:
-------------+--------------------+--------------------+-------------+--------------+------------
InvoiceMonth | Peeples Valley, AZ | Medicine Lodge, KS | Gasport, NY | Sylvanite, MT | Jessie, ND
-------------+--------------------+--------------------+-------------+--------------+------------
01.01.2013   |      3             |        1           |      4      |      2        |     2
01.02.2013   |      7             |        3           |      4      |      2        |     1
-------------+--------------------+--------------------+-------------+--------------+------------
*/

WITH CTE_TailSpinCustoms
AS
	(SELECT 
		REPLACE(RIGHT(s_c.CustomerName, len(s_c.CustomerName) - charindex('(',s_c.CustomerName)),')','') as CustomerDescr,
		DATEADD(DD, 1 - DATEPART(DD,s_i.InvoiceDate), s_i.InvoiceDate) as InvoiceMonth,
		s_i.InvoiceID as InvoiceID
	FROM
		Sales.Customers s_c
		JOIN Sales.Invoices s_i
			ON s_c.CustomerID = s_i.CustomerID
	WHERE
		s_c.CustomerID between 2 and 6)
SELECT
	FORMAT(PVT_TotalSales.InvoiceMonth, 'dd.MM.yyyy') as InvoiceMonth,
	PVT_TotalSales.[Peeples Valley, AZ] as [Peeples Valley, AZ],
	PVT_TotalSales.[Medicine Lodge, KS] as [Medicine Lodge, KS],
	PVT_TotalSales.[Gasport, NY] as [Gasport, NY],
	PVT_TotalSales.[Sylvanite, MT] as [Sylvanite, MT],
	PVT_TotalSales.[Jessie, ND] as [Jessie, ND]
FROM
	CTE_TailSpinCustoms
	PIVOT (COUNT(InvoiceID) FOR CustomerDescr in(
			[Peeples Valley, AZ],
			[Medicine Lodge, KS],
			[Gasport, NY],
			[Sylvanite, MT],
			[Jessie, ND])
		) AS PVT_TotalSales
ORDER BY PVT_TotalSales.InvoiceMonth;

--Обычно вместо этого пользовались чем-то подобным (альтернативный вариант, без PIVOT)
SELECT 
	DATEADD(DD, 1 - DATEPART(DD,s_i.InvoiceDate), s_i.InvoiceDate) as InvoiceMonth,
	sum(CASE WHEN s_c.CustomerName = 'Tailspin Toys (Peeples Valley, AZ)' then 1 else 0 end) as [Peeples Valley, AZ],
	sum(CASE WHEN s_c.CustomerName = 'Tailspin Toys (Medicine Lodge, KS)' then 1 else 0 end) as [Medicine Lodge, KS],
	sum(CASE WHEN s_c.CustomerName = 'Tailspin Toys (Gasport, NY)' then 1 else 0 end) as [Gasport, NY],
	sum(CASE WHEN s_c.CustomerName = 'Tailspin Toys (Sylvanite, MT)' then 1 else 0 end) as [Sylvanite, MT],
	sum(CASE WHEN s_c.CustomerName = 'Tailspin Toys (Jessie, ND)' then 1 else 0 end) as [Jessie, ND]
FROM
		Sales.Customers s_c
		JOIN Sales.Invoices s_i
			ON s_c.CustomerID = s_i.CustomerID
WHERE
		s_c.CustomerID between 2 and 6	
GROUP BY
	DATEADD(DD, 1 - DATEPART(DD,s_i.InvoiceDate), s_i.InvoiceDate)
ORDER BY InvoiceMonth;



/*
2. Для всех клиентов с именем, в котором есть "Tailspin Toys"
вывести все адреса, которые есть в таблице, в одной колонке.

Пример результата:
----------------------------+--------------------
CustomerName                | AddressLine
----------------------------+--------------------
Tailspin Toys (Head Office) | Shop 38
Tailspin Toys (Head Office) | 1877 Mittal Road
Tailspin Toys (Head Office) | PO Box 8975
Tailspin Toys (Head Office) | Ribeiroville
----------------------------+--------------------
*/

WITH CTE_TailspinToysAddresses
AS
	(SELECT 
		s_c.CustomerName as CustomerName,
		DeliveryAddressLine1 as AddressLine1,
		DeliveryAddressLine2 as AddressLine2,
		PostalAddressLine1 as AddressLine3,
		PostalAddressLine2 as AddressLine4
	FROM
		Sales.Customers s_c
	WHERE
		s_c.CustomerName like '%Tailspin Toys%')
SELECT
	CustomerName
	,AddressLine
	--,AddrColumns
FROM
	CTE_TailspinToysAddresses
	UNPIVOT (AddressLine FOR AddrColumns IN(AddressLine1, AddressLine2, AddressLine3, AddressLine4)) t
ORDER BY 
	CustomerName, 
	AddrColumns;

/*
3. В таблице стран (Application.Countries) есть поля с цифровым кодом страны и с буквенным.
Сделайте выборку ИД страны, названия и ее кода так, 
чтобы в поле с кодом был либо цифровой либо буквенный код.

Пример результата:
--------------------------------
CountryId | CountryName | Code
----------+-------------+-------
1         | Afghanistan | AFG
1         | Afghanistan | 4
3         | Albania     | ALB
3         | Albania     | 8
----------+-------------+-------
*/

WITH CTE_ApplicationCountries
AS
	(SELECT
		a_c.CountryID as CountryID,
		a_c.CountryName as CountryName,
		cast(a_c.IsoAlpha3Code as nvarchar(255)) as IsoAlpha3Code,
		cast(a_c.IsoNumericCode as nvarchar(255)) as IsoNumericCode
	FROM
		Application.Countries a_c)
SELECT 
	t.CountryID,
	t.CountryName,
	t.Code
FROM
	CTE_ApplicationCountries
	UNPIVOT(
		Code FOR CodeColumns IN (IsoAlpha3Code, IsoNumericCode)) t;

/*
4. Выберите по каждому клиенту два самых дорогих товара, которые он покупал.
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки.
*/


WITH CTE_CustomsMaxPrices
AS
	(SELECT
		s_i.CustomerID as CustomerID,
		s_il.StockItemID as StockItemID,
		s_il.UnitPrice as UnitPrice,
		max(s_i.InvoiceDate) as InvoiceDate
	FROM
		Sales.Invoices s_i
		JOIN Sales.InvoiceLines s_il
			ON s_i.InvoiceID = s_il.InvoiceID
	GROUP BY 
		s_i.CustomerID,
		s_il.StockItemID,
		s_il.UnitPrice)
SELECT
	s_c.CustomerID,
	s_c.CustomerName,
	c.StockItemID,
	c.UnitPrice,
	c.InvoiceDate
FROM
	Sales.Customers s_c
	OUTER APPLY (
		SELECT TOP 2
			CustomerID,
			StockItemID,
			UnitPrice,
			InvoiceDate
		FROM
			CTE_CustomsMaxPrices
		WHERE
			CTE_CustomsMaxPrices.CustomerID = s_c.CustomerID
		ORDER BY UnitPrice desc) C
ORDER BY
	CustomerID,
	UnitPrice desc;
