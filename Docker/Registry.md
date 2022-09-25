# 創建私有docker倉庫

搭建一個自己或公司專用的`docker hub`，`docker`有提供一個可以產生`docker`倉庫的鏡像，首先先將他拉下來並跑在本機端。
```
> docker run -d -p 5000:5000 -v /Users/czj/WorkSpace/docker-test/registry:/tmp/registry --privileged=true registry
```
> 掛載的數據卷依照使用者自訂的位置掛載

利用`ifconfig`得知安裝的機器ip位置為`192.168.1.2`
```
> ifconfig

en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
        options=400<CHANNEL_IO>
        ether 3c:22:fb:d8:20:5d 
        inet6 fe80::488:d4d4:23f9:70b0%en0 prefixlen 64 secured scopeid 0x9 
        inet 192.168.1.2 netmask 0xffffff00 broadcast 192.168.1.255
        nd6 options=201<PERFORMNUD,DAD>
        media: autoselect
        status: active
```
> 這裡因為是用自己的電腦安裝，ip位置為wifi內網的地址，每個人的結果可能都不同，需要自行操作

利用這個指令查詢私有倉庫內的鏡像
```
> curl -XGET http://192.168.1.2:5000/v2/_catalog

{"repositories":[]}
```
可以看到`repository`倉庫內為空，還尚未有任何一個鏡像。
## 產生新的鏡像
我們可以使用本機已存在的鏡像，或是自行建立一個鏡像，並且推上私有倉庫。

這裡我們來製作一份自己的鏡像。這裡用`ubuntu`來做範例
```
> docker run -itd --name=my-test-ubuntu ubuntu
```
創建一個在背後運行不中斷的`ubuntu`容器，進入容器後做一些環境上的配置改變。
```
> docker ps  // 檢視當前運行的容器

CONTAINER ID   IMAGE     COMMAND   CREATED              STATUS              PORTS   NAMES
6fb0b5409817   ubuntu    "bash"    About a minute ago   Up About a minute           my-test-ubuntu
```
這裡得知容器的id後，進入內部，安裝`vim`並新增一個檔案
> 因為ubuntu鏡像是個最小需求的模板，所以預設不會帶有vim這個應用
```
> docker exec -it 6fb0b5409817 bash // 進入容器內部

> apt-get update // 升級apt-get
> apt-get install -y vim // 安裝vim
> vim test.txt // 並使用vim編輯檔案儲存
> exit // 退出容器
```
到此就有一個帶有vim應用的ubuntu容器，配置好後，以這個容器產生一個新的鏡像，未來只需要使用這個新產的鏡像，就能生成帶有vim應用的ubuntu容器，亦為自己想要的配置環境，概念同於程式內的繼承觀念。

使用`docker commit`，操作手法相似於`git commit`
```
docker commit -m="此次記錄內容" -a="作者" <CONTAINER_ID|CONTAINER_NAME> <REPOSITORY>:<TAG>

docker commit -m="add vim" -a="czj" 6fb0b5409817 czj-ubuntu:1.0
```
新增一個紀錄並產生新的鏡像，`-m`為記錄的內容，`-a`為作者
```
> docker images

REPOSITORY   TAG      IMAGE ID       CREATED              SIZE
czj-ubuntu   1.0      fa8d2642705f   About a minute ago   174MB  <<--
ubuntu       latest   2dc39ba059dc   3 weeks ago          77.8MB
registry     latest   3a0f7b0a13ef   6 weeks ago          24.1MB
```
此時能看見自行所建置的鏡像，可以使用這個鏡像再產生一個新的容器，並檢查他內部是否已經有安裝vim。
> docker鏡像的概念為層層構建的，每一層都是一個`commit`去記錄那層的配置操作，復用前面幾層的設定，新增自己的設定。

## 給予鏡像標籤
當鏡像建構好後，需要給予他新的標籤，這個指令並不是變更他的標籤，而是將指定的鏡像檔多給他符合規範的標籤名，才能將他推上私有倉庫，否則預設為`docker hub`
```
docker tag <IMAGE>:<TAG> <HOST>:<PORT>/<REPOSITORY>:<TAG> 如果要新增到私服倉庫上 需要依此規定格式

> docker tag czj-ubuntu:1.0 192.168.1.2:5000/czj-ubuntu:1.0
> docker images

REPOSITORY                    TAG     IMAGE ID       CREATED          SIZE
192.168.1.2:5000/czj-ubuntu   1.0     fa8d2642705f   10 minutes ago   174MB   <<--
czj-ubuntu                    1.0     fa8d2642705f   10 minutes ago   174MB   <-
ubuntu                        latest  2dc39ba059dc   3 weeks ago      77.8MB
registry                      latest  3a0f7b0a13ef   6 weeks ago      24.1MB
```
這裡就多了個新的鏡像，雖然`REPOSITORY`名稱不同，但是`IMAGE ID`跟原先的是一樣的，只是多了個新的名稱。

## 調整docker daemon.json
因為私服的預設使用安全協議，不支援`http`，所以需要調整一下`docker`的設定，在`linux`系統上調整`/etc/docker/daemon.json`檔案，`mac`則用桌面版操作，設定
按鈕裡的`Docker Engine`，調整`daemon.json`，新增這行
```json
{
    "insecure-registries": ["192.168.1.2:5000"]
}
```
改完後重啟，即可套用。
> 因為重啟的關係，稍早使用`docker`創建的私有倉庫需要重新啟動

## 推送到私服上
將需要推上去的鏡像使用規範的格式進行推送。
```
docker push 192.168.1.2:5000/czj-ubuntu:1.0
```

## 檢驗私有倉庫內容
使用上面同一指令查看私有倉庫的鏡像內容
```
> curl -XGET http://192.168.1.2:5000/v2/_catalog 

{"repositories":["czj-ubuntu"]}
```
可看到私有的倉庫已有剛剛推上去的自製鏡像

## 驗證鏡像內容
將剛剛推上去的鏡像重新拉下來並且創建一個容器，檢查容器內是否有安裝vim應用。這裡將本機的ubuntu鏡像都先刪除
```
> docker images

REPOSITORY                    TAG       IMAGE ID       CREATED          SIZE
192.168.1.2:5000/czj-ubuntu   1.0       fa8d2642705f   19 minutes ago   174MB   <-
czj-ubuntu                    1.0       fa8d2642705f   19 minutes ago   174MB   <-
ubuntu                        latest    2dc39ba059dc   3 weeks ago      77.8MB  <-
registry                      latest    3a0f7b0a13ef   6 weeks ago      24.1MB

> docker rmi -f fa8d2642705f 2dc39ba059dc // 這裡使用-f強刪，避免其他麻煩
> docker images

REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
registry     latest    3a0f7b0a13ef   6 weeks ago   24.1MB

> docker pull 192.168.1.2:5000/czj-ubuntu:1.0 // 從私有庫拉下鏡像
> docker images

REPOSITORY                    TAG       IMAGE ID       CREATED          SIZE
192.168.1.2:5000/czj-ubuntu   1.0       fa8d2642705f   26 minutes ago   174MB  <<--
registry                      latest    3a0f7b0a13ef   6 weeks ago      24.1MB
```
此時利用私有庫抓下來的鏡像生成容器，進入容器，檢查vim是否安裝，成功～
