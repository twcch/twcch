------------------------------------------------------------------------
-- 查詢user權限
create user john identified by 'john';
show grants for john;
------------------------------------------------------------------------
-- (授權要斷線才生效)
-- Global Privileges（全域級授權）
-- 授權/撤銷 建立、移除資料庫或表格 
grant create, drop on *.* to john;
revoke create, drop on *.* from john;
-- user測試建立、移除資料庫
create schema johndb;
drop schema johndb;
-- user測試建立表格
create table author (
    author_id varchar(40) primary key not null,
    author_name varchar(40) not null
);
-- user雖可建立表格，但無法新增資料，因為尚未授權
insert into author(author_id)
values('1', 'john');
-- user測試移除表格
drop table author;
------------------------------------------------------------------------
-- Database Privileges（資料庫級授權）
-- 授權/撤銷 user可查詢bookshop資料庫內的所有表格
grant select on bookshop.* to john;
revoke select on bookshop.* from john;
-- user測試查詢功能
select * from publisher;
------------------------------------------------------------------------
-- Table Privileges（表格級授權）
-- 授權/撤銷 user可查詢bookshop資料庫內的book表格
grant select on bookshop.book to john;
revoke select on bookshop.book from john;
-- 授權/撤銷 user可查詢bookshop資料庫內的publisher表格
grant select on bookshop.publisher to john;
revoke select on bookshop.publisher from john;
-- user測試查詢功能
select book_name, price, author, publisher_name from book b
join publisher p on b.publisher_id = p.publisher_id;

-- 授權/撤銷 指定表格的所有權限
grant all on bookshop.book to john;
revoke all on bookshop.book from john;
grant all on bookshop.publisher to john;
revoke all on bookshop.publisher from john;

-- 取得指定表格的所有權限即可測試增刪改查功能
update publisher set contact = 'aaa' where publisher_id = 'P00X';
select * from publisher;
-- 將auto-commit關閉，測試2個user修改同一筆資料。先修改者如果尚未commit，後修改者會發生等待情形
-- 只要先修改者一旦commit或rollback，後修改者就會停止等待
select @@autocommit;
set autocommit = 0;
commit;
rollback;
------------------------------------------------------------------------
-- Read-Only View
-- MySQL不支援 read-only view（Oracle支援），但可以改用授權方式達到read-only
-- 1. 先建立view
create or replace view book_view as
select isbn, book_name, price, author, publication_date, b.publisher_id, publisher_name, phone
from book b 
join publisher p on b.publisher_id = p.publisher_id;
-- 2. 再授權user只能查詢該view
grant select on bookshop.book_view to john;
select * from book_view;
-- user測試是否可對view的內容異動
insert into book_view (isbn, book_name, publisher_id)
values ('9876543210123', 'test_book2', 'P002');
------------------------------------------------------------------------
-- Column Privileges（欄位級授權）
-- 授權book表格內可查詢與修改的欄位
grant 
	select(isbn, book_name, price), 
    update(price)
on book
to john;
-- 撤銷book表格內可查詢與修改的欄位
revoke 
	select(isbn, book_name, price), 
    update(price)
on book
from john;

-- user測試是否可查詢非授權欄位
select isbn, book_name, price, author from book;
-- user測試是否可修改非授權欄位
update book set book_name = 'testName' 
where isbn = '9780596009205';





