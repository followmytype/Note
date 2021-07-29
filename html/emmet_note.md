# `EMMET`使用筆記
`EMMET`是一個方便好用的`html`快捷小工具，只要簡短的幾個語句，就能產出完整的`html tag`了。[這裡]有更多更詳細的使用教學，這邊我們來做個簡短的示範：  

當我們在`html`檔輸入：  
>`html:5` 或是 `!`

然後按下`tab`鍵，就會產生底下通用的`html tag`
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    
</body>
</html>
```
## 產生同一層`tag`
如果要產生多組`tag`時，使用 `+` 這個符號
> div+p+h3
```html
<div></div>
<p></p>
<h3></h3>
```

## `tag`裡面再產生`tag`
當我們要產生一連串的`tag`時，就要利用`>`這個符號，如果要產生複數個`tag`的話，就用 `*` 讓他乘以個數，如：  
> `ul>li*3`

一樣按下`tab`：
```html
<ul>
    <li></li>
    <li></li>
    <li></li>
</ul>
```

## 跳回上層
當我們的tag想要回到上層時，使用 `^` 跳出。
> div>h3+p^div>div>span
```html
<div>
    <h3></h3>
    <p></p>
</div>
<div>
    <div><span></span></div>
</div>
```

## 使用括弧
當然我們也能使用括弧去做綁定，這樣打起來也不容易混淆
> (div>ul>li*4)+(div>h3+p)*2
```html
<div>
    <ul>
        <li></li>
        <li></li>
        <li></li>
    </ul>
</div>
<div>
    <h3></h3>
    <p></p>
</div>
<div>
    <h3></h3>
    <p></p>
</div>
```

## `tag`產出帶`class`
產生的`tag`裡，順便帶出`class`名稱，利用 `.` 這個符號，若要多個`class`名稱，就直接加上去，如：  
> `div.hello.hey.hi`
```html
<div class="hello hey hi"></div>
```

## `tag`裡帶出`id`
產生的`tag`裡帶出`id`的話，使用 `#` 這個符號，搭配 `$` 符號可以產出流水號。
> `div#hello$*3`
```html
<div id="hello1"></div>
<div id="hello2"></div>
<div id="hello3"></div>
```

## `tag`裡帶出屬性內容
使用 `[]` 可以直接打出想要的屬性。
> p[title="Hello world" foo="bar"]
```html
<p title="Hello world" foo="bar">
</p>
```
有些常用的`attribute`可以直接用 `:` 來使用。
> form:get>input:text[name="s"]+input:submit
```html
<form action="" method="get">
    <input type="text" name="s" id="">
    <input type="submit" value="">
</form>
```

## `tag`內加上文字
使用 `{}` 可以讓 `tag` 裡夾想要的文字。
> div>p{foo bar foofoo baaaaar}
```html
<div>
    <p>foo bar foofoo baaaaar</p>
</div>
```

[這裡]: https://docs.emmet.io/cheat-sheet/ "Emmet技巧"