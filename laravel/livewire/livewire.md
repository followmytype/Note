# `livewire`筆記
`livewire`是一個製作前端工具，可以用寫`php`的方式去做前端的行為，也能達到`SPA`的效果

## 安裝
使用`composer`
```
composer require livewire/livewire
```
預設的`livewire`是不需要我們進行配置設定的，但是如果有需要的話也可以，要先新增他的配置檔
```
php artisan livewire:publish --config
```

## 使用
在需要用到的頁面加上他的`style`和`script`
```
<head>
    ...
    @livewireStyles
</head>
<body>
    ...
    @livewireScripts
</body>
</html>
```
產生livewire需要使用到的檔案
```
php artisan make:livewire Test\\index
```
這裡會產生兩個檔案
* `CLASS: app/Http/Livewire/Test/Index.php`
* `VIEW:  resources/views/livewire/test/index.blade.php`

`CLASS`的這個檔案裡用來渲染剛產生的`VIEW`，而他裡面的變數可以帶到`VIEW`去，在這邊可以做到驗證、讀取、儲存資料的行為。
```php
namespace App\Http\Livewire\Test;

use Livewire\Component;

class Index extends Component
{
    // 這裡我們增加一個變數
    public $name = 'Testtt';

    public function render()
    {
        return view('livewire.test.index');
    }
}
```
`VIEW`只有一個簡單的`<div>`，他是用來顯示的根`tag`，所以不要刪掉他，裡面可以使用剛剛`CLASS`裡面的變數
```html
<div>
    {{ $name }}
</div>
```
因為這個`VIEW`只是個元件，所以我們在需要用到的`blade`頁面裡去加上他，`laravel`就會自動去引用我們剛剛創建出來的`livewire`元件了
```html
<livewire:test.test/>
```
### 綁定
`livewire`可以使用像是`vue`的`v-model`綁定方法，也就是說在`input`上可以將他的內容值跟我們的`CLASS`的變數做綁定
```html
<div>
    <input type="text" wire:model="name">
    {{ $name }}
</div>
```
表單的送出綁定如下，`submit.prevent`意思是阻擋瀏覽器幫我們送出表單的行為，取而代之的是`mySubmitFun`的方法，而`mySubmitFun`則是在我們的`CLASS`裡定義
```html
<div>
    <form wire:submit.prevent="mySubmitFun">
        <input type="text" wire:model="name">
        <button type="submit">送出</button>
    </form>
    {{ $name }}
</div>
```
```php
// 剛剛上面創建的CLASS檔案
class Index extends Component
{
    public function render() {...}

    public function mySubmitFun() {
        // 處理我們收到的表單資料
    }
}
```
