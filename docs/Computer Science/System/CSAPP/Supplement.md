# Supplement

## Section 1 Foundations of Digital Logic

## Section 2 Combinational Logic Circuit

### 2.x 门的传播延迟

**传播延迟/Propagation delay**是信号的变化从输入传播到输出所需要的时间。电路运行速度与电路中经过门的最长传播延迟成反比关系。

我们有三个传播延迟参数：**高到低的传播时间/High-to-low propagation time**$t_{PHL}$，**低到高的传播时间/Low-to-high propagation time**$t_{PLH}$，**传播延迟/Propagation delay**$t_{pd}$。

在模拟过程对门建模的时候，往往使用传输延迟与惯性延迟。**传输延迟/Transport delay**是指输出响应输入的变化，在指定的传播延迟之后发生改变。**惯性延迟/Inertial delay**类似于传输延迟，但是如果输入变化使输出在一个小于**拒绝时间/Rejection time**的时间内改变，那么两次变化中的第一次将不会发生。拒绝时间是一个确定的值，不大于传播延迟，一般等于传播延迟。

## Section 3 Sequential Logic Circuit

## Section 4 RISC-V