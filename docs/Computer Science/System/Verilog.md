# Verilog

## Chapter 01 Basic Knowledge

### 01.1 FPGA

**FPGA/Field Programmable Gate Array/现场可编程门阵列**：FPGA器属于专用集成电路的一种半定制电路，是可以编程的逻辑列阵，能够有效解决原有器件门电路数较少的问题。其基本结构包括可编程输入输出单元，可配置逻辑块，数字时钟管理模块，嵌入式块RAM，布线资源，内嵌专用硬核，底层内嵌功能单元。

### 01.2 Verilog

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
