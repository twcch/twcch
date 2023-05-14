-- 先匯入範例中 bookshop_back.sql
------------------------------------------------------------------------
select * from book order by publisher_id;
select * from publisher order by publisher_id;
-- INNER JOIN
-- 2個表格都有相同的publisher_id才會呈現該筆資料
select book_name, price, author, b.publisher_id, publisher_name
from book b 
join publisher p on b.publisher_id = p.publisher_id
order by book_name;
------------------------------------------------------------------------
-- LEFT JOIN
-- 只顯示左邊表格有的值，右邊表格無此值者會顯示null
select book_name, price, author, b.publisher_id, publisher_name
from book b 
left join publisher p on b.publisher_id = p.publisher_id
order by book_name;

-- 將書名'Head First Java'的publisher_id設為null，再重新執行left join
select * from book where isbn = '9780596009205';
update book set publisher_id = null where isbn = '9780596009205';
-- 改回publisher_id原值
update book set publisher_id = 'P001' where isbn = '9780596009205';
------------------------------------------------------------------------
-- RIGHT JOIN
-- 只顯示右邊表格有的值，左邊表格無此值者會顯示null
select book_name, price, author, b.publisher_id, p.publisher_id, publisher_name
from book b 
right join publisher p on b.publisher_id = p.publisher_id
order by book_name;
------------------------------------------------------------------------
-- FULL OUTER JOIN
-- 顯示雙方表格都有的值，無值者會顯示null
-- MySQL不支援FULL OUTER JOIN，可將LEFT JOIN與RIGHT JOIN用UNION語法結合以達到目的
select book_name, price, author, b.publisher_id, publisher_name
from book b 
left join publisher p on b.publisher_id = p.publisher_id
union
select book_name, price, author, b.publisher_id, publisher_name
from book b 
right join publisher p on b.publisher_id = p.publisher_id
order by book_name;
------------------------------------------------------------------------
-- self join
-- manager_id與employee_id有相同意義
create table employee (
	employee_id int primary key not null, 
	name varchar(40),
	manager_id int,
	foreign key (manager_id) references employee (employee_id)
);

insert into employee (employee_id, name, manager_id)
values 
(1, 'Mary', null),
(2, 'John', 1),
(3, 'Ben', 1),
(4, 'Joe', 2),
(5, 'James', 2),
(6, 'Betty', 3);

select e.employee_id, e.name, e.manager_id, m.name
from employee e 
left join employee m on e.manager_id = m.employee_id;
------------------------------------------------------------------------

