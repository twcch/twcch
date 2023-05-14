------------------------------------------------------------------------
-- Transaction
-- Workbench > Query > Auto-Commit Transactions 預設為開啟
-- 可以下指令呈現或修改auto-commit狀態
-- 顯示auto-commit狀態
select @@autocommit;
-- 修改auto-commit狀態（0 - 關閉；1 - 開啟）
set autocommit = 0;

insert into publisher (publisher_id, publisher_name, contact, phone) 
values ('P00A', 'Publisher A', 'Sue' , '04-45678901');
insert into publisher (publisher_id, publisher_name, contact, phone) 
values ('P00B', 'Publisher B', 'Hellen' , '07-78907890');

select * from publisher; -- 先查看結果
rollback;
select * from publisher; -- 再查看結果	

commit; -- commit後無法還原
------------------------------------------------------------------------
-- SAVEPOINT
savepoint point01;
insert into publisher (publisher_id, publisher_name, contact, phone) 
values ('P00Z', 'Z', 'Zen' , '02-235324233'); 
									  
savepoint point02;
delete from publisher
where publisher_id = 'P00Z';
									  
-- 回復到指定SAVEPOINT, savepoint關鍵字可省略
rollback to savepoint point02;

select * from publisher;
------------------------------------------------------------------------
