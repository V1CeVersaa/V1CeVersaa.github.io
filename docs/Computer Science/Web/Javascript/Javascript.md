# Javascript

## 1 Basic Syntax

### 1.1 script 标签

可以使用 `<script>` 标签将 JavaScript 代码插入到 HTML 页面中，如果指定了 `src` 属性，就可以将外部的 JavaScript 文件引入到 HTML 页面中，同时 `<script>` 标签内的代码就会被忽略，一个单独的 `<script>` 标签不可以同时有 `src` 属性和内部代码。

```html
<script src="script.js"></script>
<script> alert('Hello, World!'); </script>
```

### 1.2 代码结构

语句是执行行为/Action 的语法结构和命令，JavaScript 语句以分号 `;` 结尾并分割，但是如果在语句末尾存在换行符的时候，分号就大多情况下会自动插入。但是经常会有特殊的例子：

<div class="grid" markdown>

```javascript
alert('Hello');

[1, 2].forEach(alert);
```

```javascript
alert('Hello')

[1, 2].forEach(alert);
```

</div>

第二种情况会被视为 `alert('Hello')[1, 2].forEach(alert);`，就只会显示一个 `hello`，所以在 JavaScript 中，最好还是手动添加分号。

### 1.3 变量与常量

使用 `let` 或者 `var` 来创建一个变量，但是现代一般使用 `let`，比如 `let message` 就创建了一个名为 `message` 的变量，`message = "hello"` 就将 `message` 赋值成为 `hello`，变量名可以包含字母、数字、下划线和美元符号，甚至可以有非英文字母，但是不能以数字开头，同时推荐使用驼峰命名法。

不允许连续声明同一个变量，变量的值可以随时改变，JavaScript 是一种动态类型语言，变量的类型可以随时改变。

使用 `const` 可以创建一个常量，比如 `const BIRTHDAY = "28.08.2005` 就创建了一个常量，常量不可以被修改。

在教程给出的例子中，我们会发现其实下面的代码会输出 `John` 和 `John`，因为 `admin` 只是保存了 `name` 的值，而不是 `name` 的引用。
```javascript
let name = "John", admin = name;
alert(admin);
name = "susy";
alert(admin);
```

### 1.4 数据类型
