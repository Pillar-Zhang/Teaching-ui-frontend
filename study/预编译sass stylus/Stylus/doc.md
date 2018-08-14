http://stylus-lang.com/

[toc]

比较：https://github.com/stylus/stylus/blob/dev/docs/compare.md

省略大括号，省略分号，

```stylus
body
  font: 12px Helvetica, Arial, sans-serif

a.button
  -webkit-border-radius: 5px
  -moz-border-radius: 5px
  border-radius: 5px
```
  
Keep things DRY

```stylus
border-radius()
  -webkit-border-radius: arguments
  -moz-border-radius: arguments
  border-radius: arguments

body
  font: 12px Helvetica, Arial, sans-serif

a.button
  border-radius(5px)
```
  
How about transparent mixins?

```stylus
border-radius()
  -webkit-border-radius: arguments
  -moz-border-radius: arguments
  border-radius: arguments

body
  font: 12px Helvetica, Arial, sans-serif

a.button
  border-radius: 5px
```
  
Create & Share

```stylus
@import 'vendor'

body
  font: 12px Helvetica, Arial, sans-serif

a.button
  border-radius: 5px
```
  
Even in-language functions!

```stylus
sum(nums...)
  sum = 0
  sum += n for n in nums

sum(1 2 3 4)
// => 10
```

What if it were all optional?

```stylus
fonts = helvetica, arial, sans-serif

body {
  padding: 50px;
  font: 14px/1.4 fonts;
}
```

# Features

* Optional colons
* Optional semi-colons
* Optional commas
* Optional braces
* Variables
* Interpolation
* Mixins
* Arithmetic
* Type coercion
* Dynamic importing
* Conditionals
* Iteration
* Nested selectors
* Parent referencing
* Variable function calls
* Lexical scoping
* Built-in functions (over 60)
* In-language functions
* Optional compression
* Optional image inlining
* Stylus executable
* Robust error reporting
* Single-line and multi-line comments
* CSS literal for those tricky times
* Character escaping
* TextMate bundle
* and more!

# 选择符

http://stylus-lang.com/docs/selectors.html

## 缩进

用缩进替代大括号，

```stylus
body
  color white
```

属性和值之间用冒号分隔是可选的，

```stylus
body
  color: white
```

## 规则集

一组属性应用于多个选择符，可以逗号分隔，

```stylus
textarea, input
  border 1px solid #eee
```

或使用换行，

```stylus
textarea
input
  border 1px solid #eee
```

唯一的例外是当选择符看起来像属性时，如 `foo bar baz` 可以是属性也可以是选择符：

```stylus
foo bar baz
> input
  border 1px solid
```  

此时，最好在行尾添加一个逗号，如：

```stylus
foo bar baz,
form input,
> a
  border 1px solid
```

## 父引用

`&` 表示父选择符（们）。如下面的例子中，`textarea` 和 `input` 都会与 `:hover` 组合，

```stylus
textarea
input
  color #A7A7A7
  &:hover
    color #000
```

例子，在 IE 中额外设置 2px 边框，

```stylus
box-shadow()
	-webkit-box-shadow arguments
	-moz-box-shadow arguments
	box-shadow arguments
	html.ie8 &,
	html.ie7 &,
	html.ie6 &
		border 2px solid arguments[length(arguments) - 1]

body
	#login
		box-shadow 1px 1px 3px #eee
```

若需要在选择符中使用 `&`，但不是父引用的意思，需要转义，

```stylus
.foo[title*='\&']
// => .foo[title*='&']
```

## 部分引用

选择符中 `^[N]` 表示部分引用，N 是一个数字。

部分引用于父引用类似。父引用包含整个选择符，而部分引用只包含部分。

`^[0]` 给出第一级选择符，`^[1]` 给出从第二级开始到最后：

```stylus
.foo
  &__bar
    width: 10px

    ^[0]:hover &
      width: 20px
```
  
would be rendered as

```css
.foo__bar {
  width: 10px;
}
.foo:hover .foo__bar {
  width: 20px;
}
```

负值从结尾开始计数，`^[-1]` would give you the last selector from the chain before &:

```stylus
.foo
  &__bar
    &_baz
      width: 10px

      ^[-1]:hover &
        width: 20px
```
    
would be rendered as

```css
.foo__bar_baz {
  width: 10px;
}
.foo__bar:hover .foo__bar_baz {
  width: 20px;
}
```

Negative values are especially helpful for usage inside mixins when you don’t know at what nesting level you’re calling it.

Note that partial reference contain the whole rendered chain of selectors until the given nesting level, not the “part” of the selector.

## 部分引用中的范围

`^[N..M]` 中 N 和 M 都是数字，表示一个部分引用。

If the range would start from the positive value, the result won’t contain the selectors of the previous levels and you’d get the result as if the selectors of those levels were inserted at the root of the stylesheet with the combinators omitted:

```stylus
.foo
  & .bar
    width: 10px

    ^[0]:hover ^[1..-1]
      width: 20px
```

would be rendered as

```css
.foo .bar {
  width: 10px;
}
.foo:hover .bar {
  width: 20px;
}
```

One number in the range would be the start index, the second — the end index. Note that the order of those numbers won’t matter as the selectors would always render from the first levels to the last, so `^[1..-1]` would be equal to the `^[-1..1]`.

When both numbers are equal, the result would be just one raw level of a selector, so you could replace `^[1..-1]` in a previous example to `^[-1..-1]`, and it would be equal to the same last one raw selector, but would be more reliable if used inside mixins.

## 起始引用

选一个选择符开始处的 `~/`，引用第一层嵌套的选择符。等价于 `^[0]`，只是只能用在一个选择符的开始处，

```stylus
.block
  &__element
    ~/:hover &
      color: red
```
  
Would be rendered as

```css
.block:hover .block__element {
  color: #f00;
}
```

## 相对引用

The `../` characters at the start of a selector mark a relative reference, which points to the previous to the `&` compiled selector. You can nest relative reference: `../../` to get deeper levels, but note that it can be used only at the start of the selector.

```stylus
.foo
  .bar
    width: 10px

    &,
    ../ .baz
      height: 10px
```
  
would be rendered as

```css
.foo .bar {
  width: 10px;
}
.foo .bar,
.foo .baz {
  height: 10px;
}
```

Relative references can be considered as shortcuts to the partial references with ranges like `^[0..-(N + 1)]` where the N is the number of relative references used.

## 根引用

The `/` character at the start of a selector is a root reference. It references the root context and this means the selector won’t prepend the parent’s selector to it (unless you would use it with `&`). It is helpful when you need to write some styles both to some nested selector and to another one, not in the current scope.

```stylus
textarea
input
  color #A7A7A7
  &:hover,
  /.is-hovered
    color #000
```
    
Compiles to:

