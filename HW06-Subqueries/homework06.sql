/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "03 - Подзапросы, CTE, временные таблицы".

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
-- Для всех заданий, где возможно, сделайте два варианта запросов:
--  1) через вложенный запрос
--  2) через WITH (для производных таблиц)
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Выберите сотрудников (Application.People), которые являются продажниками (IsSalesPerson), 
и не сделали ни одной продажи 04 июля 2015 года. 
Вывести ИД сотрудника и его полное имя. 
Продажи смотреть в таблице Sales.Invoices.
*/
SELECT
	a_p.PersonID,
	a_p.FullName
FROM
	Application.People a_p
WHERE
	a_p.IsSalesperson = 1
	and NOT EXISTS(
		SELECT 1
		FROM Sales.Invoices s_i
		WHERE
			s_i.SalespersonPersonID = a_p.PersonID
			and s_i.InvoiceDate = '20150704');


/*
2. Выберите товары с минимальной ценой (подзапросом). Сделайте два варианта подзапроса. 
Вывести: ИД товара, наименование товара, цена.
*/

SELECT
	w_si.StockItemID,
	w_si.StockItemName,
	w_si.UnitPrice
FROM
	Warehouse.StockItems w_si
WHERE
	w_si.UnitPrice = (
		SELECT min(sub_w_si.UnitPrice)
		FROM Warehouse.StockItems sub_w_si);

WITH CTE_StockItemsMin AS
(SELECT 
	min(w_si.UnitPrice) as MinUnitPrice
FROM
	Warehouse.StockItems w_si)
SELECT
	w_si.StockItemID,
	w_si.StockItemName,
	w_si.UnitPrice
FROM
	Warehouse.StockItems w_si
	JOIN CTE_StockItemsMin
		on w_si.UnitPrice = CTE_StockItemsMin.MinUnitPrice;

/*
3. Выберите информацию по клиентам, которые перевели компании пять максимальных платежей 
из Sales.CustomerTransactions. 
Представьте несколько способов (в том числе с CTE). 
*/

SELECT
	s_c.CustomerID,
	s_c.CustomerName,
	max_trans_amt.TransactionAmount
FROM
	Sales.Customers s_c
	JOIN (
		SELECT TOP 5 
			s_ct.CustomerID AS CustomerID,
			s_ct.TransactionAmount AS TransactionAmount
		FROM 
			Sales.CustomerTransactions s_ct
		ORDER BY TransactionAmount desc) max_trans_amt
		ON s_c.CustomerID = max_trans_amt.CustomerID;

WITH CTE_max_trans_amt AS
(SELECT TOP 5 
	s_ct.CustomerID AS CustomerID,
	s_ct.TransactionAmount AS TransactionAmount
FROM 
	Sales.CustomerTransactions s_ct
ORDER BY TransactionAmount desc)
SELECT
	s_c.CustomerID,
	s_c.CustomerName,
	CTE_max_trans_amt.TransactionAmount
FROM
	Sales.Customers s_c
	JOIN CTE_max_trans_amt
		ON CTE_max_trans_amt.CustomerID = s_c.CustomerID;

/*
4. Выберите города (ид и название), в которые были доставлены товары, 
входящие в тройку самых дорогих товаров, а также имя сотрудника, 
который осуществлял упаковку заказов (PackedByPersonID).
*/

SELECT DISTINCT
	a_c.CityID,
	a_c.CityName,
	a_p.FullName
FROM
	Application.Cities a_c
	JOIN Sales.Customers s_c
		on a_c.CityID = s_c.DeliveryCityID
	JOIN Sales.Invoices s_i
		on s_i.CustomerID = s_c.CustomerID
	JOIN Application.People a_p
		on a_p.PersonID = s_i.PackedByPersonID
	JOIN Sales.InvoiceLines s_il
		on s_il.InvoiceID = s_i.InvoiceID
WHERE
	s_il.StockItemID in (
		SELECT TOP 3 w_si.StockItemID
		FROM
			Warehouse.StockItems w_si
		ORDER BY w_si.UnitPrice desc);

WITH CTE_MaxTop3Price AS
(SELECT TOP 3 w_si.StockItemID as StockItemID
FROM
	Warehouse.StockItems w_si
ORDER BY w_si.UnitPrice desc)
SELECT DISTINCT
	a_c.CityID,
	a_c.CityName,
	a_p.FullName
FROM
	Application.Cities a_c
	JOIN Sales.Customers s_c
		on a_c.CityID = s_c.DeliveryCityID
	JOIN Sales.Invoices s_i
		on s_i.CustomerID = s_c.CustomerID
	JOIN Application.People a_p
		on a_p.PersonID = s_i.PackedByPersonID
	JOIN Sales.InvoiceLines s_il
		on s_il.InvoiceID = s_i.InvoiceID
	JOIN CTE_MaxTop3Price
		on s_il.StockItemID = CTE_MaxTop3Price.StockItemID;

