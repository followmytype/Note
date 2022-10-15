# 三主三從集群配置安裝

`redis`可進行主從架構配置，當`Master`端點出意外停止運作時，`Slave`端點就能自動切換身份頂替運作，而掛掉的端點復活時會自動延續`Slave`的身份作業。

## 配置安裝
`redis`進行分佈式配置，應對突發式高流量進行擴容或是低流量時進行縮容的筆記。

這裡使用三主三從架構，共會開啟六個`redis`容器。
```
docker run -d --name=redis-node-1 --net=host --privileged=true -v <MY_PATH>/redis/redis-node-1:/data redis --cluster-enabled yes --appendonly yes --port 6381
docker run -d --name=redis-node-2 --net=host --privileged=true -v <MY_PATH>/redis/redis-node-2:/data redis --cluster-enabled yes --appendonly yes --port 6382
docker run -d --name=redis-node-3 --net=host --privileged=true -v <MY_PATH>/redis/redis-node-3:/data redis --cluster-enabled yes --appendonly yes --port 6383
docker run -d --name=redis-node-4 --net=host --privileged=true -v <MY_PATH>/redis/redis-node-4:/data redis --cluster-enabled yes --appendonly yes --port 6384
docker run -d --name=redis-node-5 --net=host --privileged=true -v <MY_PATH>/redis/redis-node-5:/data redis --cluster-enabled yes --appendonly yes --port 6385
docker run -d --name=redis-node-6 --net=host --privileged=true -v <MY_PATH>/redis/redis-node-6:/data redis --cluster-enabled yes --appendonly yes --port 6386
```
建立好後進入任一redis容器內，開始做集群設定，這裡進入`redis-node-1`:
```
docker exec -it redis-node-1 bash
```
進入後輸入這串指令，將啟用的六台`redis`拉進同一個集群
```
redis-cli --cluster create 127.0.0.1:6381 127.0.0.1:6382 127.0.0.1:6383 127.0.0.1:6384 127.0.0.1:6385 127.0.0.1:6386 --cluster-replicas 1 
```
> 輸入後會有個互動指令進行確認，這裡輸入yes就行了

而後可以進入任一容器內的`redis`互動模式中，查看集群的狀態和設定，(注意這邊請使用該容器設定的`port`)，以`redis-node-1`為例：
```
redis-cli -p 6381
```
輸入`cluster info`和`cluster nodes`可查看集群的狀態資訊，可得知集群的主從對應分別是誰
```
cluster info
cluster nodes
```
而這次的主從配置為：
|Master|Slave|槽號|
|-|-|-|
|**`node-1`**|**`node-5`**|0 - 5460|
|**`node-2`**|**`node-6`**|5461 - 10922|
|**`node-3`**|**`node-4`**|10923 - 16383|

> 因為每次的主從分配都會不一樣，所以需要仔細確認彼此對應  
> 其實也可以輸入`role`指令得知當前的`redis`身份，但會需要依次登入每個容器查看

`redis`進行`cluster`配置時，會有`0~16383`共`16384`個槽號進行分配，這裡設定六個，`redis`會將這六個均分成兩塊，分別為主三個跟從三個，然後再將主的區塊去均分`16384`槽號，而在儲存資料時，會先將資料的鍵(`key`)進行哈希算法，依照算出來的結果找到對應的槽號區間並將資料存放進去。

---
## 存儲示範
這裡進行資料存儲，以確認資料都有依照哈希算法存入對應的`redis`資料庫中。

在任一容器內登入`redis`的互動介面
> 注意：這裡因為設定好集群，所以登入時需要加上`-c`參數，代表進入集群環境，不加上的話代表進入單機環境，進行資料存儲時可能會出現失敗
```
redis-cli -p 6381 -c

set k1 v1
-> Redirected to slot [12706] located at 127.0.0.1:6383
OK
```
這裡可以看到`k1`經過哈希算法後，進入到對應的槽號，也就是`6383`這台`redis`裡，利用`redis-cli --cluster check 127.0.0.1:6383`檢查叢集內各個`redis`底下有幾個`keys`
```
redis-cli --cluster check 127.0.0.1:6383
```

---
## 主機宕機示範
這裡讓隨機一台`Master`機關閉，查看集群的活動還是否正常，資料是否保存
```
docker stop redis-node-2
```
然後進入任一容器內的`redis`互動模式中，查看集群端點狀態
```
cluster nodes

<REDIS_NODE_6_ID> 127.0.0.1:6386@16386 master - 0 1665843209442 7 connected 5461-10922
<REDIS_NODE_2_ID> 127.0.0.1:6382@16382 master,fail - 1665843034774 1665843031000 2 disconnected
<REDIS_NODE_5_ID> 127.0.0.1:6385@16385 slave <REDIS_NODE_1_ID> 0 1665843207383 1 connected
<REDIS_NODE_3_ID> 127.0.0.1:6383@16383 master - 0 1665843208000 3 connected 10923-16383
<REDIS_NODE_1_ID> 127.0.0.1:6381@16381 myself,master - 0 1665843208000 1 connected 0-5460
<REDIS_NODE_4_ID> 127.0.0.1:6384@16384 slave <REDIS_NODE_3_ID> 0 1665843208409 3 connected
```
可看到原先的`redis-node-2` `master`出現`fail`的狀態，而他的`slave`, `redis-node-6`已經成為了新的`Master`，自動上位。而在這裡一樣進行資料的存取也都不會出現問題。

而此時如果讓停止運作的`redis-node-2`復活過來後，他並不會恢復成原來的`Master`角色，而是去當`redis-node-6`的從機  
啟動`redis-node-2`
```
docker start redis-node-2
```
登入任一容器的`redis`互動介面，查看集群端點狀態
```
cluster nodes

<REDIS_NODE_1_ID> 127.0.0.1:6381@16381 myself,master - 0 1665843765000 1 connected 0-5460
<REDIS_NODE_3_ID> 127.0.0.1:6383@16383 master - 0 1665843765083 3 connected 10923-16383
<REDIS_NODE_6_ID> 127.0.0.1:6386@16386 master - 0 1665843767128 7 connected 5461-10922
<REDIS_NODE_5_ID> 127.0.0.1:6385@16385 slave <REDIS_NODE_1_ID> 0 1665843765000 1 connected
<REDIS_NODE_4_ID> 127.0.0.1:6384@16384 slave <REDIS_NODE_3_ID> 0 1665843766000 3 connected
<REDIS_NODE_2_ID> 127.0.0.1:6382@16382 slave <REDIS_NODE_6_ID> 0 1665843766108 7 connected
```
> 可看到`redis-node-2`擔任`Slave`角色並且跟隨著`redis-node-6`

如果想將`redis-node-2`復原成`Master`的身份，只需將`redis-node-6`暫停再啟就能達成位置替換
