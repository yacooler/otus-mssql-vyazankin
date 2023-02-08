/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.
Занятие "02 - Оператор SELECT и простые фильтры, JOIN".
Задания выполняются с использованием базы данных WideWorldImporters.
Бэкап БД WideWorldImporters можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak
Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------

USE WideWorldImporters;

/*
1. Все товары, в названии которых есть "urgent" или название начинается с "Animal".
Вывести: ИД товара (StockItemID), наименование товара (StockItemName).
Таблицы: Warehouse.StockItems.
*/

select 
	w_s.StockItemID,
	w_S.StockItemName
from
	Warehouse.StockItems w_s
where
	w_s.StockItemName like 'Animal%'
	or w_s.StockItemName like '%urgent%';


/*
2. Поставщиков (Suppliers), у которых не было сделано ни одного заказа (PurchaseOrders).
Сделать через JOIN, с подзапросом задание принято не будет.
Вывести: ИД поставщика (SupplierID), наименование поставщика (SupplierName).
Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders.
По каким колонкам делать JOIN подумайте самостоятельно.
*/

select
	p_s.SupplierID,
	p_s.SupplierName
from
	Purchasing.Suppliers p_s
	left join Purchasing.PurchaseOrders p_po
		on p_po.SupplierID = p_s.SupplierID
where
	p_po.PurchaseOrderID is null;

/*
3. Заказы (Orders) с товарами ценой (UnitPrice) более 100$
либо количеством единиц (Quantity) товара более 20 штук
и присутствующей датой комплектации всего заказа (PickingCompletedWhen).
Вывести:
* OrderID
* дату заказа (OrderDate) в формате ДД.ММ.ГГГГ (10.01.2011)
* название месяца, в котором был сделан заказ (используйте функцию FORMAT или DATENAME)
* номер квартала, в котором был сделан заказ (используйте функцию DATEPART)
* треть года, к которой относится дата заказа (каждая треть по 4 месяца)
* имя заказчика (Customer)
Добавьте вариант этого запроса с постраничной выборкой,
пропустив первую 1000 и отобразив следующие 100 записей.
Сортировка должна быть по номеру квартала, трети года, дате заказа (везде по возрастанию).
Таблицы: Sales.Orders, Sales.OrderLines, Sales.Customers.
*/

select distinct
	s_o.OrderID,
	FORMAT(s_o.OrderDate,'dd.MM.yyyy') as OrderDate,
	DATENAME(mm, s_o.OrderDate) as OrderDateMonthName,
	DATEPART(q, s_o.OrderDate) as OrderDateQuarterOfYear,
	FLOOR((DATEPART(MM, s_o.OrderDate) + 3) / 4) as OrderDateThirdOfYear,
	s_c.CustomerName --Customer?
from 
	Sales.Orders s_o
	join Sales.OrderLines s_ol
		on s_o.OrderID = s_ol.OrderID
	join Sales.Customers s_c
		on s_o.CustomerID = s_c.CustomerID
where
	(s_ol.Quantity > 20	or s_ol.UnitPrice > 100.00)
	and not s_ol.PickingCompletedWhen is null;


select distinct
	s_o.OrderID,
	FORMAT(s_o.OrderDate,'dd.MM.yyyy') as OrderDate,
	DATENAME(mm, s_o.OrderDate) as OrderDateMonthName,
	DATEPART(q, s_o.OrderDate) as OrderDateQuarterOfYear,
	FLOOR((DATEPART(MM, s_o.OrderDate) + 3) / 4) as OrderDateThirdOfYear,
	s_c.CustomerName
from 
	Sales.Orders s_o
	join Sales.OrderLines s_ol
		on s_o.OrderID = s_ol.OrderID
	join Sales.Customers s_c
		on s_o.CustomerID = s_c.CustomerID
where
	(s_ol.Quantity > 20	or s_ol.UnitPrice > 100.00)
	and not s_ol.PickingCompletedWhen is null
order by 
	OrderDateQuarterOfYear,
	OrderDateThirdOfYear,
	OrderDate
offset 100 rows
fetch next 100 rows only;

/*
4. Заказы поставщикам (Purchasing.Suppliers),
которые должны быть исполнены (ExpectedDeliveryDate) в январе 2013 года
с доставкой "Air Freight" или "Refrigerated Air Freight" (DeliveryMethodName)
и которые исполнены (IsOrderFinalized).
Вывести:
* способ доставки (DeliveryMethodName)
* дата доставки (ExpectedDeliveryDate)
* имя поставщика
* имя контактного лица принимавшего заказ (ContactPerson)
Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.
*/

select
	a_dm.DeliveryMethodName,
	p_po.ExpectedDeliveryDate,
	p_s.SupplierName,
	a_p.FullName
from
	Purchasing.PurchaseOrders p_po
	join Purchasing.Suppliers p_s
		on p_po.SupplierID = p_s.SupplierID
	join Application.DeliveryMethods a_dm
		on a_dm.DeliveryMethodID = p_po.DeliveryMethodID
	join Application.People a_p
		on p_po.ContactPersonID = a_p.PersonID
where
	p_po.ExpectedDeliveryDate between '20130101' and '20130131'
	and p_po.IsOrderFinalized = 1
	and a_dm.DeliveryMethodName in('Air Freight','Refrigerated Air Freight');
	
/*
5. Десять последних продаж (по дате продажи - InvoiceDate) с именем клиента (клиент - CustomerID) и именем сотрудника,
который оформил заказ (SalespersonPerson).
Сделать без подзапросов.
Вывести: ИД продажи (InvoiceID), дата продажи (InvoiceDate), имя заказчика (CustomerName), имя сотрудника (SalespersonFullName)
Таблицы: Sales.Invoices, Sales.Customers, Application.People.
*/

select top 10
	s_i.InvoiceID,
	s_i.InvoiceDate,
	s_c.CustomerName,
	a_p.FullName
from 
	Sales.Invoices s_i
	join Sales.Customers s_c
		on s_i.CustomerID = s_c.CustomerID
	join Application.People a_p
		on s_i.SalespersonPersonID = a_p.PersonID
order by 
	InvoiceDate desc 
	--,invoiceID desc
;

/*
6. Все ид и имена клиентов (клиент - CustomerID) и их контактные телефоны (PhoneNumber),
которые покупали товар "Chocolate frogs 250g".
Имя товара смотреть в таблице Warehouse.StockItems, имена клиентов и их контакты в таблице Sales.Customers.
Таблицы: Sales.Invoices, Sales.InvoiceLines, Sales.Customers, Warehouse.StockItems.
*/

select distinct
	s_c.CustomerID,
	s_c.CustomerName,
	s_c.PhoneNumber
from
	Sales.Invoices s_i
	join Sales.InvoiceLines s_il
		on s_i.InvoiceID = s_il.InvoiceID
	join Sales.Customers s_c
		on s_i.CustomerID = s_c.CustomerID
	join Warehouse.StockItems w_si
		on s_il.StockItemID = w_si.StockItemID
where
	w_si.StockItemName = 'Chocolate frogs 250g';
