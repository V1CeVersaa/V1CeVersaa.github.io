# Shell

!!! Abstract
    
    这份笔记将专注于**bash**（也就是Bourne Again SHell），暂不涉及其他种类的shell。

    下面代码均以本人 Ubuntu 22.04.3 系统中的bash为例。

## Basis

我们所熟悉的图像用户界面/Graphical User Interface/GUI在某些情况下反而限制了我们对计算机的使用，shell为我们提供了一种充分利用计算机的方式，它允许我们执行程序、输入并且获取某种半结构化的输出。

打开终端，我们就可以使用shell，下面就是我们一般看起来的样子。

```shell
test@testMachine:~$
```

其中`test`是用户名；`testMachine`是主机名；`~`是当前工作目录，特别地，`~`代表`home`；`$`是提示符，表示现在的身份不是root用户。在提示符后面，我们可以输入命令，命令最终会被shell解析并且执行。我们现在执行一些基本的命令：

```shell
test@testMachine:~$ date
Thu 14 Oct 2021 10:00:00 PM CST
test@testMachine:~$ echo hello
hello
```

在这个例子中：

- 我们不仅可以直接输入类似`date`的命令，还可以向shell传递参数，比如`echo hello`。

- 如果我们想让shell输出`hello world`，方法之一是使用单引号或者双引号包裹起来，

- 我们让shell执行了`echo`命令 



