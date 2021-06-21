# `Chocolatey`筆記

## 簡介
windows版的套件管理器，利用指令去下載安裝所需要的軟體。

## 安裝
1. 以系統管理員身分打開`powershell`，確認目前系統的指令檔執行限制(預設`Restricted`)
    ```powershell
    Get-ExecutionPolicy
    ```
2. 更改執行限制，回答`yes`就好
    ```powershell
    Set-ExecutionPolicy AllSigned
    # or
    Set-ExecutionPolicy Bypass -Scope Process
    ```
3. 安裝`chocolatey`
    ```powershell
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    ```
4. 檢查是否成功，輸入`choco`取得以下資訊代表成功
    ```powershell
    choco
    # Chocolatey v0.10.15
    # Please run 'choco -?' or 'choco <command> -?' for help menu.
    ```
5. 安裝所需工具(`vscode, git, node`)
    ```powershell
    choco install -y git nodejs-lts vscode
    ```
    安裝完成後須重新開啟`powershell`來檢查安裝的軟體是否成功
    ```powershell
    node -v
    # v14.17.0
    ```
## 補充
我在使用`npm`安裝`yarn`時遇到的問題，當順利安裝完後使用`yarn`指令系統卻說無法執行認證之類的，執行以下的指令更改指令檔執行限制
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
```

### 顯示已安裝的`package`
```powershell
choco list --localonly
```
### 顯示安裝的`package`路徑
```powershell
choco list --localonly --exact {package_name} --trace
```
通常會在C槽的programdata目錄底下，這個目錄是隱藏的，裡面的.file檔案主要就是路徑檔，xml型式，能從裡面的路徑去找出真正安裝的路徑