```css
textarea, input {
  color: #a7a7a7;
}
textarea:hover, input:hover, .is-hovered {
  color: #000;
}
```

## selector() bif

You can use the built-in `selector()` to get the current compiled selector. Could be used inside mixins for checks or other clever things.

```stylus
.foo
  selector()
// => '.foo'

.foo
  &:hover
    selector()
// '.foo:hover'
```

This bif could also accept an optional string argument, in this case it would return the compiled selector. Note that it wouldn’t prepend the selector of the current scope in case it don’t have any `&` symbols.

```stylus
.foo
  selector('.bar')
// => '.bar'

.foo
  selector('&:hover')
// '.foo:hover'
```

## Multiple values for selector() bif

selector() bif can accept multiple values or a comma-separated list in order to create a nested selector structure easier.

```stylus
{selector('.a', '.b', '.c, .d')}
  color: red
```
  
would be equal to the

```stylus
.a
  .b
    .c,
    .d
      color: red
```  

and would be rendered as

```css
.a .b .c,
.a .b .d {
  color: #f00;
}
```

## selectors() bif

This bif returns a comma-separated list of nested selectors for the current level:

```stylus
.a
  .b
    &__c
      content: selectors()
```
would be rendered as

```css
.a .b__c {
  content: '.a', '& .b', '&__c';
}
```

## 消除模棱两可

表达式 `margin - n` 可以被解释成一个减法，或属性及一个负值。为消除歧义，表达式外加括号：

```stylus
pad(n)
  margin (- n)

body
  pad(5px)
```

However, this is only true in functions (since functions act both as mixins, or calls with return values).

For example, the following is fine (and yields the same results as above):

```stylus
body
  margin -5px
```
  
Have weird property values that Stylus can’t process? `unquote()` can help you out:

```stylus
filter unquote('progid:DXImageTransform.Microsoft.BasicImage(rotation=1)')
```

Yields:

```css
filter progid:DXImageTransform.Microsoft.BasicImage(rotation=1)
```

# 变量

```stylus
font-size = 14px

body
	font font-size Arial, sans-serif
```

Variables can even consist of an expression list:

```stylus
font-size = 14px
font = font-size "Lucida Grande", Arial

body
  font font, sans-serif
```

标示符（变量名、函数）可以包含 `$` 字符，

```stylus
$font-size = 14px
body {
	font: $font-size sans-serif;
}
```

## 属性查询

引用已定义的属性。

```stylus
#logo
	position: absolute
	top: 50%
	left: 50%
	width: w = 150px
	height: h = 80px
	margin-left: -(w / 2)
	margin-top: -(h / 2)
```
   
实际不必赋值变量 `w` 和 `h`，我们可以用 `@` 加属性名访问属性值，

```stylus
#logo
	position: absolute
	top: 50%
	left: 50%
	width: 150px
	height: 80px
	margin-left: -(@width / 2)
	margin-top: -(@height / 2)
```

Another use-case is conditionally defining properties within mixins based on the existence of others. In the following example, we apply a default `z-index` of 1—but only if `z-index` was not previously specified:

```stylus
position()
	position: arguments
	z-index: 1 unless @z-index

#logo
	z-index: 20
	position: absolute

#logo2
	position: absolute
```
	
Property lookup will “bubble up” the stack until found, or return `null` if the property cannot be resolved. In the following example, `@color` will resolve to blue:

```stylus
body
	color: red
	ul
		li
			color: blue
			a
				background-color: @color
```

# 插值

Stylus supports interpolation by using the `{}` characters to surround an expression, which then becomes part of the identifier. For example, `-webkit-{'border' + '-radius'}` evaluates to `-webkit-border-radius`.

A great example use-case for this is expanding properties with vendor prefixes.

```stylus
vendor(prop, args)
	-webkit-{prop} args
	-moz-{prop} args
	{prop} args

border-radius()
	vendor('border-radius', arguments)

box-shadow()
	vendor('box-shadow', arguments)

button
	border-radius 1px 2px / 3px 4px
```
	
## 选择符插值

Interpolation works with selectors as well. For example, we may iterate to assign the `height` property for the first 5 rows in a table, as shown below:

```stylus
table
	for row in 1 2 3 4 5
		tr:nth-child({row})
			height: 10px * row
```

You may also put together multiple selectors into one variable by building a string and interpolate them in place:

```stylus
mySelectors = '#foo,#bar,.baz'

{mySelectors}
	background: #000
```

# 运算符

## 优先级

Below is the operator precedence table, highest to lowest:
	
	.
	[]
	! ~ + -
	is defined
	** * / %
	+ -
	... ..
	<= >= < >
	in
	== is != is not isnt
	is a
	&& and || or
	?:
	= := ?= += -= *= /= %=
	not
	if unless

## 一元运算符

The following unary operators are available, `!`, `not`, `-`, `+`, and `~`.

```stylus
!0
// => true

!!0
// => false

!1
// => false

!!5px
// => true

-5px
// => -5px

--5px
// => 5px

not true
// => false

not not true
// => true
```

注意 `!` 与 `not` 的优先级不同！The logical `not` operator has low precedence, therefore the following example could be replaced with

```sytlus
a = 0
b = 1

!a and !b
// => false
// parsed as: (!a) and (!b)
```

With:

```stylus
not a or b
// => false
// parsed as: not (a or b)
```

## 二元运算符

### Subscript []

The subscript operator allows us to grab a value inside an expression via index (zero-based). Negative index values starts with the last element in the expression.

```stylus
list = 1 2 3
list[0]
// => 1

list[-1]
// => 3
```

Parenthesized expressions may act as tuples (e.g. (15px 5px), (1 2 3)).

Below is an example that uses tuples for error handling (and showcasing the versatility of this construct):

```stylus
 add(a, b)
   if a is a 'unit' and b is a 'unit'
     a + b
   else
     (error 'a and b must be units!')

 body
   padding add(1,'5')
   // => padding: error "a and b must be units";
   
   padding add(1,'5')[0]
   // => padding: error;
   
   padding add(1,'5')[0] == error
   // => padding: true;

   padding add(1,'5')[1]
   // => padding: "a and b must be units";
```
   
Here’s a more complex example. Now we’re invoking the built-in `error()` function with the return error message, whenever the ident (the first value) equals error.

```stylus
 if (val = add(1,'5'))[0] == error
   error(val[1])	
```

### Range `..` `…`

Both the inclusive (`..`) and exclusive (`...`) range operators are provided, expanding to expressions:

```stylus
 1..5
 // => 1 2 3 4 5

 1...5
 // => 1 2 3 4

 5..1
 // => 5 4 3 2 1
```
 
### Additive: + -

Multiplicative and additive binary operators work as expected. Type conversion is applied within unit type classes, or default to the literal value. For example `5s - 2px` results in `3s`.

