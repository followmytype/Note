# 新增無標題檔案自動開啟選取語言模式
`vscode`使用`cmd+n`或是`ctrl+n`可以新增一個無標題檔案，但是在產生檔案時預設只是一般的文字檔，顯示語言設定要另外敲快速鍵或是滑鼠點擊選取，有時覺得很麻煩，於是去看看有沒有辦法能夠一次使用快速鍵就新增無標題檔案並且自動跳出語言選取的框框。

研究了一陣子，發現`vscode` **一個快速鍵組合只能有一個行為**，而 *新增無標題檔案* 和 *選取語言模式* 是兩個行為，結論上是不行的，後來轉而尋找有沒有套件可以輔助，最後有找到符合我需求的套件

## [`multi-command`]#
這是一個可以組合多個行為的套件，可以將新增無標題檔案和選取語言模式定為一個行為，使用方法如下：
1. 在`settings.json`裡將這個套件內自訂一個行為，這裡取名為`newFileAndMode`，意思代表新檔案且設定語言
    ```json
    {
        ...
        "multiCommand.commands": [
            {
                "command": "multiCommand.newFileAndMode"
            }
        ],
        ...
    }
    ```
2. 設定這個行爲內的動作，這裡加入新增無標題檔案以及選取語言模式這兩個行為
    ```json
    {
        ...
        "multiCommand.commands": [
            {
                "command": "multiCommand.newFileAndMode",
                "sequence": [
                    "workbench.action.files.newUntitledFile",
                    "workbench.action.editor.changeLanguageMode"
                ]
            }
        ],
        ...
    }
    ```
3. 更改快速鍵設定（`keybindings.json`），先移除`cmd+n`或是`ctrl+n`的預設行為，並且改成套件的自訂行為：
    ```json
    [
        {
            "key": "cmd+n",
            "command": "-workbench.action.files.newUntitledFile"
        },
        {
            "key": "cmd+n",
            "command": "multiCommand.newFileAndMode",
        }
    ]
    ```
這樣就大功告成了，背後的原理其實很簡單，就是新增一個行為，而這個行為會執行多個行為，這樣就符合`vscode`一個快速鍵組合只能有一個行為的規則了。

[`multi-command`]: https://marketplace.visualstudio.com/items?itemName=ryuta46.multi-command "multi-command"
