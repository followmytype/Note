# `git`使用筆記
## `git`心得
`git`就像是個存檔工具，當我在編輯專案的時候，一定會常常需要更動它，並記錄下來，幫助我找回之前的某些資料，而且在與團隊共同開發的時候，也能做好專案內每個檔案的控管，是個很棒的工具。
## `git`簡介
![git_image](https://static.coderbridge.com/img/techbridge/images/kdchang/cs101/git-workflow.png)

# `git`安裝
## MAC
我現在本身是在用MAC做開發的，MAC有個好用的套件管理工具：
* **homebrew**  

他的筆記我往後會再找時間補，只要在終端機上輸入這個
```
brew install git
```
這樣`git`就安裝完成了喔

## `git`使用
### 使用者設定
使用`git`前要先設定使用者的 `Email` 信箱以及名稱
```
git config --global user.name "CZJ"
git config --global user.email "followmytype@gmail.com"
```
然後到你想要讓`Git`進行版控的資料夾內，初始化它：
```
git init
```
接下來就要讓`git`去記錄他了，首先我們先輸入：
```
git status
```
這個指令可以看到目前的`git`狀態，如果資料夾內已經有檔案的話，他就會顯示還沒讓`git`追蹤的檔案，或是我們這裡先創一個簡單的檔案吧：
```
echo 'hello world' > index.html
```
再來就要讓`git`去控管他們了
```
git add file_name // 這是只加入特定檔案
git add *.html // 這是加入所有html檔的寫法
git add --all // 一次加入所有的檔案，包含所有更動的行為
git add -A // 同上
```
> 延伸閱讀，[git add -A 和 git add . 的區別]  

這時`git`已經將想要追蹤的項目加到暫存庫裡了，為什麼說是暫存庫呢？因為`git`希望在每筆紀錄的時候，能夠加上說明文字，告訴大家也是幫自己紀錄，這次的存檔是做了些什麼，而且暫存還能讓使用者再次確認這次的變更，等一切都確認好後，`git`才會將它存放到倉庫內儲存。  
  
然後來`commit`吧
```
git commit -m "title" // 只提交 title
git commit -m "title" -m "detail message" // 提交 title 和 補充文字
```
> `-m` 這個參數的意思就是`message`，訊息的意思，常用在簡短的commit說明上。

另外其實常常在工作上，都會在某個任務告一段落時，才會進行`commit`，所以紀錄的內容就要詳細的講述這次的行為是什麼，而使用上述的 `-m` 就會很難撰寫，所以我們會直接這樣輸入：
```
git commit
```
而這時就會進入到 `Vim` 編輯器內，可以好好的撰寫紀錄訊息了  
小提醒：
1. 用一行空白行分隔標題與內容
2. 限制標題最多只有 50 字元
3. 標題開頭要大寫（for English）
4. 標題不以句點結尾
5. 以祈使句撰寫標題
6. 內文每行最多 72 字
7. 用內文解釋 what 以及 why vs. how
> 延伸閱讀：[Git Commit Message建議寫法]  
> vim 的介紹我會找時間紀錄

這樣我們的`git`流程就已經完成了，這時補充一個指令：
```
git log
```
這個指令能查看這隻`git`的過往紀錄，是個很方便的指令

[git add -A 和 git add . 的區別]:https://www.cnblogs.com/skura23/p/5859243.html    "git add"
[Git Commit Message建議寫法]:https://wadehuanglearning.blogspot.com/2019/05/commit-commit-commit-why-what-commit.html