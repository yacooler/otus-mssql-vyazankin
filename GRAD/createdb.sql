if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('addr.account') and o.name = 'fk_account_join_flat')
alter table addr.account
   drop constraint fk_account_join_flat
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('bill.account_payment') and o.name = 'fk_account_ref_account_payment')
alter table bill.account_payment
   drop constraint fk_account_ref_account_payment
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('bill.account_payment') and o.name = 'fk_bank_file_detail_ref_account_payment')
alter table bill.account_payment
   drop constraint fk_bank_file_detail_ref_account_payment
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('bill.account_payment_details') and o.name = 'fk_account_payment_ref_account_payment_detail')
alter table bill.account_payment_details
   drop constraint fk_account_payment_ref_account_payment_detail
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('bill.account_payment_details') and o.name = 'fk_service_ref_account_payment_details')
alter table bill.account_payment_details
   drop constraint fk_service_ref_account_payment_details
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('lwy.account_payment_link_lawsuit') and o.name = 'fk_account_payment_details_ref_account_payment_link_lawsuit')
alter table lwy.account_payment_link_lawsuit
   drop constraint fk_account_payment_details_ref_account_payment_link_lawsuit
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('lwy.account_payment_link_lawsuit') and o.name = 'fk_lawsuit_detail_ref_account_payment_link_lawsuit')
alter table lwy.account_payment_link_lawsuit
   drop constraint fk_lawsuit_detail_ref_account_payment_link_lawsuit
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('bill.bank_file') and o.name = 'fk_bank_file_ref_bank_file_detail')
alter table bill.bank_file
   drop constraint fk_bank_file_ref_bank_file_detail
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('bill.bank_file_detail') and o.name = 'fk_bank_file_ref_bank_file_detail')
alter table bill.bank_file_detail
   drop constraint fk_bank_file_ref_bank_file_detail
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('addr.city') and o.name = 'fk_city_ref_mo')
alter table addr.city
   drop constraint fk_city_ref_mo
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('addr.flat') and o.name = 'fk_flat_ref_house')
alter table addr.flat
   drop constraint fk_flat_ref_house
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('addr.house') and o.name = 'fk_house_ref_street')
alter table addr.house
   drop constraint fk_house_ref_street
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('lwy.lawsuit') and o.name = 'fk_owner_term_ref_lawsuit')
alter table lwy.lawsuit
   drop constraint fk_owner_term_ref_lawsuit
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('lwy.lawsuit_detail') and o.name = 'fk_lawsuit_ref_lawsuit_detail')
alter table lwy.lawsuit_detail
   drop constraint fk_lawsuit_ref_lawsuit_detail
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('lwy.lawsuit_detail') and o.name = 'fk_service_ref_lawsuit_detail')
alter table lwy.lawsuit_detail
   drop constraint fk_service_ref_lawsuit_detail
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('prop.owner_person') and o.name = 'fk_owner_type_ref_owner')
alter table prop.owner_person
   drop constraint fk_owner_type_ref_owner
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('prop.owner_term') and o.name = 'fk_account_ref_owner_term')
alter table prop.owner_term
   drop constraint fk_account_ref_owner_term
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('prop.owner_term') and o.name = 'fk_owner_person_ref_owner_term')
alter table prop.owner_term
   drop constraint fk_owner_person_ref_owner_term
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('addr.street') and o.name = 'fk_street_ref_city')
alter table addr.street
   drop constraint fk_street_ref_city
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('addr.street') and o.name = 'fk_street_type_ref_street')
alter table addr.street
   drop constraint fk_street_type_ref_street
go

if exists (select 1
            from  sysobjects
           where  id = object_id('addr.v_house_list')
            and   type = 'V')
   drop view addr.v_house_list
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('addr.account')
            and   name  = 'UQ_account_name'
            and   indid > 0
            and   indid < 255)
   drop index addr.account.UQ_account_name
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('addr.account')
            and   name  = 'FK_account_join_flat'
            and   indid > 0
            and   indid < 255)
   drop index addr.account.FK_account_join_flat
