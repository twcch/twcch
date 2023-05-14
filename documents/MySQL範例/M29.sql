------------------------------------------------------------------------
-- 列出所有user帳號
-- user為帳號，host為可以登入的主機
select user, host from mysql.user;
------------------------------------------------------------------------
-- 新增User帳號
-- 格式為「username@hostname」。「identified by」為設定密碼
-- hostname為localhost代表user僅能在MySQL所在電腦上登入
create user john@localhost identified by 'john';
-- 新增帳號時可給予預設密碼，同時要求user一登入就要重設密碼
create user john@localhost identified by '1234' password expire;
-- 新增帳號時要求user一登入就要重設密碼（沒有預設密碼，所以user無需輸入舊密碼）
create user john@localhost password expire;
-- 沒有加上hostname則hostname為「%」，代表user可以從任何電腦登入
create user john identified by 'john';
-- username或hostname有空白或是符號要加上單引號
create user john@'%' identified by 'john';
------------------------------------------------------------------------
-- 修改user密碼
alter user john@localhost identified by 'john11';
-- 要求user重設密碼
alter user john@localhost password expire;
-- 修改user的host
update mysql.user set host='localhost' where host='%' and user='allen walker'; 
------------------------------------------------------------------------
-- 刪除User帳號
-- 沒有加上hostname則hostname為「%」
drop user john@localhost;
----------------------------------------------------

