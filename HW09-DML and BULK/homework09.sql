/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "10 - Операторы изменения данных".

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
1. Довставлять в базу пять записей используя insert в таблицу Customers или Suppliers 
*/


INSERT INTO [Sales].[Customers]
           ([CustomerID]
           ,[CustomerName]
           ,[BillToCustomerID]
           ,[CustomerCategoryID]
           ,[BuyingGroupID]
           ,[PrimaryContactPersonID]
           ,[AlternateContactPersonID]
           ,[DeliveryMethodID]
           ,[DeliveryCityID]
           ,[PostalCityID]
           ,[CreditLimit]
           ,[AccountOpenedDate]
           ,[StandardDiscountPercentage]
           ,[IsStatementSent]
           ,[IsOnCreditHold]
           ,[PaymentDays]
           ,[PhoneNumber]
           ,[FaxNumber]
           ,[DeliveryRun]
           ,[RunPosition]
           ,[WebsiteURL]
           ,[DeliveryAddressLine1]
           ,[DeliveryAddressLine2]
           ,[DeliveryPostalCode]
           ,[DeliveryLocation]
           ,[PostalAddressLine1]
           ,[PostalAddressLine2]
           ,[PostalPostalCode]
           ,[LastEditedBy])
     VALUES
           (1070					--CustomerID, int,>
           ,'Fle Theman'			--<CustomerName, nvarchar(100),>
           ,1070					--<BillToCustomerID, int,>
           ,5						--<CustomerCategoryID, int,>
           ,null					--<BuyingGroupID, int,>
           ,3260					--<PrimaryContactPersonID, int,>
           ,3261					--<AlternateContactPersonID, int,>
           ,3						--<DeliveryMethodID, int,>
           ,22090					--<DeliveryCityID, int,>
           ,22090					--<PostalCityID, int,>
           ,3000.00					--<CreditLimit, decimal(18,2),>
           ,cast(getdate() as date)	--<AccountOpenedDate, date,>
           ,3.000					--<StandardDiscountPercentage, decimal(18,3),>
           ,0						--<IsStatementSent, bit,>
           ,0						--<IsOnCreditHold, bit,>
           ,14						--<PaymentDays, int,>
           ,'(905)712-9121'			--<PhoneNumber, nvarchar(20),>
           ,'(905)712-9120'			--<FaxNumber, nvarchar(20),>
           ,null					--<DeliveryRun, nvarchar(5),>
           ,null					--<RunPosition, nvarchar(5),>
           ,'yandex.ru'				--<WebsiteURL, nvarchar(256),>
           ,'Moscow, Kremlin'		--<DeliveryAddressLine1, nvarchar(60),>
           ,'1st Floor'				--<DeliveryAddressLine2, nvarchar(60),>
           ,'142000'				--<DeliveryPostalCode, nvarchar(10),>
           ,geography::Point(37.617635, 55.755814, 4326) --<DeliveryLocation, geography,>
           ,'14200 by the demand'	--<PostalAddressLine1, nvarchar(60),>
           ,'Just go'				--<PostalAddressLine2, nvarchar(60),>
           ,'142001'				--<PostalPostalCode, nvarchar(10),>
           ,1),

		   (1071					--CustomerID, int,>
           ,'Link Wakeup'			--<CustomerName, nvarchar(100),>
           ,1071					--<BillToCustomerID, int,>
           ,5						--<CustomerCategoryID, int,>
           ,null					--<BuyingGroupID, int,>
           ,3253					--<PrimaryContactPersonID, int,>
           ,3252					--<AlternateContactPersonID, int,>
           ,3						--<DeliveryMethodID, int,>
           ,29158					--<DeliveryCityID, int,>
           ,29158					--<PostalCityID, int,>
           ,1300.00					--<CreditLimit, decimal(18,2),>
           ,cast(getdate() as date)	--<AccountOpenedDate, date,>
           ,1.000					--<StandardDiscountPercentage, decimal(18,3),>
           ,0						--<IsStatementSent, bit,>
           ,0						--<IsOnCreditHold, bit,>
           ,7						--<PaymentDays, int,>
           ,'(905)681-3308'			--<PhoneNumber, nvarchar(20),>
           ,'(905)681-3308'			--<FaxNumber, nvarchar(20),>
           ,null					--<DeliveryRun, nvarchar(5),>
           ,null					--<RunPosition, nvarchar(5),>
           ,'google.com'			--<WebsiteURL, nvarchar(256),>
           ,'NY'					--<DeliveryAddressLine1, nvarchar(60),>
           ,'Just throw it out'		--<DeliveryAddressLine2, nvarchar(60),>
           ,'77000'					--<DeliveryPostalCode, nvarchar(10),>
           ,geography::Point(40.7143, 74.006, 4326) --<DeliveryLocation, geography,>
           ,'77100 by the demand'	--<PostalAddressLine1, nvarchar(60),>
           ,'Bitrh street'			--<PostalAddressLine2, nvarchar(60),>
           ,'77101'					--<PostalPostalCode, nvarchar(10),>
           ,1),

		   (1072					--CustomerID, int,>
           ,'Splinter'				--<CustomerName, nvarchar(100),>
           ,1072					--<BillToCustomerID, int,>
           ,5						--<CustomerCategoryID, int,>
           ,null					--<BuyingGroupID, int,>
           ,3257					--<PrimaryContactPersonID, int,>
           ,3257					--<AlternateContactPersonID, int,>
           ,3						--<DeliveryMethodID, int,>
           ,22090					--<DeliveryCityID, int,>
           ,22090					--<PostalCityID, int,>
           ,7400.00					--<CreditLimit, decimal(18,2),>
           ,cast(getdate() as date)	--<AccountOpenedDate, date,>
           ,0.000					--<StandardDiscountPercentage, decimal(18,3),>
           ,0						--<IsStatementSent, bit,>
           ,0						--<IsOnCreditHold, bit,>
           ,14						--<PaymentDays, int,>
           ,'(050)712-9121'			--<PhoneNumber, nvarchar(20),>
           ,'(050)712-9120'			--<FaxNumber, nvarchar(20),>
           ,null					--<DeliveryRun, nvarchar(5),>
           ,null					--<RunPosition, nvarchar(5),>
           ,'local.tr'				--<WebsiteURL, nvarchar(256),>
           ,'Istanbul'				--<DeliveryAddressLine1, nvarchar(60),>
           ,'Bosfor'				--<DeliveryAddressLine2, nvarchar(60),>
           ,'355030'				--<DeliveryPostalCode, nvarchar(10),>
           ,geography::Point(37.617635, 55.755814, 4326) --<DeliveryLocation, geography,>
           ,'355030'				--<PostalAddressLine1, nvarchar(60),>
           ,'Just go'				--<PostalAddressLine2, nvarchar(60),>
           ,'355030'				--<PostalPostalCode, nvarchar(10),>
           ,1),

		   (1073					--CustomerID, int,>
           ,'Gordon Freeman'		--<CustomerName, nvarchar(100),>
           ,1073					--<BillToCustomerID, int,>
           ,5						--<CustomerCategoryID, int,>
           ,null					--<BuyingGroupID, int,>
           ,3256					--<PrimaryContactPersonID, int,>
           ,3256					--<AlternateContactPersonID, int,>
           ,3						--<DeliveryMethodID, int,>
           ,22090					--<DeliveryCityID, int,>
           ,22090					--<PostalCityID, int,>
           ,10000.00				--<CreditLimit, decimal(18,2),>
           ,cast(getdate() as date)	--<AccountOpenedDate, date,>
           ,0.000					--<StandardDiscountPercentage, decimal(18,3),>
           ,0						--<IsStatementSent, bit,>
           ,0						--<IsOnCreditHold, bit,>
           ,14						--<PaymentDays, int,>
           ,'(903)222-7771'			--<PhoneNumber, nvarchar(20),>
           ,'(903)221-7771'			--<FaxNumber, nvarchar(20),>
           ,null					--<DeliveryRun, nvarchar(5),>
           ,null					--<RunPosition, nvarchar(5),>
           ,'amazon.com'			--<WebsiteURL, nvarchar(256),>
           ,'London'				--<DeliveryAddressLine1, nvarchar(60),>
           ,'The Roof'				--<DeliveryAddressLine2, nvarchar(60),>
           ,'992009'				--<DeliveryPostalCode, nvarchar(10),>
           ,geography::Point(37.617635, 55.755814, 4326) --<DeliveryLocation, geography,>
           ,'992009 by the demand'	--<PostalAddressLine1, nvarchar(60),>
           ,'Near the red phone'	--<PostalAddressLine2, nvarchar(60),>
           ,'992009'				--<PostalPostalCode, nvarchar(10),>
           ,1),

		   (1074					--CustomerID, int,>
           ,'Newbie Guy'			--<CustomerName, nvarchar(100),>
           ,1074					--<BillToCustomerID, int,>
           ,5						--<CustomerCategoryID, int,>
           ,null					--<BuyingGroupID, int,>
           ,3255					--<PrimaryContactPersonID, int,>
           ,3255					--<AlternateContactPersonID, int,>
           ,3						--<DeliveryMethodID, int,>
           ,3714					--<DeliveryCityID, int,>
           ,3714					--<PostalCityID, int,>
           ,0.00					--<CreditLimit, decimal(18,2),>
           ,cast(getdate() as date)	--<AccountOpenedDate, date,>
           ,0.000					--<StandardDiscountPercentage, decimal(18,3),>
           ,0						--<IsStatementSent, bit,>
           ,0						--<IsOnCreditHold, bit,>
           ,14						--<PaymentDays, int,>
           ,'(86)3712-9121'			--<PhoneNumber, nvarchar(20),>
           ,'(86)3712-9120'			--<FaxNumber, nvarchar(20),>
           ,null					--<DeliveryRun, nvarchar(5),>
           ,null					--<RunPosition, nvarchar(5),>
           ,'aliexpress.cn'			--<WebsiteURL, nvarchar(256),>
           ,'Taiwan'				--<DeliveryAddressLine1, nvarchar(60),>
           ,'Govern'				--<DeliveryAddressLine2, nvarchar(60),>
           ,'879921'				--<DeliveryPostalCode, nvarchar(10),>
           ,geography::Point(37.617635, 55.755814, 4326) --<DeliveryLocation, geography,>
           ,'879921 by the demand'	--<PostalAddressLine1, nvarchar(60),>
           ,'Cardboard TV Box'		--<PostalAddressLine2, nvarchar(60),>
           ,'879921'				--<PostalPostalCode, nvarchar(10),>
           ,1)
