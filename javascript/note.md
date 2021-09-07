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
### 凍結物件
凍結物件，可以防止物件被做任何改變
```js
let obj = {
  name:"FreeCodeCamp",
  review:"Awesome"
};
Object.freeze(obj);
obj.review = "bad"; // failed
obj.newProp = "Test"; // failed
console.log(obj); 
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
## `var vs let`
`let`相對嚴謹，`var`能夠重複宣告不會出錯，`let`則不行
```js
var aaa = 'AAA';
var aaa = 'aaa';
console.log(aaa); // aaa

let aaa = 'AAA';
let aaa = 'aaa'; // error
```
`let`會限制在指定區塊
```js
for(var i = 0; i < 3; i++) {
  console.log(i);
}
console.log(i);
// 0, 1, 2, 3

for(let i = 0; i < 3; i++) {
  console.log(i);
}
console.log(i);
// 0, 1, 2, i is undefined
```
## `const`
`const`用來宣告一個不會改變的數
```js
const APPLE = 'apple';
APPLE = 'banana'; // type error
```
但是當const用來宣吿陣列或是物件時，他只是不能再被重新賦予新的數值，但他裡面的元素可以被更換
```js
const ARR = [1, 2, 3];
ARR = [4, 5, 6]; // type error
ARR[0] = 123; // success
```
## 箭頭函數
箭頭函數使用方法
```js
const hello = () {
  return 'hello';
}
console.log(hello()); // hello
// 簡單的回傳可以不用大括弧
const hello = () => 'hello';
console.log(hello()); // hello
// 帶參數，可以多個，也能有預設值
const hello = (greet, name = 'matt') => greet + ' ' + name;
console.log(hello('morning')); // morning matt
// rest操作符，可以帶不固定數量的參數，將args打包一個陣列
const hasMany = (...args) => {
  console.log("There are " + args.length + " arguments.");
}
hasMany(1, 2, 3); // There are 3 arguments.
hasMany(1, 'str', [], {}); // There are 4 arguments.
// spread操作符，跟rest都是...，但是結果完全不一樣，是將陣列拆解成不同個數值
let numbers = [1, 2, 3, 4, 5];
console.log(...numbers) // 1, 2, 3, 4, 5
```
## 解構賦值
能夠用一行簡單寫法直接提取物件內指定的鍵值
```js
const student = {
  name: 'matt',
  age: 18, 
  birthday: '2000-06-12'
}
const {name, age} = student;
console.log(name); // matt
console.log(age); // 18
```
解構出來的值也可以另外給新的名稱，在解構的鍵後用冒號命名新的名稱。以上述的`student`為例
```js
const {name: myName, age: myAge} = student;
console.log(myName); // matt
console.log(myAge); // 18
```
深層解構，一樣也能另外命名
```js
const user = {
  name: 'matt',
  age: 18,
  family: {
    dad: 'daddy',
    mom: 'mommy'
  }
}
const {family} = user;
console.log(family); // {dad: 'daddy', mom: 'mommy'}
const {family:{dad, mom}} = user;
console.log(dad); // daddy
const {family:{dad: myDad, mom: myMom}} = user;
console.log(myMom); // mommy
```