go

if exists (select 1
            from  sysobjects
           where  id = object_id('addr.account')
            and   type = 'U')
   drop table addr.account
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('bill.account_payment')
            and   name  = 'FK_bank_file_detail_ref_account_payment'
            and   indid > 0
            and   indid < 255)
   drop index bill.account_payment.FK_bank_file_detail_ref_account_payment
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('bill.account_payment')
            and   name  = 'FK_account_ref_account_payment'
            and   indid > 0
            and   indid < 255)
   drop index bill.account_payment.FK_account_ref_account_payment
go

if exists (select 1
            from  sysobjects
           where  id = object_id('bill.account_payment')
            and   type = 'U')
   drop table bill.account_payment
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('bill.account_payment_details')
            and   name  = 'FK_account_payment_ref_account_payment_detail'
            and   indid > 0
            and   indid < 255)
   drop index bill.account_payment_details.FK_account_payment_ref_account_payment_detail
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('bill.account_payment_details')
            and   name  = 'FK_service_ref_account_payment_details'
            and   indid > 0
            and   indid < 255)
   drop index bill.account_payment_details.FK_service_ref_account_payment_details
go

if exists (select 1
            from  sysobjects
           where  id = object_id('bill.account_payment_details')
            and   type = 'U')
   drop table bill.account_payment_details
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('lwy.account_payment_link_lawsuit')
            and   name  = 'FK_lawsuit_detail_ref_account_payment_link_lawsuit'
            and   indid > 0
            and   indid < 255)
   drop index lwy.account_payment_link_lawsuit.FK_lawsuit_detail_ref_account_payment_link_lawsuit
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('lwy.account_payment_link_lawsuit')
            and   name  = 'FK_account_payment_details_ref_account_payment_link_lawsuit'
            and   indid > 0
            and   indid < 255)
   drop index lwy.account_payment_link_lawsuit.FK_account_payment_details_ref_account_payment_link_lawsuit
go

if exists (select 1
            from  sysobjects
           where  id = object_id('lwy.account_payment_link_lawsuit')
            and   type = 'U')
   drop table lwy.account_payment_link_lawsuit
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('bill.bank')
            and   name  = 'UQ_Bank_Name'
            and   indid > 0
            and   indid < 255)
   drop index bill.bank.UQ_Bank_Name
go

if exists (select 1
            from  sysobjects
           where  id = object_id('bill.bank')
            and   type = 'U')
   drop table bill.bank
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('bill.bank_file')
            and   name  = 'FK_bank_ref_bank_file'
            and   indid > 0
            and   indid < 255)
   drop index bill.bank_file.FK_bank_ref_bank_file
go

if exists (select 1
            from  sysobjects
           where  id = object_id('bill.bank_file')
            and   type = 'U')
   drop table bill.bank_file
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('bill.bank_file_detail')
            and   name  = 'FK_bank_file_ref_bank_file_detail'
            and   indid > 0
            and   indid < 255)
   drop index bill.bank_file_detail.FK_bank_file_ref_bank_file_detail
go

if exists (select 1
            from  sysobjects
           where  id = object_id('bill.bank_file_detail')
            and   type = 'U')
   drop table bill.bank_file_detail
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('addr.city')
            and   name  = 'UQ_city_name_mo_id'
            and   indid > 0
            and   indid < 255)
   drop index addr.city.UQ_city_name_mo_id
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('addr.city')
            and   name  = 'FK_city_ref_mo'
            and   indid > 0
            and   indid < 255)
   drop index addr.city.FK_city_ref_mo
go

if exists (select 1
            from  sysobjects
           where  id = object_id('addr.city')
            and   type = 'U')
   drop table addr.city
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('addr.flat')
            and   name  = 'UQ_flat_name_house_id'
            and   indid > 0
            and   indid < 255)
   drop index addr.flat.UQ_flat_name_house_id
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('addr.flat')
            and   name  = 'FK_flat_ref_house'
            and   indid > 0
            and   indid < 255)
   drop index addr.flat.FK_flat_ref_house
