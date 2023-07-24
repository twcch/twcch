------------------------------------------------------------------------
-- INSERT INTO publisher
insert into publisher (publisher_id, publisher_name, contact, phone) 
values 
('P001', 'O''Reilly', 'Ocean' , '02-23456789'), 
('P002', 'John Wiley, Sons Inc', 'Don' , '03-36962869'),
('P003', 'Manning Publications', 'Mary' , '04-43456789'),
('P004', 'Apress', 'Allen' , '05-59876543'),
('P005', 'McGraw-Hill', 'Mike' , '06-69876543'),
('P006', 'Pearson', 'Paul' , '09-98767867'),
('P00X', 'Publisher X', 'X-Man' , '07-75698765'),
('P00Y', 'Publisher Y', 'Yale' , '08-83698765');

select * from publisher;
------------------------------------------------------------------------
-- INSERT INTO book
-- 若資料類型由DATE改為TIMESTAMP(包含時分秒)，需改為「'2005-02-19 21:02:44'」
insert into book 
(isbn, book_name, price, author, publication_date, publisher_id) 
values
('9780596009205', 'Head First Java', 1186 , 
'Kathy Sierra and Bert Bates', '2005-02-19', 'P001'),
('9780596809157', 'R Cookbook', 935 , 
'Paul Teetor', '2016-03-01', 'P001'),
('9781491936696', 'iOS 9 Swift Programming Cookbook', 1443 , 
'Vandad Nahavandipoor', '2016-01-08', 'P001'),
('9781118407813', 'Beginning Programming with Java For Dummies', 550 , 
'Barry Burd', '2014-07-11', 'P002'),
('9781617291999', 'Java 8 in Action', 936 , 
'Raoul-gabriel Urma, Mario Fusco, Alan Mycroft', '2014-08-28', 'P003'),
('9781430237174', 'Pro IOS Apps Performance Optimization', 1151 , 
'Khang Vo', '2011-11-16', 'P004'),
('9781484226766', 'Python Unit Test Automation', 731 , 
'Ashwin Pajankar', '2017-6-12', 'P004'),
('9780071751292', 'Oracle Database 11g', 1139 , 
'Jinyu Wang', '2011-09-14', 'P005'),
('9781259587405', 'Programming the Raspberry Pi', 440 , 
'Simon Monk', '2015-10-5', 'P005'),
('9780134543666', 'Starting Out with Python', 5451 , 
'Tony Gaddis', '2017-6-15', 'P006'),
('9781119017929', 'Android App Development for Dummies, 3rd Edition', 560, 
 'Donn Felker', '2015-03-09', 'P002'),
('9783527711499', 'Android App Entwicklung fur Dummies', 845, 
 'Donn Felker', '2016-12-01', 'P002'),
('9789352133468', '25 Recipes for Getting Started with R', 303.00, 
 'Paul Teetor', '2016-08-01', 'P001');

select * from book;
------------------------------------------------------------------------
-- Auto Increment
create table purchase (
  purchase_id bigint unsigned primary key not null auto_increment,
  isbn char(13) not null,
  quantity decimal(2) not null,
  purchase_date timestamp default current_timestamp,
  constraint fk_purchase_book 
  foreign key (isbn) references book (isbn)
);

insert into purchase (isbn, quantity) 
values
('9780596009205', 20),
('9780596809157', 10),
('9781491936696', 10),
('9781118407813', 40),
('9781617291999', 30),
('9781430237174', 50),
('9781484226766', 20),
('9780071751292', 30),
('9781259587405', 60),
('9780134543666', 70),
('9781119017929', 80),
('9783527711499', 40),
('9789352133468', 60),
('9780596009205', 80),
('9780596809157', 40),
('9781491936696', 20),
('9781118407813', 50),
('9781617291999', 20),
('9781430237174', 70),
('9781484226766', 90),
('9780071751292', 30),
('9781259587405', 60),
('9780134543666', 40),
('9781119017929', 10),
('9783527711499', 40),
('9789352133468', 20);

-- 即使新增失敗，仍會自動跳號，避免多人新增時無法順利取號的問題
insert into purchase (isbn, quantity) 
values
('9789352133477', 20);

select * from purchase;
------------------------------------------------------------------------
-- Prefix + Auto Increment
-- MySQL的auto increment欄位一定要為整數類型，所以該欄位不可有任何文字
-- 如果希望商品ID為自訂前綴字 + 自動編號
-- 建議再新增一個欄位存放前綴字，查詢時使用CONCAT(前綴字, 自動編號)
create table product(
prefix varchar(2) not null default 'SN', 
id int unsigned not null auto_increment primary key, 
product_name varchar(200) not null, 
unique key(prefix, id)
);

insert into product(product_name)
values
('product A'), 
('product B'), 
('product C'); 

select * from product;
-- 查詢時使用CONCAT(前綴字, 自動編號) 
select concat(prefix, id) as productId, product_name from product;
------------------------------------------------------------------------
-- Auto Increment Info
-- 查詢下一個準備產生的號碼 
select auto_increment
from  information_schema.tables
where table_schema = 'bookshop' -- 資料庫名稱
and   table_name   = 'purchase'; -- 表格名稱

-- INFORMATION_SCHEMA.TABLES儲存許多暫存的統計資訊，暫存資訊不正確可以使用information_schema_stats_expiry設定失效時間
-- 設為0代表立即失效，就會重新取得最新統計資訊；建議先執行然後再取得自動編號資訊
set @@SESSION.information_schema_stats_expiry = 0;

-- 顯示表格資訊也會呈現自動編號資訊（Auto-increment欄位）
show table status from bookshop where name like 'purchase';
------------------------------------------------------------------------
