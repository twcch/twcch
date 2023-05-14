-- 先匯入範例中 bookshop_back.sql
------------------------------------------------------------------------
-- AND: 查詢書名有「java」且書價在1000元以內的資料 (不區別大小寫)，而且依照書價升冪排序
select * from book
where book_name like '%java%' and price < 1000
order by price;

-- OR: 查詢書名有「java」或是「oracle」的資料
select * from book
where book_name like '%java%' or book_name like '%oracle%';

-- NOT: 查詢書價沒有大於1000元的書
select * from book
where not price > 1000;
------------------------------------------------------------------------
-- BETWEEN: 查詢書價介於550(含)~935(含)元的書籍
select * from book
where price between 550 and 935;
------------------------------------------------------------------------
-- IN: 查詢出版社聯絡人為'paul'或'mary'或'ocean'的資料 
select * from publisher
where contact in ('paul', 'mary', 'ocean');
-- 查詢出版社聯絡人不為'paul'或'mary'或'ocean'的資料 
select * from publisher
where not contact in ('paul', 'mary', 'ocean');
------------------------------------------------------------------------

