[toc]

## 7 文本节点

### 7.1 概述

文本节点的构造器是 `Text()`。

```js
	<p>hi</p>

	// select 'hi' text node
	var textHi = document.querySelector('p').firstChild
	console.log(textHi.constructor); //logs Text()
```

### 7.2 Text 的对象和属性

• textContent
• splitText()
• appendData()
• deleteData()
• insertData()
• replaceData()
• subStringData()
• normalize()
• data
• document.createTextNode()

### 7.3 空白符会创建文本节点

When a DOM is constructed either by the browser or by programmatic means, text nodes are created from whitespace as well as from text characters. After all, whitespace is a character. In the following code, the second paragraph, containing an empty space, has a child text node while the first paragraph does not.

```
	<p id="p1"></p>
    <p id="p2"> </p>
```

This of course means that carriage returns are considered text nodes.

```
    <p id="p1"></p>
    <p id="p2"></p>

    console.log(document.querySelector('#p1').nextSibling) //logs Text
```

### 7.4 创建、插入文本节点

It’s also possible to programmatically create Text nodes using `createTextNode()`.

```JS
var textNode = document.createTextNode('Hi');
document.querySelector('div').appendChild(textNode);
console.log(document.querySelector('div').innerText); // logs Hi
```

### 7.5 利用 `.data` 或 `nodeValue` 获取文本节点的值

利用 `.data` 或 `nodeValue` 获取文本节点的值。

### 7.6 Manipulating Text Nodes with appendData(), deleteData(), insertData(), replaceData(), and subStringData()

The `CharacterData` object from which Text nodes inherit methods provides the following methods for manipulating and extracting subvalues from Text node values:

• appendData()
• deleteData()
• insertData()
• replaceData()
• subStringData()

```js
var pElementText = document.querySelector('p').firstChild;
//add !
pElementText.appendData('!');
console.log(pElementText.data);
//remove first 'Blue'
pElementText.deleteData(7, 5);
console.log(pElementText.data);
//insert it back 'Blue'
pElementText.insertData(7, 'Blue ');
console.log(pElementText.data);
//replace first 'Blue' with 'Bunny'
pElementText.replaceData(7, 5, 'Bunny ');
console.log(pElementText.data);
//extract substring 'Blue Bunny'
console.log(pElementText.substringData(7, 10));
```

### 7.7 相邻文本节点

一般来说，相邻的文本节点不会出血，因为浏览器创建的DOM树会智能合并文本节点。However, two cases exist that make sibling text nodes possible. The first case is rather obvious. If a text node contains an Element node (e.g., `<p>Hi, <strong>cody</strong> welcome!</p>`).

### 7.8 利用 `textContent` 删除标记、返回所有文本节点

`textContent` 可用于获取所有子文本节点，或用于将节点内容设为特定文本节点。When it’s used on a node to get the textual content of the node, it will return a concatenated string of all text nodes contained with the node on which you call the method. This functionality makes it very easy to extract all text nodes from an HTML document.

```js
console.log(document.body.textContent);
```

`textContent` returns null if used on a document or doctype node.

`textContent` returns the contents from `<script>` and `<style>` elements.

### 7.9 `textContent` 和 `innerText` 的区别

多数现代浏览器（ Firefox 除外），支持一个类似于 `textContent` 的属性，称为 `innerText`。但二者有区别：

- `innerText` is aware of CSS. So, if you have hidden text, innerText ignores this text, whereas `textContent` does not.
- Because `innerText` cares about CSS, it will trigger a reflow, whereas `textContent` will not.
- `innerText` ignores the Text nodes contained in `<script>` and `<style>` elements.
- `innerText`, unlike `textContent`, will normalize the text that is returned. Just think of `textContent` as returning exactly what is in the document, with the markup removed. This will include whitespace, line breaks, and carriage returns.
- `innerText` is considered to be nonstandard and browser-specific while `textContent` is implemented from the DOM specifications.

### （未）7.10 Using `normalize()` to Combine Sibling Text Nodes into One Text Node

### （未）7.11 Using `splitText()` to Split a Text Node




