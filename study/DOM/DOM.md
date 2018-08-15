[toc]

# (未）11 DOM 事件

## 11.12 定制事件

例子，创建自定义事件 `goBigBlue`。

```js
var divElement = document.querySelector('div');
divElement.addEventListener('goBigBlue',function(event) {

// initCustomEvent 方法的参数是 (event, bubble?, cancelable?, event.detail)
```

IE 9 要求 `initCustomEvent()` 的第四个参数必填。
