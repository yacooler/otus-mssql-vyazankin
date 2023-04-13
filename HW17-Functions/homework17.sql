--Написать функцию возвращающую Клиента с наибольшей суммой покупки.
IF OBJECT_ID (N'Sales.MaxInvoiceCunsomerID', N'FN') IS NOT NULL
    DROP FUNCTION Sales.MaxInvoiceCunsomerID;
GO

CREATE FUNCTION Sales.MaxInvoiceCunsomerID()
RETURNS INT
AS
BEGIN
	DECLARE @RET DECIMAL(18,2);
	SET @RET = (
		SELECT 
			TOP 1 s_i.CustomerID
		FROM
			Sales.Invoices s_i
			JOIN Sales.InvoiceLines s_il
				ON s_il.InvoiceID = s_i.InvoiceID
		GROUP BY
			s_i.CustomerID,
			s_il.InvoiceID
		ORDER BY SUM(s_il.ExtendedPrice) desc);

		RETURN @RET;
END;
GO

SELECT Sales.MaxInvoiceCunsomerID()
--(No column name)
--834

--Написать хранимую процедуру с входящим параметром СustomerID, выводящую сумму покупки по этому клиенту.
CREATE OR ALTER PROCEDURE Sales.SP_GetCustomerInvoiceAmount
	@CustomerID int
AS
BEGIN
	SELECT 
		SUM(s_il.ExtendedPrice) as Amount
	FROM
		Sales.Invoices s_i
		JOIN Sales.InvoiceLines s_il
			ON s_il.InvoiceID = s_i.InvoiceID
	WHERE
		s_i.CustomerID = @CustomerID;

END;
GO

EXEC Sales.SP_GetCustomerInvoiceAmount @CustomerID = 1
--Amount
--351298.08



--Создать одинаковую функцию и хранимую процедуру, посмотреть в чем разница в производительности и почему.
IF OBJECT_ID (N'Sales.InvoicesAsJSON', N'FN') IS NOT NULL
    DROP FUNCTION Sales.InvoicesAsJSON;
GO
CREATE FUNCTION Sales.InvoicesAsJSON(
	@CustomerID int,
	@StartDate date = '19000101',
	@EndDate date = '29990101',
	@MinInvoiceAmt decimal(18,2) = 0.00,
	@MaxInvoiceAmt decimal(18,2) = 9999999999999999.99)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @RET NVARCHAR(MAX);

	SET @RET = 
	(
		SELECT
			s_i.InvoiceDate				[Invoice.Date],
			s_i.InvoiceID				[Invoice.ID],
			s_c.CustomerID				[Invoice.CustomerID],
			s_c.CustomerName			[Invoice.CustomerName],
			sum(s_il.ExtendedPrice)		[Invoice.InvoiceAmount],
			(SELECT
					w_si_n.StockItemID			[StockItemID],
					w_si_n.StockItemName 		[StockItemName],
					s_il_n.ExtendedPrice 		[ExtendedPrice]
				FROM
					Sales.InvoiceLines s_il_n
					JOIN Warehouse.StockItems w_si_n
						ON s_il_n.StockItemID = w_si_n.StockItemID
				WHERE
					s_il_n.InvoiceID = s_i.InvoiceID
				FOR JSON PATH)			[Invoice.Items]
		FROM
			Sales.Customers s_c
			JOIN Sales.Invoices s_i
				ON s_c.CustomerID = s_i.CustomerID
			JOIN Sales.InvoiceLines s_il
				ON s_i.InvoiceID = s_il.InvoiceID
		WHERE
			s_c.CustomerID = @CustomerID
			AND s_i.InvoiceDate between @StartDate and @EndDate
		GROUP BY
			s_i.InvoiceDate,
			s_i.InvoiceID,
			s_c.CustomerID,
			s_c.CustomerName
		HAVING 
			sum(s_il.ExtendedPrice) between @MinInvoiceAmt and @MaxInvoiceAmt
		FOR JSON PATH, ROOT('Invoices')
	);
	RETURN @ret;
END;
GO

