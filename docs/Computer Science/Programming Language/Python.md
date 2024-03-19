# Python Saves The World

## Basic Note

### 变量的命名

变量名只能包含字母、数字和下划线 “_”，变量名的第一个字符只能是字母或者下划线，变量名对大小写敏感，且不能将关键字 (亦即保留字) 作为变量名。

### 数据类型

**Python中的变量不需要声明数据类型，每个变量在使用之前必须赋值，变量在赋值之后才会被创建。**我们在创建变量的时候不需要考虑变量的类型——这和C不同——变量就是变量，没有类型，而我们所说的“类型”只是变量所指的内存中对象的类型，因为不同的对象 (比如字符串和整数) 需要以不同的方式存储。并且我们可以为多个变量同时赋值，也可以为多个对象指定多个变量。比如下面的例子：

```python
counter = 100          # 整型变量
miles   = 1000.0       # 浮点型变量
name    = "runoob"     # 字符串

a = b = c = 1		   # 为多个变量同时赋值
a, b, c = 1, 2, "Hi"   # 为多个对象指定多个变量
```

Python内置的`type()`函数可以用来查询变量所指的**对象**类型，并且可以使用`isinstance()`来判断：

```python
a, b, c, d =20, 5.5, True, 4+3j
print(type(a), type(b), type(c), type(d))
>>> <class 'int'> <class 'float'> <class 'bool'> <class 'complex'>
print(isinstance(a, int))
>>> True
```

`type()`和`isinstance()`的区别在于：

- `type()`不会认为子类是一种父类类型；
- `isinstance()`会认为子类是一种父类类型。

### 字符串 (string)

#### 对字符串的操作

字符串就是一系列字符，由引号 (可以是单引号或者双引号) 确定，其列表有两种索引方式：从左到右默认从0开始；或者从右向左从-1开始。对于字符串的某些处理和C类似，比如我们可以实现以下操作：

`````` python
str = "Hello"
print(str[0])				#Output:H
print(str[2:4])			    #Output:ll
print(str * 2)				#Output:HelloHello
print(str + " " + "world")	#Output:Hello world
print(str[0:4:2])			#Output:Hl
``````

我们可以发现，字符串的某些处理其实就是对列表的处理。但是值得注意的是，Python没有单独的字符类型，一个字符就是长度为1的字符串，并且Python的字符串不能被改变。

在Python中，我们可以使用**方法**进行对数据的操作，某些方法会改变数据内容 (比如`reverse()`)，某些则不会 (比如下面这些)。对于字符串，利用`lower()`、`upper()`、`title()`、`strip()`、`lstrip()`和`rstrip()`，我们可以去除字符串两侧的空格，并且调整字符的大小写。比如：

``````python
name = "hEllo "
print(name.title())			#Output:Hello 
print(name.upper())			#Output:HELLO 
print(name.lower(),end="")	#Output:hello  (后边没有换行)
print(name.rstrip(),end="@")#Output:hEllo@ 
``````

在Python中，**空白**泛指所有非打印字符，比如空格、列表和换行符。`print()`在打印结束之后会自动换行，但是如果在`print()`函数之后参加`end=""`参数，我们就可以实现不换行效果，事实上Python里`end`参数的默认值为`"\n"`，表明在打印的字符串的末尾自动添加换行符，来设定特定符号，比如上面代码的最后一行将字符串的末尾自动添加了一个`@`。

#### 对字符串的比较



### 数字 (Number)

#### 类型

Python支持**`int`**、**`float`**、**`bool`**、**`complex`**四种类型。整数类型只有一种`int`，表示为长整型。

#### 运算

求模运算符`%`、四则运算符`+ - * /`与取余运算符`%`均和C语言中的相同，只是默认情况下的除法`/`的结果是一个浮点数，而使用运算符`//`就可以得到一个整数。此外，运算符`**`表示乘方。



### 类型转换

以下函数均将接受的参数进行转化并返回。

`str()`函数

`int()`函数将字符串表示的整形数值转化成整型数字。

`float()`函数将字符串表示的浮点数转化成浮点数。

### 列表 (List)

列表由一系列按照特定顺序排列的元素组成，我们用方括号表示列表，并且用逗号分隔其中的元素。列表中的元素可以不相同，甚至可以包含列表 (也就是嵌套)。列表的索引和字符串的索引相同，从`0`开始；或者从尾部开始，最后一个元素的索引为`-1`，往前一位为`-2`，以此类推。

需要注意的是，`sorted()`函数和`sort()`方法 (和排序相关的) 均不能用在字符串和数字混合的列表 (元组和字典) 排序之中。

### 元组 (Tuple)

### 字典 (Dictionary)

#### 声明与基本操作

字典是一系列**键-值对**。每一个键都与值相对应，我们可以用键访问对应的值。值可以是任意数据类型，但是键必须是不可变的数据类型，比如数字或字符串。我们允许创建空字典，可以随时添加、修改或者删除字典内的数据。

