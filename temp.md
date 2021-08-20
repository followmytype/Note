# 暫時的筆記
javascript
## Object
### 刪除物件內部的值
使用`delete`能刪除指定的屬性
```javascript
var myDog = {
  "name": "Happy Coder",
  "legs": 4,
  "tails": 1,
  "friends": ["freeCodeCamp Campers"],
  "bark": "woof"
};
delete myDog.tails
```