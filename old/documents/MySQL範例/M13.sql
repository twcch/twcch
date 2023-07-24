------------------------------------------------------------------------
-- UPDATE
select * from publisher;
update publisher set contact = 'John', phone = '07-1234567765';
-- where publisher_id = 'P00X';
------------------------------------------------------------------------
-- DELETE
select * from publisher;
delete from publisher 
where publisher_id = 'P00X' or publisher_id = 'P00Y';

-- 被外來鍵參照到的資料無法刪除
-- 預設修改、刪除沒有加上唯一鍵條件會被禁止；如果要取消，先關閉Safe Updates，然後重新連線
-- Preferences > SQL Editor > Safe Updates
delete from publisher;
delete from book;
------------------------------------------------------------------------
