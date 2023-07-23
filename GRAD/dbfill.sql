insert into addr.mo(mo_name)
values('Серпуховский городской округ')
insert into addr.mo(mo_name)
values('Подольский городской округ')

insert into addr.city([mo_id], [city_name])
values
	(1,'Серпухов'), (1,'Чехов'),(1,'Протвино'),(1,'Пущино'),
	(2,'Подольск'), (2,'Дубровицы'),(2,'Кузнечики');

insert into [addr].[street_type]([street_short_type_name], [street_full_type_name])
values('ул.','улица'),('пер.', 'переулок'), ('пр.','проезд'),('просп.','проспект');

insert into [addr].[street](city_id, street_type_id, street_name)
values
	(1, 3, 'Мишина'),(1,1,'Швагирева'),(1,1,'Весенняя'),(1,1,'Ленина'),(1,4,'Ленина')

select * from addr.house order by 2

--Заполняем улицы домами
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
				cast(@currentNumber as varchar(10)) + SUBSTRING('          АБВГ',cast(floor(rand() * 14 + 1) as int),1))
		
			SET @currentNumber = @currentNumber + cast(floor(rand() * 3 + 1) as int)
			SET @J = @J + 1
		END

		SET @street = @street + 1

	END
COMMIT;

--Заполняем квартиры
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

--Лицевые счета
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
('Сбербанк'),('АльфаБанк'),('ВТБ'),('Газпромбанк');


INSERT INTO bill.service([service_name])
VALUES ('Отопление'),('Горячая вода'),('Хородная вода'),('Канализация'),('Пеня')


--Собственники
INSERT INTO [prop].[owner_type](owner_type_name)
VALUES('Физическое лицо'),('Частное юридическое лицо'),('Муниципальная собственность'),
	('Федеральная собственность'),('Ведомственная собственность');

