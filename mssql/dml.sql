-- data manipulation language

use AdventureWorks2017;
go

-- SELECT (select, from, where, group by, order by)
select 'hello'
select 1 + 1;

select * -- horizontal filter
from Person.Person;

-- collation = character set is case insensitive, accent sensitive
    -- A == a, a != (accented a)

select firstname, lastname
from Person.Person;

  --
select firstname, LastName --see how case doesn't matter
from Person.Person
where firstname = 'john' or lastname = 'john'; -- vertical filter

select firstname, lastname
from Person.Person
where firstname <> 'john' and lastname <> 'john';
  --

select firstname, lastname
from Person.Person
where (firstname like 'k%') or (lastname like 'k%'); 
-- where (firstname >= 'k' and firstname < 'l') or  (lastname >= 'k' and lastname < 'l') does same thing

-- '%' wildcard, 0 or more 
-- '_' wildcard, exactly 1
-- '[x,y]' either x or y    '[a-d]%' or '[a-d]_'

  --
select firstname, lastname, count(*) as count -- aggregate count, average, sum
from Person.Person
where firstname = 'john'
group by firstname, LastName;

select firstname, lastname, count(*) as count
from Person.Person
where firstname = 'john' -- vertical filter of records
group by firstname, LastName
having count(*) > 1; -- vertical filter of records

select firstname, lastname, count(*) as count
from Person.Person
where firstname = 'john'
group by firstname, LastName
having count(*) > 1
order by lastname desc, count desc;

select firstname, lastname, count(*) as johns
from Person.Person
where firstname = 'john'
group by firstname, LastName
having count(*) > 1
order by johns desc, lastname desc;
  --

-- ORDER OF EXECUTION 
  -- from
  -- where
  -- group by
  -- having
  -- select
  -- order by

-- INSERT
select *
from Person.Address;
--where AddressLine2 like '123 elm%';

insert into Person.Address(AddressLine2, AddressLine1, City, StateProvinceID, PostalCode, SpatialLocation, rowguid, ModifiedDate)
values ('123 elm street', 'suite 200', 'Dallas', 14, 'DABO1', 0xE6100000010C72C2B2242FE04A4016902E7EB1B7F8BF, 'fd069aaa-ad12-4a4c-a548-23b35dfeb241', 2020-23-7 00:00:00.000)

-- UPDATE
update pa
set AddressLine2 = 'suite 200', AddressLine1 = '123 elm street'
from Person.Address as pa
where Addressline1 = 'suite 200';
go

-- DELETE
delete pa
from Person.Address as pa
where Addressline2 = 'suite 200';
go

-- VIEW
create view vw_getpersons with schemabinding -- firstname and lastname
as
select firstname, lastname
from Person.Person
go

select * from vw_getpersons; -- read-only access to Person.Person
go

alter view vw_getpersons with schemabinding
as
select firstname, middlename, lastname
from Person.Person
go

-- FUNCTION

-- STORED PROCEDURE

-- TRIGGER

-- 