go

if exists (select 1
            from  sysobjects
           where  id = object_id('addr.flat')
            and   type = 'U')
   drop table addr.flat
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('addr.house')
            and   name  = 'UQ_house_name_street_id'
            and   indid > 0
            and   indid < 255)
   drop index addr.house.UQ_house_name_street_id
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('addr.house')
            and   name  = 'FK_house_ref_street'
            and   indid > 0
            and   indid < 255)
   drop index addr.house.FK_house_ref_street
go

if exists (select 1
            from  sysobjects
           where  id = object_id('addr.house')
            and   type = 'U')
   drop table addr.house
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('lwy.lawsuit')
            and   name  = 'FK_owner_term_ref_lawsuit'
            and   indid > 0
            and   indid < 255)
   drop index lwy.lawsuit.FK_owner_term_ref_lawsuit
go

if exists (select 1
            from  sysobjects
           where  id = object_id('lwy.lawsuit')
            and   type = 'U')
   drop table lwy.lawsuit
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('lwy.lawsuit_detail')
            and   name  = 'FK_service_ref_lawsuit_detail'
            and   indid > 0
            and   indid < 255)
   drop index lwy.lawsuit_detail.FK_service_ref_lawsuit_detail
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('lwy.lawsuit_detail')
            and   name  = 'FK_lawsuit_ref_lawsuit_detail'
            and   indid > 0
            and   indid < 255)
   drop index lwy.lawsuit_detail.FK_lawsuit_ref_lawsuit_detail
go

if exists (select 1
            from  sysobjects
           where  id = object_id('lwy.lawsuit_detail')
            and   type = 'U')
   drop table lwy.lawsuit_detail
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('prop.owner_person')
            and   name  = 'IX_owner_name__type_id'
            and   indid > 0
            and   indid < 255)
   drop index prop.owner_person.IX_owner_name__type_id
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('prop.owner_person')
            and   name  = 'FK_owner_type_ref_owner'
            and   indid > 0
            and   indid < 255)
   drop index prop.owner_person.FK_owner_type_ref_owner
go

if exists (select 1
            from  sysobjects
           where  id = object_id('prop.owner_person')
            and   type = 'U')
   drop table prop.owner_person
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('prop.owner_term')
            and   name  = 'FK_account_ref_owner_term'
            and   indid > 0
            and   indid < 255)
   drop index prop.owner_term.FK_account_ref_owner_term
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('prop.owner_term')
            and   name  = 'FK_owner_ref_owner_term'
            and   indid > 0
            and   indid < 255)
   drop index prop.owner_term.FK_owner_ref_owner_term
go

if exists (select 1
            from  sysobjects
           where  id = object_id('prop.owner_term')
            and   type = 'U')
   drop table prop.owner_term
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('prop.owner_type')
            and   name  = 'UQ_owner_type_name'
            and   indid > 0
            and   indid < 255)
   drop index prop.owner_type.UQ_owner_type_name
go

if exists (select 1
            from  sysobjects
           where  id = object_id('prop.owner_type')
            and   type = 'U')
   drop table prop.owner_type
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('addr.mo')
            and   name  = 'UQ_mo_name'
            and   indid > 0
            and   indid < 255)
   drop index addr.mo.UQ_mo_name
go

if exists (select 1
            from  sysobjects
           where  id = object_id('addr.mo')
            and   type = 'U')
   drop table addr.mo
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('bill.service')
            and   name  = 'UQ_service_name'
            and   indid > 0
            and   indid < 255)
   drop index bill.service.UQ_service_name
go

