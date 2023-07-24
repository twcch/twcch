------------------------------------------------------------------------
-- 查詢表格的索引資訊
show index from book;
-- 評估執行效能：查看執行結果的rows欄位資訊，1代表只要找1列；13代表要找13列
-- 評估有無索引的效能差異
explain select * from book where isbn = '9780596009205'; -- 有索引
explain select * from book where book_name = 'Head First Java'; -- 沒有索引
----------------------------------------------------
-- 建立主索引 (建立主鍵時就會自動建立主索引。另外MySQL還會自動幫外來鍵建立索引)
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

-- 顯示表格的索引資訊
show index from book;
----------------------------------------------------
-- 建立唯一索引 (如果不是複合型可以直接放在欄位定義之後，否則要放在所有欄位定義之後，與主鍵一樣)
create table book (
  isbn char(13) primary key not null,
  book_name varchar(200) unique not null,
  price decimal(8,2),
  author varchar(200),
  publication_date date,
  publisher_id varchar(40)
); 

create table book (
  isbn char(13) not null,
  book_name varchar(200) not null,
  price decimal(8,2),
  author varchar(200),
  publication_date date,
  publisher_id varchar(40),
  primary key(isbn),
  unique(book_name, author)
);
-- 沒給唯一鍵名稱會自動以欄位名稱當做索引名稱
alter table book add unique(book_name); 
alter table book add unique unique_book_name(book_name);
-- 顯示表格的索引資訊
show index from book;
-- 移除索引
drop index book_name on book;
drop index unique_book_name on book;
----------------------------------------------------
-- 建立非唯一索引
-- 建立單一索引
create index idx_book_name on book(book_name);
-- 沒給索引名稱會自動以欄位名稱當做索引名稱
alter table book add index(book_name);
alter table book add index idx_book_name(book_name);
-- 顯示表格的索引資訊
show index from book;
-- 移除索引
drop index book_name on book;
drop index idx_book_name on book;

-- 建立複合索引
create index idx_book_name_author on book(book_name, author);
-- 沒給索引名稱會自動以第一個欄位名稱當做索引名稱
alter table book add index(book_name, author);
alter table book add index idx_book_name_author(book_name, author);
-- 顯示表格的索引資訊
show index from book;
-- 移除索引
drop index book_name on book;
drop index idx_book_name_author on book;
----------------------------------------------------