```stylus
15px - 5px
// => 10px

5 - 2
// => 3

5in - 50mm
// => 3.031in

5s - 1000ms
// => 4s

20mm + 4in
// => 121.6mm

"foo " + "bar"
// => "foo bar"

"num " + 15
// => "num 15"
```

### Multiplicative: / * %

```stylus
2000ms + (1s * 2)
// => 4000ms

5s / 2
// => 2.5s

4 % 2
// => 0
```

When using `/` within a property value, you must wrap with parens. Otherwise the `/` is taken literally (to support CSS line-height):

```css
font: 14px/1.5;
```

But the following is evaluated as `14px ÷ 1.5`:

```stylus
font: (14px/1.5);
```

This is only required for the `/` operator.

### Exponent: **

The Exponent operator:

```stylus
2 ** 8
// => 256
```

### Equality & Relational: == != >= <= > <

Equality operators can be used to equate units, colors, strings, and even identifiers. This is a powerful concept, as even arbitrary identifiers (such as as `wahoo`) can be utilized as atoms. A function could return `yes` or `no` instead of `true` or `false` (although not advised).

```stylus
5 == 5
// => true

10 > 5
// => true

#fff == #fff
// => true

true == false
// => false

wahoo == yay
// => false

wahoo == wahoo
// => true

"test" == "test"
// => true

true is true
// => true

'hey' is not 'bye'
// => true

'hey' isnt 'bye'
// => true

(foo bar) == (foo bar)
// => true

(1 2 3) == (1 2 3)
// => true

(1 2 3) == (1 1 3)
// => false
```

Only exact values match. For example, `0 == false` and `null == false` are both `false`.

Aliases:

	==    is
	!=    is not
	!=    isnt

### Truthfulness

Nearly everything within Stylus resolves to true, including units with a suffix. Even `0%`, `0px`, etc. will resolve to true (because it’s common in Stylus for mixins or functions to accept units as valid).

However, `0` itself is false in terms of arithmetic.

Expressions (or “lists”) with a length greater than 1 are considered truthy.

`true` examples:

	0% 
	0px
	1px 
	-1
	-1px
	hey
	'hey'
	(0 0 0)
	('' '')

`false` examples:

	0 
	null
	false
	''

### Logical Operators: `&&` `||` `and` `or`

Logical operators `&&` and `||` are aliased `and` / `or` which apply the same precedence.

```stylus
5 && 3
// => 3

0 || 5
// => 5

0 && 5
// => 0

#fff is a 'rgba' and 15 is a 'unit'
// => true
```


### 存在运算符：`in`

Checks for the existence of the left-hand operand within the right-hand expression.

Simple examples:

```stylus
nums = 1 2 3
1 in nums
// => true

5 in nums
// => false
```

检测标示符的存在性：

```stylus
words = foo bar baz
bar in words
// => true

HEY in words
// => false
```

Works with tuples too:

```stylus
vals = (error 'one') (error 'two')
error in vals
// => false
  
(error 'one') in vals
// => true

(error 'two') in vals
// => true

(error 'something') in vals
// => false
```

Example usage in mixin:

```stylus
pad(types = padding, n = 5px)
	if padding in types
		padding n
	if margin in types
		margin n

body
	pad()

body
	pad(margin)

body
	pad(padding margin, 10px)
```

### Conditional Assignment: `?=` `:=`

The conditional assignment operator `?=` (aliased as `:=`) lets us define variables without clobbering old values (if present). This operator expands to an `is defined` binary operation within a ternary.

For example, the following are equivalent:

```stylus
color := white
color ?= white
color = color is defined ? color : white
```

### Instance Check: is a

Stylus provides a binary operator named `is a` used to type check.

```stylus
15 is a 'unit'
// => true

#fff is a 'rgba'
// => true

15 is a 'rgba'
// => false
```

或者可以使用内建函数 `type()`：

```stylus
type(#fff) == 'rgba'
// => true                                                                            
```

Note: color is the only special-case, evaluating to true when the left-hand operand is an RGBA or HSLA node.

### Variable Definition: `is defined`

This pseudo binary operator does not accept a right-hand operator, and does not evaluate the left. This allows us to check if a variable has a value assigned to it.

```stylus
foo is defined
// => false

foo = 15px
foo is defined
// => true

#fff is defined
// => 'invalid "is defined" check on non-variable #fff'
```

Alternatively, one can use the `lookup(name)` built-in function to do this—or to perform dynamic lookups:

```stylus
name = 'blue'
lookup('light-' + name)
// => null

light-blue = #80e2e9
lookup('light-' + name)
// => #80e2e9
```

未定义的标示符也是真值，如

```stylus
body
  if ohnoes
    padding 5px
```
    
Will yield the following CSS when undefined:

```css
body {
  padding: 5px;
}
```

However this will be safe:

```stylus
body
  if ohnoes is defined
    padding 5px
```
    
## Ternary

The ternary operator works as we would expect in most languages. It’s the only operator with three operands (the condition expression, the truth expression, and the false expression).

```stylus
num = 15
num ? unit(num, 'px') : 20px
// => 15px
```

## Casting

As an terse alternative to the `unit()` built-in function, the syntax `(expr) unit` may be used to force the suffix.

```stylus
body
  n = 5
  foo: (n)em
  foo: (n)%
  foo: (n + 5)%
  foo: (n * 5)px
  foo: unit(n + 5, '%')
  foo: unit(5 + 180 / 2, deg)
```
  
## 颜色操作

Operations on colors provide a terse, expressive way to alter components. For example, we can operate on each RGB:

```stylus
#0e0 + #0e0
// => #0f0
```

调整亮度，增减百分比。提亮，加；变暗，减。

```stylus
#888 + 50%
// => #c3c3c3

#888 - 50%
// => #444
```

调整色相（hue），加减一个度数。For example, adding 50deg to this red value results in a yellow:

```stylus
#f00 + 50deg
// => #ffd500
```

Values clamp appropriately. For example, we can “spin” the hue 180 degrees, and if the current value is 320deg, it will resolve to 140deg.

We may also tweak several values at once (including the alpha) by using `rgb()`, `rgba()`, `hsl()`, or `hsla()`:

```stylus
#f00 - rgba(100,0,0,0.5)
// => rgba(155,0,0,0.5)
```

## Sprintf

The string sprintf-like operator `%` can be used to generate a literal value, internally passing arguments through the `s()` built-in:

```stylus
'X::Microsoft::Crap(%s)' % #fc0
// => X::Microsoft::Crap(#fc0)
```

Multiple values should be parenthesized:

```stylus
'-webkit-gradient(%s, %s, %s)' % (linear (0 0) (0 100%))
// => -webkit-gradient(linear, 0 0, 0 100%)
```

# MIXINS

Both mixins and functions are defined in the same manner, but they are applied in different ways.

For example, we have a `border-radius(n)` function defined below, which is invoked as a mixin (i.e., invoked as a statement, rather than part of an expression).