if exists (select 1
            from  sysobjects
           where  id = object_id('bill.service')
            and   type = 'U')
   drop table bill.service
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('addr.street')
            and   name  = 'UQ_street_name_type_city_id'
            and   indid > 0
            and   indid < 255)
   drop index addr.street.UQ_street_name_type_city_id
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('addr.street')
            and   name  = 'FK_street_type_ref_street'
            and   indid > 0
            and   indid < 255)
   drop index addr.street.FK_street_type_ref_street
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('addr.street')
            and   name  = 'FK_street_ref_city'
            and   indid > 0
            and   indid < 255)
   drop index addr.street.FK_street_ref_city
go

if exists (select 1
            from  sysobjects
           where  id = object_id('addr.street')
            and   type = 'U')
   drop table addr.street
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('addr.street_type')
            and   name  = 'UQ_street_full_type_name'
            and   indid > 0
            and   indid < 255)
   drop index addr.street_type.UQ_street_full_type_name
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('addr.street_type')
            and   name  = 'UQ_street_short_type_name'
            and   indid > 0
            and   indid < 255)
   drop index addr.street_type.UQ_street_short_type_name
go

if exists (select 1
            from  sysobjects
           where  id = object_id('addr.street_type')
            and   type = 'U')
   drop table addr.street_type
go

drop schema addr
go

drop schema bill
go

drop schema lwy
go

drop schema prop
go

/*==============================================================*/
/* User: addr                                                   */
/*==============================================================*/
create schema addr
go


/*==============================================================*/
/* User: bill                                                   */
/*==============================================================*/
create schema bill
go


/*==============================================================*/
/* User: lwy                                                    */
/*==============================================================*/
create schema lwy
go


/*==============================================================*/
/* User: prop                                                   */
/*==============================================================*/
create schema prop
go



/*==============================================================*/
/* Table: account                                               */
/*==============================================================*/
create table addr.account (
   account_id           int                  identity,
   flat_id              int                  not null,
   account_name         varchar(255)         not null,
   account_dt_start     datetime             not null
      constraint CKC_ACCOUNT_DT_START_ACCOUNT check (account_dt_start between '20000101' and '20990101'),
   account_dt_end       datetime             not null constraint DF_ACCOUNT_DT_END default '20990101'
   constraint PK_ACCOUNT primary key nonclustered (account_id)
)
go

/*==============================================================*/
/* Index: FK_account_join_flat                                  */
/*==============================================================*/
create index FK_account_join_flat on addr.account (
flat_id ASC
)
go

/*==============================================================*/
/* Index: UQ_account_name                                       */
/*==============================================================*/
create unique index UQ_account_name on addr.account (
account_name ASC
)
go

/*==============================================================*/
/* Table: account_payment                                       */
/*==============================================================*/
create table bill.account_payment (
   account_payment_id   Bigint               identity,
   bank_file_detail_id  Bigint               not null,
   account_id           int                  not null,
   acc_pay_date         datetime             not null,
   acc_pay_accept_date  datetime             not null,
   acc_pay_term_date    datetime             not null,
   acc_pay_amount       numeric(12,2)        not null,
   acc_pay_type         int                  not null,
   constraint PK_ACCOUNT_PAYMENT primary key nonclustered (account_payment_id)
)
go

/*==============================================================*/
/* Index: FK_account_ref_account_payment                        */
/*==============================================================*/
create index FK_account_ref_account_payment on bill.account_payment (
account_id ASC
)
go

/*==============================================================*/
/* Index: FK_bank_file_detail_ref_account_payment               */
/*==============================================================*/
create index FK_bank_file_detail_ref_account_payment on bill.account_payment (
bank_file_detail_id ASC
)
go

/*==============================================================*/
/* Table: account_payment_details                               */
/*==============================================================*/
create table bill.account_payment_details (
   account_payment_detail_id Bigint               identity,
   account_payment_id   Bigint               not null,
   service_id           int                  not null,
   acc_pay_detail_amount decimal(12,2)        not null,
   constraint PK_ACCOUNT_PAYMENT_DETAILS primary key nonclustered (account_payment_detail_id)
)
go

