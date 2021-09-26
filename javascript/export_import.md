# `js`導出導入功能
`js`重複函示使用方法：
`html`引入，使用`module`特性的`js`，可以使用`export`和`import`的特性
```html
<script type="module" src="./string.js"></script>
```
例如`string.js`是一個函式庫檔案，要讓外面的程式可以使用內部函示，就需要用到`export`去導出函式，共有兩個方式
1. 直接在要導出的`function`前放上`export`:
    ```js
    // string.js
    export function func1() {
        return 'i am func1';
    }
    ```
2. 或是在檔案尾部宣告要導出的`function`
    ```js
    // string.js
    function func1() {
        return 'i am func1';
    }
    function func2() {
        return 'i am func2';
    }
    export { func1, func2 };
    ```
而其他要用到的`string.js`函式的檔案就需要去導入(`import`)他們。因為剛剛`string.js`導出`func1`, `func2`，這邊就能引入使用
```js
import { func1, func2 } from './string.js';

func1() // i am func1
```
另一個引入方法可以引入全部並且讓他們都存在另一個物件
```js
import * as stringFunModule from './string.js';
stringFunModule.func1(); // i am func1
```
## 默認導出引入
有時一個文件只會導出一個主要的函示，這時就會用到`default`這個特殊字串，這時候給函式有沒有取名都無所謂，因為對其他檔案來說這個檔案只代表一個函式，可以自由命名它
```js
// math.js
export default function add(x, y) {
  return x + y;
}

export default function(x, y) {
  return x + y;
}
```
另一個引入的文件，因為math.js這個文件只會導出一個函數，所以不需要用到大括弧去解構它，甚至可以另外命名被導出的函數名稱
```js
import theAdd from "./math.js";

theAdd(1, 3); // 4
```