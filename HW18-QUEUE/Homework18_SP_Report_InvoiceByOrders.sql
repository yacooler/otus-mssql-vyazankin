CREATE OR ALTER PROCEDURE SP_Report_InvoiceByOrders
	@CustomerID int,
	@dt_beg date,
	@dt_end date,
	@output_report_id int = null OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO Reports.CustomerInvoiceByOrders(
		param_customerID,
		param_dt_beg,
		param_dt_end,
		report_order_count)
	SELECT
		@CustomerID,
		@dt_beg,
		@dt_end,
		COUNT(*)
	FROM
		Sales.Invoices s_i
	WHERE
		s_i.CustomerID = @CustomerID
		and s_i.InvoiceDate between @dt_beg and @dt_end;

	SELECT @output_report_id = @@IDENTITY;


END


/*CREATE TABLE reports.CustomerInvoiceByOrders(
	reportID int identity PRIMARY KEY CLUSTERED,
	param_customerID int not null,
	param_dt_beg date not null,
	param_dt_end date not null,
	dttRequest datetime2 not null DEFAULT GETDATE(),
	report_order_count int null);*/