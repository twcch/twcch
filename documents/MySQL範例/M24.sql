-- 先匯入範例中 bookshop_back.sql
------------------------------------------------------------------------
-- Subquery
-- 將小於等於平均書價的書列出
select * from book
where price <= (select avg(price) from book)
order by book_name;

-- 算出所有書籍總進貨量的平均值
select avg(total) from (
	select sum(quantity) total 
	from purchase 
	group by isbn
) book_total;
------------------------------------------------------------------------
-- IN, ANY, ALL
-- in: 查詢所有出版java類書籍的出版社
select publisher_id, publisher_name from publisher
where publisher_id in 
(select publisher_id from book where book_name like '%java%');

-- 用any改寫
select publisher_id, publisher_name from publisher
where publisher_id = any(select publisher_id from book where book_name like '%java%');

/* in, any, all差別
in: 單純比較是否與子查詢結果值相同，所以無法使用<>, <, >, <=, >=
any: 除了值是否相同外，還可以跟子查詢結果的任一個值比大小，屬於or觀念
all: 跟子查詢結果的每一個值比大小，屬於and觀念
*/
-- in: 列出與java書價相同的書
select * from book
where price in (select price from book where book_name like '%java%');

-- any: 列出高於任一本java書價的書
select * from book
where price >= any(select price from book where book_name like '%java%');
-- some: 與any是同義複詞，所以結果一樣
select * from book
where price >= some(select price from book where book_name like '%java%');

-- all: 列出高於所有java書價的書
select * from book
where price >= all(select price from book where book_name like '%java%');
------------------------------------------------------------------------
-- EXISTS
-- in: 查詢所有出版java類書籍的出版社
select publisher_id, publisher_name from publisher
where publisher_id in (
	select publisher_id from book where book_name like '%java%'
);

-- 以exists改寫，將有出版java類書籍的出版社列出
select publisher_id, publisher_name from publisher p
where exists (
	select 1 from book b 
	where p.publisher_id = b.publisher_id and book_name like '%java%'
);

/* 
1. exists與in執行效能比較
exists判斷主查詢的欄位是否存在於子查詢，而該欄位大都是pk，建有索引，所以比對速度快。
in則會以主/子查詢欄位內儲存的值詳細比對是否值相同而決定是否要剔除該筆資料，
所以一般而言in的執行效能會比較差。

2. exists子查詢使用欄位名稱與定值 (例如數字1)的差異：
使用欄位名稱或定值不會影響exists比對速度，因為如上述是以索引判斷，
但如果使用「*」或是多個欄位，會影響存入記憶體的速度，而且也較佔用記憶體空間。
*/
------------------------------------------------------------------------