When `border-radius()` is invoked within a selector, the properties are expanded and copied into the selector.

```stylus
border-radius(n)
  -webkit-border-radius n
  -moz-border-radius n
  border-radius n

form input[type=button]
  border-radius(5px)
```
  
Compiles to:

```css
form input[type=button] {
  -webkit-border-radius: 5px;
  -moz-border-radius: 5px;
  border-radius: 5px;
}
```

使用 mixins 时可以省略括号。

```stylus
border-radius(n)
  -webkit-border-radius n
  -moz-border-radius n
  border-radius n

form input[type=button]
  border-radius 5px
```

注意 mixin 中的 `border-radius` 被当做一个属性，而不是递归的函数调用。

To take this further, we can utilize the automatic `arguments` local variable, containing the expression passed, allowing multiple values to be passed:

```stylus
border-radius()
  -webkit-border-radius arguments
  -moz-border-radius arguments
  border-radius arguments
```

Now we can pass values like `border-radius 1px 2px / 3px 4px`!

Another great use of this is the addition of transparent support for vendor-specifics—such as opacity support for IE:

```stylus
support-for-ie ?= true

opacity(n)
	opacity n
	if support-for-ie
		filter unquote('progid:DXImageTransform.Microsoft.Alpha(Opacity=' + round(n * 100) + ')')

#logo
	&:hover
		opacity 0.5
```

## Parent References

Mixins may utilize the parent reference character `&`, acting on the parent instead of further nesting.

For example, let’s say we want to create a `stripe(even, odd)` mixin for striping table rows. We provide both even and odd with default color values, and assign the `background-color` property on the row. Nested within the `tr` we use `&` to reference the `tr`, providing the even color.

```stylus
stripe(even = #fff, odd = #eee)
	tr
		background-color odd
		&.even
		&:nth-child(even)
			background-color even
```

We may then utilize the mixin as shown below:

```stylus
table
	stripe()
	td
		padding 4px 10px

table#users
	stripe(#303030, #494848)
	td
		color white
```
	
Alternatively, `stripe()` could be defined without parent references:

```stylus
stripe(even = #fff, odd = #eee)
	tr
		background-color odd
	tr.even
	tr:nth-child(even)
		background-color even
```
	
If we wished, we could invoke `stripe()` as if it were a property:

```stylus
stripe #fff #000
```

## Block mixins

You can pass blocks to mixins by calling mixin with `+` prefix:

```stylus
+foo()
	width: 10px
```
	
The passed block would be available inside the mixin as `block` variable, that then could be used with interpolation:

```stylus
foo()
  .bar
    {block}

+foo()
  width: 10px
```

=>

```stylus
.bar {
	width: 10px;
}
```
   
This feature is in its rough state ATM, but would be enhanced in the future.

## Mixing Mixins in Mixins

Mixins can (of course!) utilize other mixins, building upon their own selectors and properties.

For example, below we create `comma-list()` to inline (via `inline-list()`) and comma-separate an unordered list.

```stylus
 inline-list()
   li
     display inline

 comma-list()
   inline-list()
   li
     &:after
       content ', '
     &:last-child:after
       content ''

 ul
   comma-list()
```
   
Rendering:

```css
ul li:after {
  content: ", ";
}
ul li:last-child:after {
  content: "";
}
ul li {
  display: inline;
}
```

# 函数

Stylus features powerful in-language function definitions. Function definitions appear identical to mixins; 但函数可以返回一个值。

## 返回值

Let’s try a trivial example: creating a function that adds two numbers.

```stylus
add(a, b)
	a + b
```
  
We can then use this function in conditions, in property values, etc.

```stylus
body
	padding add(10px, 5)
```

## Argument Defaults

Optional arguments may default to a given expression. With Stylus we may even default arguments to earlier arguments!

For example:

```stylus
add(a, b = a)
	a + b

add(10, 5)
	// => 15
 
add(10)
	// => 20
```
	
Note: Since argument defaults are assignments, we can also use function calls for defaults:

```stylus
add(a, b = unit(a, px))
	a + b
```

## 命名实参

Functions accept named parameters. This frees you from remembering the order of parameters, or simply improves the readability of your code.

For example:

```stylus
subtract(a, b)
  a - b
  
subtract(b: 10, a: 25)
```

## Function Bodies

We can take our simple `add()` function further. Let’s casting all units passed as px via the `unit()` built-in. It reassigns each argument, and provides a unit-type string (or identifier), which ignores unit conversion.

```stylus
 add(a, b = a)
   a = unit(a, px)
   b = unit(b, px)
   a + b

 add(15%, 10deg)
 // => 25
```
 
## 多个返回值

Stylus functions can return several values—just as you can assign several values to a variable.

For example, the following is a valid assignment:

```stylus
sizes = 15px 10px
 
sizes[0]
// => 15px 
```
   
Similarly, we may return several values:

```stylus
sizes()
	15px 10px

sizes()[0]
// => 15px
```

One slight exception is when return values are identifiers. For example, the following looks like a property assignment to Stylus (since no operators are present):

```stylus
swap(a, b)
	b a
```
	
To disambiguate, we can either wrap with parentheses, or use the `return` keyword:

```stylus
swap(a, b)
	(b a)

swap(a, b)
	return b a
```

## 条件

Let’s say we want to create a function named `stringish()` to determine whether the argument can be transformed to a string. We check if `val` is a string, or an ident (which is string-like). Because undefined identifiers yield themselves as the value, we may compare them to themselves as shown below (where `yes` and `no` are used in place of true and false):

```stylus
stringish(val)
	if val is a 'string' or val is a 'ident'
		yes
	else
		no
```
	
Usage:

```stylus
stringish('yay') == yes
// => true

stringish(yay) == yes
// => true

stringish(0) == no
// => true
```

note: `yes` and `no` are not boolean literals. They are simply undefined identifiers in this case.

Another example:

```stylus
compare(a, b)
  if a > b
    higher
  else if a < b
    lower
  else
    equal
```

## 别名

To alias a function, simply assign a function’s name to a new identifier. For example, our `add()` function could be aliased as `plus()`, like so:

```stylus
plus = add

plus(1, 2)
// => 3
```

## Variable Functions

In the same way that we can “alias” a function, we can pass a function as well. Here, our `invoke()` function accepts a function, so we can pass it `add()` or `sub()`.

```stylus
add(a, b)
  a + b

sub(a, b)
  a - b

invoke(a, b, fn)
  fn(a, b)

body
  padding invoke(5, 10, add)
  padding invoke(5, 10, sub)
```

## 匿名函数

You can use anonymous functions where needed using `@(){}` syntax. Here is how you could use it to create a custom `sort()` function:

