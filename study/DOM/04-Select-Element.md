[toc]

## 4. 选择元素节点

### 4.1 选中特定元素节点

选取单个元素节点的常用方法：`querySelector()`、 `getElementById()`。

```js
console.log(document.querySelector('li').textContent);
console.log(document.getElementById('last').textContent);
```

The `querySelector()` method permits a parameter in the form of a CSS selector syntax. Basically, you can pass this method a CSS3 selector (e.g., `#score>tbody>tr>td:nth-of-type(2)`), which it will use to select a single element in the DOM.

`querySelector()` 返回找到的一个节点。

元素节点也有 `querySelector()` 方法，实现在子树中查找。

### 4.2 选择/创建元素列表（ `NodeList` ）

常用方法：`querySelectorAll()`、 `getElementsByTagName()`、 `getElementsByClassName()`。

```js
console.log(document.querySelectorAll('li'));
console.log(document.getElementsByTagName('li'));
console.log(document.getElementsByClassName('liClass'));
```

`NodeList`s created from `getElementsByTagName()` and `getElementsByClassName()` are considered live and will always reflect the state of the document, even if the document is updated after the list is created/selected.

The `querySelectorAll()` method does not return a live list of elements. This means the list created from querySelectorAll() is a snapshot of the document at the time it was created.

`querySelectorAll()`, `getElementsByTagName()`, and `getElementsByClassName()` are also defined on element nodes. This allows the methods to limit their results to a specific vein (or set of veins) of the DOM tree.

Passing either `querySelectorAll()` or `getElementsByTagName()` the string `'*'`, which generally means “all,” will return a list of all elements in the document.

The `NodeList`s are array-like lists/collections and have a read-only `length` property (but they do not inherit array methods).

### 4.3 选择所有直接子元素

Using the `children` property from an element node, we can get a list [an `HTMLCollection`] of all the immediate child nodes that are element nodes.

Notice that using `children` only gives us the immediate element nodes, excluding any nodes (e.g., text nodes) that are not elements. If the element has no children, `children` will return an empty array-like list.

`HTMLCollection`s contain elements in document order; that is, they are placed in the array in the order the elements appear in the DOM.

`HTMLCollection`s are live, which means any change to the document will be reflected dynamically in the collection.

### 4.4 上下文选择

The methods `querySelector()`, `querySelectorAll()`, `getElementsByTagName()`, and `getElementsByClassName()`, typically accessed from the `document` object, are also defined on element nodes.

### 4.5 预定义的选择

- `document.all`：文档中素有元素
- `document.forms`：文档中所有 `<form>` 元素
- `document.images`：文档中所有 `<img>` 元素
- `document.links`：文档中所有 `<a>` 元素
- `document.scripts`：All `<script>` elements in the HTML document
- `document.styleSheets`：All `<link>` or `<style>` elements in the HTML document

These preconfigured arrays are constructed from the `HTMLCollection` interface/object, except for `document.styleSheets`, which uses `StyleSheetList`.

`HTMLCollection` is live, just like `NodeList` [except for `querySelector
All()`].

Oddly, `document.all` is constructed from an `HTMLAllCollection`, not an `HTMLCollection`, and is not supported in Firefox.

### 4.6 Using `matchesSelector()` to Verify That an Element Will Be Selected

利用 `matchesSelector()` 方法判断元素是否匹配特定选择符字符串。例如，判断 `<li>` 是否为 `<ul>` 的第一个元素。

```
// fails in modern browser must use browser prefix moz, webkit, o, and ms
console.log(document.querySelector('li').matchesSelector('li:first-child'));
// logs false
// prefix moz
/* console.log(document.querySelector('li').mozMatchesSelector
('li:first-child')); */
// prefix webkit
/* console.log(document.querySelector('li').webkitMatchesSelector
('li:first-child')); */
// prefix o
/* console.log(document.querySelector('li').oMatchesSelector
('li:first-child')); */
// prefix ms
/* console.log(document.querySelector('li').msMatchesSelector
('li:first-child')); */
```

`matchesSelector()` has not seen much love from the browsers, as its usage is behind that of the browser prefixes `mozMatchesSelector()`, `webkitMatchesSelector()`, `oMatchesSelector()`, and `msMatchesSelector()`.

In the future, `matchesSelector()` will be renamed to `matches()`.

