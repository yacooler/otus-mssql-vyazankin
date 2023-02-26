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
