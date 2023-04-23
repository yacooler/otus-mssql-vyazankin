CREATE OR ALTER PROCEDURE SP_ProcessQueryRequest_Report_InvoiceByOrders
AS
BEGIN
	SET NOCOUNT ON;

	--message data
	DECLARE @DLG_HANDLE UNIQUEIDENTIFIER,
			@message nvarchar(max),
			@messageType sysname,
			@responseMessage nvarchar(max);

	--business data
	DECLARE @customerID int,
			@dt_beg date,
			@dt_end date,
			@output_report_id int;

	BEGIN TRANSACTION;

		--select message data & metadata 
		RECEIVE TOP(1)
			@DLG_HANDLE = CONVERSATION_HANDLE,
			@message = MESSAGE_BODY,
			@messageType = MESSAGE_TYPE_NAME
		FROM [dbo].[TargetQueueReport_invoiceByOrders];

		--correct message type - we are able to process report
		IF @messageType = N'//WWI/MSG/RequestReport_InvoiceByOrders'
		BEGIN

			--fill in business params
			SELECT
				@customerID = id,
				@dt_beg = cast(chdt_beg as date),
				@dt_end = cast(chdt_end as date)
			FROM OPENJSON(@message) 
			WITH (
				id INT 'strict $.customerID',
				chdt_beg NVARCHAR(50) 'strict $.dt_beg',
				chdt_end NVARCHAR(50) 'strict $.dt_end'
			);


			--run business report
			EXEC SP_Report_InvoiceByOrders @CustomerID = @customerID, @dt_beg = @dt_beg, @dt_end = @dt_end, @output_report_id = NULL;

			SELECT @responseMessage = (
				SELECT @output_report_id as [report_id]
				FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
			
			SEND ON CONVERSATION @DLG_HANDLE
			MESSAGE TYPE [//WWI/MSG/ResponseReport_InvoiceByOrders]
			(@responseMessage);

			END CONVERSATION @DLG_HANDLE;

		END

	COMMIT TRANSACTION;

END