GO

/*
2. Удалите одну запись из Customers, которая была вами добавлена
*/

DELETE Sales.Customers
WHERE CustomerID = 1073;


/*
3. Изменить одну запись, из добавленных через UPDATE
*/

UPDATE s_c
SET 
	s_c.DeliveryLocation = geography::Point(41.08304, 28.9497, 4326)
FROM
	Sales.Customers s_c
WHERE
	CustomerID = 1072;

/*
4. Написать MERGE, который вставит вставит запись в клиенты, если ее там нет, и изменит если она уже есть
*/

MERGE Sales.Customers AS TargetTable
USING (SELECT 
			1073							as CustomerID
           ,'Gordon Freeman'				as CustomerName
           ,1073							as BillToCustomerID
           ,5								as CustomerCategoryID
           ,cast(null as int)				as BuyingGroupID
           ,3256							as PrimaryContactPersonID
           ,3256							as AlternateContactPersonID
           ,3								as DeliveryMethodID
           ,22090							as DeliveryCityID
           ,22090							as PostalCityID
           ,10000.00						as CreditLimit
           ,cast(getdate() as date)			as AccountOpenedDate
           ,0.000							as StandardDiscountPercentage
           ,0								as IsStatementSent
           ,0								as IsOnCreditHold
           ,14								as PaymentDays
           ,'(903)222-7771'					as PhoneNumber
           ,'(903)221-7771'					as FaxNumber
           ,cast(null as nvarchar(5))		as DeliveryRun
           ,cast(null as nvarchar(5))		as RunPosition
           ,'amazon.com'					as WebsiteURL
           ,'London'						as DeliveryAddressLine1
           ,'The Roof'						as DeliveryAddressLine2
           ,'992009'						as DeliveryPostalCode
           ,geography::Point(37.617635, 55.755814, 4326) as DeliveryLocation
           ,'992009 by the demand'			as PostalAddressLine1
           ,'Near the red phone'			as PostalAddressLine2
           ,'992009'						as PostalPostalCode
           ,1								as LastEditedBy) AS SourceTable
