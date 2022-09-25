# docker container常用指令

### 建立容器
```
docker run <IMAGE>
```
簡單快速建立容器，但通常會搭配不一樣的參數進行設定
1. `--name`: 指定容器名稱
2. `-i`: 以交互模式運行容器，通常與`-t`同時使用
3. `-t`: 為容器分配一個虛擬終端，通常與`-i`同時使用，即為啟動交互式容器（擁有終端，等待使用者輸入）
    ```
    docker run -it <image> /bin/bash 使用交互模式產生一個容器，並在容器內執行/bin/bash指令
    ```
    放在鏡像後面的是指派容器要執行的命令，而這邊需要容器給我們一個交互式的`Shell`，所以為`/bin/bash`
4. `-d`: 後台運行容器並回傳容器ID，也即是啟動後台守護式容器（在後台運行）  
    但一些鏡像生成的容器如果沒有前台的進程，或是掛著一直執行的指令，docker會自動關閉它，所以想要讓他保持開啟的方式就是使用`-itd`參數，讓生成的容器開啟一個交互的前台進程，不會讓容器自動關閉
5. `-P`: `port`隨機映射
6. `-p`: 指定`port`配對

-p 使用方法
|參數|說明|
|-|-|
|`-p hostPort:containerPort`|指定本地`port`對映容器的`port`，例: `-p 8080:80`|
|`-p ip:hostPort:containerPort`|配置`ip`與`port`映射容器`port`，例: `-p 10.0.0.100:8080:80`|
|`-p ip::containerPort`|指定`ip`隨機`port`設定，例: `-p 10.0.0.100::80`|
|`-p hostPort:containerPort:udp`|指定通訊協議，例: `-p 8080:80:udp`|
|`-p hostPort:containerPort -p hostPort:containerPort`|指定多個映射，例: `-p 80:80 -p 443:443`|

---
### 列出存在且活著的容器
```
docker ps
--------------------------
CONTAINER_ID IMAGE   COMMAND  CREATED STATUS PORTS     NAME
容器ID        來源鏡像 執行的命令 創建時間  狀態   對映的port 容器名稱
```
參數
1. `-a`: 列出全部容器，包含未啟用
2. `-l`: 選出最近創建的容器
3. `-n`: 選出最近創建的n個容器
4. `-q`: 只羅列容器ID
---
### 退出容器
退出容器有兩種辦法，一個會在退出的時候停止容器，另一個則是退出時容器保持啟動狀態。
1. 在命令端輸入`exit`，退出並停止容器
2. `ctrl+p+q`，退出但保持容器啟用狀態
---
### 啟動已停止容器
```
docker start <CONTAINER_ID|CONTAINER_NAME>
```
### 重啟容器
```
docker restart <CONTAINER_ID|CONTAINER_NAME>
```
### 停止容器
```
docker stop <CONTAINER_ID|CONTAINER_NAME>
```
### 強制停止容器
```
docker kill <CONTAINER_ID|CONTAINER_NAME>
```
### 刪除容器
一般刪除指令不能刪除正在運行中的容器，需加上`-f`強制執行
```
docker rm <CONTAINER_ID|CONTAINER_NAME> 可用空格分割不同的容器ID達到刪除多個容器的效果
docker rm -f <CONTAINER_ID|CONTAINER_NAME> 強制刪除容器

docker rm -f $(docker ps -a -q)
```
---
### 查看容器log日誌
```
docker logs <CONTAINER_ID|CONTAINER_NAME>
```
---
### 查看容器運行進程
```
docker top <CONTAINER_ID|CONTAINER_NAME>
```
---
### 查看容器內部細節
```
docker inspect <CONTAINER_ID|CONTAINER_NAME>
```
---
### 容器內運行指令
將想執行的指令交給指定容器，容器會在內部運行結果
```
docker exec <CONTAINER_ID|CONTAINER_NAME> <COMMAND>
```
參數
1. `-d`: 讓指令在容器內背後執行
2. `-i`: 以交互式執行
3. `-t`: 為容器配發一個虛擬終端

#### 範例
命令容器執行`echo hello`，會印出`hello`。若加上`-d`參數則會在容器內背後執行，不會顯示結果
```
docker exec <CONTAINER_ID|CONTAINER_NAME> echo hello
```
進入容器內的標準輸入模式，並使用`bash`
> 這個方法是啟用一個新的終端並且進入，若退出並不會影響原先容器的運行。還有另外一種進入容器的方式為`docker attath`
```
docker exec -it <CONTAINER_ID|CONTAINER_NAME> bash
```
---
### 容器與本機檔案流動
```
將容器內的檔案拷貝到本機
docker cp <CONTAINER_ID|CONTAINER_NAME>:<FILE_PATH> <LOCAL_PAHT>

將本機檔案拷貝到容器內
docker cp <FILE_PATH> <CONTAINER_ID|CONTAINER_NAME>:<PATH>
```
---
### 容器備份 匯出與導入
匯出容器資料
```
docker export <CONTAINER_ID|CONTAINER_NAME> export.tar
```
匯入容器資料
```
cat export.tar | docker import - <IMAGE>
```
就能將資料導入新增的容器 達到備份的效果

---
## 補充

### 進入容器的另一種方法：`docker attath`
這個方法是直接進入容器啟動命令的終端，不會另開進程，如果用`exit`退出，會導致容器的關閉。
