# `composer`使用筆記
`composer`是一個套件管理器，可以幫助專案去安裝所需的外部套件，以及紀錄套件的版本號，也幫助開發人員不用一直使用`include`或是`require`去載入所需要的檔案。

---
## 使用`composer` 
`composer`他本身是一個`composer.phar`檔案，是一個用`php`去執行的檔案，所以可以直接從官網上下載`phar`檔案，單獨放在專案中就能使用，使用方法：
```bash
# 單獨放在專案中，這時就要用php去執行這個檔案，然後後面帶入參數，也就是想要做的行為
php composer.phar [command...]
# 如果我們想要在整個系統上執行的話，就將這個檔案放入全域變數中/usr/local/bin/composer，就能在系統上使用composer指令
composer [command...]
```
---
## 更新`composer`
更新`composer`本身
```bash
composer selfupdate
```
回到上一個`composer`版本
```bash
composer selfupdate --rollback
```
---
## 安裝外部套件
使用`composer`去安裝別人寫好的套件
```
composer require {vendor}/{package}
```
這段指令會到`packagist`上找這個套件，下載到專案內，然後把套件的資訊寫道`composer.json`的`require`裡去。`packagist`是一個大家存放套件的地方，就像是圖書館。 
### 另一種安裝方法
將想要的套件名稱及版本號寫在專案上的`composer.json`裡面的`require`欄位，然後`composer`就會去讀這個檔案並且把相關的套件下載安裝。
```
composer install
```
### 結論
最主要的都是這個`composer.json`檔案，他掌握了專案內所需的套件以及版本，而`composer`就是去讀它來達到控制的效果。

---
## 更新專案內的套件
```
composer update
```
`composer`會去讀`composer.json`上關於套件的版本資訊，並且去做套件的更新。

---
## `install` vs `require` vs `update`
* `install`
    1. 會去看有沒有`lock`檔，有的話就照`lock`把**精確**的套件版本以及相依的套件安裝起來
    2. 沒有的話會走`update`的流程，查看`json`檔，把需要的套件安裝起來，並且產生`lock`檔案去記錄這次的安裝套件的精確版本號
* `update`
    1. 檢查`json`檔案內的版本資訊
    2. 安裝新的套件版本
    3. 更新`lock`檔案
* `require`
    * 單純安裝特定套件
---
## 自動載入`autoload`
當專案內有寫屬於自己的套件庫或是一些通用函式，可以透過`composer`來幫忙管理，假設專案的架構如下
```
{我的專案}
|index.php
|composer.json
|-src:
|  - Folder1:
|      - MyClass1.php
|      - MyClass2.php
|  - Folder2:
|      - MyClass1.php
|  - MyClass.php
|-libs:
|  - Folder1:
|      - LibClass1.php
|  - LibClass2.php
|-helpers:
|  - my_function.php # 檔案內只有自訂函式沒有類別
|-vendor:...
```
以往如果要在`index.php`內使用`src`, `lib`, `helpers`的工具時，都要用`include`或是`require`來引入，檔案一多用相對位置也會混亂，也會不知道到底誰載入過誰，這時可以用`composer`幫忙自動載入所寫的類別，就能方便的使用我們定義的類別。要在`composer.json`檔裡的`autoload`欄位做設定，使用方法有三：
```json
# composer.json
{
    ...
    "autoload": {
        "psr-4": {...},
        "classmap": [...],
        "files": [...],
    }
    ...
}
```
改完`composer.json`後要下指令讓`composer`紀錄剛剛的設定
```bash
composer dump
# or
composer dump-autoload
```
三種載入方式說明：
* ### `psr-4`
    使用`psr-4`的規範，在想要綁定的目錄給他命名空間(`namespace`)，這裡假設`src`的命名空間為`App`，如下：
    ```json
    {
        "autoload": {
            "psr-4": {
                "App\\": "src/"
            }
        }
    }
    ```
    因為這裡遵守`psr-4`的規範，所以`src`底下的`php`檔都要自訂`namespace`，檔名要跟檔案內的類別名稱一樣，而`namespace`的命名規則要跟目錄結構一樣，以`src/Folder1/MyClass1.php`為例：
    ```php
    # src/Folder1/MyClass1.php
    namespace App\Folder1;
    // 因為檔案的位置在src/Folder1/裡面
    // 而src這個位置又已經在composer.json裡取名為App，所以他的命名空間就是App\Folder1

    class MyClass1
    {...}
    ```
    這樣就能在`index.php`內去使用這個`class`，而他唯一要引入的就是`vendor`裡的`autoload.php`檔案
    ```php
    # index.php
    use App\Folder1\MyClass1;
    // 這裡因為Folder2裡面也有一個MyClass1，為了不要混淆，所以將他取別名
    use App\Folder2\MyClass1 as Folder2MyClass1;

    // 這裡只需要引用autoload.php就能達到所要的效果了
    include 'vendor/autoload.php';

    $myClass = new MyClass1();
    $myClassFromFolder2 = new Folder2MyClass1();
    ```
    使用`psr-4`的好處是只需要`dump`一次，不管在`src`裡面新增多少類別，`composer`都會幫忙引入。