```python
dictionary1 = dict()
dictionary1['first'] = "1st"	#添加键-值对
dictionary1['first'] = "111"	#修改值
print(dictionary['first'])		#访问值
del dictionary1['first']		#删除值的同时删除键-值对
dictionary1.clear()				#清空词典
del dictionary1					#删除词典
```

可以发现添加键-值对的语法和修改值的相同。

#### 遍历词典

如果要遍历字典内的键-值对，我们需要先声明两个变量，使用`items()`方法，它返回一个键-值对列表，在遍历每一个键值对的过程之中，会将键和值依次存储到两个变量之中。同理`keys()`方法和`values()`方法分别返回一个存储着键和值的列表，值得注意的是这些列表的元素顺序和其原本的存储顺序不相同，因为Python只关心键与值的对应关系，而不关心存储顺序。

```python
dic1 ={'name': "Hello", 'year': 18, 'position': 'hang'}
for key,val in dic1.items():
	print(key,val)
for key in dic1.keys:
    print(key.title())
for val in dic1.values()
	print(val.upper())
```

### 嵌套

#### 字典列表

#### 字典中的列表

#### 字典中的字典

### 语句(statement)

#### 布尔运算符(boolean operators)

Python支持三个布尔运算符：`and`、`or`和`not`，它们的内容和C中的`&&`、`||`和`!`相同，优先级也相同：`not`有最高的优先级 ，`and`其次，`or`的优先级最低。同时，布尔运算符还支持短路运算(short circiuting)，即如果`and`和`or`的第一个操作数（也就是operand）一定可以决定表达式的真值，就不会检查后面的表达式，所以`True or 1 / 0`和`False and 1 / 0`甚至都没问题。

需要注意的是，`and`和`or`都不将返回值限定为`True`或者`False`，相反，它们返回最后一个求值的参数(the last evaluated argument)，比如字符串`s`需要在它为空的时候被替换成一个默认值，就可以使用`s = s or "Default"`来处理。但是`not`总需要创建一个新的值，所以不管接收到的参数是不是一个布尔值，都返回布尔值。

Python将`0`、`None`、`''`(空字符串)和`[]`(空列表)都规定为`False`，其余值规定为`True`。这表明了布尔值的范围其实比纯粹的`True`和`False`更加丰富。

#### 复合语句(compound statement)

语句值由解释器运行的，执行一项操作的语句（A statement is executed by the interpreter to perform an action）。

复合语句由一个或者多个子句(clause)组成，每个子句由一个句头(header)和一个句体(suite)组成，组成复合语句的子句头都处于相同的缩进层级。 每个子句头以一个作为唯一标识的关键字开始并以一个冒号结束。 子句体是由一个子句控制的一组语句。 子句体可以是在子句头的冒号之后与其同处一行的一条或者由分号分隔的多条简单语句，或者也可以是在其之后缩进的一行或多行语句。 只有后一种形式的子句体才能包含嵌套的复合语句。简而言之，复合语句大概长这样：

```python
<header>:			
    <statements>		# 两个句头之间夹着的是Suite
    ...					# 以上是一个Clause
<separating header>:
    <statements>
    ...
...
```

- 第一个句头决定了这个复合语句的类型。
- 字句的句头控制句体的执行（The header of a clause controls the suite that follows）。
- `def`语句、`if`语句和`while`语句都是标准的复合语句。
- 执行子句体指的就是按照句体内的表达式顺序执行表达式。



#### `if`语句

#### `for`循环

#### `while`循环

#### 循环的控制

利用`continue`和`break`来跳过此次循环或者跳出循环，逻辑和C一样。

`while`循环还可以这样用：根据对列表判断是否非空来控制循环。

```python
unconfirmed_users = ["1","2","3"]
while unconfirmed_users
	print(unconfirmed_users.pop())
print(unconfirmed_users)
```

这个循环只会在列表`unconfirmed_users`非空的时候运行，当它变空的时候，就不会继续运行了。

#### `assert`语句

`assert`语句的基本语法如下：`assert_stmt ::=  "assert" <expression> ["," <expression>]`。当`assert`后面的`<expression>`的布尔值是`False`时，程序会中断运行，并且抛出`AssertionError: <expression>`，这里的`<expression>`对应的是方括号里的`<expression>`。一个例子如下：

```python
>>> assert 2 > 3, 'Math is broken'
# Traceback (most recent call last):
#    File "<stdin>", line 1, in <module>
# AssertionError: Math is broken
```

#### `return`语句

A return statement completes the evaluation of call

### 函数

函数就是一个带名字的代码块，用于完成具体的工作。关键字`def`表示开始定义一个函数，向Python指出函数名，并且提供形参。函数定义下所有缩进行构成函数体，被三个引号引起来的部分是称作文档字符串的注释，描述函数是做什么的，Python用其生成有关程序中函数的文档。

在定义中括号里出现的变量是形式参数 (Formal Parameter)，是函数完成工作需要的信息，在调用函数时传入的是实际参数 (Actual Argument)，是调用函数的时候传递给函数的信息，值存储在相应的形式参数之中。

