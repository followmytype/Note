# `jQuery`筆記
## 選取規則
純`tag`
```javascript
$('tag')
```
用`class`
```javascript
$('.tag_class')
```
用`id`
```javascript
$('#tag_id')
```
用標籤內的屬性去做選取，譬如`<tag att=test></tag>`
```javascript
$('tag[att=test]')
```
用標籤的狀態來選取
```javascript
$('input[type=checkbox]:checked')
```

## `AJAX`
```javascript
var form = $('form') // 選取你要做的表單
// 當表單要送出時做的行為
form.submit(function (e) {
    e.preventDefault(); // 取消預設動作，（表單送出）
    // 使用AJAX方法
    $.ajax({
        // 選擇要用的請求方法
        method: 'post',
        // 要發送位置
        url: 'ajax.php',
        // 要送的資料
        data: {
            name: $('input[name=name]').val(),
            password: $('input[name=password]').val()
        }
    }).success(function (data) { // 當成功時要做的行為
        console.log(data);
    }).fail(function (data) { // 處理失敗要做的行為
        console.log(data.status)
        console.log(data.statusText)
    }).always(function () { // 當ajax做完時總會做的行為
        console.log('always do.')
    });
})
```

## 補充
同一個步道：同步  
不同個步道：非同步
```javascript
$('input[type=radio]').is(":checked")
```
更改`check`狀態
```javascript
$('input[type=radio]').prop('checked', false);
```
