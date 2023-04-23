CREATE OR ALTER PROCEDURE SP_RequestReport_InvoiceByOrders
	@customerID int,
	@dt_beg date,
	@dt_end date
AS
BEGIN
	SET NOCOUNT ON;

	--send parameters as JSON
	DECLARE @param nvarchar(max);

	SET @param = (
		select top 1 @customerID as [customerID],
		@dt_beg as [dt_beg],
		@dt_end as [dt_end]
		FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)

	--sample: {"customerID":1000,"dt_beg":"2023-04-23","dt_end":"2023-08-01"}


	DECLARE @DLG_HANDLE UNIQUEIDENTIFIER;

	BEGIN TRANSACTION
		

		--open dialogue
		BEGIN DIALOG @DLG_HANDLE
		FROM SERVICE	[//WWI/MSG/InitiatorService_QueueReport_invoiceByOrders]
		TO SERVICE		'//WWI/MSG/TargetService_QueueReport_invoiceByOrders'
		ON CONTRACT		[//WWI/MSG/ContractReport_InvoiceByOrders]
		WITH ENCRYPTION = OFF;

		SEND ON CONVERSATION @DLG_HANDLE
		MESSAGE TYPE [//WWI/MSG/RequestReport_InvoiceByOrders]
		(@param);

	COMMIT TRANSACTION
	
END

