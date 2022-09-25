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
