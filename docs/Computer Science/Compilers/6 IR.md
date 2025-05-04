# Topic 6：中间表示生成

回顾一下编译器的组成，我们可以简单地分成三个阶段：

- 前端：词法分析、语法分析、语义分析，从源码生成抽象语法树（也可以生成 IR）；
- 中端：中间表示生成、机器无关代码优化，基于 IR 的分析和变换，也可能生成新的 IR；
- 后端：指令选择、寄存器分配、指令调度等，进行机器相关优化，从 IR 生成目标代码。

!!! Abstract "Outline"

    - [x] [1. 中间表示概述](#1)
    - [x] [2. IR Tree 的中间表示](#2-ir-tree)
    - [x] [3. IR Tree 的生成](#3-ir-tree)

## 1. 中间表示概述

如果不使用 IR，直接将 M 种源语言翻译成 N 种目标语言，那么我们需要 M * N 种不同的编译器，这显然是不现实的。但是统一使用一种 IR 之后，就只需要 M 个前端和 N 个后端了。

可以见得，直接生成目标机器码的设计一方面阻碍了模块型，一方面也限制了可移植性。

实际的编译器常常采用多层 IR 设计，这样支持了多种不同层次的分析与变换。按照抽象层次来讲，可以分为下面三种：

- 高层中间表示/High-level IR：贴近输入语言，方便从前端生成，比如 Rust 的 HIR IR；
- 底层中间表示/Low-level IR：贴近目标语言，方便目标代码生成，比如 GCC 的 RTL 中间表示；
- 中层中间表示/Middle-level IR：介于高层和底层之间，比如 Numba 和 TVM 的 IR。

但是这三种之间并没有明确的界限。

按照结构特征分类，可以分为下面三种：

- 结构化表示/Structural：一般是图形化的，比如树和有向无环图，大量的用在源码到源码的转换上；
- 线性表示：存储布局是线性的，比如有三地址码、栈机；
- 混合表示/Hybrid：介于结构化和线性之间，结合了结构化和线性的特点。

下面详细介绍三地址码，其接近大多数目标机器的执行模型，支持大多数目标机器移动的数据类型和操作，提供高于机器码的抽象表达能力，但是这种表达能力是有限的。三地址码的一般形式是 $x = y \operatorname*{op} z$。每一个指令最多具有一个算符，并且最多具有三个操作数。比如表达式 $x + y * z$ 的三地址语句序列就是 $t_1 = y * z, t_2 = x + t_1$。可以看作按照从深到浅的顺序，将表达式树的节点依次写成三地址语句。

<img class="center-picture" src="../assets/6-1.png" width=550 />

下面是一个翻译的例子：

<img class="center-picture" src="../assets/6-2.png" width=550 />

整个三地址指令序列通过一个链表来实现，最常见的实现是使用四元式/Quadruples，每一个 TAC 指令使用一个包含四个字段的结构体表示，比如 $(\mathrm{op}, \mathrm{arg}_1, \mathrm{arg}_2, \mathrm{result})$。对于不需要三个地址的执行，比如一元运算、赋值、跳转和标签，某些地址字段会被设置为空，比如使用 `_` 代表空。典型的例子有：

- `t1 = x > 0` -> `(gt, x, 0, t1)`
- `if_false t1 goto L1` -> `(if_false, t1, L1, _)`
- `fact = 1` -> `(asn, 1, _, fact)`
- `label L2` -> `(lab, L2, _, _)`

其余实现包括三元式/Triples 和间接三元式/Indirect Triples。

静态单赋值/Static Single Assignment/SSA 是一种特殊的三地址码，其所有变量在代码之中只被赋值**一次**。

下面是原始代码和 SSA 的版本的对比：

```C
// 原始代码      SSA 版本
x = a;          x_1 = a;
y = x + 1;      y_1 = x_1 + 1;
x = b;          x_2 = b;
z = x * 2;      z_1 = x_2 * 2;
```

SSA 方便了编译器的很多分析和优化，比如查询 def-use 信息，基于 SSA 的稀疏分析加速算法，以及一些算法也严格依赖 SSA。SSA 也广泛应用于现代编译器中，比如 LLVM。

## 2. IR Tree 的中间表示

现代的编译器使用多级 IR 设计，越到后面阶段的 IR 越接近目标机器的机器码，但是 Tiger 编译器只使用单个 IR，大致翻译流程为：AST -> IR Tree -> Assembly -> Machine Code。使用 BNF 形式的文法描述为：

<img class="center-picture" src="../assets/6-3.png" width=550 />

IR 中间指令列举如下：

<img class="center-picture" src="../assets/6-4.png" width=550 />

<img class="center-picture" src="../assets/6-5.png" width=550 />

简单举几个例子：

- `BINOP(PLUS, TEMP(t1), CONST(1))` 对应着 `t1 + 1`；
- `MEM(CONST(100))` 对应着访问内存地址为 100 的值；
- `ESEQ(MOVE(TEMP(t1), CONST(1)), TEMP(t1))` 对应着先计算 `t1 = 1`，然后计算表达式 `t1;`；
- `MOVE(MEM(e1), e2)` 对应着 `*e1 = e2;`；
- `EXP(CALL(NAME(print), ...))` 对应着调用 `print` 函数并且丢弃返回值；
- `CJUMP(EQ, TEMP(t1), CONST(0), L1, L2)` 对应着 `if (t1 == 0) goto L1; else goto L2;`；
- `SEQ(MOVE(...), JUMP(...))` 对应着赋值之后直接跳转。

对于 $\operatorname*{ESEQ}(s, e)$，其中对 $s$ 求值是为了使用其副作用，在求值结束之后，对 $e$ 求值作为结果，这里语句 $s$ 不返回值。其中副作用意味着更新某些内存单元的内容或者临时寄存器的值。

<img class="center-picture" src="../assets/6-6.png" width=550 />

## 3. IR Tree 的生成

> 这部分太多了我靠

简单来说，Tiger 语言中的表达式分为三类：

- Ex：带有返回值的 AST 表达式，比如 `x` 和 `a + b`；
- Nx：不带有返回值的 AST 表达式，比如 `print(x)`；
- Cx：条件表达式，返回值为布尔值。

很多情况下我们需要在不同的表达式之间进行转换，这部分我们就可以看见，其实 IR 翻译是上下文有关问题，就没办法使用 CFG 刻画了。

<img class="center-picture" src="../assets/6-7.png" width=550 />

对于简单的声明在当前过程内的栈帧的变量，其相对于桢指针的偏移量 $k$ 是已知的，并且 Tiger 语言的所有变量都是一个字大小的，因此我们可以翻译成这样的中间代码：`MEM(BINOP(PLUS, TEMP FP, CONST k))`。

对于需要静态链访问的变量，需要翻译成如下的中间代码：`MEM(+(CONST k_n, MEM(+(CONST k_{n-1}, ... MEM(+(CONST k_1, TEMP FP)) ... )))`。注意到我们使用了 `+(e1, e2)` 来表示 `BINOP(PLUS, e1, e2)`。

对于数组和记录，其实就是一种固定的指针，没有办法直接拷贝，因此下面的代码在执行后，`a` 和 `b` 都指向了一个包含 12 个 7 的数组：

```ocaml
let 
    type intArray = array of int
    var a := intArray[12] of 0
    var b := intArray[12] of 7
in a := b
```

右值出现在赋值语句的右侧，



