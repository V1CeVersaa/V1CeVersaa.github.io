# 实验纪实与代码分析

## 1 2-to-1 Multiplexer

我们首先以一种特别的角度看与门：与的运算的作用之一就是**屏蔽**，当某个输入的值为零时，与的输出就是零，不管另一个输入是什么。这就使得我想要的数据都未被屏蔽，不想要的都被屏蔽为0。比如对于运算$A\land S$，$S$可以看作一个选择子，当$S=T$的时候，输出就是$A$，不论$A$的真值为多少，输出的值就是$A$的值；当$S=F$的时候，输出就是$F$，这时候$A$就被**屏蔽**了。

二路选择器的逻辑就是“屏蔽”，对于下面的二路选择器，最重要的结构就是**上下两个与门**和**中间一个非门**，选择信号$S$分成两份，通过非门变成两个不同的信号，分别接向两个与门，如果$S$的信号为$1$/$T$，那么就将下面的门屏蔽，输出上边的门信号；反之亦然。
![alt text](../images/img-Verilog/mux2to1.png)

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



if-else 必须在always块中使用，并且输出必须是reg类型。但是在`always@(*)`中，内部的reg被综合成wire类型

## 2 复合多路选择器/Cascaded Mux

多路选择器可以根据选择子从**多个单bit**输入中选择**单bit**输出，但是如果我们需要从**多个多bit**输入中选择**多bit**输出，那么就需要使用复合多路选择器。复合多路选择器在硬件实现上其实是由多个单路选择器级联而成的。


## 3 七段数码管译码器/Seven-Segment Decoder

七段数码管的显示译码的对应关系如下，使用复合多路选择器，就不难得到下面源码。解释源码的方法很简单，把它的接口`a`到`g`分开，当卡诺图写就好了。

![alt text](../images/img-Verilog/5.png)

=== "index版本"

    好看一点并且比较符合**选择**想法的写法。

    ```verilog
    module SegDecoder_new (
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

        wire [6:0] segs [15:0];
        assign segs[0] = 7'b0000001;
        assign segs[1] = 7'b1001111;
        assign segs[2] = 7'b0010010;
        assign segs[3] = 7'b0000110;
        assign segs[4] = 7'b1001100;
        assign segs[5] = 7'b0100100;
        assign segs[6] = 7'b0100000;
        assign segs[7] = 7'b0001111;
        assign segs[8] = 7'b0000000;
        assign segs[9] = 7'b0000100;
        assign segs[10] = 7'b0001000;
        assign segs[11] = 7'b1100000;
        assign segs[12] = 7'b0110001;
        assign segs[13] = 7'b1000010;
        assign segs[14] = 7'b0110000;
        assign segs[15] = 7'b0111000;

        assign {a, b, c, d, e, f, g} = {7{LE}} | segs[data];

        assign p = ~point;

    endmodule //SegDecoder
    ```

=== "与或版本"
    这个是对应的图片，非常的朴素。
    ![alt text](images/img-Verilog/7.png)
    但是这个是老实人写法，就直接按照真值表画电路硬刚，千万别这么写，丑死了。

    ```verilog
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
        assign d = LE | (~data[0] &  data[1] & ~data[2] &  data[3] |
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

## 4 全加器(Full Adder)


=== "1-bit full adder"

    ```verilog
    module Adder(
        input a,
        input b,
        input c_in,
        output s,
        output c_out
    );
        
        assign s = a ^ b ^ c_in;
        assign c_out = a & b | a & c_in | b & c_in;

    endmodule 
    ```

=== "ripple-carry adder"

    ```verilog
    module Adders #(
        parameter LENGTH = 32
    )(
        input [LENGTH-1:0] a,
        input [LENGTH-1:0] b,
        input c_in,
        output [LENGTH-1:0] s,
        output c_out
    );
    
        wire c[LENGTH:0];
        assign c[0] = c_in;

        genvar i;
        generate
            for(i = 0; i < LENGTH; i = i + 1)begin
                Adder adder(.a(a[i]), .b(b[i]), .c_in(c[i]), .s(s[i]), .c_out(c[i+1]));
            end      
        endgenerate

        assign c_out = c[LENGTH];
    
    endmodule
    ```

=== "sub-adder"

    ```verilog
    module AddSubers #(
        parameter LENGTH = 32
    )(
        input [LENGTH-1:0] a,
        input [LENGTH-1:0] b,
        input do_sub,
        output [LENGTH-1:0] s,
        output c
    );
        wire [LENGTH-1:0] res_adder;
        assign res_adder = {LENGTH{do_sub}};
        wire [LENGTH-1:0] tmp;
        assign tmp = res_adder ^ b;
        Adders #(.LENGTH(LENGTH))adder_sub(.a(a), .b(tmp), .c_in(do_sub), .s(s), .c_out(c));
    
    endmodule
    ```

=== "4-bit lookahead adder"

    ```verilog
    module Lookahead_Adder4(
        input [3:0] a,
        input [3:0] b,
        input c_in,
        output [3:0] s,
        output c_out
    );

        wire [3:0] G;
        wire [3:0] P;
        wire [4:0] c;

        genvar i;
        generate
            for(i = 0; i<4; i=i+1)begin
                assign G[i] = a[i] & b[i];
                assign P[i] = a[i] ^ b[i];
            end
        endgenerate

        assign c[0] = c_in;
        assign c[1] = G[0] | P[0] & c[0];
        // assign c[2] = G[1] | P[1] & c[1];
        assign c[2] = G[1] | P[1] & G[0] | P[1] & P[0] & c[0] ;
        assign c[3] = G[2] | P[2] & G[1] | P[2] & P[1] & G[0] | 
                      P[2] & P[1] & P[0] & c[0] ;
        assign c[4] = G[3] | P[3] & G[2] | P[3] & P[2] & G[1] | 
                      P[3] & P[2] & P[1] & G[0] | P[3] & P[2] & P[1] & P[0] & c[0];
        assign c_out = c[4];

        generate
            for(i = 0; i<4; i=i+1)begin
                assign s[i] = P[i] ^ c[i];
            end
        endgenerate
    
    endmodule
    ```

## 5 七段数码管驱动

## 6 有限状态机

说是有限状态机，其实就是完成 C 程里面一个常见的小程序，记录输入 a 的数量，当连续输入三个 a 的时候，结束程序，当输入 b 的时候，计数清零。

=== "FSM"

    ```verilog
    module FSM(
        input rstn,
        input clk,
        input a,
        input b,
        output [1:0] state
    );
    
    typedef enum logic [1:0] {st0, st1, st2, st3} fsm_state_t;
    fsm_state_t state_s;
    
    always @(posedge clk or negedge rstn) begin
        if(~rstn)
            state_s <= st0;
        else begin
            case(state_s)
                st0: begin
                    if(a) state_s <= st1; 
                    else if(b) state_s <= st0;
                end
                st1: begin
                    if(a) state_s <= st2;
                    else if(b) state_s <= st0;
                end
                st2: begin
                    if(a) state_s <= st3;
                    else if(b) state_s <= st0;
                end
                st3: state_s <= st3;
            endcase
        end
    end

    assign state = state_s;

    endmodule
    ```


