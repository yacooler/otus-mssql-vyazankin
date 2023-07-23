insert into addr.mo(mo_name)
values('������������ ��������� �����')
insert into addr.mo(mo_name)
values('���������� ��������� �����')

insert into addr.city([mo_id], [city_name])
values
	(1,'��������'), (1,'�����'),(1,'��������'),(1,'������'),
	(2,'��������'), (2,'���������'),(2,'���������');

insert into [addr].[street_type]([street_short_type_name], [street_full_type_name])
values('��.','�����'),('���.', '��������'), ('��.','������'),('�����.','��������');

insert into [addr].[street](city_id, street_type_id, street_name)
values
	(1, 3, '������'),(1,1,'���������'),(1,1,'��������'),(1,1,'������'),(1,4,'������')

select * from addr.house order by 2

--��������� ����� ������
BEGIN TRAN
	declare @street integer = 1
	WHILE(@street < 6)
	BEGIN
		declare @houses integer = rand() * 50 + 5
		declare @j integer = 1;
		declare @currentNumber integer = 1
	
		WHILE (@J < @houses)
		BEGIN
			INSERT INTO [addr].[house] (street_id, house_name)
			VALUES(
				@street,
				cast(@currentNumber as varchar(10)) + SUBSTRING('          ����',cast(floor(rand() * 14 + 1) as int),1))
		
			SET @currentNumber = @currentNumber + cast(floor(rand() * 3 + 1) as int)
			SET @J = @J + 1
		END

		SET @street = @street + 1

	END
COMMIT;

--��������� ��������
BEGIN TRAN
	DECLARE @totalhouses integer;
	SELECT @totalhouses = (select count(*) from addr.house);
	
	DECLARE @house integer = 1;
	WHILE(@house <= @totalhouses)
	BEGIN
		DECLARE @flats integer;
		DECLARE @flat integer = 0;
		
		SET @flats = 40 + floor( rand() * 15) * 4;
		WHILE (@flat < @flats)
		BEGIN
			INSERT INTO [addr].[flat]([house_id], [flat_name])
			VALUES (@house, cast(@flat + 1 as varchar(10)))
			SET @flat = @flat + 1;
		END
		SET @house = @house + 1;
	END
COMMIT;

--������� �����
BEGIN TRAN
	SET  IDENTITY_INSERT addr.account on;
	DECLARE @current_flat_id integer;

	DECLARE flat_cursor CURSOR  
	FOR SELECT flat_id
	FROM [addr].[flat];

	OPEN flat_cursor  
	FETCH NEXT FROM flat_cursor 
	INTO @current_flat_id;  
	DECLARE @acc_id integer = 1;

	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		INSERT INTO addr.account(
			account_id,
			flat_id,
			account_name,
			account_dt_start,
			account_dt_end)
		VALUES
			(@acc_id,
			@current_flat_id,
			dbo.fn_generate_account_name(@current_flat_id),
			'20000101',
			'20990101');
		SET @acc_id = @acc_id + 1;
		FETCH NEXT FROM flat_cursor 
		INTO @current_flat_id;  
	END

	CLOSE flat_cursor;
	DEALLOCATE flat_cursor;

	SET  IDENTITY_INSERT addr.account off;
COMMIT	

INSERT INTO bill.bank (bank_name)
VALUES
('��������'),('���������'),('���'),('�����������');


INSERT INTO bill.service([service_name])
VALUES ('���������'),('������� ����'),('�������� ����'),('�����������'),('����')


--������������
INSERT INTO [prop].[owner_type](owner_type_name)
VALUES('���������� ����'),('������� ����������� ����'),('������������� �������������'),
	('����������� �������������'),('������������� �������������');