ON TargetTable.CustomerID = SourceTable.CustomerID
WHEN MATCHED 
    THEN UPDATE 
        SET 
           [CustomerName]				= SourceTable.[CustomerName]
           ,[BillToCustomerID]			= SourceTable.[BillToCustomerID]
           ,[CustomerCategoryID]		= SourceTable.[CustomerCategoryID]
           ,[BuyingGroupID]				= SourceTable.[BuyingGroupID]
           ,[PrimaryContactPersonID]	= SourceTable.[PrimaryContactPersonID]
           ,[AlternateContactPersonID]	= SourceTable.[AlternateContactPersonID]
           ,[DeliveryMethodID]			= SourceTable.[DeliveryMethodID]
           ,[DeliveryCityID]			= SourceTable.[DeliveryCityID]
           ,[PostalCityID]				= SourceTable.[PostalCityID]
           ,[CreditLimit]				= SourceTable.[CreditLimit]
           ,[AccountOpenedDate]			 = SourceTable.[AccountOpenedDate]
           ,[StandardDiscountPercentage] = SourceTable.[StandardDiscountPercentage]
           ,[IsStatementSent]			 = SourceTable.[IsStatementSent]
           ,[IsOnCreditHold]			 = SourceTable.[IsOnCreditHold]
           ,[PaymentDays]				 = SourceTable.[PaymentDays]
           ,[PhoneNumber]				 = SourceTable.[PhoneNumber]
           ,[FaxNumber]					 = SourceTable.[FaxNumber]
           ,[DeliveryRun]				 = SourceTable.[DeliveryRun]
           ,[RunPosition]				 = SourceTable.[RunPosition]
           ,[WebsiteURL]				 = SourceTable.[WebsiteURL]
           ,[DeliveryAddressLine1]		 = SourceTable.[DeliveryAddressLine1]
           ,[DeliveryAddressLine2]		 = SourceTable.[DeliveryAddressLine2]
           ,[DeliveryPostalCode]		 = SourceTable.[DeliveryPostalCode]
           ,[DeliveryLocation]			 = SourceTable.[DeliveryLocation]
           ,[PostalAddressLine1]		 = SourceTable.[PostalAddressLine1]
           ,[PostalAddressLine2]		 = SourceTable.[PostalAddressLine2]
           ,[PostalPostalCode]			 = SourceTable.[PostalPostalCode]
           ,[LastEditedBy]				 = SourceTable.[LastEditedBy]
