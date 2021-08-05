# `composer`使用筆記
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