------------------------------------------------------------------------
-- 指定要對bookshop資料庫執行「use bookshop」，或雙點該資料庫
use bookshop; 
-- CREATE TABLE - PK (可以直接在欄位後面加PK設定)
create table publisher (
  publisher_id varchar(40) primary key not null,
  publisher_name varchar(40) not null,
  contact varchar(40),
  phone varchar(40) not null,
  create_time timestamp default current_timestamp
);

-- 要建立複合PK必須列在後面
create table publisher (
  publisher_id varchar(40) not null,
  publisher_name varchar(40) not null,
  contact varchar(40),
  phone varchar(40) not null,
  create_time timestamp default current_timestamp on update current_timestamp,
  primary key (publisher_id)
);

-- 顯示指定表格定義
describe publisher;
------------------------------------------------------------------------
-- CREATE TABLE - FK
create table book (
  isbn char(13) primary key not null,
  book_name varchar(200) not null,
  price decimal(8,2),
  author varchar(200),
  publication_date date,
  publisher_id varchar(40),
  constraint fk_book_publisher
  foreign key (publisher_id) references publisher (publisher_id)
);

-- 顯示表格參照資訊
select table_name, column_name,constraint_name, referenced_table_name, referenced_column_name
from information_schema.key_column_usage 
where referenced_table_schema = 'bookshop' and table_name = 'book';
------------------------------------------------------------------------
-- ALTER TABLE
-- 表格更名
alter table book rename to books;
-- 新增欄位
alter table book add column language varchar(40);
-- 欄位更名
alter table book rename column language to languages;
-- 修改/刪除欄位預設值
alter table book alter column languages set default 'chinese';
alter table book alter column languages drop default;
-- 修改欄位類型
alter table book modify languages varchar(20);
-- 刪除欄位
alter table book drop column languages;
-- 建立fk
alter table book add constraint fk_book_publisher
foreign key (publisher_id) references publisher (publisher_id);
-- 移除fk
alter table book drop foreign key fk_book_publisher;
-- 欄位改為不可/可為空值
alter table book modify author varchar(200) not null;
alter table book modify author varchar(200) null;
------------------------------------------------------------------------
-- drop table
drop table book;
drop table publisher;
------------------------------------------------------------------------
