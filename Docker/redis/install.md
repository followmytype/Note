# `redis` 安裝筆記
```
docker run -d -p 6739:6739 \
--privileged=true \
-v <PATH>/redis.conf:/usr/local/etc/redis/redis.conf \
-v <PATH>/data:/data \
redis \
redis-server /usr/local/etc/redis/redis.conf \
```
第一行簡單的設定開啟一個對應`port:6379`且背景運行，第二行為設定與本地端掛載的目錄文件時需要加上的，以免出現權限錯誤，第三行如果有自己配置設定的`redis`設定檔則補上，第四行將`redis`內部儲存的資料掛載出來，以免容器意外停止時再啟還能保有過往資料，最後一行則讓`redis`套用剛剛掛載的設定檔。

這裡可以試著更改設定文件來測試，87行的設定可以註解掉，這裡原先的意思代表只允許本地端連接，若註解則開放外部連接。
```
87: bind 127.0.0.1 -::1
```
設定redis的daemonize為no，或是將daemonize yes給註釋起來，因為這個配置會與docker run的-d參數衝突，導致啟動失敗
```
309: daemonize no
# or
309: # daemonize yes
```
設定redis登入密碼，可選填
```
1036: requirepass foobared
```
設定redis數據持久化，可選填
```
1379: appendonly yes
```
