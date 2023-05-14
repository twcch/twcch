-- 先匯入範例中 bookshop_back.sql
------------------------------------------------------------------------
-- CREATE TABLE AS SELECT
-- 建立book_back表格並將書價>=1000的書名、定價、作者、出版日期插入
create table book_back as 
select book_name, price, author, publication_date from book
where price >= 1000;
------------------------------------------------------------------------
-- INSERT INTO SELECT
-- 將書價 < 1000的書名、定價、作者、出版日期插入到已存在的book_back表格內
insert into book_back 
select book_name, price, author, publication_date from book
where price < 1000;
------------------------------------------------------------------------
