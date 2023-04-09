------------------------------------------------------Муниципальные образования-------------------------------
--Уникальный индекс на муниципальном образовании для поиска по имени и ограничению по уникальности имени
CREATE UNIQUE INDEX UQ_ro_mo_name 
ON addr.ro_mo (
	mo_name ASC
)


------------------------------------------------------Населенные пункты---------------------------------------
--Уникальный индекс на населенном пункте для поиска по имени и ограничению по уникальности имени внутри муниципального образования
CREATE UNIQUE INDEX UQ_city_name_mo_id 
ON addr.city (
	city_name ASC,
	mo_id ASC
)

--Для объединения таблицы городов с муниципальными образованием
CREATE INDEX FK_city_ref_mo 
ON addr.city (
	mo_id ASC
)


-------------------------------------------------------Улицы--------------------------------------------------
--Уникальный индекс на улице для поиска по имени и ограничение уникальности имени в пределах типа и населенного пункта
CREATE UNIQUE INDEX UQ_street_name_type_city_id 
ON addr.street (
	street_name ASC,
	city_id ASC,
	street_type_id ASC
)

--Для объединения таблицы улиц и городов
CREATE INDEX FK_street_ref_city 
ON addr.street (
	city_id ASC
)

--Для объединения таблицы улиц с типом улицы
CREATE INDEX FK_street_type_ref_street
ON addr.street (
	street_type_id ASC
)

-------------------------------------------------------Типы улиц-----------------------------------------------
--Уникальные индексы на тип улицы и полный тип улицы. Вряд-ли понадобятся при поиске, т.к. количество типов сильно ограничено
CREATE UNIQUE INDEX UQ_street_short_type_name on addr.street_type (
	street_short_type_name ASC
)

CREATE UNIQUE INDEX UQ_street_full_type_name on addr.street_type (
	street_full_type_name ASC
)

-------------------------------------------------------Дома----------------------------------------------------
--Для обеспечения уникальности имени дома внутри улицы и поиска по имени дома
CREATE UNIQUE INDEX UQ_house_name_street_id 
ON addr.house (
	house_name ASC,
	street_id ASC
)

--Для объединения домов и улиц
CREATE INDEX FK_house_ref_street
ON addr.house (
	street_id ASC
)

------------------------------------------------------Представление по поиску адреса---------------------------
--Сделано WITH SCHEMABINDING, поэтому позволяет повесить на себя кластерный индекс
CREATE CLUSTERED INDEX PK_house_list 
ON addr.v_house_list(
    house_id ASC
)

--Каталог для полнотекстового индекса
CREATE FULLTEXT CATALOG ftCatalog AS DEFAULT;  

--Полнотекстовый индекс, POPULATION включен по умолчанию. full address - набор всех полей адресных таблиц через пробел
CREATE FULLTEXT INDEX 
ON addr.v_house_list
	(full_address LANGUAGE 1049) 
KEY INDEX PK_house_list;  
