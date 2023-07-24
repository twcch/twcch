-- 先匯入範例中 bookshop_back.sql
------------------------------------------------------------------------
-- LIMIT
-- 將最便宜的3本書列出
select * from book order by price limit 3;
-- 書價低到高排序，先取出第一頁 (1 ~ 10)、再取得第二頁 (11 ~ 20)
select * from book order by price limit 10;
select * from book order by price limit 10 offset 10;
select * from book order by price;
------------------------------------------------------------------------
-- RANK()
-- 依照書價低至高排名，相同價格名次要相同
select book_name, price, rank() over(order by price) price_rank
from book;
-- 列出書價排名為前2名便宜的書
select * from (
	select book_name, price, 
	rank() over(order by price) price_rank
	from book
) book_rank
where price_rank <= 2;

-- 將每本書的出版日期由新到舊排名，使用rank()列出前3名
select book_name, publication_date from (
	select book_name, publication_date, 
	rank() over(order by publication_date desc) publication_date_rank
	from book
) book_rank 
where publication_date_rank <= 3;

-- 將每本書的總進貨量由高至低排名，使用rank()列出前3名
select * from (
	select p.isbn, book_name, sum(quantity), 
	rank() over(order by sum(quantity) desc) sum_rank
	from purchase p
	join book b on p.isbn = b.isbn
	group by p.isbn, book_name
) purchase_rank
where sum_rank <= 3;
------------------------------------------------------------------------
