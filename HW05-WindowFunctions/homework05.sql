/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "06 - Оконные функции".

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
1. Сделать расчет суммы продаж нарастающим итогом по месяцам с 2015 года 
(в рамках одного месяца он будет одинаковый, нарастать будет в течение времени выборки).
Выведите: id продажи, название клиента, дату продажи, сумму продажи, сумму нарастающим итогом

Пример:
-------------+----------------------------
Дата продажи | Нарастающий итог по месяцу
-------------+----------------------------
 2015-01-29   | 4801725.31
 2015-01-30	 | 4801725.31
 2015-01-31	 | 4801725.31
 2015-02-01	 | 9626342.98
 2015-02-02	 | 9626342.98
 2015-02-03	 | 9626342.98
Продажи можно взять из таблицы Invoices.
Нарастающий итог должен быть без оконной функции.
*/

set statistics time, io on


WITH 
	CTE_InvocesTotalSum AS
	(SELECT	
		EOMONTH(s_i.InvoiceDate) as InvoiceEOMDate,
		sum(s_il.Quantity * s_il.UnitPrice) as InvoicePriceTotal
	from 
	Sales.Invoices s_i 
	JOIN Sales.InvoiceLines s_il
		on s_i.InvoiceID = s_il.InvoiceID
	WHERE s_i.InvoiceDate between '20150101' and '20151231'
	GROUP BY 
		EOMONTH(s_i.InvoiceDate))
SELECT
	s_i.InvoiceID,
	s_c.CustomerName,
	s_i.InvoiceDate,
	sum(cte_its.InvoicePriceTotal)
FROM
	Sales.Invoices s_i
	JOIN Sales.Customers s_c
		ON s_i.CustomerID = s_c.CustomerID
	JOIN CTE_InvocesTotalSum cte_its
		ON cte_its.InvoiceEOMDate <= EOMONTH(s_i.InvoiceDate)
GROUP BY 
	s_i.InvoiceID,
	s_c.CustomerName,
	s_i.InvoiceDate
ORDER BY
	s_i.InvoiceID,
	s_c.CustomerName,
	s_i.InvoiceDate;

--Table 'Worktable'. Scan count 12, logical reads 143379
--Table 'Invoices'. Scan count 2, logical reads 22800

/*
2. Сделайте расчет суммы нарастающим итогом в предыдущем запросе с помощью оконной функции.
   Сравните производительность запросов 1 и 2 с помощью set statistics time, io on
*/
SELECT
	s_i.InvoiceID,
	s_c.CustomerName,
	s_i.InvoiceDate,
	sum(s_il.Quantity * s_il.UnitPrice) over (order by EOMONTH(s_i.InvoiceDate) RANGE UNBOUNDED PRECEDING)
FROM
	Sales.Invoices s_i 
	JOIN Sales.InvoiceLines s_il
		on s_i.InvoiceID = s_il.InvoiceID
	JOIN Sales.Customers s_c
		ON s_i.CustomerID = s_c.CustomerID 
WHERE 
	s_i.InvoiceDate between '20150101' and '20151231'
ORDER BY
	s_i.InvoiceID,
	s_c.CustomerName,
	s_i.InvoiceDate;

--Table 'Invoices'. Scan count 1, logical reads 11400


/*
3. Вывести список 2х самых популярных продуктов (по количеству проданных) 
в каждом месяце за 2016 год (по 2 самых популярных продукта в каждом месяце).
*/

SELECT 
	res.InvoiceDateEOM as InvoiceDateEOM,
	w_si.StockItemName as StockItemName,
	res.StockItemID,
	res.StockItemCountByMonth as StockItemCountByMonth
FROM 
	(SELECT 
			t.InvoiceDateEOM,
			t.StockItemID,
			t.StockItemCountByMonth,
			ROW_NUMBER() over (partition by t.InvoiceDateEOM order by t.StockItemCountByMonth desc) as rn
		FROM
			(SELECT
				EOMONTH(s_i.InvoiceDate) as InvoiceDateEOM,
				s_il.StockItemID,
				sum(s_il.Quantity) as StockItemCountByMonth
			FROM
				Sales.Invoices s_i 
				JOIN Sales.InvoiceLines s_il
					on s_i.InvoiceID = s_il.InvoiceID	
			GROUP BY
				EOMONTH(s_i.InvoiceDate),
				s_il.StockItemID) t) res
	JOIN Warehouse.StockItems w_si
		on res.rn between 1 and 2
		and w_si.StockItemID = res.StockItemID
WHERE
	res.InvoiceDateEOM between '20160101' and '20161231'
ORDER BY 
	InvoiceDateEOM,
	StockItemCountByMonth,
	StockItemName;
		
