[toc]

# 表格

## 通过 CSS 显示为表格

本文主要介绍 `display: table` 和 `display :table-cell`。

CSS table 不是新的东西，它是 CSS2.1 的内容。它的兼容性很强，除了 IE7 及以下版本，其他的浏览器它都可以使用。

你不能够在 table-cell 中再套其他的 table-cell。Float 对 table-cell 无影响。margin 对 table-cell 的元素无影响。

**纵向居中内容**

用 `display：table` 把容器中内容横向纵向居中十分简单。方法是：

```html
<div class="tbl">
    <h1 class="cell">Yes, I'm centered</h1>
<div>
```
```css
.tbl {
    display: table;
    width: 100%;
    table-layout: fixed;
    background-color: hotpink;
    height: 8rem;
}
.cell {
    display: table-cell;
    vertical-align: middle;
    text-align: center;
}
```