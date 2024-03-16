# Verilog

## Chapter 1 Basic Knowledge

### 1.1 FPGA

**FPGA/Field Programmable Gate Array/现场可编程门阵列**：FPGA器属于专用集成电路/ASIC的一种半定制电路，是可以编程的逻辑列阵，可以按照设计人员的需求配置指定的电路结构，让客户不必依赖于芯片制造商设计和制造的专用集成电路就可以实现所需要的功能，同时实现非常高效的逻辑运算。其基本结构包括可编程输入输出单元，可配置逻辑块，数字时钟管理模块，嵌入式块RAM，布线资源，内嵌专用硬核，底层内嵌功能单元。

### 1.2 Verilog

Verilog HDL是一种硬件描述语言，用于从算法级、门级到开关级的多种抽象设计层次的数字系统建模。Verilog HDL提供了编程语言接口，通过这个接口可以在模拟、验证期间从设计外部访问设计，包括模拟的具体控制和运行。



```Verilog
module main(
    input I0,
    input I1.
    input I2,
    output O );
```

**wire**的电器特性：
- wire必须被**有且仅有**一个`assign`输入；
- wire可以有0个或者多个`assign`输出.


### 运算符

按位运算符：

- `&`：按位与；
- `|`：按位或；
- `^`：按位异或；
- `~`：按位取反；
- `~^`：按位同或；


## Example

### 1.1 2-to-1 Multiplexer

我们首先以一种特别的角度看与门：与的运算的作用之一就是**屏蔽**，当某个输入的值为零时，与的输出就是零，不管另一个输入是什么。这就使得我想要的数据都未被屏蔽，不想要的都被屏蔽为0。比如对于运算$A\land S$，$S$可以看作一个选择子，当$S=T$的时候，输出就是$A$，不论$A$的真值为多少，输出的值就是$A$的值；当$S=F$的时候，输出就是$F$，这时候$A$就被**屏蔽**了。

二路选择器的逻辑就是“屏蔽”，对于下面的二路选择器，最重要的结构就是**上下两个与门**和**中间一个非门**，选择信号$S$分成两份，通过非门变成两个不同的信号，分别接向两个与门，如果$S$的信号为$1$/$T$，那么就将下面的门屏蔽，输出上边的门信号；反之亦然。
![alt text](./images/img-Verilog/mux2to1.png)

=== "结构化描述"
    这里边利用了Verilog内置的一些门，比如`AND`和`OR`门。这种描述方式的优点就是可以很好的与真实的电路相对应，但是缺点就是不够简洁，写起来很坐牢。
    ```Verilog
    module Mux2to1 (
        input I0,
        input I1,
        input S,
        output O
        );
        wire S0_n;
        NOT not0 (S0_n, S);
        // assign S0_n = ~S;
        wire and0_s;
        wire and1_s;
        AND and0(and0_s, I0, S0_n);
        AND and1(and1_s, I1, S);
        OR or0(O, and0_s, and1_s);
    ```

=== "数据流描述"
    这种描述方法充分利用了与`&`、或`|`、非`~`以及异或`^`等运算符代替了`AND`、`OR`、`NOT`等门的描述，使得描述更加简洁。忍不住了，直接写数组。
    ```Verilog
    module Mux2to1 (
        input [1:0] I,
        input S,
        output O
        );
        assign O = I[0] & ~S | I[1] & S;
    ```
    并且这种写法还需要注意优先级的问题，Verilog的优先级是`~`>`&`>`|`，所以这里的写法是正确的。

    我们还应该知道：
    
    - **一个类C的运算符其实是一个简化描述的电路**；
    - 一个运算符的操作数是这个电路的输入；
    - 一个运算符运算表达式的值是这个电路的输出；
    - 运算表达式的嵌套是门电路的级联；

=== "行为描述"
    这种描述方法是最简洁的，但是也是最抽象的，使用了大量的高度抽象的类C语句来提升编程的灵活性：
    ```Verilog
    module Mux2to1 (
        input I0,
        input I1,
        input S,
        output O
        );
        assign O = S ? I1 : I0;
    ```

    Verilog利用了C中的三目运算符来实现了二路选择器，语法是这样的`exp0 ? exp1 : exp2`，这里的赋值语句并不是表示*如果选择子$S$是$1$，我就把`I0`和`I1`连上*，实际上**这就是一个二路选择器**，`exp0`是**构造选择子电路的输出**，真不是不连电路啊……



if-else 必须在always块中使用，并且输出必须是reg类型。但是在always@(*)中，内部的reg被综合成wire类型

### 1.2 复合多路选择器/Cascaded Mux

多路选择器可以根据选择子从**多个单bit**输入中选择**单bit**输出，但是如果我们需要从**多个多bit**输入中选择**多bit**输出，那么就需要使用复合多路选择器。复合多路选择器在硬件实现上其实是由多个单路选择器级联而成的。


### 1.3 七段数码管译码器/Seven-Segment Decoder

七段数码管的显示译码的对应关系如下，使用复合多路选择器，就不难得到下面源码。解释源码的方法很简单，把它的接口`a`到`g`分开，当卡诺图写就好了。

![alt text](images/img-Verilog/5.png)
![alt text](images/img-Verilog/7.png)

=== "SegDecoder"
```Verilog
module SegDecoder (
    input wire [3:0] data,
    input wire point,
    input wire LE,

    output wire a,
    output wire b,
    output wire c,
    output wire d,
    output wire e,
    output wire f,
    output wire g,
    output wire p
);
    
    assign a = LE | ( data[0] &  data[1] & ~data[2] &  data[3] | 
                      data[0] & ~data[1] &  data[2] &  data[3] | 
                     ~data[0] & ~data[1] &  data[2] & ~data[3] | 
                      data[0] & ~data[1] & ~data[2] & ~data[3] );
    assign b = LE | ( data[0] &  data[1] &  data[3] | 
                     ~data[0] &  data[2] &  data[3] |
                     ~data[0] &  data[1] &  data[2] | 
                      data[0] & ~data[1] &  data[2] & ~data[3] );
    assign c = LE | ( data[1] &  data[2] &  data[3] |
                     ~data[0] &  data[1] & ~data[2] & ~data[3] |
                     ~data[0] &  data[2] &  data[3] );
    assign d = LE | (~data[0] &  data[1] & ~data[2] & data[3]  |
                      data[0] &  data[1] &  data[2] |
                     ~data[0] & ~data[1] &  data[2] & ~data[3] |
                      data[0] & ~data[1] & ~data[2] & ~data[3] );
    assign e = LE | ( data[0] & ~data[1] & ~data[2] |
                     ~data[1] &  data[2] & ~data[3] |
                      data[0] & ~data[3] );
    assign f = LE | ( data[0] &  data[1] & ~data[3] |
                      data[1] & ~data[2] & ~data[3] |
                      data[0] & ~data[2] & ~data[3] |
                      data[0] & ~data[1] &  data[2] &  data[3] );
    assign g = LE | (~data[0] & ~data[1] &  data[2] &  data[3] |
                      data[0] &  data[1] &  data[2] & ~data[3] |
                     ~data[1] & ~data[2] & ~data[3] );
    assign p = ~point;

endmodule //SegDecoder
```

