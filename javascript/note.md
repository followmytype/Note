# `JavaScript note`

## `Array`
* `pop()` vs `push()`
    * `array.pop()`: 移除並得到陣列最後一個元素
    * `array.push(something)`: 新增元素到陣列最後面
* `shift()` vs `unshift()`
    * `shift()`: 移除並得到陣列第一個元素
    * `unshift()`: 新增元素到陣列最前面
## `Object`
### 刪除物件內部的值
使用`delete`能刪除指定的屬性
```js
var myDog = {
  "name": "Happy Coder",
  "legs": 4,
  "tails": 1,
  "friends": ["freeCodeCamp Campers"],
  "bark": "woof"
};
delete myDog.tails
```
### 檢查屬性是否存在
使用`hasOwnProperty`方法檢查屬性是否存在
```js
var myObj = {
  one: "one one",
  two: "two two"
};
myObj.hasOwnProperty("one");   // true
myObj.hasOwnProperty("three"); // false
```
## `swtich`
用法：
```js
switch(lowercaseLetter) {
  case "a":
    console.log("A");
    break;
  case "b":
  case "c":
    console.log("B");
    break;
  default:
    console.log("default");
}
```
## `String`
數字字串轉成數字，若不行則返回`NaN`。第二個參數是進位設定，代表說要用什麼進位看待第一個參數：
```js
parseInt("007");      // 7
parseInt("10011", 2); // 19
```
## `Math`
隨機小數，只會產生0~1之間的小數，可能有零，但不會有一：
```js
Math.random()
```
向下取整：`Math.floor()` 函式會回傳小於等於所給數字的最大整數。
```js
Math.floor(5.95);  // 5
Math.floor(5.05);  // 5
Math.floor(5);     // 5
Math.floor(-5.05); // -6
```
