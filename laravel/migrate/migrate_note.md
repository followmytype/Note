# `Migrate`筆記
## `refresh` V.S. `fresh`
可以加上`--seed`去輸入預設資料
```
# 將migrate檔案rollback再重新migrate，然後輸入預設資料
php artisan migrate:refresh --seed

# 直接刪除所有table然後再migrate
php artisan migrate:fresh
```