BEGIN TRAN
	DECLARE @i integer = 0;
	DECLARE @accounts integer = 0;
	SELECT @accounts = count(*) from addr.account;
	
	WHILE @i < @accounts
	BEGIN
		WITH CTE_F 
		AS
			(SELECT 1 as ID, '������' as f
			UNION SELECT 2 ,'�������'
			UNION SELECT 3 ,'��������'
			UNION SELECT 4 ,'�����'
			UNION SELECT 5 ,'��������'
			UNION SELECT 6 ,'������'
			UNION SELECT 7 ,'�������'
			UNION SELECT 8 ,'��������'
			UNION SELECT 9 ,'�������'
			UNION SELECT 10 ,'�������'
			UNION SELECT 11 ,'�������'
			UNION SELECT 12 ,'������'
			UNION SELECT 13 ,'��������'
			UNION SELECT 14 ,'�������'
			UNION SELECT 15 ,'�������'
			UNION SELECT 16 ,'������'
			UNION SELECT 17 ,'������'
			UNION SELECT 18 ,'������'
			UNION SELECT 19 ,'��������'
			UNION SELECT 20 ,'��������'
			UNION SELECT 21 ,'�����'
			UNION SELECT 22 ,'�������'
			UNION SELECT 23 ,'�������'
			UNION SELECT 24 ,'�������'
			UNION SELECT 25 ,'�������'
			UNION SELECT 26 ,'������'
			UNION SELECT 27 ,'��������'
			UNION SELECT 28 ,'�������'
			UNION SELECT 29 ,'�������'
			UNION SELECT 30 ,'���������'
			UNION SELECT 31 ,'�������'
			UNION SELECT 32 ,'��������'
			UNION SELECT 33 ,'�������'
			UNION SELECT 34 ,'�������'
			UNION SELECT 35 ,'������'
			UNION SELECT 36 ,'�����������'
			UNION SELECT 37 ,'��������'
			UNION SELECT 38 ,'�������'
			UNION SELECT 39 ,'�����'
			UNION SELECT 40 ,'�������'
			UNION SELECT 41 ,'�����'
			UNION SELECT 42 ,'��������'
			UNION SELECT 43 ,'�������'
			UNION SELECT 44 ,'�������'
			UNION SELECT 45 ,'����������'
			UNION SELECT 46 ,'�������'
			UNION SELECT 47 ,'�����'
			UNION SELECT 48 ,'��������'
			UNION SELECT 49 ,'�������'
			UNION SELECT 50 ,'�������'
			UNION SELECT 51 ,'�����'
			UNION SELECT 52 ,'�������'
			UNION SELECT 53 ,'��������'
			UNION SELECT 54 ,'�������'
			UNION SELECT 55 ,'�������'
			UNION SELECT 56 ,'������'
			UNION SELECT 57 ,'���������'
			UNION SELECT 58 ,'��������'
			UNION SELECT 59 ,'������'
			UNION SELECT 60 ,'�������'
			UNION SELECT 61 ,'�������'
			UNION SELECT 62 ,'�����'
			UNION SELECT 63 ,'������'
			UNION SELECT 64 ,'�������'
			UNION SELECT 65 ,'������'
			UNION SELECT 66 ,'�������'
			UNION SELECT 67 ,'������'
			UNION SELECT 68 ,'������'
			UNION SELECT 69 ,'���������'
			UNION SELECT 70 ,'�������'
			UNION SELECT 71 ,'��������'
			UNION SELECT 72 ,'�������'
			UNION SELECT 73 ,'�������'
			UNION SELECT 74 ,'���������'
			UNION SELECT 75 ,'�������'
			UNION SELECT 76 ,'��������'
			UNION SELECT 77 ,'��������'
			UNION SELECT 78 ,'�����'
			UNION SELECT 79 ,'������'
			UNION SELECT 80 ,'�������'
			UNION SELECT 81 ,'��������'
			UNION SELECT 82 ,'������'
			UNION SELECT 83 ,'�������'
			UNION SELECT 84 ,'��������'
			UNION SELECT 85 ,'�������'
			UNION SELECT 86 ,'�������'
			UNION SELECT 87 ,'�����'
			UNION SELECT 88 ,'��������'
			UNION SELECT 89 ,'�����'
			UNION SELECT 90 ,'������'
			UNION SELECT 91 ,'��������'
			UNION SELECT 92 ,'���������'
			UNION SELECT 93 ,'�������'
			UNION SELECT 94 ,'�������'
			UNION SELECT 95 ,'������'
			UNION SELECT 96 ,'�������'
			UNION SELECT 97 ,'���������'
			UNION SELECT 98 ,'�������'
			UNION SELECT 99 ,'���������'
			UNION SELECT 100,' ��������')
		INSERT INTO [prop].[owner_person](
			owner_name,
			owner_type_id,
			owner_sex)
		SELECT
			(SELECT rtrim(f) from CTE_F where CTE_F.ID = cast(floor(RAND()*100 + 1) as int))
			+ ' ' + substring('��������������������������', cast(floor(RAND() * LEN('��������������������������') + 1) as int),1) +'.'
			+ ' ' + substring('��������������������������', cast(floor(RAND() * LEN('��������������������������') + 1) as int),1) +'.',
			cast(floor(RAND() * 5 + 1) as int),
			1
		;
		SET @i = @i + 1;
	END
COMMIT


INSERT INTO [prop].[owner_term] (
	account_id,
	owner_term_dt_start,
	owner_term_dt_end,
	owner_id)
SELECT 
	a.account_id,
	a.account_dt_start,
	a.account_dt_end,
	p.owner_id
FROM
	[addr].[account] a
	JOIN [prop].[owner_person] p
		ON a.account_id = p.owner_id;

--�������� ����, 1000 ����
BEGIN TRAN
	declare @i integer = 1;
	declare @max_owner_term_id integer;
	set identity_insert [lwy].[lawsuit] on;


	SELECT @max_owner_term_id = (select max([prop].[owner_term].owner_term_id) from [prop].[owner_term]);
	print @max_owner_term_id
	WHILE(@i <= 1000)
	BEGIN
		declare @law_debt_dt_beg datetime;
		declare @law_debt_dt_end datetime;
		declare @owner_term_id integer;

		SET @law_debt_dt_beg = dateadd(dd, cast(floor(RAND() * 250) as int),'20170101');
		SET @law_debt_dt_end = dateadd(dd, cast(floor(RAND() * 500 + 365) as int),@law_debt_dt_beg );
		SET @owner_term_id =  cast(floor(RAND() * @max_owner_term_id + 1) as int)

		INSERT INTO [lwy].[lawsuit](
			lawsuit_id,
			owner_term_id,
			law_dt_beg,
			law_debt_dt_beg,
			law_debt_dt_end)
		SELECT
			@i,
			@owner_term_id,
			dateadd(dd, cast(floor(RAND() * 100) as int),'20230101'),
			@law_debt_dt_beg,
			@law_debt_dt_end;

		set @i = @i + 1;
	END

	set identity_insert [lwy].[lawsuit] off;

COMMIT
