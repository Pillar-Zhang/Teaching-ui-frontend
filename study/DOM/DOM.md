[toc]

# (未）11 DOM 事件

## 11.12 定制事件

例子，创建自定义事件 `goBigBlue`。

```js
var divElement = document.querySelector('div');var cheer = document.createEvent('CustomEvent'); // 必须用 'CustomEvent'
divElement.addEventListener('goBigBlue',function(event) {    console.log(event.detail.goBigBlueIs)},false);

// initCustomEvent 方法的参数是 (event, bubble?, cancelable?, event.detail)cheer.initCustomEvent('goBigBlue', true, false, {goBigBlueIs:'its gone!'});divElement.dispatchEvent(cheer);
```

IE 9 要求 `initCustomEvent()` 的第四个参数必填。

