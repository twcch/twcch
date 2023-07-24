-- 先匯入範例中 bookshop_back.sql
------------------------------------------------------------------------
-- 字串函式（MySQL不區別大小寫，索引位置皆為1-based）
-- char_length(str): 回傳字串str的長度，以字元計算
select book_name, char_length(book_name) as char_length from book;
-- concat(str1, str2, …): 將str1, str2...等各個字串串接起來
select concat(curdate(), '-', order_id) as id from order_master;
-- concat_ws(separator, str1, str2, …): ws (with separator) 意指使用分隔符號串接各個字串
select concat_ws('-', curdate(), order_id) as id from order_master;
-- field(str, str1, str2, str3, …): 在字串列表（str1, str2, ...）內搜尋是否存在str字串，有則回傳所在位置，無則回傳0
select field('bb', 'aa', 'bb', 'cc', 'dd', 'ff');
select field('gg', 'aa', 'bb', 'cc', 'dd', 'ff');
-- find_in_set(str, strlist): 在字串列表 strlist 內搜尋是否存在str字串，有則回傳所在位置，無則回傳0。2個參數任一個為null則結果為null。str不可包含逗號（,）
select find_in_set('b','a,b,c,d');
select find_in_set('g','a,b,c,d');
-- format(x, d[,locale]): 格式化數字x，使其長得像 ‘#,###,###.##'。d代表小數位數，如果d為0代表不需要小數部分。locale代表在地化設定（可以不設定）
select format(12332.123456, 4); -- 4代表保留4位小數，第5位小數四捨五入
select format(12332.123456, 0);
select format(12332.123456, 4, 'de_de'); -- de_de代表德語。德語分位與小數符號與美語顛倒
-- insert(str, pos, len, newstr): 以newstr取代指定位置pos與長度len所代表的文字
select insert('abc.com', 1, 3, 'xyz');
-- instr(str, substr): 尋找str內是否存在substr，有則回傳第一個找到的位置。功能與locate(substr,str)相似，只不過參數位置顛倒
select book_name, instr(book_name, 'java') from book;
-- left(str, len): 將str左邊len長度的字回傳
select book_name, left(book_name, 5) as left_5 from book;
-- length(str): 回傳str長度，以byte計算
select length('哈囉') as length, char_length('哈囉') as char_length;
select length('hello') as length, char_length('hello') as char_length;
-- lower(str): 將str轉成小寫字，lcase(str)功能相同
select book_name, lower(book_name) as lower_book_name from book;
-- repeat(str, count): 將str重複count次數
select repeat('mysql', 3);
-- replace(str, from_str, to_str): 將str文字中所有from_str都替換成to_str (區別大小寫)
select book_name, replace(book_name, 'Oracle', 'mysql') as replaced_book_name
from book where book_name like '%oracle%';
-- reverse(str): 將str內容反轉
select book_name, reverse(book_name) as reverse_book_name from book;
-- right(str, len): 將str右邊len長度的字回傳
select book_name, right(book_name, 5) as right_5 from book;
-- substring(str, pos),  substring(str,pos,len): 回傳指定位置的局部字串。只有pos代表取值範圍從pos到最後一個字元；有len代表取len個數的字元（個數包含pos字元）
select substring('123456789', 5);
select substring('123456789', 5, 3);
-- substring_index(str, delim, count): 回傳第count分隔符號(delim)前的局部字串。count為正代表左算到右；負代表右算到左
select substring_index('www.mysql.com', '.', 2);
select substring_index('www.mysql.com', '.', -2);
-- trim([{both | leading | trailing} [remstr] from] str), trim([remstr from] str): 去除左右空白字元或指定字元
select trim('  hello  ');
select trim(leading from '  hello  ');
select trim(trailing from '  hello  ');
select trim('x' from 'xxhelloxx');
select trim(leading 'x' from 'xxhelloxx');
select trim(trailing 'x' from 'xxhelloxx');
-- upper(str): 將str轉成小寫字，ucase(str))功能相同
select book_name, upper(book_name) as upper_book_name from book;
------------------------------------------------------------------------
-- 數學函式
-- abs(x): 回傳x的絕對值，如果x是null則回傳null
select abs(-1.1);
-- ceil(x): 回傳大於x的最小整數，ceiling(x)功能相同
select ceil(1.67), ceil(1.37);
-- degrees(x): 將弧度轉成角度
select degrees(1);
-- floor(x): 回傳小於x的最大整數
select floor(1.67), floor(1.37);
-- pi(): 回傳圓周率
select pi();
-- pow(x, y): x的y次方，power(x, y)功能相同
select pow(2, 3);
-- radians(x): 將角度x轉成弧度
select radians(60);
-- rand([n]): 回傳一個介於0(含)~1.0(不含)的亂數。n是seed value，如果加上則可重複產生相同亂數
select rand(), rand(3);
select 5 + rand() * (10 - 5); -- 回傳一個介於5(含)~10(不含)的亂數
-- round(x, d): -- 將x數字四捨五入到小數第d位，省略d則代表到整數位
select round(1.67), round(1.67, 1);
-- sin(x): 回傳弧度為x的sine值
select sin(radians(60));
-- truncate(x, d): 保留數字x到小數第d個位數，其餘去除
select truncate(1.678, 1); -- 保留小數至第1個位數
select truncate(1.678, 0); -- 只保留整數，刪除所有小數
------------------------------------------------------------------------

