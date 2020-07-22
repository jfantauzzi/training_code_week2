-- data definition language

use master;
go

-- CREATE

create database PizzaStoreDb; --project
go

create schema Pizza; --namespace -- ~mkdir pizza
go

--constraints = datatype, key, default, check, null, ?
--number datatypes = tinyint (int8), smallint (int16), int (int32), bigint (int64), numeric, decimal
--text datatypes = text, ntext, varchar, ***nvarchar (utf-8), char (ascii), nchar(utf-8)
--datetime datatypes = date, time, datetime, datetime2
--boolean datatypes = bit

create table Pizza.Pizza -- ~touch pizza/pizza
(
  PizzaId int not null, --primary key (not recommended),
  Name nvarchar(250) not null,
  DateModified datetime2(0) not null,
  IsValid bit not null,
  constraint PK_PizzaId (PizzaId) primary key
);

create table Pizza.Crust
(
  CrustId int not null,
  constraint PK_CrustId (CrustId) primary key

);

create table Pizza.Size
(
  SizeId int not null,
  constraint PK_SizeId (SizeId) primary key
);

create table Pizza.Topping
(
ToppingId int not null,
constraint PK_ToppingId (ToppingId) primary key
);


-- ALTER

-- DROP

-- TRUNCATE