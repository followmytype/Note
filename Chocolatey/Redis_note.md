# Redis 筆記
`Redis`是一個簡單的`key-value`資料庫，儲存在記憶體中，常用來做快取資料的運用。
## 簡單運用
這裡是簡單的資料輸入與運用範例
### `SET`
使用`SET`來記錄一筆資料的索引及其數值
```redis
SET {key_name} {value}
```
### `GET`
利用`GET`拿取紀錄在`redis`裡面的資料
```redis
GET {key_name} 
```
簡而來說，`Redis`是一個鍵值資料庫，用`SET`設好`key`的名稱和他所帶的值，在用`GET`去取這個`key`所帶的值。
### `EXISTS`
使用`EXISTS`查看資料有沒有存在，存在回傳`1`，不存在則是`0`
```redis
EXISTS {key_name}
```
### `DEL`
刪除這個`key`以及他賦予的值
```redis
DEL {key_name}
```
---
### `INCR`
將值加一
```redis
SET {key_name} 10
INCR {key_name}
GET {key_name}
```
這樣的結果會得到`11`，`INCR`會將值加一，如果沒有預先設定(`SET`)`key`而直接使用`INCR`，`Redis`會自動建立這筆`key`並賦予`1`，底下會回傳`1`
```redis
INCR {key_name}
GET {key_name}
```
> `INCR`執行時會自動判斷值是不是整數，整數的話會成功加一，如果不是整數的話則會出錯。
### `INCRBY`
加上指定數量
```redis
INCRBY {key_name} 100
```
將指定的`key`的值加上`100`
### `DECR`
減一
```redis
SET {key_name} 10
DECR {key_name}
GET {key_name}
```
這樣則會得到`9`，使用方法與`INCR`相似
### `DECRBY`
減去指定數量
```redis
DECRBY {key_name} 100
```
---
## 設定期限
`Redis`可以設定資料的生命，時間到了後就會自動移除
### `EXPIRE`
設定資料的存活時間，單位是秒
```redis
SET {key_name} "bbbb"
EXPIRE {key_name} 120
```
這筆資料將在兩分鐘後刪除。而我們也可以在設定資料時順便賦予他的期限
```redis
SET {key_name} {value} EX {seconds}
```
> 當設定一筆資料的有效期限後，如果重新設定他的值，沒有設定期限，資料將取消過期的設定，若要查看資料還有多久的存活時間可以使用`TTL`
### `TTL`
查看資料的存活時間
```redis
TTL {key_name}
```
指令將會回傳存活秒數，回傳`-2`代表這個值已經過期不存在，`-1`則是這筆資料不會過期。
### `PERSIST`
手動的取消資料的期限
```redis
PERSIST {key_name}
```
---
## 列表 - `LIST`
`Redis`資料儲存形式之一，一個`key`裡面存放多筆數值組成的列表，具有順序性
### `RPUSH`
全名是`right push`，右側新增，將資料新增到列表的尾端
```redis
RPUSH {list_name} value
```
### `LPUSH`
全名是`left push`，左側新增，將資料新增到列表的首端
```redis
RPUSH {list_name} value
```
> `RPUSH`、`LPUSH`兩個指令都可以做多筆資料的一次性輸入
> ```redis
> RPUSH {list_name} {value1} {value2} {value3} 
> ```
### `RPOP`
全名是`right pop`，右側刪除，刪除列表的尾端資料
```redis
RPOP {list_name}
```
### `LPOP`
全名是`left pop`，左側刪除，刪除列表的首端資料
```redis
LPOP {list_name}
```
### `LLEN`
全名是`list length`，取得列表的長度
```redis
LLEN {list_name}
```
### `LRANGE`
全名是`list range`，取得列表的指定範圍資料，第一個參數是列表的`index`，從零開始選到第五個數值。第二個參數為`-1`時代表選到最後一個，`-2`則是倒數第二個，以此類推。
```redis
LRANGE {list_name} 0 5
```
### `LSET`
更改列表指定`index`的值
```redis
LSET {list_name} 1 {value}
```
---
## 集合 - `SET`
跟列表類似的儲存方式，差別在於集合沒有順序性以及集合裡的每筆資料只會出現一次
### `SADD`
全名`SET ADD`，新增一筆資料到集合裡，一樣可以動態輸入多筆資料。回傳成功輸入的數量
```redis
SADD {set_name} {value1} {value2}
```
### `SREM`
全名`SET REMOVE`，刪除集合裡的某筆資料，回傳`1`代表刪除成功，回傳`0`代表集合裡沒有這筆資料
```redis
SREM {set_name} {value}
```
### `SCARD`
回傳集合的數量，若沒有集合則為零
```redis
SCARD {set_name}
```
### `SPOP`
全名`SET POP`，取出指定數量的集合資料，沒有的話預設一筆，隨機移除並回傳集合的資料
```redis
SPOP {set_name} [{number}]
```
### `SRANDMEMBER`
全名`SET RANDOM MEMBER`，隨機獲得指定數量的集合資料，預設一筆，不會移除集合內的資料。如果數量是負數的話，一樣給出指定數量的資料，但是內容會有重複的
```redis
SRANDMEMBER MEMBER [{number}]
```
### `SISMEMBER`
檢查數值是否存在於集合中，回傳`1`代表存在於集合中，`0`則是沒有
```redis
SISMEMBER {set_name} {value}
```
### `SMEMBERS`
列出集合內的資料
```redis
SMEMBERS {set_name}
```
### `SUNION`
取兩個集合的聯集
```
SUNION {set_name1} {set_name2}
```
---
## 有序集合 - `SORTED SET`
集合雖然好用，但是他並沒有排序，所以`Redis`給了集合新的設計，增加他的排序，用`Z`開頭，每個數值都會帶一個分數(`score`)，作為排序的依據，成員一樣唯一，但是分數可以重複
### `ZADD`
新增有序集合資料，一樣可以新增多筆資料，如果資料已經存在但是`score`不一樣，則會更新該筆資料的`score`
```redis
ZADD {sorted_set_name} {score1} {value1} [{score2} {value2}]
```
### `ZCARD`
取得有序集合內的資料數量
```redis
ZCARD {sorted_set_name}
```
### `ZCOUNT`
計算兩個分數區間的資料數量
```redis
ZCOUNT {sorted_set_name} {min} {max}
```
### `ZRANGE`
取得指定index內的資料，一樣從零開始
```
ZRANGE {sorted_set_name} {min_index} {max_index}
```
---
## 哈希 - `HASH`
哈希是一個域值對應的資料儲存型態，類似物件的儲存方式，可以命名索引
### `HSET`
設定一組的哈希的域名及其值，域值可以動態多筆輸入
```redis
HSET {hash_name} {index_name1} {value1} [{index_name2} {value2}]
```
### `HGETALL`
取得該筆哈希的所有資料
```redis
HGETALL {hash_name}
```
### `HGET`
取得指定哈希域值
```redis
HGET {hash_name} {index_name}
```
### `HINCRBY`
當哈希儲存的值是整數時，可以使用`INCRBY`去增加指定的數量
```redis
HINCRBY {hash_name} {index_name} {number}
```
### `HDEL`
刪除指定的域值
```redis
HDEL {hash_name} {index_name}
```

## 附錄
- [Redis命令參考](http://redisdoc.com/index.html)
- [Laravel Redis](https://segmentfault.com/a/1190000009695841)