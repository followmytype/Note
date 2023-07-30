# docker volumn
目錄掛載，將產生的容器內部資料夾目錄跟本機的資料夾目錄綁定起來，操作本機的檔案也能同步更新到容器內部的檔案內容，當容器被刪除時，也能保留檔案在本機上。
> 選擇的目錄不管是本機端還是容器內部，如果該目錄不存在，docker會自動建立該目錄
```
docker run --privileged=true -v <LOCAL_DIRECTORY_PATH>:<CONTAINER_DIRECTORY_PATH> <IMAGE>
```
檢查容器的綁定狀態
```
docker inspect <CONTAINER_ID|CONTAINER_NAME>

{
    ...
    "Mounts": [
        {
            "Type": "bind",
            "Source": "<LOCAL_DIRECTORY_PATH>",
            "Destination": "<CONTAINER_DIRECTORY_PATH>",
            "Mode": "",
            "RW": true,
            "Propagation": "rprivate"
        }
    ],
    ...
}
```
## 補充
### `--privileged=true`
在使用掛載時，建議加上`--privileged=true`，因為在掛載時可能會碰到`cannot open directory : Permission denied`關於安全的權限問題，加上這個參數能擴大容器掛載目錄的權限，解決這個問題。
### 唯讀限制設定
當在設定綁定時，如果沒有特別設定，預設為讀寫都開放，亦即容器內可以新增編輯查看檔案，同步到本機端的目錄內，本機端新增的檔案，容器內也能修改，但可以限制容器的讀取權限。
```
docker run --privileged=true -v <LOCAL_DIRECTORY_PATH>:<CONTAINER_DIRECTORY_PATH>:ro <IMAGE>
```
在容器綁定路徑後方加上`ro`，限制容器的為唯讀，不能編輯該目錄底下的任一檔案，只能查看內容
### 繼承綁定掛載
綁定設定可以繼承，新增一個新的容器，綁定的目錄設定與已存在的容器一樣。因為只是套用已存在的設定，所以原先存在的容器如果不在了，並不會影響到新建容器。此可達到不同容器內的檔案目錄共享。
```
docker run --name=<CONTAINER_NAME> --privileged=true --volumes-from=<CONTAINER_NAME> ubuntu bash
```

## docker compose volumes與mount綁定
使用docker compose時，綁定可以分為三種
1. 匿名綁定
2. 命名綁定
3. 指定本機位置綁定

這邊先準備會需要用到的檔案和指令：
```yml
version: '3.8'
services:
  db:
    image: mysql
    restart: always
    environment:
      MYSQL_ALLOW_EMPTY_PASSWORD: "yes"
      MYSQL_DATABASE: test_db
    ports:
      - "3310:3306"
# 匿名設定---------------
    volumes:
      - /var/lib/mysql
# ---------------------
# 命名設定--------------
    volumes:
      - db_data:/var/lib/mysql
volumes:
  db_data:
# 也可以這樣寫
volumes:
  db_data: 
    driver: local
#----------------------
# 指定本機位置設定--------------
    volumes:
      - $PWD/data:/var/lib/mysql
#----------------------
```
建立資料表指令
```sql
USE test_db;
SHOW TABLES;
CREATE TABLE users (
       user_id int NOT NULL AUTO_INCREMENT,
       name VARCHAR(20),
       PRIMARY KEY (user_id)
);
```

### 一、匿名綁定
docker會使用volumes功能，代表這個綁定交由他控管，綁定時只設定要綁定**容器內**的哪些位置或檔案，一旦容器啟動，docker會自動在本機端設定一個位置做綁定，而當容器刪除，資料還會存放在本地端內，但因為是匿名設定，所以具體位置都是以隨機數去產生，即使使用相同的設定檔案再啟容器，新容器也不會擁有之前的資料。volumes會一直存在於本機端中，通常用於暫時性的資料保存或測試。

### 二、命名綁定
一樣使用bolumes，綁定時將綁定的volumes給予自訂的名稱，啟動後docker會找尋本地端有沒有此名稱的volumns，有則使用，若無、則自動在本機端找尋位置做綁定，然後給予名稱，保存檔案。

### 三、指定本機位置綁定
直接指定本機端與容器內的綁定的綁定，因為夠直接夠單純，所以不會新增volumes。

### external
```yml
version: '3.8'
services:
  db:
    image: mysql
    restart: always
    environment:
      MYSQL_ALLOW_EMPTY_PASSWORD: "yes"
      MYSQL_DATABASE: test_db
    ports:
      - "3310:3306"
    volumes:
      - db-data:/etc/data
volumes:
  db-data:
    external: true
```
當設定external時，代表要使用外部的volumes，也就是說我們會認定名叫`db-data`的volumes已經存在，如果不存在的話，docker會回傳錯誤中斷執行。

當原先設定命名volumes時，以上面的設定檔來說，預設的volumes名稱會是`{project_name}_db-data`，但因為我們使用外部volumns，所以他會去找名稱叫做`db-data`的volumes。
