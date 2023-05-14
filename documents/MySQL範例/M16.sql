-- 先匯入範例中 bookshop_back.sql
------------------------------------------------------------------------
-- select
-- 查詢表格所有欄位內的值
select * from book;
-- 別名前的AS可加可不加
select isbn, book_name, price * 0.9 sale_price, author, publication_date 
from book;
-- 如果別名有關鍵字或空白字元要加上「""」才不會出錯
select isbn, book_name, price * 0.9 "sale price", author, publication_date 
from book;
-- DISTINCT
select distinct publisher_id from book;
------------------------------------------------------------------------
-- order by兩個以上欄位，可分別指定升冪或降冪
select * from book order by price, book_name desc;

-- 先將任一price改為null (對欄位右鍵選Set Field to NULL) ，null會自動依照升/降冪排序
select isbn, book_name, price from book order by price;
-- ISNULL(NULL) 為1，其餘為0
select isbn, book_name, price, isnull(price) from book order by isnull(price);
------------------------------------------------------------------------
-- where
-- 查詢出版社名稱為pearson的資料
select * from publisher 
where publisher_name = 'pearson';

-- 查詢書價在1000元以內的書籍
select * from book
where price < 1000;

-- 將沒有出版社資訊的書籍列出 (先將一本書的publisher_id值清空)
-- Workbench視覺刪除資料只會將資料設為空字串而不會設為空值，需對欄位右鍵選Set Field to NULL，或是使用UPDATE指令
update book set publisher_id = null
where isbn = '9780596009205';

-- 將沒有出版社資訊的書籍列出
select * from book 
where publisher_id is null;

-- 查詢書名開頭為任一字元再加上「ava」的資料
select * from book 
where book_name like '_ava%'; 

-- 查詢書名含有「java」的資料
select * from book 
where book_name like '%java%';
------------------------------------------------------------------------