```stylus
sort(list, fn = null)
  // default sort function
  if fn == null
    fn = @(a, b) {
      a > b
    }

  // bubble sort
  for $i in 1..length(list) - 1
    for $j in 0..$i - 1
      if fn(list[$j], list[$i])
        $temp = list[$i]
        list[$i] = list[$j]
        list[$j] = $temp
  return list

  sort('e' 'c' 'f' 'a' 'b' 'd')
  // => 'a' 'b' 'c' 'd' 'e' 'f'

  sort(5 3 6 1 2 4, @(a, b){
    a < b
  })
  // => 6 5 4 3 2 1
```

## arguments

The `arguments` local is available to all function bodies, and contains all the arguments passed.

For example:

```stylus
 sum()
   n = 0
   for num in arguments
     n = n + num

 sum(1,2,3,4,5)
 // => 15
```
 
## Hash Example

Below we define the `get(hash, key)` function, which returns the value of key (or null). We iterate each pair in hash, returning the pair’s second node when the first (the key) matches.

```stylus
get(hash, key)
	return pair[1] if pair[0] == key for pair in hash
```
	
As demonstrated below, in-language functions—paired with robust Stylus expressions—can provide great flexibility:

```stylus
hash = (one 1) (two 2) (three 3)
  
get(hash, two)
// => 2

get(hash, three)
// => 3

get(hash, something)
// => null
```

# KEYWORD ARGUMENTS

Stylus supports keyword arguments, or “kwargs”. These allow you to reference arguments by their associated parameter name.

The examples shown below are functionally equivalent. However, we can place keyword arguments anywhere within the list. The remaining arguments that are not keyed will be applied to the parameters that have not been satisfied.

```stylus
  body {
    color: rgba(255, 200, 100, 0.5);
    color: rgba(red: 255, green: 200, blue: 100, alpha: 0.5);
    color: rgba(alpha: 0.5, blue: 100, red: 255, 200);
    color: rgba(alpha: 0.5, blue: 100, 255, 200);
  }
```

To see what parameters a function or mixin accept, use the `p()` function:

```stylus
p(rgba)
```

Yielding:

```
inspect: rgba(red, green, blue, alpha)
```

# 内建函数

## `red(color[, value])`

读写颜色的红色部分。

```stylus
 red(#c00)
 // => 204

 red(#000, 255)
 // => #f00
```
 
## `green(color[, value])`

读写颜色的绿色部分。

```stylus
 green(#0c0)
 // => 204

 green(#000, 255)
 // => #0f0
```
 
## `blue(color[, value])`

读写颜色的蓝色部分。

```stylus
 blue(#00c)
 // => 204

 blue(#000, 255)
 // => #00f
```
 
## `alpha(color[, value])`

读写颜色的alpha值。

```stylus
  alpha(#fff)
  // => 1

  alpha(rgba(0,0,0,0.3))
  // => 0.3

  alpha(#fff, 0.5)
  // => rgba(255,255,255,0.5)
```
  
## `dark(color)`

Check if color is dark:

```stylus
  dark(black)
  // => true

  dark(#005716)
  // => true

  dark(white)
  // => false
```
 
## `light(color)`

Check if color is light:

```stylus
light(black)
// => false

light(white)
// => true

light(#00FF40)
// => true
```

## `hue(color[, value])`

读写颜色的色调，

```stylus
hue(hsl(50deg, 100%, 80%))
// => 50deg

hue(#00c, 90deg)
// => #6c0
```

## `saturation(color[, value])`

读写颜色的饱和度，

```stylus
saturation(hsl(50deg, 100%, 80%))
// => 100%

saturation(#00c, 50%)
// => #339
```

## `lightness(color[, value])`

读写颜色的亮度，

```stylus
lightness(hsl(50deg, 100%, 80%))
// => 80%

lightness(#00c, 80%)
// => #99f
```

## `push(expr, args…)`

Push the given args to expr.

```stylus
nums = 1 2
push(nums, 3, 4, 5)

nums
// => 1 2 3 4 5
```

Aliased as `append()`

## `pop(expr)`

Pop a value from expr.

```stylus
nums = 4 5 3 2 1
num = pop(nums)

nums
// => 4 5 3 2
num
// => 1
```

## `shift(expr)`

移除 `expr` 的第一项，

```stylus
nums = 4 5 3 2 1
num = shift(nums)

nums
// => 5 3 2 1
num
// => 4
``` 
## `unshift(expr, args…)`

Unshift the given args to expr.

```stylus
nums = 4 5
unshift(nums, 3, 2, 1)

nums
// => 1 2 3 4 5
```

Aliased as `prepend()`

## `index(list, value)`

Returns the index (zero-based) of a value within a list.

```stylus
list = 1 2 3

index(list, 2)
// => 1

index(1px solid red, red)
// => 2
```

## `keys(pairs)`

Return keys in the given pairs:

```stylus
pairs = (one 1) (two 2) (three 3)
keys(pairs)
// => one two three
```

## `values(pairs)`

Return values in the given pairs:

```stylus
pairs = (one 1) (two 2) (three 3)
values(pairs)
// => 1 2 3
```

## `list-separator(list)`

Return the separator of the given list.

```stylus
list1 = a b c
list-separator(list1)
// => ' '

list2 = a, b, c
list-separator(list2)
// => ','
```

## `typeof(node)`

Return type of node as a string.

```stylus
type(12)
// => 'unit'

typeof(12)
// => 'unit'

typeof(#fff)
// => 'rgba'

type-of(#fff)
// => 'rgba'
```

Aliased as `type-of` and `type`.

## `unit(unit[, type])`

Return a string for the type of unit or an empty string, or assign the given type without unit conversion.

```stylus
unit(10)
// => ''

unit(15in)
// => 'in'

unit(15%, 'px')
// => 15px

unit(15%, px)
// => 15px
```

## `percentage(num)`

Convert a num to a percentage.

```stylus
percentage(.5)
// => 50%

percentage(4 / 100)
// => 4%
```

## `abs(unit)`

```stylus
abs(-5px)
// => 5px

abs(5px)
// => 5px
```

## `ceil(unit)`

```stylus
ceil(5.5in)
// => 6in
```

## `floor(unit)`

```stylus
floor(5.6px)
// => 5px
```

## `round(unit)`

```stylus
round(5.5px)
// => 6px

round(5.4px)
// => 5px
```

Note: All rounding functions can accept optional precision argument — you can pass the number of digits you want to save after the period:

```stylus
ceil(5.52px,1)
// => 5.6px

floor(5.57px,1)
// => 5.5px

round(5.52px,1)
// => 5.5px
```

## `sin(angle)`

Returns the value of sine for the given angle. If the angle is given as a degree unit, like 45deg, it is treated as a degree, otherwise it is treated as radians.

```stylus
sin(30deg)
// => 0.5

sin(3*PI/4)
// => 0.707106781
```

## `cos(angle)`