```python
def calc(number,times=2):				# Function signature
    """完成乘方的操作，默认为平方"""
    ret = 1								# Function body
    for cnt in range(0,times):
    	ret *= number
    return ret
```

我们认为赋值操作是一种简单的**抽象（abstraction）**方式，它将变量的名字与其值联系到了一起；而函数定义是一种更强大的抽象方式，它允许将名字与表达式联系到了一起。函数由函数签名与函数体组成。

- **函数签名（function signature）**`<name>(<formal parameters>)`表明了函数的名字与接受的形式参数的数量；

- **函数体（function body）**`<expression>`决定了使用函数时的计算过程。

`def`语句的执行过程如下：

- Create a function with signature `<name>(<formal parameters>)`;
- Set the body of that function to be everything indented after the first line;
- Bind `<name>` to that function in current frame.

Procedure for calling/applying user-defined functions(version 1):

- Add a local frame, forming a new environment;
- Bind the function's formal parameters to is arguments in that frame;
- Execute the body of the function in that new environment.

函数的定义域(domain)：

函数的值域(range)：

函数可以分为纯函数(pure function)和非纯函数(non-pure function)两类，纯函数指的是没有副作用(side-effect)的函数，反之，非纯函数有副作用，`print()`函数就是典型的非纯函数，它将内容显示在终端上。如果一个函数体内没有`return`语句，函数会自动返回`None`，`print()`就是这样返回的。A side effect isn't a value：it is anything that happens as a consequence of calling a function. 

有意思的是，在终端中，`print()`会显示没有引号的文本，但是`return`会保留引号。下面是一个例子：

```python
def what_prints():
    print('Hello World!')
    return 'Exiting this function.'

>>> what_prints()
Hello World!
'Exiting this function.'
```

### `None`

`None`在Python里面表示一种特殊的值：**Nothing**。

`None`其实有着其相应的数据类型：`NoneType`，所以在进行`None + 4`的操作的时候，就会出现类型错误：**TypeError: unsupported operand type(s) for +: 'NoneType' and 'int'**，这表明`None`和一般的数据类型不能相加。

### 用户输入

`input()`函数接受一个参数，即需要向用户显示的提示 (prompt) ，暂停程序运行并将提示输出到屏幕上，等待读取用户输入，在按下回车键之后继续运行，并且将用户的输入作为`input()`函数的返回值。

### 转义字符



|          |                  |      |
| :------: | :--------------: | ---- |
| max(a,b) | 输出a和b的最大值 |      |
|          |                  |      |
|          |                  |      |
|          |                  |      |
|          |                  |      |
|          |                  |      |
|          |                  |      |

## Lambda Expressions

```
lambda_expr ::= "lambda" [parameter_list] ":" return_expression
```

Lambda expressions (sometimes called lambda forms) are expressions that evaluate to fuctions by specifying two things: the parameters and a return expression. Lambda expressions are used to create anonymous functions. The expression `lambda parameters : expression` yields a function object, and this unnamed object behaves as a functions object defined with:

```python
def <lambda>(parameters):
	return expression
```

While both `lambda` expressions and `def` statements create function objects, there are some notable differences. `lambda` expressions work like other expressions; much like a mathematical expression just evaluates to a number and does not alter the current environment, a `lambda` expression evaluates to a function without changing the current environment: It does not create or modify any variables.

## Recursive Functions

**Definition**: A function is called recursive if the body of that function calls itself, either directly or indirectly.

**Implication**: Executing the body of a recursive function may require applying that function again.

The anatomy of a recursive function:

- the **def statement header** is similiar to other functions.
- Conditional statements check for **base cases**.
- Base cases are evaluated **without recursive calls**.
- Recursive cases are evaluated **with recursive calls**.

## Object-Oriented Programming



## Standard Library



## `operator`模块

`opertaor`模块包含了一套和Python内置的运算符对应的高效率函数，包含的种类有：对象的比较运算、逻辑运算、数学运算和序列运算。

|      ---       | ---      | ---  |
| :------------: | -------- | ---- |
|                |          |      |
| operator.add() | add(1,2) | 3    |
| operator.mul() | mul(2,3) | 6    |
|                |          |      |
|                |          |      |
|                |          |      |
|                |          |      |
|                |          |      |
|                |          |      |

## *CS61A*

### Lab 0

Docstring: 

### Lecture 2: Functions

An expression describes a computation and evaluates to a value.

Evaluation procedure for call expressions:

- Evaluate the operator and then the operand subexpressions (from left to right).
- Apply the function that is the value of the operator subexpression to the arguments that are the values of the operand subexpression. 

All expressions can use function call notation. (demo)

Call expression: 

Environment diagrams visualize the interpreter's progress.

a function's signature has all the information needed to create a local frame.

Pure functions: only return values.

Non-pure functions: have side effects. 

`print()` is a non-pure function because it displays its output depending on the argument passed in , and returning `None`. 



### Debug

#### Using `print()` statements







