1,NaN 是 IEEE 754 定义的一个值。它表示非数字，尽管 typeof NaN === 'number'。如果运算中有一个运算数为 NaN，结果为 NaN。使用 isNaN 函数判断一个值是否为数字,请写出下列打印值：

//后面 写答案 
NaN === NaN    
// 
NaN !== NaN    
// 
NaN+123        
//
NaN++"123"      
//
isNaN(NaN)       
// 
isNaN(0)         
// 
isNaN('oops')    
// 
isNaN('0')       
// 

2，要判断一个属性是否存在，可以用 in 运算符，写出下列打印值：

var a = { b: 1, d: null }
"b" in a        
// 
"c" in a        
// 
"d" in d        
// 

3，splice() 用于去除数组中一部分。第一个参数指定开始删除的位置，第二个参数指定删除个数。


const numbers = ['a', 'v', 's', 'd']

numbers.splice(2, 1)
//

4,判断下列是否为假值：

false
//
null
//
undefined
//
"true"
//
“”
//
[]
//
0
//
NaN
//
true
//
"false"
//
{}
//

5,for-in枚举所有对象的属性名，如何判断一个属性名就是该对象的成员，还是从其原型链中得到的？
// 请写出判断的方法 

6，判断下列// 应该填写的值

let obj = {
    a: 1,
    good: function() { console.log(this && this.a) }
}
obj.good() 
//

let g = obj.good
g()
//

7，尝试写出该函数执行后的值：

var add_the_handlers = function (nodes) {
    var i
    for (i = 0; i < nodes.length; i += 1) {
        nodes[i].onclick = function (e) {
            console.log(i)
            }
        }
   }

add_the_handlers([1,2,3,4])
//

8,请写出下列执行后的值

var o = { x: 1 }
"x" in o 
// 
"y" in o 
// 
"toString" in o 
// 

9，如何返回一个数组包含对象的自有属性
//

10，如何返回一个数组包含对象的所有属性，包括不可枚举的属性
//