Returns the value of cosine for the given angle. If the angle is given as a degree unit, like 45deg, it is treated as a degree, otherwise it is treated as radians.

```stylus
cos(180deg)
// => -1
```

## `tan(angle)`

Returns the value of tangent for the given angle. If the angle is given as a degree unit, like 45deg, it is treated as a degree, otherwise it is treated as radians.

```stylus
tan(45deg)
// => 1

tan(90deg)
// => Infinity
```

## `min(a, b)`

```stylus
min(1, 5)
// => 1
```

## `max(a, b)`

```stylus
max(1, 5)
// => 5
```

## `even(unit)`

```stylus
even(6px)
// => true
```

## `odd(unit)`

```stylus
odd(5mm)
// => true
```

## `sum(nums)`

```stylus
sum(1 2 3)
// => 6
```

## `avg(nums)`

```stylus
avg(1 2 3)
// => 2
```

## `range(start, stop[, step])`

Returns a list of units from start to stop (included) by given step. If step argument is omitted, it defaults to 1. The step must not be zero.

```stylus
range(1, 6)
// equals to `1..6`
// 1 2 3 4 5 6

range(1, 6, 2)
// 1 3 5

range(-6, -1, 2)
// -6 -4 -2

range(1px, 3px, 0.5px)
// 1px 1.5px 2px 2.5px 3px
```

It is most often used in for loops:

```stylus
for i in range(10px, 50px, 10)
  .col-{i}
    width: i
```
    
## `base-convert(num, base, width)`

Returns a Literal num converted to the provided base, padded to width with zeroes (default width is `2`)

```stylus
base-convert(1, 10, 3)
// => 001

base-convert(14, 16, 1)
// => e

base-convert(42, 2)
// => 101010
```

## `match(pattern, string[, flags])`

Retrieves the matches when matching a `val(string)` against a `pattern(regular expression)`.

```stylus
match('^(height|width)?([<>=]{1,})(.*)', 'height>=1024px')
// => 'height>=1024px' 'height' '>=' '1024px'

match('^foo(?:bar)?', 'foo')
// => 'foo'

match('^foo(?:bar)?', 'foobar')
// => 'foobar'

match('^foo(?:bar)?', 'bar')
// => null

match('ain', 'The rain in SPAIN stays mainly in the plain')
// => 'ain'

match('ain', 'The rain in SPAIN stays mainly in the plain', g)
// => 'ain' 'ain' 'ain'

match('ain', 'The rain in SPAIN stays mainly in the plain', 'gi')
// => 'ain' 'AIN' 'ain' 'ain'
```

## `replace(pattern, replacement, val)`

Returns string with all matches of pattern replaced by replacement in given val

```stylus
replace(i, e, 'griin')
// => 'green'

replace(i, e, griin)
// => #008000
```

## `join(delim, vals…)`

Join the given vals with delim.

```stylus
join(' ', 1 2 3)
// => "1 2 3"

join(',', 1 2 3)
// => "1,2,3"

join(', ', foo bar baz)
// => "foo, bar, baz"

join(', ', foo, bar, baz)
// => "foo, bar, baz"

join(', ', 1 2, 3 4, 5 6)
// => "1 2, 3 4, 5 6"
```

## `split(delim, val)`

The `split()` method splits a string/ident into an array of strings by separating the string into substrings.

```stylus
split(_, bar1_bar2_bar3)
// => bar1 bar2 bar3

split(_, 'bar1_bar2_bar3')
// => 'bar1' 'bar2' 'bar3'
```

## `substr(val, start, length)`

The `substr()` method returns the characters in a string beginning at the specified location through the specified number of characters.

```stylus
substr(ident, 1, 2)
// => de

substr('string', 1, 2)
// => 'tr'

val = dredd
substr(substr(val, 1), 0, 3)
// => #f00
```

## `slice(val, start[, end])`

The `slice()` method extracts a section of a string/list and returns a new string/list.

```stylus
slice(‘lorem’ ‘ipsum’ ‘dolor’, 1, 2)
slice(‘lorem’ ‘ipsum’ ‘dolor’, 1, -1)
// => ‘ipsum’

slice(‘lorem ipsum’, 1, 5) // => ‘orem’ slice(rredd, 1, -1) // => #f00

slice(1px solid black, 1) // => solid #000
```

## `hsla(color | h,s,l,a)`

Convert the given color to an HSLA node, or h,s,l,a component values.

```stylus
hsla(10deg, 50%, 30%, 0.5)
// => HSLA

hsla(#ffcc00)
// => HSLA
```

## `hsl(color | h,s,l)`

Convert the given color to an HSLA node, or h,s,l,a component values.

```stylus
hsl(10, 50, 30)
// => HSLA

hsl(#ffcc00)
// => HSLA
```

## `rgba(color | r,g,b,a)`

Return RGBA from the r,g,b,a channels or provide a color to tweak the alpha.

```stylus
rgba(255,0,0,0.5)
// => rgba(255,0,0,0.5)

rgba(255,0,0,1)
// => #ff0000

rgba(#ffcc00, 0.5)
// rgba(255,204,0,0.5)
```

Alternatively stylus supports the `#rgba` and `#rrggbbaa` notations as well:

```stylus
#fc08
// => rgba(255,204,0,0.5)

#ffcc00ee
// => rgba(255,204,0,0.9)
```

## `rgb(color | r,g,b)`

Return a RGBA from the r,g,b channels or cast to an RGBA node.

```stylus
rgb(255,204,0)
// => #ffcc00

rgb(#fff)
// => #fff
```

## `blend(top[, bottom])`

Blends the given top color over the bottom one using the normal blending. The bottom argument is optional and is defaulted to #fff.

```stylus
blend(rgba(#FFF, 0.5), #000)
// => #808080

blend(rgba(#FFDE00,.42), #19C261)
// => #7ace38

blend(rgba(lime, 0.5), rgba(red, 0.25))
// => rgba(128,128,0,0.625)
```

## `lighten(color, amount)`

Lighten the given color by amount. This function is unit-sensitive, for example supporting percentages as shown below.

```stylus
lighten(#2c2c2c, 30)
// => #787878

lighten(#2c2c2c, 30%)
// => #393939
```

## `darken(color, amount)`

Darken the given color by amount. This function is unit-sensitive, for example supporting percentages as shown below.

```stylus
darken(#D62828, 30)
// => #551010

darken(#D62828, 30%)
// => #961c1c
```

## `desaturate(color, amount)`

Desaturate the given color by amount.

```stylus
desaturate(#f00, 40%)
// => #c33
```

## `saturate(color, amount)`

Saturate the given color by amount.

```stylus
saturate(#c33, 40%)
// => #f00
```

## complement(color)

Gives the complementary color. Equals to spinning hue to `180deg`.

```stylus
complement(#fd0cc7)
// => #0cfd42
```

## invert(color)

Inverts the color. The red, green, and blue values are inverted, while the opacity is left alone.