/*==============================================================*/
/* Index: FK_service_ref_account_payment_details                */
/*==============================================================*/
create index FK_service_ref_account_payment_details on bill.account_payment_details (
service_id ASC
)
go

/*==============================================================*/
/* Index: FK_account_payment_ref_account_payment_detail         */
/*==============================================================*/
create index FK_account_payment_ref_account_payment_detail on bill.account_payment_details (
account_payment_id ASC
)
go

/*==============================================================*/
/* Table: account_payment_link_lawsuit                          */
/*==============================================================*/
create table lwy.account_payment_link_lawsuit (
   account_payment_link_lawsuit_id Bigint               identity,
   lawsuit_detail_id    Bigint               not null,
   account_payment_detail_id Bigint               not null,
   acc_cred_amount      numeric(12,2)        not null,
   constraint PK_ACCOUNT_PAYMENT_LINK_LAWSUI primary key nonclustered (account_payment_link_lawsuit_id)
)
go

/*====================================================================*/
/* Index: FK_account_payment_details_ref_account_payment_link_lawsuit */
/*====================================================================*/
create index FK_account_payment_details_ref_account_payment_link_lawsuit on lwy.account_payment_link_lawsuit (
account_payment_detail_id ASC
)
go

/*==============================================================*/
/* Index: FK_lawsuit_detail_ref_account_payment_link_lawsuit    */
/*==============================================================*/
create index FK_lawsuit_detail_ref_account_payment_link_lawsuit on lwy.account_payment_link_lawsuit (
lawsuit_detail_id ASC
)
go

/*==============================================================*/
/* Table: bank                                                  */
/*==============================================================*/
create table bill.bank (
   bank_id              int                  identity,
   bank_name            varchar(255)         not null,
   constraint PK_BANK primary key nonclustered (bank_id)
)
go

/*==============================================================*/
/* Index: UQ_Bank_Name                                          */
/*==============================================================*/
create unique index UQ_Bank_Name on bill.bank (
bank_name ASC
)
go

/*==============================================================*/
/* Table: bank_file                                             */
/*==============================================================*/
create table bill.bank_file (
   bank_file_id         int                  identity,
   bank_id              int                  not null,
   bank_file_name       varchar(255)         not null,
   bank_file_dt_create  datetime             not null,
   bank_file_dt_load    datetime             null,
   bank_file_crc        varchar(255)         null,
   constraint PK_BANK_FILE primary key nonclustered (bank_file_id)
)
go

/*==============================================================*/
/* Index: FK_bank_ref_bank_file                                 */
/*==============================================================*/
create index FK_bank_ref_bank_file on bill.bank_file (
bank_id ASC
)
go

/*==============================================================*/
/* Table: bank_file_detail                                      */
/*==============================================================*/
create table bill.bank_file_detail (
   bank_file_detail_id  Bigint               identity,
   bank_file_id         int                  not null,
   bank_file_row        varchar(max)         not null,
   bank_file_payment_date datetime             not null,
   constraint PK_BANK_FILE_DETAIL primary key nonclustered (bank_file_detail_id)
)
go

/*==============================================================*/
/* Index: FK_bank_file_ref_bank_file_detail                     */
/*==============================================================*/
create index FK_bank_file_ref_bank_file_detail on bill.bank_file_detail (
bank_file_id ASC
)
go

/*==============================================================*/
/* Table: city                                                  */
/*==============================================================*/
create table addr.city (
   city_id              integer              identity,
   mo_id                integer              not null,
   city_name            varchar(255)         not null,
   constraint PK_CITY primary key nonclustered (city_id)
)
go

/*==============================================================*/
/* Index: FK_city_ref_mo                                        */
/*==============================================================*/
create index FK_city_ref_mo on addr.city (
mo_id ASC
)
go

/*==============================================================*/
/* Index: UQ_city_name_mo_id                                    */
/*==============================================================*/
create unique index UQ_city_name_mo_id on addr.city (
city_name ASC,
mo_id ASC
)
go

