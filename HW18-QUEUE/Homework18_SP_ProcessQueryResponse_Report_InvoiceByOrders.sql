CREATE OR ALTER PROCEDURE SP_ProcessQueryResponse_Report_InvoiceByOrders
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @DLG_HANDLE UNIQUEIDENTIFIER,
			@message nvarchar(max);

	BEGIN TRANSACTION;

	RECEIVE TOP(1)
		@DLG_HANDLE = CONVERSATION_HANDLE,
		@message = MESSAGE_BODY
	FROM
		[dbo].[InitiatorQueueReport_invoiceByOrders];

	END CONVERSATION @DLG_HANDLE;
	
	--@message contains {report_id} field which is not necessary now but could be used

	COMMIT TRANSACTION;

END