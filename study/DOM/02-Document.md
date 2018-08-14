[toc]

## 2. Document 节点

### 2.1 document 节点概述

`window.document` 的构造器为 `HTMLDocument`。节点类型为 `DOCUMENT_NODE`。

Both `Document` and `HTMLDocument` constructors are typically instantiated by the browser when you load an HTML document. However, using `document.implementation.createHTMLDocument()`, it’s possible to create your own HTML document outside the one currently loaded in the browser. In addition to `createHTMLDocument()`, it’s possible to create a document object that has yet to be set up as an HTML document using `createDocument()`. An example use of these methods might be to programmatically provide an HTML document to an iframe.

### 2.2 HTMLDocument 属性和方法

- `documentElement`
- `implementation.*`
- `activeElement`
- `body`
- `head`
- `title`
- `lastModified`
- `referrer`
- `URL`
- `defaultview`
- `compatMode`
- `ownerDocument`
- `hasFocus()`

### 2.4 document 子节点

`document` 节点包含一个 `DocumentType` 节点和一个 `Element` 节点。This should not be a surprise, since HTML documents typically contain only one doctype (e.g., `<!DOCTYPE html>`) and one element (e.g., `<html lang="en">`).

```js
console.log(document.childNodes[0].nodeType);
console.log(document.childNodes[1].nodeType);
```

> If a comment node (not discussed in this book) is made outside the `<html lang="en">` element, it will become a child node of the `window.document`. However, having comment nodes outside the `<html>` element can cause some buggy results in IE and is a violation of the
DOM specification.

### 2.5 document 提供的到高层节点的快捷访问

Using the following properties, we can get a shortcut reference to the following nodes:

- `document.doctype` refers to `<!DOCTYPE>`.
- `document.documentElement` refers to `<html lang="en">`.
- `document.head` refers to `<head>`.
- `document.body` refers to `<body>`.

The doctype or DTD is a `nodeType` of `10` or `DOCUMENT_TYPE_NODE` and should not be confused with the `DOCUMENT_NODE` (a.k.a. `window.document` constructed from `HTMLDocument()`). The doctype is constructed from the `DocumentType()` constructor.

In Safari, Chrome, and Opera, the `document.doctype` does not appear in the `document.childNodes` list.

### （未）2.6 Using `document.implementation.hasFeature()` to Detect DOM Specifications/Features

### 2.7 Getting a Reference to the Focus/Active Node in the Document

Using the `document.activeElement`, we can quickly get a reference to the node in the document that is focused/active.

### 2.8 判断文档或文档的节点是否有焦点

Using the `document.hasFocus()` method, it’s possible to know whether the user currently is focused on the window that has the HTML document loaded.

### 2.9 `document.defaultView` Is a Shortcut to the Head/Global Object

`document.defaultView` 指向全局对象（或称头对象），在浏览器中即 `window` 对象。

If you are dealing with a DOM that is headless or a JavaScript environment that is not running in a web browser [i.e., Node.js], this property can get you access to the head object scope.

### 2.10 Using `ownerDocument` to Get a Reference to the Document from an Element

节点的 `ownerDocument` 属性，返回节点所属的文档。