SELECT Sales.InvoicesAsJSON(832, '20160514', '20160514', DEFAULT, DEFAULT)

--{
--  "Invoices": [
--    {
--      "Invoice": {
--        "Date": "2016-05-14",
--        "ID": 69456,
--        "CustomerID": 832,
--        "CustomerName": "Aakriti Byrraju",
--        "InvoiceAmount": 1968.8,
--        "Items": [
--          {
--            "StockItemID": 175,
--            "StockItemName": "Bubblewrap dispenser (Blue) 1.5m",
--            "ExtendedPrice": 1380
--          },
--          {
--            "StockItemID": 205,
--            "StockItemName": "Tape dispenser (Blue)",
--            "ExtendedPrice": 368
--          },
--          {
--            "StockItemID": 135,
--            "StockItemName": "Animal with big feet slippers (Brown) M",
--            "ExtendedPrice": 110.4
--          },
--          {
--            "StockItemID": 150,
--            "StockItemName": "Pack of 12 action figures (variety)",
--            "ExtendedPrice": 110.4
--          }
--        ]
--      }
--    }
--  ]
--}


CREATE OR ALTER PROCEDURE Sales.SP_InvoicesAsJSON
	@CustomerID int,
	@StartDate date = '19000101',
	@EndDate date = '29990101',
	@MinInvoiceAmt decimal(18,2) = 0.00,
	@MaxInvoiceAmt decimal(18,2) = 9999999999999999.99
AS
BEGIN	
	SELECT
		s_i.InvoiceDate				[Invoice.Date],
		s_i.InvoiceID				[Invoice.ID],
		s_c.CustomerID				[Invoice.CustomerID],
		s_c.CustomerName			[Invoice.CustomerName],
		sum(s_il.ExtendedPrice)		[Invoice.InvoiceAmount],
		(SELECT
				w_si_n.StockItemID			[StockItemID],
				w_si_n.StockItemName 		[StockItemName],
				s_il_n.ExtendedPrice 		[ExtendedPrice]
			FROM
				Sales.InvoiceLines s_il_n
				JOIN Warehouse.StockItems w_si_n
					ON s_il_n.StockItemID = w_si_n.StockItemID
			WHERE
				s_il_n.InvoiceID = s_i.InvoiceID
			FOR JSON PATH)			[Invoice.Items]
	FROM
		Sales.Customers s_c
		JOIN Sales.Invoices s_i
			ON s_c.CustomerID = s_i.CustomerID
		JOIN Sales.InvoiceLines s_il
			ON s_i.InvoiceID = s_il.InvoiceID
	WHERE
		s_c.CustomerID = @CustomerID
		AND s_i.InvoiceDate between @StartDate and @EndDate
	GROUP BY
		s_i.InvoiceDate,
		s_i.InvoiceID,
		s_c.CustomerID,
		s_c.CustomerName
	HAVING 
		sum(s_il.ExtendedPrice) between @MinInvoiceAmt and @MaxInvoiceAmt
	FOR JSON PATH, ROOT('Invoices');	
END;

EXEC Sales.SP_InvoicesAsJSON @CustomerID = 832, @StartDate = '20160514', @EndDate = '20160514'

--{
--  "Invoices": [
--    {
--      "Invoice": {
--        "Date": "2016-05-14",
--        "ID": 69456,
--        "CustomerID": 832,
--        "CustomerName": "Aakriti Byrraju",
--        "InvoiceAmount": 1968.8,
--        "Items": [
--          {
--            "StockItemID": 175,
--            "StockItemName": "Bubblewrap dispenser (Blue) 1.5m",
--            "ExtendedPrice": 1380
--          },
--          {
--            "StockItemID": 205,
--            "StockItemName": "Tape dispenser (Blue)",
--            "ExtendedPrice": 368
--          },
--          {
--            "StockItemID": 135,
--            "StockItemName": "Animal with big feet slippers (Brown) M",
--            "ExtendedPrice": 110.4
--          },
--          {
--            "StockItemID": 150,
--            "StockItemName": "Pack of 12 action figures (variety)",
--            "ExtendedPrice": 110.4
--          }
--        ]
--      }
--    }
--  ]
--}


