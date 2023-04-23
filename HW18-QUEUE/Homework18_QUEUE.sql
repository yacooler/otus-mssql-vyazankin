

--Set up broker
select name, is_broker_enabled from sys.databases


USE master;

ALTER DATABASE [WideWorldImporters]
SET ENABLE_BROKER WITH ROLLBACK IMMEDIATE; --Do not use on productive

ALTER DATABASE [WideWorldImporters] SET TRUSTWORTHY ON;

ALTER AUTHORIZATION ON DATABASE::[WideWorldImporters] to [sa];


--Create message type. 

USE WideWorldImporters;

--For request preparing report usnin JSON
CREATE MESSAGE TYPE
	[//WWI/MSG/RequestReport_InvoiceByOrders];


--For response about preparing report usnin JSON
CREATE MESSAGE TYPE
	[//WWI/MSG/ResponseReport_InvoiceByOrders];


--Contract
CREATE CONTRACT [//WWI/MSG/ContractReport_InvoiceByOrders]
	(
		[//WWI/MSG/RequestReport_InvoiceByOrders] SENT BY INITIATOR,
		[//WWI/MSG/ResponseReport_InvoiceByOrders] SENT BY TARGET
	);

--Queues
CREATE QUEUE TargetQueueReport_invoiceByOrders;

CREATE QUEUE InitiatorQueueReport_invoiceByOrders;


--Services
CREATE SERVICE [//WWI/MSG/TargetService_QueueReport_invoiceByOrders]
	ON QUEUE [TargetQueueReport_invoiceByOrders]
	([//WWI/MSG/ContractReport_InvoiceByOrders]);

CREATE SERVICE [//WWI/MSG/InitiatorService_QueueReport_invoiceByOrders]
	ON QUEUE InitiatorQueueReport_invoiceByOrders
	([//WWI/MSG/ContractReport_InvoiceByOrders]);

--0:49:05 video
--activation procedures
ALTER QUEUE InitiatorQueueReport_invoiceByOrders
WITH 
	STATUS = ON,
	RETENTION = OFF,
	POISON_MESSAGE_HANDLING (STATUS = OFF),
	ACTIVATION(
		STATUS = ON,
		MAX_QUEUE_READERS = 1,
		EXECUTE AS OWNER,
		PROCEDURE_NAME = SP_ProcessQueryResponse_Report_InvoiceByOrders);


ALTER QUEUE TargetQueueReport_invoiceByOrders
WITH 
	STATUS = ON,
	RETENTION = OFF,
	POISON_MESSAGE_HANDLING (STATUS = OFF),
	ACTIVATION(
		STATUS = ON,
		MAX_QUEUE_READERS = 1,
		EXECUTE AS OWNER,
		PROCEDURE_NAME = SP_ProcessQueryRequest_Report_InvoiceByOrders);

--TEST


EXEC SP_RequestReport_InvoiceByOrders @CustomerID = 44, @dt_beg = '20140601', @dt_end = '20150101'

select  count(*) from Sales.Invoices
where CustomerID = 44
and InvoiceDate between '20140601' and '20150101'
--12

SELECT * from Reports.CustomerInvoiceByOrders

select * from sys.transmission_queue

select * from TargetQueueReport_invoiceByOrders

select * from InitiatorQueueReport_invoiceByOrders