[toc]

# jQuery 对象

一个 jQuery 对象是对一组 DOM 元素的封装。“一组”而不是“一个” 使得 jQuery 可以执行批量操作，并且对“空”免疫。例如，获取文档中所有 `p` 元素，添加一个 class，只需要

```js
$("p").addClass("XXX")
```

不需要任何循环。如果文档中没有任何 p 元素，也不会导致异常。

通过 jQuery 对象的 `length` 属性获取其中的 DOM 元素个数。通过下标访问其中的 DOM 元素。但 jQuery 对象不是数组，只有这两个数组的功能而已。

检查元素是否存在，得判断 `length` 是否不为零：

```js
if ($('#someDiv').length) {
```

## jQuery 对象和 DOM 元素

注意通过下标访问返回的是 DOM 元素而不是 jQuery 对象。例如 `$("p")[0]` 是一个 JavaScript 的 DOM 元素，不是 jQuery 对象。

要把一个 DOM 元素转换为 jQuery 对象，只需要用 `$`（即 `jQuery`）函数包裹。如：

```js
$(docuemnt.body)

$("p").each(function(){ $(this)...})
```

要时刻注意当前操纵的是 jQuery 对象还是 DOM 元素！

jQuery 的 `.each()` 方法，和 jQuery 的事件回调方法中，`this` 是一个 DOM 元素。

## 级联

很多 jQuery 方法返回 jQuery 对象，以实现级联调用的风格。

```js
$( "p" ).css( "color", "red" ).find( ".special" ).css( "color", "green" );
```

如果 jQuery 方法会改变 jQuery 对象中的元素，如 `.filter()` 或 `.find()`，这些方法返回的是新的 jQuery 对象。要返回之前的 jQuery 对象，使用 `.end()` 方法。


