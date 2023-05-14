-- 先匯入範例中 bookshop_back.sql
------------------------------------------------------------------------
-- 聚集函式 
-- sum()：加總書名有java的書價
select sum(price) books_sum from book 
where book_name like '%java%';

select * from book where book_name like '%java%';

-- avg()：計算平均書價
select avg(price) books_average 
from book;

select * from book;

-- count()：計算書價在1000元以上的總數量
select count(isbn) from book
where price >= 1000;

select count(1) from book
where price >= 1000;

select 1 from book
where price >= 1000;

select * from book where price >= 1000;

-- max(), min()：取得最高書價與最低書價
select max(price) as book_max_price, min(price) as book_min_price
from book;

select * from book order by price;

-- 聚集函式都可合併使用
select sum(price), avg(price), count(1), max(price), min(price)
from book;
------------------------------------------------------------------------
