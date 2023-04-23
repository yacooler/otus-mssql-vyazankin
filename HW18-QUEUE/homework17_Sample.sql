EXEC SP_RequestReport_InvoiceByOrders @CustomerID = 44, @dt_beg = '20140601', @dt_end = '20150101'

select  count(*) from Sales.Invoices where CustomerID = 44 and InvoiceDate between '20140601' and '20150101'
--12 строк ожидается

--Проверка таблицы с отчетами
SELECT * from Reports.CustomerInvoiceByOrders

--Проверка очередей
select * from sys.transmission_queue
select * from TargetQueueReport_invoiceByOrders
select * from InitiatorQueueReport_invoiceByOrders
