# linux 指令筆記

## 執行多個指令
### 一般分隔`;`
逐一執行，指令間有順序性，但無相關性，使用 `;` 做分隔。
```
command1 ; command2 ; command3
```
### AND`&&`
指令間有順序性，且需要前面指令成功才能繼續執行，使用 `&&` 做分隔。
```
command1 && command2
```
> 若 `command1` 失敗則 `command2` 便不會執行。
### OR`||`
當前面的指令失敗，才會執行下一個指令。
```
command1 || command2
```
> `command1` 失敗時，`command2` 才會執行
