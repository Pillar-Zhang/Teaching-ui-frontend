[toc]

# 操纵 DOM

## 解析 HTML 生成 DOM

向 `jQuery()` 传入一个字符串，如果该字符串以 `<tag ... >` 开头，则开头到最后一个 `>` 的部分则会被当作 HTML 解析。解析的结果是一个 jQuery 对象。

传给操纵方法（如 `.append()`）的参数如果是字符串，也会被当做 HTML 解析。

若要显式的将字符串解析为 HTML，调用 `$.parseHTML()`（jQuery 1.8+）。

```js
$( "<b>hello</b>" ).appendTo( "body" );

// bye 会被忽略
$( "<b>hello</b>bye" ).appendTo( "body" );

// 语法错误！bye<b>hello</b>不可识别
$( "bye<b>hello</b>" ).appendTo( "body" );

// Appends bye<b>hello</b>:
$( $.parseHTML( "bye<b>hello</b>" ) ).appendTo( "body" );

// Appends <b>hello</b>wait<b>bye</b>:
$( "<b>hello</b>wait<b>bye</b>" ).appendTo( "body" );
```

向 `jQuery()` 传入一个字符串后，还可以传入第二个参数，它是一个对象，用于设置生成元素的 attribute：

```js
var e = $("<a>", { href: "#", class: "a-class another-class", title: "..." });
```