BEGIN TRAN
	DECLARE @i integer = 0;
	DECLARE @accounts integer = 0;
	SELECT @accounts = count(*) from addr.account;
	
	WHILE @i < @accounts
	BEGIN
		WITH CTE_F 
		AS
			(SELECT 1 as ID, 'Иванов' as f
			UNION SELECT 2 ,'Смирнов'
			UNION SELECT 3 ,'Кузнецов'
			UNION SELECT 4 ,'Попов'
			UNION SELECT 5 ,'Васильев'
			UNION SELECT 6 ,'Петров'
			UNION SELECT 7 ,'Соколов'
			UNION SELECT 8 ,'Михайлов'
			UNION SELECT 9 ,'Новиков'
			UNION SELECT 10 ,'Федоров'
			UNION SELECT 11 ,'Морозов'
			UNION SELECT 12 ,'Волков'
			UNION SELECT 13 ,'Алексеев'
			UNION SELECT 14 ,'Лебедев'
			UNION SELECT 15 ,'Семенов'
			UNION SELECT 16 ,'Егоров'
			UNION SELECT 17 ,'Павлов'
			UNION SELECT 18 ,'Козлов'
			UNION SELECT 19 ,'Степанов'
			UNION SELECT 20 ,'Николаев'
			UNION SELECT 21 ,'Орлов'
			UNION SELECT 22 ,'Андреев'
			UNION SELECT 23 ,'Макаров'
			UNION SELECT 24 ,'Никитин'
			UNION SELECT 25 ,'Захаров'
			UNION SELECT 26 ,'Зайцев'
			UNION SELECT 27 ,'Соловьев'
			UNION SELECT 28 ,'Борисов'
			UNION SELECT 29 ,'Яковлев'
			UNION SELECT 30 ,'Григорьев'
			UNION SELECT 31 ,'Романов'
			UNION SELECT 32 ,'Воробьев'
			UNION SELECT 33 ,'Сергеев'
			UNION SELECT 34 ,'Кузьмин'
			UNION SELECT 35 ,'Фролов'
			UNION SELECT 36 ,'Александров'
			UNION SELECT 37 ,'Дмитриев'
			UNION SELECT 38 ,'Королев'
			UNION SELECT 39 ,'Гусев'
			UNION SELECT 40 ,'Киселев'
			UNION SELECT 41 ,'Ильин'
			UNION SELECT 42 ,'Максимов'
			UNION SELECT 43 ,'Поляков'
			UNION SELECT 44 ,'Сорокин'
			UNION SELECT 45 ,'Виноградов'
			UNION SELECT 46 ,'Ковалев'
			UNION SELECT 47 ,'Белов'
			UNION SELECT 48 ,'Медведев'
			UNION SELECT 49 ,'Антонов'
			UNION SELECT 50 ,'Тарасов'
			UNION SELECT 51 ,'Жуков'
			UNION SELECT 52 ,'Баранов'
			UNION SELECT 53 ,'Филиппов'
			UNION SELECT 54 ,'Комаров'
			UNION SELECT 55 ,'Давыдов'
			UNION SELECT 56 ,'Беляев'
			UNION SELECT 57 ,'Герасимов'
			UNION SELECT 58 ,'Богданов'
			UNION SELECT 59 ,'Осипов'
			UNION SELECT 60 ,'Сидоров'
			UNION SELECT 61 ,'Матвеев'
			UNION SELECT 62 ,'Титов'
			UNION SELECT 63 ,'Марков'
			UNION SELECT 64 ,'Миронов'
			UNION SELECT 65 ,'Крылов'
			UNION SELECT 66 ,'Куликов'
			UNION SELECT 67 ,'Карпов'
			UNION SELECT 68 ,'Власов'
			UNION SELECT 69 ,'Мельников'
			UNION SELECT 70 ,'Денисов'
			UNION SELECT 71 ,'Гаврилов'
			UNION SELECT 72 ,'Тихонов'
			UNION SELECT 73 ,'Казаков'
			UNION SELECT 74 ,'Афанасьев'
			UNION SELECT 75 ,'Данилов'
			UNION SELECT 76 ,'Савельев'
			UNION SELECT 77 ,'Тимофеев'
			UNION SELECT 78 ,'Фомин'
			UNION SELECT 79 ,'Чернов'
			UNION SELECT 80 ,'Абрамов'
			UNION SELECT 81 ,'Мартынов'
			UNION SELECT 82 ,'Ефимов'
			UNION SELECT 83 ,'Федотов'
			UNION SELECT 84 ,'Щербаков'
			UNION SELECT 85 ,'Назаров'
			UNION SELECT 86 ,'Калинин'
			UNION SELECT 87 ,'Исаев'
			UNION SELECT 88 ,'Чернышев'
			UNION SELECT 89 ,'Быков'
			UNION SELECT 90 ,'Маслов'
			UNION SELECT 91 ,'Родионов'
			UNION SELECT 92 ,'Коновалов'
			UNION SELECT 93 ,'Лазарев'
			UNION SELECT 94 ,'Воронин'
			UNION SELECT 95 ,'Климов'
			UNION SELECT 96 ,'Филатов'
			UNION SELECT 97 ,'Пономарев'
			UNION SELECT 98 ,'Голубев'
			UNION SELECT 99 ,'Кудрявцев'
			UNION SELECT 100,' Прохоров')
		INSERT INTO [prop].[owner_person](
			owner_name,
			owner_type_id,
			owner_sex)
		SELECT
			(SELECT rtrim(f) from CTE_F where CTE_F.ID = cast(floor(RAND()*100 + 1) as int))
			+ ' ' + substring('АБВГДЕЖЗИКЛМНОПРСТУФХЧШЭЮЯ', cast(floor(RAND() * LEN('АБВГДЕЖЗИКЛМНОПРСТУФХЧШЭЮЯ') + 1) as int),1) +'.'
			+ ' ' + substring('АБВГДЕЖЗИКЛМНОПРСТУФХЧШЭЮЯ', cast(floor(RAND() * LEN('АБВГДЕЖЗИКЛМНОПРСТУФХЧШЭЮЯ') + 1) as int),1) +'.',
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

--Судебные дела, 1000 штук
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
