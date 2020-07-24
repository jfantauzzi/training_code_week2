-- data manipulation language

use AdventureWorks2017;
go

-- SELECT (select, from, where, group by, order by)
select 'hello'
select 1 + 1;

select *
-- horizontal filter
from Person.Person;

-- collation = character set is case insensitive, accent sensitive
-- A == a, a != (accented a)

select firstname, lastname
from Person.Person;

--
select firstname, LastName
--see how case doesn't matter
from Person.Person
where firstname = 'john' or lastname = 'john';
-- vertical filter

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
select firstname, lastname, count(*) as count
-- aggregate count, average, sum
from Person.Person
where firstname = 'john'
group by firstname, LastName;

select firstname, lastname, count(*) as count
from Person.Person
where firstname = 'john'
-- vertical filter of records
group by firstname, LastName
having count(*) > 1;
-- vertical filter of records

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

--insert into Person.Address(AddressLine2, AddressLine1, City, StateProvinceID, PostalCode, SpatialLocation, rowguid, ModifiedDate)
--values ('123 elm street', 'suite 200', 'Dallas', 14, 'DABO1', 0xE6100000010C72C2B2242FE04A4016902E7EB1B7F8BF, 'fd069aaa-ad12-4a4c-a548-23b35dfeb241', 2020-23-07 00:00:00)

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
create view vw_getpersons
with
  schemabinding
-- firstname and lastname
as
  select firstname, lastname
  from Person.Person
go

select *
from vw_getpersons; -- read-only access to Person.Person
go

alter view vw_getpersons
with
  schemabinding
as
  select firstname, middlename, lastname
  from Person.Person
go

drop view vw_getpersons;
go

-- FUNCTION
-- scalar = returns a value
create function fn_getname(@id int)
returns nvarchar(250)
as
begin
  -- what is the value of null   in data, null = value not available and value not given
  -- why is coalesce a solution?

  declare @result nvarchar(250);
  select @result = firstname + coalesce(' ' + middlename + ' ', ' ') + lastname
  -- coalesce = isnull alternative
  from Person.Person
  where businessentityid = @id;

  return @result;
end;
go

select dbo.fn_getname(100);
go

--function 2
create function fn_fullname(@first nvarchar(200), @last nvarchar(200))
returns nvarchar(401)
as
begin
  return @first + ' ' + @last
end;
go

select dbo.fn_fullname(firstname, lastname)
from Person.Person;
go

-- tabular = returns 1 or more records (views with )
create function fn_getpeople(@first nvarchar(200))
returns table
as
return
  select firstname, lastname
from Person.Person
where firstname = @first
go

select *
from dbo.fn_getpeople();
go

-- STORED PROCEDURE
create proc sp_insertperson(@first nvarchar, @last nvarchar)
as
begin
  -- validate first, last
  -- validate duplicate
  -- insert

  begin tran
  --wrapping in a transaction
  -- Atomic = should affect 1 record set and it should complete
  -- Consistent = should be the same record if repeated with same result
  -- Isolated = isolation levels, should not have side effects
  -- Durable = should be saved entirely

  if(@first is not null and @last is not null)
    begin
      declare @result int;
      select @result = BusinessEntityID
      from Person.Person
      where Firstname = @first and Lastname = @last;

    if (@result is null)
    begin
      checkpoint 
      insert into Person.Person (Firstname, LastName)
      values(@first, @last);
      commit tran;
    -- isolation levels (isolating read from edit/delete)
    -- READ UNCOMMITED = dirty read, any record in the table complete or not
    -- READ COMMITED = clean read, only completed records can be read
    -- REPEATABLE READ = clean read, only the latest snapshot can be read
    -- SERIALIZABLE = clean read, dataset is locked from edit/delete
      end
      else
      begin
        rollback tran;
      end
    end
  end;
go

-- JOIN
-- inner -> inner
-- outer -> full, left, right
-- cross
-- self

select pp.firstname, pp.lastname
from Person.Person as pp
left join Person.BusinessEntityAddress as bea on bea.BusinessEntityID = pp.BusinessEntityID --inner vs left depending on business requirement (inner would include johns without addressses)
left join Person.Address as pa on pa.AddressID = bea.AddressID
where pp.FirstName = 'john';


-- UNION = based on datatypes
select firstname
from Person.Person
union -- filter duplicates, unique record set  union all would not filter
select name
from Production.Product;
go
-- TRIGGER
-- before = intercept event, and run pre-query ahead of event 
-- for = intercept event, and run post-query after events
-- instead of = intercept event, and run new-query

create trigger tr_switchname
on Person.Person
for insert
as
  declare @first nvarchar;
  declare @last nvarchar;

  select @first = firstname, @last = lastname
  from inserted; -- inserted, deleted = special tables to capture insert/update

  update Person.Person
  set firstname = @last, lastname = @first
  where firstname = @first and lastname = @last
go

-- TRANSACTION
-- ACID, COMMIT TRAN, ROLLBACK, *CHECKPOINT*

-- ORM + Entity Framework Core + Data-first Approach
-- ORM = oject relational mappers
-- ODBC connector = open db connector (serialization - XML)
-- ADO.NET library to interface with ODBC
-- in C# we write SQL as string > ADO.NEt