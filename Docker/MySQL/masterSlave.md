# MySql 主從架構docker安裝

建立主從模式的mysql架構

## 目錄架構
這裡以搭建一個主和一個從為範例，主和從資料庫的外部文件架構，到時用於容器內的綁定
```bash
# master端
<PATH>/mysql-master/log
<PATH>/mysql-master/data
<PATH>/mysql-master/conf

# slave端
<PATH>/mysql-slave/log
<PATH>/mysql-slave/data
<PATH>/mysql-slave/conf
```
而在`master`的`conf`內新建`my.conf`檔案，寫入配置文件
```bash
# <PATH>/mysql-master/conf/my.cnf
[mysqld]
## 設定server id，需為同一局域內唯一值
server_id=101
## 指定不同步的資料庫
binlog-ignore-db=mysql
## 開啟二進制日誌功能
log-bin=mall-mysql-bin
## 設定二進制日誌內存大小
binlog_cache_size=1M
## 設定二進制日誌格式(mixed, statement, row)
binlog_format=mixed
## 二進制日誌過期清理時間，預設為0，表示不清理
expire_logs_days=7
## 跳過主從複製中遇到的指定類型錯誤，避免slave端複製中斷
## 例：1062為主鍵重複，1032為主從資料不一致
slave_skip_errors=1062
```
完成後將主資料庫架設起來：
```bash
# master
docker run -d -p=3307:3306 --privileged=true \
    --name=<YOUR_CONTAINER_NAME>-master \
    -v=<PATH>/mysql-master/log:/var/log/mysql \
    -v=<PATH>/mysql-master/data:/var/lib/mysql \
    -v=<PATH>/mysql-master/conf:/etc/mysql/conf.d \
    -e=MYSQL_ROOT_PASSWORD=<YOUR_SECRET_PASSWORD> \
    mysql
```
然後進入主資料庫容器，新增`slave`帳號和權限，讓從資料庫可以進入主資料庫進行複製：
```bash
> docker exec -it <CONTAINER_NAME> bash

mysql-master-container > mysql -uroot -p

mysql > show databases;
mysql > CREATE USER 'slave'@'%' IDENTIFIED BY '123456';
mysql > GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'slave'@'%';
```
再來是從資料庫的配置文件：
```bash
# <PATH>/mysql-slave/conf/my.cnf
[mysqld]
## 設定server id，需為同一局域內唯一值
server_id=102
## 指定不同步的資料庫
binlog-ignore-db=mysql
## 開啟二進制日誌功能
log-bin=mall-mysql-slave1-bin
## 設定二進制日誌內存大小
binlog_cache_size=1M
## 設定二進制日誌格式(mixed, statement, row)
binlog_format=mixed
## 二進制日誌過期清理時間，預設為0，表示不清理
expire_logs_days=7
## 跳過主從複製中遇到的指定類型錯誤，避免slave端複製中斷
## 例：1062為主鍵重複，1032為主從資料不一致
slave_skip_errors=1062
## relay_log配置中繼日誌
relay_log=mall-mysql-relay-bin
## 表示將複製事件寫進自己的二進制日誌
log_slave_updates=1
## slave端資料設定唯讀（擁有super權限的用戶例外）
read_only=1
```
再來建立從資料庫：
```bash
# slave
docker run -d -p=3308:3306 --privileged=true \
    --name=<YOUR_CONTAINER_NAME>-slave \
    -v=<PATH>/mysql-master/log:/var/log/mysql \
    -v=<PATH>/mysql-master/data:/var/lib/mysql \
    -v=<PATH>/mysql-master/conf:/etc/mysql/conf.d \
    -e=MYSQL_ROOT_PASSWORD=<YOUR_SECRET_PASSWORD> \
    mysql
```
> 建立容器後都要使用`docker ps`去檢查容器的狀態

這時進入主資料庫的容器，並且登入`mysql`後查看狀態，記住回傳的數值
```sql
show master status;

+-----------------------+----------+--------------+------------------+-------------------+
| File                  | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+-----------------------+----------+--------------+------------------+-------------------+
| mall-mysql-bin.000003 |      712 |              | mysql            |                   |
+-----------------------+----------+--------------+------------------+-------------------+
```
然後再進入從資料庫，進行另一步配置：
```sql
> docker exec -it <CONTAINER_NAME> bash

mysql-slave-container> mysql -uroot -p

mysql> change master to master_host='主資料庫ip', master_user='slave', master_password='123456', master_port=3307, master_log_file='mall-mysql-bin.000001', master_log_pos=617, master_connect_retry=30;
```
這裡解釋參數定義：
* `master_host`: 主資料庫的`ip`位置端
* `master_port`: 主資料庫對外開放的`port`端
* `master_user`: 從資料庫登入主資料庫使用的帳號
* `master_password`: 登入的密碼
* `master_log_file`: 指定從資料庫要複製的日誌文件，通過查看主資料的狀態獲取`file`參數
* `master_log_pos`: 指定從資料庫要從哪個位置開始複製，通過查看主資料的狀態獲取`position`參數
* `master_connect_retry`: 連線失敗重試的時間間隔，單位為秒

當配置完成後，一樣要查看從資料庫的狀態：
> 這裡的加上`\G`的結果為顯示的格式改變，變成直式顯示
```sql
show slave status \G;
```
顯示出來的資料主要看`Slave_IO_Running`和`Slave_SQL_Running`這兩個屬性的值，可以看到他們都為`No`，表示未開啟，所以要將這個開關打開，讓從資料庫開始執行複製主資料庫的行為
```sql
start slave;
```
然後就能測試了，進入主資料庫新建資料庫、資料表、插入新的數據、更新數據、刪除數據等等，再去從資料庫檢查能否查到剛剛更動的資料
```
mysql > create database db01;
mysql > use db01;
mysql > create table t01(id int, name varchar(20));
mysql > insert into t01 values(1, 'apple');
mysql > insert into t01 values(2, 'banana');
```
## 備註
當配置文件有修改時，記得都要重啟容器以套用新的設定
```bash
docker restart <CONTAINER_NAME>
```

當在檢查從資料庫時發現`Slave_IO_Running`為`Connectiog`時，可能是因為主資料庫的設定有問題，最有可能是帳號密碼錯誤，可以重新設定看看