/*==============================================================*/
/* Table: flat                                                  */
/*==============================================================*/
create table addr.flat (
   flat_id              int                  identity,
   house_id             int                  not null,
   flat_name            varchar(255)         not null,
   constraint PK_FLAT primary key nonclustered (flat_id)
)
go

/*==============================================================*/
/* Index: FK_flat_ref_house                                     */
/*==============================================================*/
create index FK_flat_ref_house on addr.flat (
house_id ASC
)
go

/*==============================================================*/
/* Index: UQ_flat_name_house_id                                 */
/*==============================================================*/
create index UQ_flat_name_house_id on addr.flat (
house_id ASC,
flat_name ASC
)
go

/*==============================================================*/
/* Table: house                                                 */
/*==============================================================*/
create table addr.house (
   house_id             int                  identity,
   street_id            int                  not null,
   house_name           varchar(255)         not null,
   constraint PK_HOUSE primary key nonclustered (house_id)
)
go

/*==============================================================*/
/* Index: FK_house_ref_street                                   */
/*==============================================================*/
create index FK_house_ref_street on addr.house (
street_id ASC
)
go

/*==============================================================*/
/* Index: UQ_house_name_street_id                               */
/*==============================================================*/
create unique index UQ_house_name_street_id on addr.house (
house_name ASC,
street_id ASC
)
go

/*==============================================================*/
/* Table: lawsuit                                               */
/*==============================================================*/
create table lwy.lawsuit (
   lawsuit_id           int                  identity,
   owner_term_id        int                  not null,
   law_dt_beg           datetime             not null,
   law_debt_dt_beg      datetime             not null,
   law_debt_dt_end      datetime             not null,
   constraint PK_LAWSUIT primary key nonclustered (lawsuit_id)
)
go

/*==============================================================*/
/* Index: FK_owner_term_ref_lawsuit                             */
/*==============================================================*/
create index FK_owner_term_ref_lawsuit on lwy.lawsuit (
owner_term_id ASC
)
go

/*==============================================================*/
/* Table: lawsuit_detail                                        */
/*==============================================================*/
create table lwy.lawsuit_detail (
   lawsuit_detail_id    Bigint               identity,
   lawsuit_id           int                  not null,
   service_id           int                  not null,
   law_debt_amount      numeric(12,2)        not null,
   constraint PK_LAWSUIT_DETAIL primary key nonclustered (lawsuit_detail_id)
)
go

/*==============================================================*/
/* Index: FK_lawsuit_ref_lawsuit_detail                         */
/*==============================================================*/
create index FK_lawsuit_ref_lawsuit_detail on lwy.lawsuit_detail (
lawsuit_id ASC
)
go

/*==============================================================*/
/* Index: FK_service_ref_lawsuit_detail                         */
/*==============================================================*/
create index FK_service_ref_lawsuit_detail on lwy.lawsuit_detail (
service_id ASC
)
go

/*==============================================================*/
/* Table: owner_person                                         */
/*==============================================================*/
create table prop.owner_person (
   owner_id             int                  identity,
   owner_name           varchar(255)         not null,
   owner_type_id        int                  not null,
   owner_sex            smallint             not null constraint DF_OWNER_SEX_UNKNOWN default 0
      constraint CKC_OWNER_SEX_OWNER_PE check (owner_sex between 0 and 2),
   constraint PK_OWNER_PERSON primary key nonclustered (owner_id)
)
go

/*==============================================================*/
/* Index: FK_owner_type_ref_owner                               */
/*==============================================================*/
create index FK_owner_type_ref_owner on prop.owner_person (
owner_type_id ASC
)
go

/*==============================================================*/
/* Index: IX_owner_name__type_id                                */
/*==============================================================*/
create index IX_owner_name__type_id on prop.owner_person (
owner_name ASC
)
include (owner_type_id)
go