```stylus
invert(#d62828)
// => #29d7d7
```

## spin(color, amount)

Spins hue of the given color by amount.

```stylus
spin(#ff0000, 90deg)
// => #80ff00
```

## grayscale(color)

Gives the grayscale equivalent of the given color. Equals to desaturate by 100%.

```stylus
grayscale(#fd0cc7)
// => #0cfd42
```

## mix(color1, color2[, amount])

Mix two colors by a given amount. The amount is optional and is defaulted to 50%.

```stylus
mix(#000, #fff, 30%)
// => #b2b2b2
```

## tint(color, amount)

Mix the given color with white.

```stylus
tint(#fd0cc7,66%)
// => #feaceb
```

## shade(color, amount)

Mix the given color with black.

```stylus
shade(#fd0cc7,66%)
// => #560443
```

## luminosity(color)

Returns the relative luminance of the given color.

```stylus
luminosity(white)
// => 1

luminosity(#000)
// => 0

luminosity(red)
// => 0.2126
```

## contrast(top[, bottom])

Returns the contrast ratio object between top and bottom colors, based on script underlying “contrast ratio” tool by Lea Verou.

The second argument is optional and is defaulted to `#fff`.

The main key in the returned object is ratio, it also have min and max values that are different from the ratio only when the bottom color is transparent. In that case the error also contains an error margin.

```stylus
contrast(#000, #fff).ratio
=> 21
contrast(#000, rgba(#FFF, 0.5))
=> { "ratio": "13.15;", "error": "-7.85", "min": "5.3", "max": "21" }
```

## transparentify(top[, bottom, alpha])

Returns the transparent version of the given top color, as if it was blend over the given bottom color (or the closest to it, if it is possible).

The second argument is optional and is defaulted to #fff.

The third argument is optional and overrides the autodetected alpha.

```stylu
transparentify(#808080)
=> rgba(0,0,0,0.5)

transparentify(#414141, #000)
=> rgba(255,255,255,0.25)

transparentify(#91974C, #F34949, 0.5)
=> rgba(47,229,79,0.5)
```

## unquote(str | ident)

Unquote the given str and returned as a Literal node.

```stylus
unquote("sans-serif")
// => sans-serif

unquote(sans-serif)
// => sans-serif

unquote('1px / 2px')
// => 1px / 2px
```

## convert(str)

Like `unquote()` but tries to convert the given str to a Stylus node.

```stylus
unit = convert('40px')
typeof(unit)
// => 'unit'

color = convert('#fff')
typeof(color)
// => 'rgba'

foo = convert('foo')
typeof(foo)
// => 'ident'
```

## s(fmt, …)

The `s()` function is similar to `unquote()`, in that it returns a Literal node, however it accepts a format string much like C’s `sprintf()`. Currently the only specifier is `%s`.

```stylus
s('bar()');
// => bar()

s('bar(%s)', 'baz');
// => bar("baz")

s('bar(%s)', baz);
// => bar(baz)

s('bar(%s)', 15px);
// => bar(15px)

s('rgba(%s, %s, %s, 0.5)', 255, 100, 50);
// => rgba(255, 100, 50, 0.5)

s('bar(%Z)', 15px);
// => bar(%Z)

s('bar(%s, %s)', 15px);
// => bar(15px, null)
```    

Check out the `%` string operator for equivalent behaviour.

## basename(path[, ext])

Returns the basename of path, (optionally) with ext extension removed.

```stylus
basename('images/foo.png')
// => "foo.png"

basename('images/foo.png', '.png')
// => "foo"
```

## dirname(path)

Returns the dirname of path.

```stylus
dirname('images/foo.png')
// => "images"
```

## extname(path)

Returns the filename extension of path including the dot.

```stylus
extname('images/foo.png')
// => ".png"
```

## pathjoin(…)

Peform a path join.

```stylus
pathjoin('images', 'foo.png')
// => "images/foo.png"

path = 'images/foo.png'
ext = extname(path)
pathjoin(dirname(path), basename(path, ext) + _thumb + ext)
// => 'images/foo_thumb.png'
```

## `called-from` property

called-from property contains the list of the functions the current function was called from in the reverse order (the first item is the deepest function).

```stylus
foo()
  bar()

bar()
  baz()

baz()
  return called-from

foo()
// => bar foo
```

## current-media()

`current-media()` function returns the string of the current block’s @media rule or `''` if there is no @media above the block.

```stylus
@media only screen and (min-width: 1024px)
  current-media()
// => '@media (only screen and (min-width: (1024px)))'
```

## `+cache(keys…)`

`+cache` is a really powerful built-in function that allows you to create your own “cachable” mixins.

“Cachable mixin” is the one, that would apply its contents to the given selector on the first call, but would `@extend` the first call’s selector at the second call with the same params.

```stylus
size($width, $height = $width)
  +cache('w' + $width)
    width: $width
  +cache('h' + $height)
    height: $height

.a
  size: 10px 20px
.b
  size: 10px 2em
.c
  size: 1px 2em
```
  
Would yield to

```css
.a,
.b {
  width: 10px;
}
.a {
  height: 20px;
}
.b,
.c {
  height: 2em;
}
.c {
  width: 1px;
}
```

See how the selectors are grouped together by the used property.

## `+prefix-classes(prefix)`

Stylus comes with a block mixin prefix-classes that can be used for prefixing the classes inside any given Stylus’ block. For example:

```stylus
+prefix-classes('foo-')
  .bar
    width: 10px
```    

Yields:

```css
.foo-bar {
  width: 10px;
}
```

## lookup(name)

Allows to lookup a variable with a given name, passed as a string. Returns `null` if the variable is undefined.

Useful when you need to get a value of a variable with dynamically generated name:

```stylus
font-size-1 = 10px
font-size-2 = 20px
font-size-3 = 30px

for i in 1..3
  .text-{i}
    font-size: lookup('font-size-' + i)
```

## define(name, expr[, global])

Allows to create or overwrite a variable with a given name, passed as a string, onto current scope (or global scope if global is true).

This bif can be useful on those cases in which you’d wish interpolation in variable names:

```stylus
prefix = 'border'
border = { color: #000, length: 1px, style: solid }

for prop, val in border
  define(prefix + '-' + prop, val)

body
  border: border-length border-style border-color
```

## operate(op, left, right)

Perform the given `op` on the left and right operands:

```stylus
op = '+'
operate(op, 15, 5)
// => 20
```

## length([expr])

Parenthesized expressions may act as tuples, the `length()` function returns the length of such expressions.

```stylus
length((1 2 3 4))
// => 4

length((1 2))
// => 2

length((1))
// => 1

length(())
// => 0

length(1 2 3)
// => 3

length(1)
// => 1

length()
// => 0
```

## selector()

Returns the compiled current selector or `&` if called at root level.

