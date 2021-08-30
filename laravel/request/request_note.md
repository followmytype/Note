# `request`驗證

## 在`request`檔案取請求參數
```php
# SomeThingRequest.php
$some = $this->input('some');
// or
$some = $this->some;
```
## 驗證前準備
當想在驗證前做一些額外處理，例如加入額外的鍵值
```php
# SomeThingRequest.php
protected function prepareForValidation()
{
    $this->merge([
        'timestamp' => Canbon::now(),
    ]);
}
```
## 在`request`檔案拿取路由參數(`route parameter`)
```php
# web.php, 這裡文章的路由參數取名叫post_id
Route::('post/{post_id}', 'PostController');
# SomeThingRequest.php 而在request檔案就必須要用路由參數的名稱取值
$postId = $this->route('post_id');
```