WHEN NOT MATCHED 
    THEN INSERT ([CustomerName]
           ,[BillToCustomerID]
           ,[CustomerCategoryID]
           ,[BuyingGroupID]
           ,[PrimaryContactPersonID]
           ,[AlternateContactPersonID]
           ,[DeliveryMethodID]
           ,[DeliveryCityID]
           ,[PostalCityID]
           ,[CreditLimit]
           ,[AccountOpenedDate]
           ,[StandardDiscountPercentage]
           ,[IsStatementSent]
           ,[IsOnCreditHold]
           ,[PaymentDays]
           ,[PhoneNumber]
           ,[FaxNumber]
           ,[DeliveryRun]
           ,[RunPosition]
           ,[WebsiteURL]
           ,[DeliveryAddressLine1]
           ,[DeliveryAddressLine2]
           ,[DeliveryPostalCode]
           ,[DeliveryLocation]
           ,[PostalAddressLine1]
           ,[PostalAddressLine2]
           ,[PostalPostalCode]
           ,[LastEditedBy])
        VALUES (
			SourceTable.[CustomerName]
			,SourceTable.[BillToCustomerID]
			,SourceTable.[CustomerCategoryID]
			,SourceTable.[BuyingGroupID]
			,SourceTable.[PrimaryContactPersonID]
			,SourceTable.[AlternateContactPersonID]
			,SourceTable.[DeliveryMethodID]
			,SourceTable.[DeliveryCityID]
			,SourceTable.[PostalCityID]
			,SourceTable.[CreditLimit]
			,SourceTable.[AccountOpenedDate]
			,SourceTable.[StandardDiscountPercentage]
			,SourceTable.[IsStatementSent]
			,SourceTable.[IsOnCreditHold]
			,SourceTable.[PaymentDays]
			,SourceTable.[PhoneNumber]
			,SourceTable.[FaxNumber]
			,SourceTable.[DeliveryRun]
			,SourceTable.[RunPosition]
			,SourceTable.[WebsiteURL]
			,SourceTable.[DeliveryAddressLine1]
			,SourceTable.[DeliveryAddressLine2]
			,SourceTable.[DeliveryPostalCode]
			,SourceTable.[DeliveryLocation]
			,SourceTable.[PostalAddressLine1]
			,SourceTable.[PostalAddressLine2]
			,SourceTable.[PostalPostalCode]
			,SourceTable.[LastEditedBy]
		);



