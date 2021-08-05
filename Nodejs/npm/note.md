# `npm`筆記
## 套件安裝
當拿到一個`node`專案時，需要先安裝他所需要的套件
```bash
npm install
# 預設會連開發套件一併下載，如果不要安裝開發套件就要加額外參數
npm install --only=prod
# or
npm install --only=production
```
## 安裝指定套件
```bash
npm install {package}
# or
npm i {package}
```
在`npm v5.0,0`之前安套件要加個`--save`
```bash
npm install {package} --save
# or
npm i {package} --save
```
## 安裝開發套件
有些套件在開發階段會用到，但是產品階段用不到，譬如說寫測試的套件，而這些套件可以在安裝的時候做分類
```bash
npm install {package} -D
# or
npm i {package} -D
# or
npm install {package} --save-dev
# or
npm i {package} --save-dev
```
`package.json`都會紀錄相關資訊
```json
{
    ...
    // 依賴套件
    "dependencies": {
        "package1": "v1.0"
    },
    // 開發時需要用到的套件
    "devDependencies": {
        "package2": "v2.0"
    }
}
```