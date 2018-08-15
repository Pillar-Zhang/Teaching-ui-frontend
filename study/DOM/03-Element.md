[toc]

## 3 元素节点

### 3.1 HTML*Element 概述

每个元素都有自己的构造器。如 `<a>` 的构造器是 `HTMLAnchorElement()`。

```js
console.log(document.querySelector('a').constructor);
```

其他构造器还有 `HTMLHtmlElement`、 `HTMLParagraphElement`、 `HTMLHeadElement`、 `HTMLHeadingElement` 等等。

### 3.2 HTML*Element 属性与方法

• createElement()
• tagName
• children
• getAttribute()
• setAttribute()
• hasAttribute()
• removeAttribute()
• classList()
• dataset
• attributes

### 3.3 创建元素

通过 `createElement()` 创建元素。传入标签名。

```js
var elementNode = document.createElement('textarea');
document.body.appendChild(elementNode);
console.log(document.querySelector('textarea'));
```

### 3.4 获取元素的标签名

通过 `tagName` 获取元素的标签名。`nodeName` 返回相同的值。二者返回值都是大写的。

```js
console.log(document.querySelector('a').tagName); //logs A
//the nodeName property returns the same value
console.log(document.querySelector('a').nodeName); //logs A
```

### 3.5 获取元素的特性的列表

`attributes` 返回一个 `NamedNodeMap`。其中每个元素是一个 `Attr` 节点。

```js
var atts = document.querySelector('a').attributes;
for(var i=0; i< atts.length; i++) {
	console.log(atts[i].nodeName + '=' + atts[i].nodeValue);
}
```

The array returned from accessing the `attributes` property should be considered live. This means its contents can be changed at any time.

布尔特性（如 `<option selected>foo</option>`）没有值，除非提供值（如 `<option selected="selected">foo</option>`）。

### 3.6 读写、移除元素的特性值

`NamedNodeMap` 提供了 `getNamedItem()`、 `setNamedItem()`、 `removeNamedItem()` 等方法。但不如使用 `getAttribute()`、 `setAttribute()`、 `hasAttribute()`、 `removeAttribute()`。

Use `removeAttribute()` instead of setting the attribute value to `null` or `''` using `setAttribute()`.

Some element attributes are available from element nodes as object properties (i.e., `document.body.id` or `document.body.className`).

### 3.7 元素是否有特定属性

利用 `hasAttribute()`。

This method will return true if the element contains the attribute, even if the attribute has no value.

### 3.8 获取类列表

利用元素节点的 `classList` 属性，我们可以访问类列表（ `DOMTokenList`，类数组 ）。`className` 属性返回的是空格分隔的类列表。

`classList` 只读，但可以通过 `add()`、 `remove()`、 `contains()` 和 `toggle()` 修改。

`classList.contains()` 判断类列表中是否包含给定类。

> IE 9 does not support `classList`. Support will be available in IE 10. Several polyfills are available (such as https://github.com/eligrey/classList.js or https://gist.github.com/1381839).

### 3.12 读写 `data-*` 特性

元素节点的 `dataset` 属性返回一个对象（ `DOMStringMap` ），包含所有 `data-*` 特性。

```
	<div data-foo-foo="foo" data-bar-bar="bar"></div>

	var elm = document.querySelector('div');
    //get
    console.log(elm.dataset.fooFoo); //logs 'foo'
    console.log(elm.dataset.barBar); //logs 'bar'
```

`dataset` 包含 data 特性的驼峰版本。如 `data-foo-foo` 会变成 `fooFoo` 属性。

删除一个 `data-*` 特性，只需要用标准 `delete` 运算符，如 `delete data set.fooFoo`。

`dataset` is not supported in IE 9. A polyfill is available. However, you can always just use `getAttribute('data-foo')`, `removeAttribute('data-foo')`, `setAttribute('data-foo')`, and `hasAttribute('data-foo')`.