/*==============================================================*/
/* Table: owner_term                                            */
/*==============================================================*/
create table prop.owner_term (
   owner_term_id        int                  identity,
   account_id           int                  not null,
   owner_term_dt_start  datetime             not null,
   owner_term_dt_end    datetime             not null,
   owner_id             int                  not null,
   constraint PK_OWNER_TERM primary key nonclustered (owner_term_id)
)
go

/*==============================================================*/
/* Index: FK_owner_ref_owner_term                               */
/*==============================================================*/
create index FK_owner_ref_owner_term on prop.owner_term (
owner_id ASC
)
go

/*==============================================================*/
/* Index: FK_account_ref_owner_term                             */
/*==============================================================*/
create index FK_account_ref_owner_term on prop.owner_term (
account_id ASC
)
go

/*==============================================================*/
/* Table: owner_type                                            */
/*==============================================================*/
create table prop.owner_type (
   owner_type_id        int                  identity,
   owner_type_name      varchar(255)         not null,
   constraint PK_OWNER_TYPE primary key nonclustered (owner_type_id)
)
go

/*==============================================================*/
/* Index: UQ_owner_type_name                                    */
/*==============================================================*/
create unique index UQ_owner_type_name on prop.owner_type (
owner_type_name ASC
)
go

/*==============================================================*/
/* Table: mo                                                 */
/*==============================================================*/
create table addr.mo (
   mo_id                int                  identity,
   mo_name              varchar(255)         not null,
   constraint PK_mo primary key nonclustered (mo_id)
)
go

/*==============================================================*/
/* Index: UQ_mo_name                                         */
/*==============================================================*/
create unique index UQ_mo_name on addr.mo (
mo_name ASC
)
go

/*==============================================================*/
/* Table: service                                               */
/*==============================================================*/
create table bill.service (
   service_id           int                  identity,
   service_name         varchar(255)         not null,
   constraint PK_SERVICE primary key nonclustered (service_id)
)
go

/*==============================================================*/
/* Index: UQ_service_name                                       */
/*==============================================================*/
create unique index UQ_service_name on bill.service (
service_name ASC
)
go

/*==============================================================*/
/* Table: street                                                */
/*==============================================================*/
create table addr.street (
   street_id            int                  identity,
   city_id              int                  not null,
   street_type_id       int                  not null,
   street_name          Varchar(255)         not null,
   constraint PK_STREET primary key nonclustered (street_id)
)
go

/*==============================================================*/
/* Index: FK_street_ref_city                                    */
/*==============================================================*/
create index FK_street_ref_city on addr.street (
city_id ASC
)
go

/*==============================================================*/
/* Index: FK_street_type_ref_street                             */
/*==============================================================*/
create index FK_street_type_ref_street on addr.street (
street_type_id ASC
)
go

/*==============================================================*/
/* Index: UQ_street_name_type_city_id                           */
/*==============================================================*/
create unique index UQ_street_name_type_city_id on addr.street (
street_name ASC,
city_id ASC,
street_type_id ASC
)
go

/*==============================================================*/
/* Table: street_type                                           */
/*==============================================================*/
create table addr.street_type (
   street_type_id       int                  identity,
   street_short_type_name varchar(255)         not null,
   street_full_type_name varchar(255)         not null,
   constraint PK_STREET_TYPE primary key nonclustered (street_type_id)
)
go

/*==============================================================*/
/* Index: UQ_street_short_type_name                             */
/*==============================================================*/
create unique index UQ_street_short_type_name on addr.street_type (
street_short_type_name ASC
)
go

/*==============================================================*/
/* Index: UQ_street_full_type_name                              */
/*==============================================================*/
create unique index UQ_street_full_type_name on addr.street_type (
street_full_type_name ASC
)
go

/*==============================================================*/
/* View: v_house_list                                           */
/*==============================================================*/

