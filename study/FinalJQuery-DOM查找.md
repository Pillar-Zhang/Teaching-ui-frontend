[toc]

# DOM 查询

## 其他

使用多个属性来进行过滤

```js
//在使用许多相类似的有着不同类型的input元素时，
//这种基于精确度的方法很有用
var elements = $('#someid input[type=sometype][value=somevalue]').get();
```

隐藏一个包含了某个值文本的元素：

```js
$("p.value:contains('thetextvalue')").hide();
```

# DOM 游走

## 后代元素

方法：`children()` `find()`

首先明确后代元素的意思是，不包括后代中的文本节点。

`children()` 与 `find()` 的区别是，`children()` 只会向下寻找一级。但 `find()` 会向下寻找多级。

`children()` 和 `find()` 都支持传入一个选择器，用于缩小范围。而且对于 `find()` 选择器是必须传的，如果想获取所有后代，也要传 `'*'`。

选择符上下文的功能由 `find()` 实现，因此下面两种写法等价：

```js
$( "li.item-ii" ).find( "li" )
$( "li", "li.item-ii" )
```

jQuery 1.6 开始，`find()` 还可以用于过滤选择。此时传入一个 jQuery 对象或 DOM 元素，交集被保留。

```js
var allListElements = $( "li" );
$( "li.item-ii" ).find( allListElements );

var item1 = $( "li.item-1" )[ 0 ];
$( "li.item-ii" ).find( item1 ).css( "background-color", "red" );
```

## 向上

方法 ：`parent()` `parents()` `parentsUntil()` `offsetParent()` `closest()`

`parent()` 获取当前对象中所有元素的父母（向上一级）。

`parents()` 返回所有祖先，包括父母；返回元素的顺序从最近的到最远的。若原来的集合中有多个 DOM 元素，结果按这些元素相反的顺序，重复的被移除。

`parent()` 和 `parents()` 都支持传入选择符过滤。

`parentsUntil()` 返回祖先，直到指定的选择符、元素、jQuery 元素指定的祖先（不包括）。如果要过滤，还可以再传入第二个参数：

```js
parentsUntil( [selector/element/jquery ] [, filter ] )
```

若不提供第一个参数，等价于 `.parents()`，即返回所有祖先。

`offsetParent()` 返回最近的定位祖先。

`closest()` 对于集合中的每个元素，获取匹配条件的第一个元素，**从自己开始**测试，然后沿着 DOM 树测试其各个祖先。例如找当前 td 的最近的 table：

```js
$td.closest("table")
```

我们可以传入一个 DOM 元素，作为上下文，规定在它**下面**查找匹配元素。

## 同辈

同辈有三组方法，因为同辈有所有同辈、前面的同辈或后面的同辈三类。

### 后面的

方法：`next()` `nextAll()` `nextUntil()`

`next()` 给出集合中元素的下一个同辈元素。如果传入一个选择符，则获取匹配的、后面的第一个元素。

`nextAll()` 给出后面所有的同辈元素。如果传入选择符，进行过滤。

`nextUntil()` 获取集合中每个元素的所有后续通配，直到（不包括）匹配选择符、DOM 节点或 jQuery 对象的元素。第二个参数可以传入一个过滤器。若不传第一个参数（或没匹配上），结果与 `nextAll()` 相同。

### 前面的

方法：`prev()` `prevAll()` `prevUntil()`

### 所有同辈

方法：`siblings()`

所有同辈，不包括元素自己。支持传入一个选择符过滤。