-- ---------------------------------------------------------------------------
-- Опциональное задание
-- ---------------------------------------------------------------------------
-- Можно двигаться как в сторону улучшения читабельности запроса, 
-- так и в сторону упрощения плана\ускорения. 
-- Сравнить производительность запросов можно через SET STATISTICS IO, TIME ON. 
-- Если знакомы с планами запросов, то используйте их (тогда к решению также приложите планы). 
-- Напишите ваши рассуждения по поводу оптимизации. 

-- 5. Объясните, что делает и оптимизируйте запрос

SELECT 
	Invoices.InvoiceID, 
	Invoices.InvoiceDate,
	(SELECT People.FullName
		FROM Application.People
		WHERE People.PersonID = Invoices.SalespersonPersonID
	) AS SalesPersonName,
	SalesTotals.TotalSumm AS TotalSummByInvoice, 
	(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
		FROM Sales.OrderLines
		WHERE OrderLines.OrderId = (SELECT Orders.OrderId 
			FROM Sales.Orders
			WHERE Orders.PickingCompletedWhen IS NOT NULL	
				AND Orders.OrderId = Invoices.OrderId)	
	) AS TotalSummForPickedItems
FROM Sales.Invoices 
	JOIN
	(SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
	FROM Sales.InvoiceLines
	GROUP BY InvoiceId
	HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
		ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC

-- --
--Запрос выбирает все оплаченные счета (Запись в Invoices), сумма всех позиций которых превышает 27000. 
--В случае, если заказ полностью собран (Orders.PickingCompletedWhen IS NOT NULL), выводит сумму позиций на момент заказа.

--Попытка оптимизации особо ничего не дает, в основном запрос выходит более дорогим по времени, но 50/50% по эстимейтед плану.

SELECT
	Sales.Invoices.InvoiceID as InvoiceID,
	Sales.Invoices.InvoiceDate as InvoiceDate,
	Application.People.FullName as SalesPersonName,
	SalesTotals.TotalSumm as TotalSummByInvoice,
	SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice) TotalSummForPickedItems
FROM
	(SELECT 
			InvoiceId, 
			SUM(Quantity*UnitPrice) AS TotalSumm
		FROM Sales.InvoiceLines
		GROUP BY InvoiceId
		HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
	JOIN Sales.Invoices 
		ON Invoices.InvoiceID = SalesTotals.InvoiceID
	JOIN Application.People
		ON Application.People.PersonID = Sales.Invoices.SalespersonPersonID
	LEFT JOIN Sales.Orders
		on Sales.Invoices.OrderID = Sales.Orders.OrderID
		AND NOT Sales.Orders.PickingCompletedWhen IS NULL
	LEFT JOIN Sales.OrderLines
		ON OrderLines.OrderId = Sales.Orders.OrderID
GROUP BY
	Sales.Invoices.InvoiceID,
	Sales.Invoices.InvoiceDate,
	Application.People.FullName,
	SalesTotals.TotalSumm
ORDER BY TotalSummByInvoice DESC;

--Быстрее всего наверное получается через временную таблицу в tempdb, не понятно по заданию, можно ли ее использовать и как это правильно проверить на таком
--небольшом объеме данных. Самый дорогой запрос - отбор 8 строк, его можно таким образом вынести за скобки.

DROP TABLE #TotalSales;
SELECT 
	InvoiceId, 
	SUM(Quantity*UnitPrice) AS TotalSumm
INTO #TotalSales
FROM Sales.InvoiceLines
GROUP BY InvoiceId
HAVING SUM(Quantity*UnitPrice) > 27000;


SELECT
	Sales.Invoices.InvoiceID as InvoiceID,
	Sales.Invoices.InvoiceDate as InvoiceDate,
	Application.People.FullName as SalesPersonName,
	SalesTotals.TotalSumm as TotalSummByInvoice,
	SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice) TotalSummForPickedItems
FROM
	#TotalSales AS SalesTotals
	JOIN Sales.Invoices 
		ON Invoices.InvoiceID = SalesTotals.InvoiceID
	JOIN Application.People
		ON Application.People.PersonID = Sales.Invoices.SalespersonPersonID
	LEFT JOIN Sales.Orders
		on Sales.Invoices.OrderID = Sales.Orders.OrderID
		AND NOT Sales.Orders.PickingCompletedWhen IS NULL
	LEFT JOIN Sales.OrderLines
		ON OrderLines.OrderId = Sales.Orders.OrderID
GROUP BY
	Sales.Invoices.InvoiceID,
	Sales.Invoices.InvoiceDate,
	Application.People.FullName,
	SalesTotals.TotalSumm
ORDER BY TotalSummByInvoice DESC;