```stylus
.foo
  selector()
// => '.foo'

.foo
  &:hover
    selector()
// '.foo:hover'
```

## selector-exists(selector)

Returns true if the given selector exists.

```stylus
.foo
  color red

  a
    font-size 12px

selector-exists('.foo') // true
selector-exists('.foo a') // true
selector-exists('.foo li') // false
selector-exists('.bar') // false
```

This method does not take into account the current context meaning:

```stylus
.foo
  color red

  a
    font-size 12px

  selector-exists('a') // false
  selector-exists(selector() + ' a') // true
```
  
## warn(msg)

Warn with the given error msg, does not exit.

```stylus
  warn("oh noes!")
```
  
## error(msg)

Exits with the given error msg.

```stylus
add(a, b)
  unless a is a 'unit' and b is a 'unit'
    error('add() expects units')
  a + b
```
  
## last(expr)

Return the last value in the given expr:

```stylus
nums = 1 2 3
last(nums)
last(1 2 3)
// => 3

list = (one 1) (two 2) (three 3)
last(list)
// => (three 3)
```

## p(expr)

Inspect the given expr:

```stylus
fonts = Arial, sans-serif
p('test')
p(123)
p((1 2 3))
p(fonts)
p(#fff)
p(rgba(0,0,0,0.2))

add(a, b)
	a + b

p(add)
```

stdout:

```
 inspect: "test"
 inspect: 123
 inspect: 1 2 3
 inspect: Arial, sans-serif
 inspect: #fff
 inspect: rgba(0,0,0,0.2)
 inspect: add(a, b)
```

## opposite-position(positions)

Return the opposites of the given positions.

```stylus
opposite-position(right)
// => left

opposite-position(top left)
// => bottom right

opposite-position('top' 'left')
// => bottom right
```

## image-size(path)

Returns the width and height of the image found at path. Lookups are performed in the same manner as @import, altered by the paths setting.

```stylus
  width(img)
    return image-size(img)[0]

  height(img)
    return image-size(img)[1]

  image-size('tux.png')
  // => 405px 250px

  image-size('tux.png')[0] == width('tux.png')
  // => true
```
  
## embedurl(path[, encoding])

Returns an inline image as a `url()` literal, encoded with encoding (available encodings: base64 (default), and utf8).

```stylus
background: embedurl('logo.png')
// => background: url("data:image/png;base64,…")

background: embedurl('logo.svg', 'utf8')
// => background: url("data:image/svg+xml;charset=utf-8,…")
```

## add-property(name, expr)

Adds property name, with the given expr to the closest block.

For example:

  something()
    add-property('bar', 1 2 3)
    s('bar')

  body
    foo: something()
yields:

  body {
    bar: 1 2 3;
    foo: bar;
  }
Next the “magic” current-property local variable comes into play. This variable is automatically available to function bodies, and contains an expression with the current property’s name, and value.

For example if we were to inspect this local variable using p(), we get the following:

    p(current-property)
    // => "foo" (foo __CALL__ bar baz)

    p(current-property[0])
    // => "foo"

    p(current-property[1])
    // => foo __CALL__ bar baz
Using current-property we can take our example a bit further, and duplicate the property with new values, and a conditional to ensure the function is only used within a property value.

    something(n)
      if current-property
        add-property(current-property[0], s('-webkit-something(%s)', n))
        add-property(current-property[0], s('-moz-something(%s)', n))
        s('something(%s)', n)
      else
        error('something() must be used within a property')

    body {
      foo: something(15px) bar;
    }
yields:

    body {
      foo: -webkit-something(15px);
      foo: -moz-something(15px);
      foo: something(15px) bar;
    }
If you noticed in the example above, bar is only present for the initial call, since we returned something(15px), it remained in-place within the expression, however the others do not take the rest of the expression into account.

Our more robust solution below, defines a function named replace() which clones the expression to prevent mutation, replaces the string value of an expression with another, and returns the cloned expression. We then move on to replace __CALL__ within the expressions, which represents the cyclic call to something().

    replace(expr, str, val)
      expr = clone(expr)
      for e, i in expr
        if str == e
          expr[i] = val
      expr

    something(n)
      if current-property
        val = current-property[1]
        webkit = replace(val, '__CALL__', s('-webkit-something(%s)', n))
        moz = replace(val, '__CALL__', s('-moz-something(%s)', n))
        add-property(current-property[0], webkit)
        add-property(current-property[0], moz)
        s('something(%s)', n)
      else
        error('something() must be used within a property')

    body
      foo: something(5px) bar baz
yields:

      body {
        foo: -webkit-something(5px) bar baz;
        foo: -moz-something(5px) bar baz;
        foo: something(5px) bar baz;
      }
Our implementation is now fully transparent both in regards to the property it is called within, and the position of the call. This powerful concept aids in transparent vendor support for function calls, such as gradients.

json(path[, options])
Convert a .json file into stylus variables or an object. Nested variable object keys are joined with a dash (-).

For example, the following sample media-queries.json file:

{
    "small": "screen and (max-width:400px)",
    "tablet": {
        "landscape": "screen and (min-width:600px) and (orientation:landscape)",
        "portrait": "screen and (min-width:600px) and (orientation:portrait)"
    }
}
May be used in the following ways:

json('media-queries.json')

@media small
// => @media screen and (max-width:400px)

@media tablet-landscape
// => @media screen and (min-width:600px) and (orientation:landscape)

vars = json('vars.json', { hash: true })
body
  width: vars.width

vars = json('vars.json', { hash: true, leave-strings: true })
typeof(vars.icon)
// => 'string'

// don't throw an error if the JSON file doesn't exist
optional = json('optional.json', { hash: true, optional: true })
typeof(optional)
// => 'null'
use(path)
You can use any given js-plugin at given path with use() function right inside your ‘.styl’ files, like this:

use("plugins/add.js")

width add(10, 100)
// => width: 110
And the add.js plugin in this case looks this way:

var plugin = function(){
  return function(style){
    style.define('add', function(a, b) {
      return a.operate('+', b);
    });
  };
};
module.exports = plugin;
If you’d like to return any Stylus objects like RGBA, Ident or Unit, you could use the provided Stylus nodes like this:

var plugin = function(){
  return function(style){
    var nodes = this.nodes;
    style.define('something', function() {
      return new nodes.Ident('foobar');
    });
  };
};
module.exports = plugin;
You can pass any options as an optional second argument, using the hash object:

use("plugins/add.js", { foo: bar })
Undefined Functions
Undefined functions will output as literals, so for example we may call rgba-stop(50%, #fff) within our css, and it will output as you would expect. We can use this within helpers as well.

In the example below we simply define the function stop() which returns the literal rgba-stop() call.

stop(pos, rgba)
  rgba-stop(pos, rgba)

stop(50%, orange)
// => rgba-stop(50%, #ffa500)