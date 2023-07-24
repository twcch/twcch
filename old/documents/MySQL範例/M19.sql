-- 先匯入範例中 bookshop_back.sql
------------------------------------------------------------------------
-- 日期時間函式
-- adddate(date, interval value unit): 將指定日期時間date加上指定單位unit的值value，date_add(date,interval value unit)功能相同
-- 日期時間單位參看：https://dev.mysql.com/doc/refman/8.0/en/expressions.html#temporal-intervals
select adddate('2020-12-31', interval 1 day);
select date_add('2020-12-31 23:59:59', interval 1 second);
-- date(date): 回傳日期部分
select date('2020-12-31 10:05:01');
-- date_format(date, format): 將指定日期date使用format來格式化
-- 格式化符號參看：https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html#function_date-format
select book_name, date_format(publication_date, '%y-%m-%d') as pubdate from book;
-- datediff(date1, date2): 回傳2個日期相差的天數(date1 - date2)
select datediff('2020-12-31 10:05:01', '2020-12-30 12:05:01');
select datediff('2020-12-30 12:05:01', '2020-12-31 10:05:01');
-- dayofmonth(date): 回傳日期date是一個月的第幾日
select dayofmonth('2020-12-31');
-- dayofweek(date): 回傳日期date的weekday(1 = Sunday, 2 = Monday, …, 7 = Saturday).
select dayofweek('2020-12-31');
-- dayofyear(date): 回傳日期date是一年的第幾日
select dayofyear('2020-12-31');
-- extract(unit from date): 依照單位unit回傳日期date的局部內容
select extract(month from '2020-12-31 10:05:01');
select extract(hour_minute from '2020-12-31 08:01:05');
-- hour(time): 回傳時 
select hour('2020-12-31 10:05:01');
-- last_day(date): 回傳日期date月份中的最後一天
select last_day('2020-12-1');
-- minute(time): 回傳分
select minute('2020-12-31 10:05:01'); 
-- month(date): 回傳月 
select month('2020-12-31 10:05:01'); 
-- now(): 回傳sql語法準備執行時的時間，語法內呼叫多次也是回傳相同時間；這點跟sysdate()每次回傳執行當下的時間不同
select now(), sleep(1), now();
-- second(time): 回傳秒
select second('2020-12-31 10:05:01'); 
-- str_to_date(str, format): 將字串str解析回日期時間，與date_format()正好相反
select str_to_date('dec 31, 2020', '%M %d, %Y');
-- sysdate(): 回傳執行當下的時間，跟now()回傳準備執行時的時間不同
select now(), sysdate(), sleep(1), now(), sysdate();
-- time(time): 回傳時間部分
select time('2020-12-31 10:05:01');
-- timediff(date1, date2): 回傳2個日期相差的時間(date1 - date2)
select timediff('2020-12-31 10:05:01', '2020-12-30 12:05:01');
-- timestampdiff(unit, date1, date2): 回傳2個日期相差的時間(date2 - date1)，將差值以指定單位unit計算
select timestampdiff(hour, '2020-12-31 10:05:01', '2020-12-30 12:05:01');
select timestampdiff(minute, '2020-12-31 10:05:01', '2020-12-30 12:05:01');
-- week(date): 回傳一年的第幾週 
select week('2020-12-31');
-- year(date): 回傳年
select year('2020-12-31');
------------------------------------------------------------------------
-- 資料類型轉換函式
-- convert(value, datatype): 將值value轉成指定類型datatype(可以為binary, char, date, datetime, time, signed, unsigned)
select convert('20201231', date);
select convert('100501', time);
select convert(123.456, char);
select convert(5-10, signed);
------------------------------------------------------------------------
-- 流程控制函式
-- if(expr1, expr2, expr3): expr1為true回傳expr2，否則回傳expr3
select book_name, price, if(price >= 1000, 'expensive', 'cheap') as tag from book;
-- ifnull(expr1, expr2): expr1不是null則回傳expr1，否則回傳expr2
select ifnull('john', 'mary');
select ifnull(null, 'mary');
------------------------------------------------------------------------
-- 系統資訊函式
-- charset(str): 回傳str的字元集
select book_name, charset(book_name) from book;
-- database(): 回傳使用中的資料庫名稱
select database();
-- user(): 回傳當下user帳號與主機名稱
select user();
-- version(): 回傳資料庫版本
select version();
------------------------------------------------------------------------

