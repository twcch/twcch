-- 先匯入範例中 bookshop_back.sql
------------------------------------------------------------------------
-- 建立View
create view book_view as 
select isbn, book_name, price, author, publication_date, b.publisher_id, publisher_name, phone
from book b 
join publisher p on b.publisher_id = p.publisher_id 
where price < 1000;

-- 建立或取代View
create or replace view book_view as
select isbn, book_name, price, author, publication_date, b.publisher_id, publisher_name, phone
from book b 
join publisher p on b.publisher_id = p.publisher_id;
------------------------------------------------------------------------
-- 查詢View
select * from book_view;

-- 刪除View
drop view book_view;
------------------------------------------------------------------------