/*
4. Функции одним запросом
Посчитайте по таблице товаров (в вывод также должен попасть ид товара, название, брэнд и цена):
* пронумеруйте записи по названию товара, так чтобы при изменении буквы алфавита нумерация начиналась заново
* посчитайте общее количество товаров и выведете полем в этом же запросе
* посчитайте общее количество товаров в зависимости от первой буквы названия товара
* отобразите следующий id товара исходя из того, что порядок отображения товаров по имени 
* предыдущий ид товара с тем же порядком отображения (по имени)
* названия товара 2 строки назад, в случае если предыдущей строки нет нужно вывести "No items"
* сформируйте 30 групп товаров по полю вес товара на 1 шт

Для этой задачи НЕ нужно писать аналог без аналитических функций.
*/

SELECT 
	w_si.StockItemID as StockItemID,
	w_si.StockItemName as StockItemName,
	w_si.Brand as Brand,
	w_si.UnitPrice as UnitPrice,
	ROW_NUMBER() over (partition by left(w_si.StockItemName,1) order by w_si.StockItemName) as StockItemRN,
	COUNT(*) over () as TotalCnt,
	COUNT(*) over (partition by left(w_si.StockItemName,1)) as FirstLetterTotalCnt,
	LEAD(w_si.StockItemID) over (order by w_si.StockItemName) as NextStockItemID,
	LAG(w_si.StockItemID) over (order by w_si.StockItemName) as PrevStockItemID,
	LAG(w_si.StockItemName, 2, 'No items') over (order by w_si.StockItemName) as Prev2StockItemID,
	NTILE(30) over (order by TypicalWeightPerUnit) as GroupNum
FROM 
	Warehouse.StockItems w_si;


/*
5. По каждому сотруднику выведите последнего клиента, которому сотрудник что-то продал.
   В результатах должны быть ид и фамилия сотрудника, ид и название клиента, дата продажи, сумму сделки.
*/

SELECT
	a_p.PersonID as SalesPersonID,
	right(a_p.FullName, len(a_p.FullName)-charindex(' ',a_p.FullName)) as SaleSurname,
	s_c.CustomerID as CustomerID,
	s_c.CustomerName as CustomerName,
	sales.InvoiceDate as InvoiceDate,
	sum(s_il.Quantity * s_il.UnitPrice) as CustomAmount
FROM
	Application.People a_p
	JOIN (SELECT 
				s_i.InvoiceID as InvoiceID,
				s_i.CustomerID as CustomerID,
				s_i.InvoiceDate as InvoiceDate,
				s_i.SalespersonPersonID as SalespersonPersonID,
				ROW_NUMBER() over (partition by s_i.SalespersonPersonID order by s_i.InvoiceID desc ) as rn
			FROM
				Sales.Invoices s_i) sales
		ON a_p.PersonID = sales.SalespersonPersonID
		and sales.rn = 1
	JOIN Sales.Customers s_c
		on sales.CustomerID = s_c.CustomerID
	JOIN Sales.InvoiceLines s_il
		on s_il.InvoiceID = sales.InvoiceID
WHERE 
	IsSalesperson = 1
GROUP BY
	a_p.PersonID,
	right(a_p.FullName, len(a_p.FullName)-charindex(' ',a_p.FullName)),
	s_c.CustomerID,
	s_c.CustomerName,
	sales.InvoiceDate;

/*
6. Выберите по каждому клиенту два самых дорогих товара, которые он покупал.
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки.
*/
WITH CTE_LastCustoms 
AS
	(SELECT
		s_i.CustomerID as CustomerID,
		s_il.StockItemID as StockItemID,
		max(s_il.UnitPrice) as UnitPrice,
		max(s_i.InvoiceID) as InvoiceID,
		max(s_i.InvoiceDate) as InvoiceDate
	FROM
		Sales.Invoices s_i 
		JOIN Sales.InvoiceLines s_il
			on s_il.InvoiceID = s_i.InvoiceID
	GROUP BY
		s_i.CustomerID,
		s_il.StockItemID)
SELECT 
	s_c.CustomerID as CustomerID,
	s_c.CustomerName as CustomerName,
	ranged.StockItemID as StockItemID,
	ranged.UnitPrice as UnitPrice,
	ranged.InvoiceDate as InvoiceDate
FROM
	Sales.Customers s_c
	JOIN	(SELECT 
			CustomerID,
			StockItemID,
			UnitPrice,
			InvoiceID,
			InvoiceDate,
			ROW_NUMBER() over (partition by cte_lc.CustomerID order by cte_lc.CustomerID, cte_lc.UnitPrice desc) as rn
		FROM
			CTE_LastCustoms cte_lc) ranged
		ON s_c.CustomerID = ranged.CustomerID
		and ranged.rn <= 2
ORDER BY 
	CustomerID;
