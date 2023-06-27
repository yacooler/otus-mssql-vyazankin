alter database [fkr_lk_2023_06_05]
add filegroup [calc_of_rent_years_filegroup];

alter database [fkr_lk_2023_06_05]
add file (
	name = 'calc_of_rent_years_data',
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\calc_of_rent_years_data.ndf')
to filegroup [calc_of_rent_years_filegroup];


create partition function [fnp_calc_of_rent_years] (datetime) as range right 
for values ('20140101','20150101','20160101','20170101','20180101','20190101','20200101','20210101','20220101','20230101','20240101', '20250101','20260101','20270101','20280101','20290101','20300101');

create partition scheme [schm_calc_of_rent_years] as partition [fnp_calc_of_rent_years] all to ([calc_of_rent_years_filegroup]);

create table calc_of_rent_parts(
	AccountID numeric(13) NOT NULL,
	AccountDate datetime NOT NULL,
	AccountForDate datetime NOT NULL,
	ServiceID int NOT NULL,
	SupplierID int NOT NULL,
	isRecalc int NOT NULL,
	Amount numeric(12,2) NOT NULL);

create clustered index CL_PART_Calc_of_rent_parts on calc_of_rent_parts ([AccountDate])
on [schm_calc_of_rent_years]([AccountDate]);


DECLARE @ENDTERM datetime = '20231201';
DECLARE @TERM datetime = '20140101';

WHILE (@TERM <> @ENDTERM)
BEGIN
	SET @TERM = DATEADD(mm, 1, @TERM);

	INSERT INTO calc_of_rent_parts(
		AccountID,
		AccountDate,
		AccountForDate,
		ServiceID,
		SupplierID,
		isRecalc,
		Amount)
	SELECT
		AccountID,
		AccountDate,
		AccountForDate,
		ServiceID,
		SupplierID,
		isRecalc,
		Amount
	FROM
		calculate.calc_of_rent_parts
	WHERE
		AccountDate between @TERM and EOMONTH(@TERM);
END