/*
5. Напишите запрос, который выгрузит данные через bcp out и загрузить через bulk insert
*/

/*DATA SAVING*/

--Set cmd shell
exec sp_configure 'show_advanced_options', 1; 
go
exec sp_configure 'xp_cmdshell', 1; 
go
reconfigure; 
go

--Для OUTPUT папки нужно добавить права, чтобы MS SQL имел возможность туда писать
exec master..xp_cmdshell 'bcp "WideWorldImporters.Sales.Customers" out "C:\Users\vagrant\Desktop\BCP_OUT\sales_customers.csv" -T -w -t"!@#$%" -k -S WIN-LHPGJN0227F'

--https://stackoverflow.com/questions/35229957/error-microsoftodbc-driver-11-for-sql-serverwarning-bcp-import-with-a-for

--output
--NULL
--Starting copy...
--SQLState = S1000, NativeError = 0
--Error = [Microsoft][ODBC Driver 17 for SQL Server]Warning: BCP import with a format file will convert empty strings in delimited columns to NULL.
--NULL
--668 rows copied.
--Network packet size (bytes): 4096
--Clock Time (ms.) Total     : 16     Average : (41750.00 rows per sec.)
--NULL



/*DATA LOADING*/

CREATE TABLE [Sales].[__Customers_BULK](
	[CustomerID] [int] NOT NULL,
	[CustomerName] [nvarchar](100) NOT NULL,
	[BillToCustomerID] [int] NOT NULL,
	[CustomerCategoryID] [int] NOT NULL,
	[BuyingGroupID] [int] NULL,
	[PrimaryContactPersonID] [int] NOT NULL,
	[AlternateContactPersonID] [int] NULL,
	[DeliveryMethodID] [int] NOT NULL,
	[DeliveryCityID] [int] NOT NULL,
	[PostalCityID] [int] NOT NULL,
	[CreditLimit] [decimal](18, 2) NULL,
	[AccountOpenedDate] [date] NOT NULL,
	[StandardDiscountPercentage] [decimal](18, 3) NOT NULL,
	[IsStatementSent] [bit] NOT NULL,
	[IsOnCreditHold] [bit] NOT NULL,
	[PaymentDays] [int] NOT NULL,
	[PhoneNumber] [nvarchar](20) NOT NULL,
	[FaxNumber] [nvarchar](20) NOT NULL,
	[DeliveryRun] [nvarchar](5) NULL,
	[RunPosition] [nvarchar](5) NULL,
	[WebsiteURL] [nvarchar](256) NOT NULL,
	[DeliveryAddressLine1] [nvarchar](60) NOT NULL,
	[DeliveryAddressLine2] [nvarchar](60) NULL,
	[DeliveryPostalCode] [nvarchar](10) NOT NULL,
	[DeliveryLocation] [geography] NULL,
	[PostalAddressLine1] [nvarchar](60) NOT NULL,
	[PostalAddressLine2] [nvarchar](60) NULL,
	[PostalPostalCode] [nvarchar](10) NOT NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7),
	[ValidTo] [datetime2](7),
 CONSTRAINT [PK_Sales_Customers_BULK] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [USERDATA],
 CONSTRAINT [UQ_Sales_Customers_BULK_CustomerName] UNIQUE NONCLUSTERED 
(
	[CustomerName] ASC
)
)
GO


BULK INSERT WideWorldImporters.Sales.__Customers_BULK
FROM "C:\Users\vagrant\Desktop\BCP_OUT\sales_customers.csv"
WITH(
	BATCHSIZE = 1000,
	DATAFILETYPE = 'widechar',
	FIELDTERMINATOR = '!@#$%',
	ROWTERMINATOR = '\n',
	KEEPNULLS,
	TABLOCK);


--(668 rows affected)
--Completion time: 2023-03-11T15:13:27.9974591+00:00

/*CHECK*/
SELECT TOP 10 CustomerID, CustomerName
FROM WideWorldImporters.Sales.__Customers_BULK

--CustomerID	CustomerName
--832	Aakriti Byrraju
--836	Abel Spirlea
--869	Abel Tatarescu
--1048	Abhra Ganguly
--901	Adrian Andreasson
--1055	Adriana Pena
--1061	Agrita Abele
--817	Agrita Kanepa
--1034	Aishwarya Dantuluri
--1016	Aive Petrov