* ### `classmap`
    `classmap`的意義是讓`composer`去指定的目錄底下找出所有檔案內定義的類別，提取出來，自動綁定，可以全域呼叫。他是一個陣列，所以能指定多個目錄。這裡指定的目錄為`libs`
    ```json
    {
        "autoload": {
            "classmap": [
                "libs"
            ],
        }
    }
    ```
    設定好後執行`composer dump`，就能在`vendor/composer/autoload_classmap.php`這個檔案內看到綁定的結果：
    ```php
    # vendor/composer/autoload_classmap.php
    ...
    return array(
        'LibClass1' => $baseDir . '/libs/Folder1/LibClass1.php',
        'LibClass2' => $baseDir . '/libs/LibClass2.php',
    );
    ```
    這樣就能在`index.php`裡直接呼叫`libs`裡面的所有類別
    ```php
    # index.php

    include 'vendor/autoload.php'; // 一樣要引用autoload.php才會幫我們做引入

    $LibClass1 = new LibClass1();
    $LibClass2 = new LibClass2();
    ```
    `classmap`的好處是他不用特別使用`use`就能直接全域呼叫類別，但是他的壞處是只要有另外一個相同名稱的類別，衝突就會出現，且每次這個`libs`內的檔案有更動時，都要在`composer dump`一次去紀錄設定。
    > `classmap`只是幫忙在背後做`include`檔案的行為，所以要使用的類別名稱還是要看檔案內的類別名稱，而不是看檔案名，例如`libs`裡面有一個檔案叫做`Test.php`：
    ```php
    # libs/Test.php
    class AnotherName
    {...}
    ```
    這時`vendor/composer/autoload_classmap.php`裡面的內容會是：
    ```php
    # vendor/composer/autoload_classmap.php
    'AnotherName' => $baseDir . '/libs/Test.php',
    ```
    之後呼叫會適用`new AnotherName()`來實作。
* ### `files`
    `files`則是指定單一檔案來引入，這邊是陣列形式，可以指定多個檔案，例如：
    ```json
    {
        "autoload": {
            "files": [
                "helpers/my_function.php"
            ]
        }
    }
    ```
    `my_function.php`內都是放自訂的函式
    ```php
    # helpers/my_function.php
    function1 () {...}
    function2 () {...}
    function3 () {...}
    ```
    一樣能在`index.php`內直接呼叫函式
    ```php
    # index.php

    include 'vendor/autoload.php'; // 一樣要引用autoload.php才會幫我們做引入

    function1();
    function2();
    function3();
    ```
    `files`的優缺點跟`classmap`差不多，只是他比較麻煩的是要將指定的檔案一個個引入，一樣每次有所更動時都要`composer dump`。
## 建立`composer`專案
使用以下指令可以建立專案，並且回答相關問題：
```bash
composer init
```
## 套件開發
當專案開發和套件開發是同時進行時，直接在`composer.json`裡面去指定在本機開發的套件位置，就能達到同步的效果。
1. 目錄架構
    ```
    |---- {My_projuct}
    |       |------ composer.json
    |
    |---- {My_package}
            |------ composer.json
    ```
2. 專案的`composer.json`
    ```json
    {
        /* require裡加上套件名稱 */
        "require": {
            "{My_package}": "dev-main",
        },
        /* repositories加上位置 */
        "repositories": [
            {
                "type": "path",
                "url": "../{My_package}"
            }
        ]
    }
    ```
記得下`composer require {My_package}`，這樣就能在開發套件時同時在專案內做測試使用。

## 補充
### 套件的版本意義
通常版本號有三碼`X.Y.Z`，分別代表的意義：
1. `X`: 主版本號，通常代表穩定版，號碼更新代表套件內大更改，一些釋出的`api`可能改變名稱，使用方式改變等等
2. `Y`: 小版本號，通常代表新的`feature`，也就是可能新增一些新的功能
3. `Z`: 通常代表`fixes`，也就是一些`bug`修復
---
### `composer.json`檢查
當有**手動**更改`composer.json`時，檢查有沒有出錯
```
composer validate
```
---
### `composer init`
1. 沒有要公布的話`License`用`proprietary`