create view addr.v_house_list with schemabinding  as
SELECT
   addr.mo.mo_id,
   addr.mo.mo_name,
   addr.city.city_id,
   addr.city.city_name,
   addr.street.street_id,
   addr.street.street_name,
   addr.street_type.street_type_id,
   addr.street_type.street_short_type_name,
   addr.street_type.street_full_type_name,
   addr.house.house_id,
	addr.house.house_name,
   addr.mo.mo_name + ' ' + addr.city.city_name + ' ' + addr.street_type.street_full_type_name + ' ' + addr.street.street_name + ' ' + addr.house.house_name full_address
from
   addr.mo
   JOIN addr.city on  addr.mo.mo_id = addr.city.mo_id
   JOIN addr.street on  addr.street.city_id = addr.city.city_id
   JOIN addr.street_type on  addr.street_type.street_type_id = addr.street.street_type_id
   JOIN addr.house on  addr.house.street_id = addr.street.street_id
go

CREATE UNIQUE CLUSTERED INDEX PK_house_list 
ON addr.v_house_list(
    house_id ASC
)

alter table addr.account
   add constraint fk_account_join_flat foreign key (flat_id)
      references addr.flat (flat_id)
go

alter table bill.account_payment
   add constraint fk_account_ref_account_payment foreign key (account_id)
      references addr.account (account_id)
go

alter table bill.account_payment
   add constraint fk_bank_file_detail_ref_account_payment foreign key (bank_file_detail_id)
      references bill.bank_file_detail (bank_file_detail_id)
go

alter table bill.account_payment_details
   add constraint fk_account_payment_ref_account_payment_detail foreign key (account_payment_id)
      references bill.account_payment (account_payment_id)
go

alter table bill.account_payment_details
   add constraint fk_service_ref_account_payment_details foreign key (service_id)
      references bill.service (service_id)
go

alter table lwy.account_payment_link_lawsuit
   add constraint fk_account_payment_details_ref_account_payment_link_lawsuit foreign key (account_payment_detail_id)
      references bill.account_payment_details (account_payment_detail_id)
go

alter table lwy.account_payment_link_lawsuit
   add constraint fk_lawsuit_detail_ref_account_payment_link_lawsuit foreign key (lawsuit_detail_id)
      references lwy.lawsuit_detail (lawsuit_detail_id)
go

alter table bill.bank_file
   add constraint fk_bank_file_ref_bank_file_detail foreign key (bank_id)
      references bill.bank (bank_id)
go


alter table addr.city
   add constraint fk_city_ref_mo foreign key (mo_id)
      references addr.mo (mo_id)
go

alter table addr.flat
   add constraint fk_flat_ref_house foreign key (house_id)
      references addr.house (house_id)
go

alter table addr.house
   add constraint fk_house_ref_street foreign key (street_id)
      references addr.street (street_id)
go

alter table lwy.lawsuit
   add constraint fk_owner_term_ref_lawsuit foreign key (owner_term_id)
      references prop.owner_term (owner_term_id)
go

alter table lwy.lawsuit_detail
   add constraint fk_lawsuit_ref_lawsuit_detail foreign key (lawsuit_id)
      references lwy.lawsuit (lawsuit_id)
go

alter table lwy.lawsuit_detail
   add constraint fk_service_ref_lawsuit_detail foreign key (service_id)
      references bill.service (service_id)
go

alter table prop.owner_person
   add constraint fk_owner_type_ref_owner foreign key (owner_type_id)
      references prop.owner_type (owner_type_id)
go

alter table prop.owner_term
   add constraint fk_account_ref_owner_term foreign key (account_id)
      references addr.account (account_id)
go

alter table prop.owner_term
   add constraint fk_owner_person_ref_owner_term foreign key (owner_id)
      references prop.owner_person (owner_id)
go

alter table addr.street
   add constraint fk_street_ref_city foreign key (city_id)
      references addr.city (city_id)
go

alter table addr.street
   add constraint fk_street_type_ref_street foreign key (street_type_id)
      references addr.street_type (street_type_id)
go
