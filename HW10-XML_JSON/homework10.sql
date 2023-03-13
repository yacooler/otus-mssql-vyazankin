/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "08 - Выборки из XML и JSON полей".

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
Примечания к заданиям 1, 2:
* Если с выгрузкой в файл будут проблемы, то можно сделать просто SELECT c результатом в виде XML. 
* Если у вас в проекте предусмотрен экспорт/импорт в XML, то можете взять свой XML и свои таблицы.
* Если с этим XML вам будет скучно, то можете взять любые открытые данные и импортировать их в таблицы (например, с https://data.gov.ru).
* Пример экспорта/импорта в файл https://docs.microsoft.com/en-us/sql/relational-databases/import-export/examples-of-bulk-import-and-export-of-xml-documents-sql-server
*/


/*
1. В личном кабинете есть файл StockItems.xml.
Это данные из таблицы Warehouse.StockItems.
Преобразовать эти данные в плоскую таблицу с полями, аналогичными Warehouse.StockItems.
Поля: StockItemName, SupplierID, UnitPackageID, OuterPackageID, QuantityPerOuter, TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice 

Загрузить эти данные в таблицу Warehouse.StockItems: 
существующие записи в таблице обновить, отсутствующие добавить (сопоставлять записи по полю StockItemName). 

Сделать два варианта: с помощью OPENXML и через XQuery.
*/

/*------------------------------------------OPENXML solution--------------------------------------------*/

DECLARE @xmlDoc XML;
DECLARE @xmlDocHandle INT;

SELECT @xmlDoc = BulkColumn
FROM OPENROWSET(
	BULK 'C:\Users\vagrant\Desktop\BCP\StockItems-188-1fb5df.xml',
	SINGLE_CLOB)
AS date;

EXEC sp_xml_preparedocument @xmlDocHandle out, @xmlDoc;

MERGE Warehouse.StockItems as targ
USING(
	SELECT
		[StockItemName]
		,[SupplierID]
		,[UnitPackageID]
		,[OuterPackageID]
		,[QuantityPerOuter]
		,[TypicalWeightPerUnit]
		,[LeadTimeDays]
		,[IsChillerStock]
		,[TaxRate]
		,[UnitPrice]
	FROM
		OPENXML(@xmlDocHandle, N'StockItems/Item')
		WITH (
			[StockItemName]			NVARCHAR(100)	'@Name'
			,[SupplierID]			INT				'SupplierID'
			,[UnitPackageID]		INT				'Package/UnitPackageID'
			,[OuterPackageID]		INT				'Package/OuterPackageID'
			,[QuantityPerOuter]		INT				'Package/QuantityPerOuter'
			,[TypicalWeightPerUnit]	DECIMAL(18,3)	'Package/TypicalWeightPerUnit'
			,[LeadTimeDays]			INT				'LeadTimeDays'
			,[IsChillerStock]		BIT				'IsChillerStock'
			,[TaxRate]				DECIMAL(18,3)	'TaxRate'
			,[UnitPrice]			DECIMAL(18,2)	'UnitPrice'
			) t) src
ON targ.StockItemName = src.StockItemName
WHEN MATCHED THEN UPDATE SET
		targ.[SupplierID]=				src.[SupplierID]
		,targ.[UnitPackageID]=			src.[UnitPackageID]
		,targ.[OuterPackageID]=			src.[OuterPackageID]
		,targ.[QuantityPerOuter]=		src.[QuantityPerOuter]
		,targ.[TypicalWeightPerUnit]=	src.[TypicalWeightPerUnit]
		,targ.[LeadTimeDays]=			src.[LeadTimeDays]
		,targ.[IsChillerStock]=			src.[IsChillerStock]
		,targ.[TaxRate]=				src.[TaxRate]
		,targ.[UnitPrice]=				src.[UnitPrice]
WHEN NOT MATCHED THEN INSERT
		([StockItemName]
		,[SupplierID]
		,[UnitPackageID]
		,[OuterPackageID]
		,[QuantityPerOuter]
		,[TypicalWeightPerUnit]
		,[LeadTimeDays]
		,[IsChillerStock]
		,[TaxRate]
		,[UnitPrice]
		,[LastEditedBy])
	VALUES
		(src.[StockItemName]
		,src.[SupplierID]
		,src.[UnitPackageID]
		,src.[OuterPackageID]
		,src.[QuantityPerOuter]
		,src.[TypicalWeightPerUnit]
		,src.[LeadTimeDays]
		,src.[IsChillerStock]
		,src.[TaxRate]
		,src.[UnitPrice]
		,1 /*Admin*/);

EXEC sp_xml_removedocument @xmlDocHandle;

/*-----------------------------RESULT-----------------------------
(15 rows affected)
Completion time: 2023-03-12T18:22:51.2536459+00:00  */


/*------------------------------------------XQUERY solution--------------------------------------------*/

DECLARE @xmlXDoc XML;

SELECT @xmlXDoc = BulkColumn
FROM OPENROWSET(
	BULK 'C:\Users\vagrant\Desktop\BCP\StockItems-188-1fb5df.xml',
	SINGLE_CLOB)
AS date;




MERGE Warehouse.StockItems as targ
USING(
		SELECT
			itemNode.value('(@Name)[1]',						'NVARCHAR(100)')	as [StockItemName]
			,itemNode.value('(SupplierID)[1]',					'INT')				as [SupplierID]
			,itemNode.value('(Package/UnitPackageID)[1]',		'INT')				as [UnitPackageID]
			,itemNode.value('(Package/OuterPackageID)[1]',		'INT')				as [OuterPackageID]
			,itemNode.value('(Package/QuantityPerOuter)[1]',	'INT')				as [QuantityPerOuter]
			,itemNode.value('(Package/TypicalWeightPerUnit)[1]', 'DECIMAL(18,3)')	as [TypicalWeightPerUnit]
			,itemNode.value('(LeadTimeDays)[1]',				'INT')				as [LeadTimeDays]
			,itemNode.value('(IsChillerStock)[1]',				'BIT')				as [IsChillerStock]
			,itemNode.value('(TaxRate)[1]',						'DECIMAL(18,3)')	as [TaxRate]
			,itemNode.value('(UnitPrice)[1]',					'DECIMAL(18,2)')	as [UnitPrice]
		FROM
			@xmlXDoc.nodes('/StockItems/Item') t(itemNode)
		) src
ON targ.StockItemName = src.StockItemName
WHEN MATCHED THEN UPDATE SET
		targ.[SupplierID]=				src.[SupplierID]
		,targ.[UnitPackageID]=			src.[UnitPackageID]
		,targ.[OuterPackageID]=			src.[OuterPackageID]
		,targ.[QuantityPerOuter]=		src.[QuantityPerOuter]
		,targ.[TypicalWeightPerUnit]=	src.[TypicalWeightPerUnit]
		,targ.[LeadTimeDays]=			src.[LeadTimeDays]
		,targ.[IsChillerStock]=			src.[IsChillerStock]
		,targ.[TaxRate]=				src.[TaxRate]
		,targ.[UnitPrice]=				src.[UnitPrice]
WHEN NOT MATCHED THEN INSERT
		([StockItemName]
		,[SupplierID]
		,[UnitPackageID]
		,[OuterPackageID]
		,[QuantityPerOuter]
		,[TypicalWeightPerUnit]
		,[LeadTimeDays]
		,[IsChillerStock]
		,[TaxRate]
		,[UnitPrice]
		,[LastEditedBy])
	VALUES
		(src.[StockItemName]
		,src.[SupplierID]
		,src.[UnitPackageID]
		,src.[OuterPackageID]
		,src.[QuantityPerOuter]
		,src.[TypicalWeightPerUnit]
		,src.[LeadTimeDays]
		,src.[IsChillerStock]
		,src.[TaxRate]
		,src.[UnitPrice]
		,1 /*Admin*/);

/*-----------------------------RESULT-----------------------------
(15 rows affected)
Completion time: 2023-03-12T19:40:51.2371608+00:00  */

/*
2. Выгрузить данные из таблицы StockItems в такой же xml-файл, как StockItems.xml
*/

SELECT
	w_si.StockItemName		as [@ItemName],
	w_si.SupplierID			as [SupplierID],
	w_si.UnitPackageID		as [Package/UnitPackageID],
	w_si.OuterPackageID		as [Package/OuterPackageID],
	w_si.QuantityPerOuter	as [Package/QuantityPerOuter],
	w_si.TypicalWeightPerUnit as [Package/TypicalWeightPerUnit],
	w_si.LeadTimeDays		as [LeadTimeDays],
	w_si.IsChillerStock		as [IsChillerStock],
	w_si.TaxRate			as [TaxRate],
	w_si.UnitPrice			as [UnitPrice]
FROM
	Warehouse.StockItems w_si
FOR XML PATH('Item'), ROOT('StockItems')


/*--------------------RESULT--------------*/
--<StockItems>
--  <Item ItemName="USB missile launcher (Green)">
--    <SupplierID>12</SupplierID>
--    <Package>
--      <UnitPackageID>7</UnitPackageID>
--      <OuterPackageID>7</OuterPackageID>
--      <QuantityPerOuter>1</QuantityPerOuter>
--      <TypicalWeightPerUnit>0.300</TypicalWeightPerUnit>
--    </Package>
--    <LeadTimeDays>14</LeadTimeDays>
--    <IsChillerStock>0</IsChillerStock>
--    <TaxRate>15.000</TaxRate>
--    <UnitPrice>25.00</UnitPrice>
--  </Item>
--	...
--</StockItems>


/*
3. В таблице Warehouse.StockItems в колонке CustomFields есть данные в JSON.
Написать SELECT для вывода:
- StockItemID
- StockItemName
- CountryOfManufacture (из CustomFields)
- FirstTag (из поля CustomFields, первое значение из массива Tags)
*/

SELECT 
	w_si.StockItemID,
	w_si.StockItemName,
	JSON_VALUE(w_si.CustomFields, '$.CountryOfManufacture') as CountryOfManufacture,
	JSON_VALUE(w_si.CustomFields, '$.Tags[0]') as FirstTag
FROM
	Warehouse.StockItems w_si;

/*--------------------TEST RESULT--------------*/
--StockItemID	StockItemName	CustomFields	CountryOfManufacture	CountryOfManufacture
--1	USB missile launcher (Green)	{ "CountryOfManufacture": "China", "Tags": ["USB Powered"] }	China	USB Powered
--2	USB rocket launcher (Gray)	{ "CountryOfManufacture": "China", "Tags": ["USB Powered"] }	China	USB Powered
--3	Office cube periscope (Black)	{ "CountryOfManufacture": "China", "Tags": [] }	China	NULL
--4	USB food flash drive - sushi roll	{ "CountryOfManufacture": "Japan", "Tags": ["32GB","USB Powered"] }	Japan	32GB


/*
4. Найти в StockItems строки, где есть тэг "Vintage".
Вывести: 
- StockItemID
- StockItemName
- (опционально) все теги (из CustomFields) через запятую в одном поле

Тэги искать в поле CustomFields, а не в Tags.
Запрос написать через функции работы с JSON.
Для поиска использовать равенство, использовать LIKE запрещено.

Должно быть в таком виде:
... where ... = 'Vintage'

Так принято не будет:
... where ... Tags like '%Vintage%'
... where ... CustomFields like '%Vintage%' 
*/

WITH CTE_ItemsWithTags 
AS
	(SELECT 
		w_si.StockItemID as StockItemID,
		w_si.StockItemName as StockItemName,
		nestTags.value as Tag
	FROM
		Warehouse.StockItems w_si
		CROSS APPLY OPENJSON(w_si.CustomFields,'$.Tags') nestTags)
SELECT
	CTE_ItemsWithTags.StockItemID,
	CTE_ItemsWithTags.StockItemName,
	STRING_AGG(CTE_ItemsWithTags.Tag,',') as Tags
FROM
	CTE_ItemsWithTags
WHERE EXISTS(
	SELECT 1
	FROM CTE_ItemsWithTags e
	WHERE e.StockItemID = CTE_ItemsWithTags.StockItemID
	and e.Tag = 'Vintage')
GROUP BY 
	CTE_ItemsWithTags.StockItemID,
	CTE_ItemsWithTags.StockItemName;

/*--------------------RESULT--------------*/
--StockItemID	StockItemName	Tags
--64	RC vintage American toy coupe with remote control (Red) 1/50 scale	Radio Control,Realistic Sound,Vintage
--65	RC vintage American toy coupe with remote control (Black) 1/50 scale	Radio Control,Realistic Sound,Vintage
--73	Ride on vintage American toy coupe (Red) 1/12 scale	Vintage,So Realistic
--74	Ride on vintage American toy coupe (Black) 1/12 scale	Vintage,So Realistic
