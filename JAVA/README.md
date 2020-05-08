# `JAVA`筆記
在某次的工作任務裡，因為需要操作某個軟體，需要用到`JAVA`，才重新碰起只有在大學一兩個學期才玩過的語言，發現到原來我對`JAVA`一點都不熟，ㄎㄎ，我還真的很混啊。

先來介紹一些`JAVA`的名詞吧
## `JVM`、`JRE` 與 `JDK`
在這之前先來看這張圖
![JAVA](https://www.oracle.com/ocom/groups/public/@otn/documents/digitalasset/2005450.jpg)
### `JVM`
全名`Java Virtual Machine`，是一個執行`JAVA`程式的虛擬小平台，在以前剛碰到`JAVA`的時候，大家都一直說他擁有跨平台的優勢，那先來說說跨平台是怎麼回事。

通常來說，程式語言在編寫完成後，需要再經過編譯，轉換成電腦看得懂的1010，但是現在運行的作意系統非常多，在A系統裡面編譯過後的執行檔若拿到B系統的話，就沒辦法執行了，必須要重新去編寫這個程式。

而JAVA呢，他完全不用考慮作業系統的問題，真正執行與運作的是`JVM`這個虛擬機，他可以裝在任何的作業系統上，只要編譯完成後，把你的執行檔拿給`JVM`，他就會負責去跟作業系統溝通，讓作業系統執行。
### `JRE`
`Java Runtime Environment`，JAVA的執行環境，在我們編寫`JAVA`程式的時候，常常會用到很多已經建立好的物件函示，而這些提供這些好用工具的，就是`JRE`了。
### `JDK`
再來就是`JDK`了，`JDK`是`JAVA`的編譯工具，他能把`.java`的檔案編譯為`.class`，是`JAVA`開發者會需要裝到的東西，而看到上圖，我們可以做個總結：
* `JDK`負責編譯
* `JRE`提供程式內運用的工具
* `JVM`讓程式能夠執行在任何環境下的東西

通常一般來說，下載安裝`JAVA`指的是`JRE` 和 `JVM`，而`JDK`是給開發者安裝的，下載後一樣會包含上面兩個，如果只是執行`java`程式的話，安裝`JRE`就可以了。
## `JDK`安裝
在我安裝`JDK`的時候，對於他也是霧煞煞，才知道他有很多版本，網上大多是推薦安裝`JAVA 8`，那我們就來安裝他吧，首先我們先到 [這裡] 來找我們要的`JAVA`版本，然後往下滑看到`JAVA 8` 的 `JDK` 下載，選擇自己的作業系統，點擊下載後，**居然說要登入！！**其實我也不知道為什麼他要這麼做，但是後來在網路上看到解法
> 這邊我是用macbook
1. 首先當下載彈窗出現時，按同意後，不要立刻按下下載，**滑鼠右鍵點擊下載按鈕**，然後**複製連結**，會得到下面這串網址
```
https://www.oracle.com/webapps/redirect/signon?nexturl=https://download.oracle.com/otn/java/jdk/8u251-b08/3d5a2bb8f8d4428bbe94aed7ec7ae784/jdk-8u251-macosx-x64.dmg
```
可以看到他的按鈕先幫你導去登入頁面，另外加上登入成功後的下載網址，我們要的就是那串網址，也就是`nexturl`後面的那串
```
https://download.oracle.com/otn/java/jdk/8u251-b08/3d5a2bb8f8d4428bbe94aed7ec7ae784/jdk-8u251-macosx-x64.dmg
```
2. 再來就是拿上面這串去下載，把他直接貼到網址上是不行的，我們要用`wget`這個工具，是個下載工具，在終端機上執行下面這個指令，網址就帶上面我們得到的那個
```
wget -c --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie"  https://download.oracle.com/otn/java/jdk/8u251-b08/3d5a2bb8f8d4428bbe94aed7ec7ae784/jdk-8u251-macosx-x64.dmg
```
這樣就拿到我們要的`JDK`安裝檔了～

[這裡]: https://www.oracle.com/java/technologies/javase-downloads.html