/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.
Занятие "02 - Оператор SELECT и простые фильтры, GROUP BY, HAVING".

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

USE WideWorldImporters;

/*
1. Посчитать среднюю цену товара, общую сумму продажи по месяцам.
Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Средняя цена за месяц по всем товарам
* Общая сумма продаж за месяц

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

select 
	datepart(year, s_i.InvoiceDate) as yr,
	datepart(MONTH, s_i.InvoiceDate) as mn,
	AVG(s_il.unitPrice) as avg_price_mn,
	sum(s_il.quantity * s_il.unitPrice) as sum_cost_mn
from 
	sales.Invoices s_i
	join Sales.InvoiceLines s_il
		on s_i.InvoiceID = s_il.InvoiceID
group by 
	datepart(year, s_i.InvoiceDate),
	datepart(MONTH, s_i.InvoiceDate)
order by yr, mn;

/*
2. Отобразить все месяцы, где общая сумма продаж превысила 4 600 000

Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Общая сумма продаж

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
Сортировка по году и месяцу.

*/
select 
	datepart(year, s_i.InvoiceDate) as yr,
	datepart(MONTH, s_i.InvoiceDate) as mn,
	sum(s_il.quantity * s_il.unitPrice) as sum_cost_mn
from 
	sales.Invoices s_i
	join Sales.InvoiceLines s_il
		on s_i.InvoiceID = s_il.InvoiceID
group by 
	datepart(year, s_i.InvoiceDate),
	datepart(MONTH, s_i.InvoiceDate)
having sum(s_il.quantity * s_il.unitPrice) > 4600000
order by yr, mn;

/*
3. Вывести сумму продаж, дату первой продажи
и количество проданного по месяцам, по товарам,
продажи которых менее 50 ед в месяц.
Группировка должна быть по году,  месяцу, товару.

Вывести:
* Год продажи
* Месяц продажи
* Наименование товара
* Сумма продаж
* Дата первой продажи
* Количество проданного

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

select
	datepart(year, s_i.InvoiceDate) as yr,
	datepart(MONTH, s_i.InvoiceDate) as mn,
	w_s.StockItemName,
	sum(s_il.Quantity * s_il.UnitPrice) as cost_mn,
	min(s_i.invoiceDate) as first_sale,
	sum(s_il.Quantity) as quant_mn
from 
	sales.Invoices s_i
	join Sales.InvoiceLines s_il
		on s_i.InvoiceID = s_il.InvoiceID
	join [Warehouse].[StockItems] w_s
		on s_il.StockItemID = w_s.StockItemID
group by 
	datepart(year, s_i.InvoiceDate),
	datepart(MONTH, s_i.InvoiceDate),
	w_s.StockItemName
having 
	sum(s_il.Quantity) < 50
order by yr, mn, StockItemName
-- ---------------------------------------------------------------------------
-- Опционально
-- ---------------------------------------------------------------------------
/*
4. Написать второй запрос ("Отобразить все месяцы, где общая сумма продаж превысила 4 600 000") 
за период 2015 год так, чтобы месяц, в котором сумма продаж была меньше указанной суммы также отображался в результатах,
но в качестве суммы продаж было бы '-'.
Сортировка по году и месяцу.

Пример результата:
-----+-------+------------
Year | Month | SalesTotal
-----+-------+------------
2015 | 1     | -
2015 | 2     | -
2015 | 3     | -
2015 | 4     | 5073264.75
2015 | 5     | -
2015 | 6     | -
2015 | 7     | 5155672.00
2015 | 8     | -
2015 | 9     | 4662600.00
2015 | 10    | -
2015 | 11    | -
2015 | 12    | -

*/

select 
	t.yr as [Year],
	t.mn as [Month],
	isnull(cast(t_sales.sum_cost as varchar(255)),'-') as [SalesTotal]
from 
	(VALUES 
		(2015, 1), (2015, 2), (2015, 3), (2015, 4),
		(2015, 5), (2015, 6), (2015, 7), (2015, 8),
		(2015, 9), (2015, 10), (2015, 11), (2015, 12)) as t(yr, mn)
	left join (
		select 
			datepart(year, s_i.InvoiceDate) yr,
			datepart(month, s_i.InvoiceDate) mn,
			sum(s_il.quantity * s_il.unitPrice) sum_cost
		from
			sales.Invoices s_i
			join Sales.InvoiceLines s_il
				on s_i.InvoiceID = s_il.InvoiceID
		group by 
			datepart(year, s_i.InvoiceDate),
			datepart(month, s_i.InvoiceDate)
		having sum(s_il.quantity * s_il.unitPrice) > 4600000) t_sales
		on t.yr = t_sales.yr
		and t.mn = t_sales.mn
order by [Year],[Month]
