# MySql docker安裝
創建一個mysql容器，過程中有不少坑，筆記筆記。

使用這個指令建立mysql容器
```
docker run -d -p=3306:3306 --privileged=true \
-v=<PATH>/mysql/log:/var/log/mysql \
-v=<PATH>/mysql/data:/var/lib/mysql \
-v=<PATH>/mysql/conf:/etc/mysql/conf.d \
-e=MYSQL_ROOT_PASSWORD=<YOUR_SECRET_PASSWORD> \
--name=<YOUR_CONTAINER_NAME> \
mysql \
mysqld --default-authentication-plugin=mysql_native_password
```
目錄掛載的設定是讓mysql的日誌記錄、儲存資料、設定檔可以掛載到本機端。

當進入mysql容器後，操作測試
```
> mysql -uroot -p

mysql > show databases;
mysql > create database db01;
mysql > use db01;
mysql > create table t01(id int, name varchar(20));
mysql > insert into t01 values(1, 'apple');
mysql > insert into t01 values(2, '蘋果');
```
當執行到輸入中文時，會發現無法打出中文，原因是容器內的系統字符集問題，當進到容器時可用`locale`檢查。
```
> locale

LANG=
LC_CTYPE="POSIX"
LC_NUMERIC="POSIX"
LC_TIME="POSIX"
LC_COLLATE="POSIX"
LC_MONETARY="POSIX"
LC_MESSAGES="POSIX"
LC_PAPER="POSIX"
LC_NAME="POSIX"
LC_ADDRESS="POSIX"
LC_TELEPHONE="POSIX"
LC_MEASUREMENT="POSIX"
LC_IDENTIFICATION="POSIX"
LC_ALL=
```
可以看到上面的設定都是`POSIX`，他是不支援中文輸入的，再看看系統能切換的字符集有哪些
```
> locale -a

C
C.utf8
POSIX
```
發現有C.utf8，他是可以支援中文輸入的，此時退出容器，調整設定後再進入容器
```
docker exec -it mysql env LANG=C.utf8 bash

> locale

LANG=C.utf8
LC_CTYPE="C.utf8"
LC_NUMERIC="C.utf8"
LC_TIME="C.utf8"
LC_COLLATE="C.utf8"
LC_MONETARY="C.utf8"
LC_MESSAGES="C.utf8"
LC_PAPER="C.utf8"
LC_NAME="C.utf8"
LC_ADDRESS="C.utf8"
LC_TELEPHONE="C.utf8"
LC_MEASUREMENT="C.utf8"
LC_IDENTIFICATION="C.utf8"
LC_ALL=
```
此時容器內就能輸入中文了，但又會遇到另一個問題，當要輸入中文資料讓資料表儲存時，mysql又會出錯，原因是mysql內部的字符碼沒有支援utf8。這裡進去mysql後輸入以下指令：
```
mysql> SHOW VARIABLES LIKE 'character%';

+--------------------------+--------------------------------+
| Variable_name            | Value                          |
+--------------------------+--------------------------------+
| character_set_client     | latin1                         |
| character_set_connection | latin1                         |
| character_set_database   | utf8mb4                        |
| character_set_filesystem | binary                         |
| character_set_results    | latin1                         |
| character_set_server     | utf8mb4                        |
| character_set_system     | utf8mb3                        |
| character_sets_dir       | /usr/share/mysql-8.0/charsets/ |
+--------------------------+--------------------------------+
```
可看到mysql內部預設的系統字符為拉丁文，需要將他調整為utf8，這裡在剛剛掛載的設定目錄(`<PATH>/mysql/conf`)內新增`my.conf`檔案，加上以下的內容，將mysql內部的字符設定更改為`utf8`
```
[client]
default_character_set=utf8mb4
[mysqld]
character_set_server = utf8mb4
collation_server = utf8_general_ci
```
到此完成mysql的docker安裝
> 如果安裝後從外部連結沒遇到無法儲存或是顯示中文資料的話，這些配置可以不用加沒關係，通常都會是舊版的mysql才會發生這個問題


## 補充
|变量名|注释|
|-|-|
|character_set_client|主要是用来设置客户端使用的字符集|
|character_set_connection|主要用来设置连接数据库时的字符集,如果程序中没有指明连接数据库使用的字符集类型则按照这个字符集设置.|
|character_set_database|主要用来设置默认创建数据库的编码格式,如果在创建数据库时没有设置编码格式,就按照这个格式设置.|
|character_set_filesystem|文件系统的编码格式,把操作系统上的文件名转化成此字符集,即可character_set_client转换character_set_filesystem.默认binary是不做任何转换的.|
|character_set_results|数据库给客户端返回时使用的编码格式,如果没有指明,使用服务器默认的编码格式.|
|character_set_server|服务器安装时指定的默认编码格式,这个变量建议由系统自己管理,不要认为定义.|
|character_set_system|数据库系统使用的编码格式,这个值一直是utf8,不需要设置,它是存储系统元数据的编码格式.|
|character_set_dir|这个变量是字符集安装的目录.|

https://juejin.cn/post/6966912301249069086