SET STATISTICS IO, TIME ON;

SELECT Sales.InvoicesAsJSON(832, DEFAULT, DEFAULT, DEFAULT, DEFAULT)

 --SQL Server Execution Times:
   --CPU time = 47 ms,  elapsed time = 91 ms.

EXEC Sales.SP_InvoicesAsJSON @CustomerID = 832
	--(102 rows affected)
	--Table 'StockItems'. Scan count 0, logical reads 670, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
	--Table 'InvoiceLines'. Scan count 103, logical reads 6214, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
	--Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
	--Table 'Customers'. Scan count 0, logical reads 2, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
	--Table 'Invoices'. Scan count 1, logical reads 323, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

	--SQL Server Execution Times:
 --  CPU time = 31 ms,  elapsed time = 95 ms.

SET STATISTICS IO, TIME OFF;




--Создайте табличную функцию покажите как ее можно вызвать для каждой строки result set'а без использования цикла.

IF OBJECT_ID (N'Sales.TopStockItemsByCustomer', N'TF') IS NOT NULL
    DROP FUNCTION Sales.TopStockItemsByCustomer;
GO

CREATE FUNCTION Sales.TopStockItemsByCustomer(
	@CustomerID int,
	@MaxRows int = 3)
RETURNS @Res TABLE (
	StockItemID int not null,
	StockItemName varchar(100) not null,
	SalesCount int not null)
AS
BEGIN
	INSERT INTO @Res(
		StockItemID,
		StockItemName,
		SalesCount)
	SELECT TOP (@MaxRows)
		s_il.StockItemID,
		w_si.StockItemName,
		COUNT(*) cnt
	FROM
		Sales.Invoices s_i
		JOIN Sales.InvoiceLines s_il
			ON s_i.InvoiceID = s_il.InvoiceID
		JOIN Warehouse.StockItems w_si
			ON w_si.StockItemID = s_il.StockItemID
	WHERE
		s_i.CustomerID = @CustomerID
	GROUP BY	
		s_il.StockItemID,
		w_si.StockItemName
	ORDER BY cnt DESC;

	RETURN
END

SELECT 
	s_c.CustomerID,
	s_c.CustomerName,
	fn.StockItemID,
	fn.StockItemName,
	fn.SalesCount
FROM Sales.Customers s_c
	CROSS APPLY Sales.TopStockItemsByCustomer(s_c.CustomerID,3) fn

--CustomerID	CustomerName	StockItemID	StockItemName	SalesCount
--1	Tailspin Toys (Head Office)	22	DBA joke mug - it depends (White)	7
--1	Tailspin Toys (Head Office)	74	Ride on vintage American toy coupe (Black) 1/12 scale	5
--1	Tailspin Toys (Head Office)	203	Tape dispenser (Black)	5
--2	Tailspin Toys (Sylvanite, MT)	177	Shipping carton (Brown) 413x285x187mm	6
--2	Tailspin Toys (Sylvanite, MT)	38	Developer joke mug - inheritance is the OO way to become wealthy (White)	5
--2	Tailspin Toys (Sylvanite, MT)	96	"The Gu" red shirt XML tag t-shirt (Black) XXL	5
--3	Tailspin Toys (Peeples Valley, AZ)	162	32 mm Double sided bubble wrap 10m	9
--3	Tailspin Toys (Peeples Valley, AZ)	101	"The Gu" red shirt XML tag t-shirt (Black) 7XL	6
--3	Tailspin Toys (Peeples Valley, AZ)	29	DBA joke mug - two types of DBAs (Black)	6
--4	Tailspin Toys (Medicine Lodge, KS)	195	Black and orange handle with care despatch tape  48mmx75m	5
--4	Tailspin Toys (Medicine Lodge, KS)	50	Developer joke mug - old C developers never die (White)	5
--4	Tailspin Toys (Medicine Lodge, KS)	21	DBA joke mug - you might be a DBA if (Black)	4
--....
