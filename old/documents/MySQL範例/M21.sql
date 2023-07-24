-- 先匯入範例中 bookshop_back.sql
------------------------------------------------------------------------
-- UNION：舉辦作者與出版社酒會，客人名單上列出作者與出版社聯絡人名稱
select distinct author guest from book
union all
select contact guest from publisher
order by guest;
------------------------------------------------------------------------
