# docker image常用指令

### 查看本地鏡像(images)
```
docker images
-------------
REPOSITORY  TAG  IMAGE_ID  CREATED  VIRTUAL_SIZE
鏡像名稱      版號  鏡像ID    創建日期   容量
```
> 如果不指定鏡像版號，預設使用最新的版本，名為`latest`  
> 指定版號的寫法`<IMAGE>:<TAG>`

參數
```
docker images -a 列出所有本地鏡像（含歷史紀錄）
docker images -q 只列出鏡像ID
```
---
### 搜尋鏡像
```
docker search <IMAGE>
--------------------------
NAME    DESCRIPTION STARS  OFFICIAL      AUTOMATED
鏡像名稱  鏡像說明     星星數  是否為官方鏡像   是否為自動構建的
```
參數

`--limit`: 只列出指定數量（預設25個）
```
docker search --limit 5 redis 只列出5個redis鏡像
```
---
### 下載鏡像
```
docker pull <IMAGE>[:TAG]
```
`TAG`為指定版本號，如果沒填寫，為最新版
```
docker pull mysql         下載最新版mysql鏡像
docker pull mysql:latest  下載最新版mysql鏡像
docker pull mysql:5.6     下載5.6版mysql鏡像
```
---
### 查看docker鏡像/容器/數據卷所使用的空間
```
docker system df
----------------
TYPE                 TOTAL  ACTIVE  SIZE  RECLAIMABLE
                     數量   活動中    大小   可回收的
Images-鏡像
Containers-容器
Local Volumes-數據卷
Build Cache-緩存
```
---
### 刪除鏡像
```
docker rmi <IMAGE_ID> [<IMAGE_ID>]
docker rmi -f <IMAGE_ID> 強制刪除鏡像
docker rmi -f $(docker images -qa) 一次刪除全部鏡像
```
> 可一次刪除多個鏡像 彼此間用空格分開。  
> 如果有存在的容器適用想刪除的鏡像生成的，則鏡像無法刪除。
---
## 補充

### 虛懸鏡像(dangling image)
名稱與標籤（版號）都為`none`的鏡像，可直接刪除，`docker`在構建時的遺留
```
$ docker images

REPOSITORY  TAG     IMAGE_ID  CREATED        VIRTUAL_SIZE
<none>      <none>  asdladjk  one month ago  10.4MB
```
