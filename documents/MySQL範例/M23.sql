-- 先匯入範例中 bookshop_back.sql
------------------------------------------------------------------------
-- GROUP BY
-- 列出每個出版社出版了幾本書
select publisher_id, count(book_name) book_count
from book
group by publisher_id
order by book_count desc;

select publisher_id, book_name from book order by publisher_id;

-- select列出來的欄位，除了聚集函數的欄位外，其餘都要列在group by條件中，否則會不符合閱讀邏輯
select publisher_id, author, count(book_name) book_count
from book
group by publisher_id, author
order by publisher_id;

-- 列出每個出版社的平均書價，顯示欄位包含出版社名稱與平均書價
-- 若不將出版社id列在group by，當出版社名稱相同時，會將不同出版社id但相同出版社名稱的資料合併
select publisher_name, avg(price) average_price
from book b 
join publisher p on b.publisher_id = p.publisher_id
group by b.publisher_id, publisher_name
order by publisher_name;

-- 列出每個出版社最貴/最便宜的書價
select publisher_name, max(price), min(price)
from book b
join publisher p on b.publisher_id = p.publisher_id
group by b.publisher_id, publisher_name
order by publisher_name;

-- 列出每本書的總進貨量
select p.isbn, book_name, sum(quantity)
from purchase p
join book b on p.isbn = b.isbn
group by p.isbn, book_name
order by book_name;
------------------------------------------------------------------------
-- HAVING
-- 列出總進貨量超過200本的出版社
-- MySQL的having可以使用total別名 (但Oracle不行)
select b.publisher_id, publisher_name, sum(quantity) total
from purchase pc
join book b on pc.isbn = b.isbn
join publisher pb on b.publisher_id = pb.publisher_id
group by b.publisher_id, publisher_name
having total >= 200
order by total desc;
------------------------------------------------------------------------
