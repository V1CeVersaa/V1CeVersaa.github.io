# Chapter 3

## Knowledge

### 1. 随机变量及其分布

- **「随机变量与其概率分布」**：设 $\xi(\omega)$ 是定义于概率空间 $(\Omega, \mathcal{F}, P)$ 上的单值实函数，如果 $\xi$ 是 $\mathcal{F}$-可测的，也就是对于直线上的任一博雷尔点集 $B$, 有

    $$
    \{\omega : \xi(\omega) \in B\} \in \mathcal{F}
    $$

    则称 $\xi(\omega)$ 为**随机变量**，而 $P\{\xi(\omega) \in B\}$ 称为随机变量 $\xi(\omega)$ 的**概率分布**。特别地，若取 $B = (-\infty, x)$，则有

    $$
    \{\omega : \xi(\omega) < x\} \in \mathcal{F}
    $$

    因此 $P\{\xi(\omega) < x\}$ 有定义。注意到

    $$
    P\{a \leq \xi(\omega) < b\} = P\{\xi(\omega) < b\} - P\{\xi(\omega) < a\}
    $$

    所以只要对一切实数 $x$ 给出概率 $P\{\xi(\omega) < x\}$，就能算出 $\xi(\omega)$ 落入某个区间 $[a, b)$ 的概率，再利用概率的性质还可以算出 $\xi(\omega)$ 属于某些相当复杂的直线点集（譬如可列个不相交的左闭右开区间之和）的概率。

- **「随机变量的分布函数」**：称

    $$
    F(x) = P\{\xi(\omega) < x\}, \quad -\infty < x < \infty
    $$

    为随机变量 $\xi(\omega)$ 的**分布函数**（distribution function）。**需要注意的是，这里分布函数的定义取的是小于号 $<$**。为书写方便起见，通常把“随机变量 $\xi(\omega)$ 服从分布函数 $F(x)$” 简记作 $\xi(\omega) \sim F(x)$。由上面的式子立刻得到 

    $$
    P\{a \leq \xi(\omega) < b\} = F(b) - F(a)
    $$

- **「分布函数的性质」**：分布函数 $F(x)$ 具有下列性质：

    1. 单调性：若 $a < b$，则 $F(a) \leq F(b)$；
    2. $\lim\limits_{x \to -\infty} F(x) = 0$, $\lim\limits_{x \to +\infty} F(x) = 1$； \tag{3.1.6}
    3. 左连续性：$F(x - 0) = F(x)$。

    ???- Info "Proof"

        1. $F(b) - F(a) = P\{a \leq \xi < b\} \geq 0$。
        2. 根据

            $$
            \begin{aligned}
            P\{-\infty < \xi < +\infty \} &:= \sum_{n=-\infty}^{\infty}\limits P\{n \leq \xi < n + 1\} \\
            &= \sum_{n=-\infty}^{\infty} \left[ F(n+1) - F(n) \right] \\ 
            &= \lim_{n \to +\infty} F(n) - \lim_{m \to -\infty} F(m) = 1 \\
            \end{aligned}
            $$

            由于 $F(x)$ 的单调性，$\lim\limits_{x \to -\infty} F(x) = \lim\limits_{m \to -\infty} F(m)$ 存在。

            因为 $0 \leq F(x) \leq 1$，故

            $$
            \lim\limits_{x \to -\infty} F(x) = 0, \quad \lim\limits_{x \to +\infty} F(x) = 1
            $$

            今后为书写方便起见，将记

            $$
            F(-\infty) = \lim\limits_{x \to -\infty} F(x), \quad F(+\infty) = \lim\limits_{x \to +\infty} F(x) \tag{3.1.7}
            $$

        3. 由于 $F(x)$ 是单调函数，只须证明对于一列单调上升的数列 $x_0 < x_1 < x_2 < \cdots < x_n < \cdots$, 当 $x_n \to x$ 成立时 $\lim\limits_{n \to \infty} F(x_n) = F(x)$ 即可。因为

            $$
            \begin{aligned}
            F(x) - F(x_0) &= P\{x_0 \leq \xi < x\} = \sum_{n=1}^{\infty} \left[ F(x_n) - F(x_{n-1}) \right] \\ 
            &= \lim_{n \to \infty} F(x_n) - F(x_0)
            \end{aligned}
            $$

            所以

            $$
            F(x-0) = \lim_{n \to \infty} F(x_n) = F(x)
            $$

        可以看出分布函数的这三个基本性质，正好对应于概率的三个基本性质。

    有了分布函数之后，就可以计算很多关于随机变量 $\xi$ 的概率了，比如

    $$\begin{aligned}
        &P\{\xi(\omega) = a\} = F(a + 0) - F(a) \\
        &P\{\xi(\omega) \leq a\} = F(a + 0) \\ 
        &P\{\xi(\omega) \geq a\} = 1 - F(a) \\
        &P\{\xi(\omega) > a\} = 1 - F(a + 0)
    \end{aligned}$$

- **「常见的离散型随机变量的分布」**：这里大多是复习上章的内容：
    1. 「伯努利分布/两点分布」：
    2. 「二项分布」：背景是 $n$ 重伯努利试验中，考虑随机变量 $\mu$ 位事件 $A$ 发生 $k$ 次的次数，其分布律为：$\displaystyle P\{\mu = k\} = \binom{n}{k} p^k (1-p)^{n-k}$，简记为 $\mu \sim B(n, p)$。
    3. 「超几何分布」：
    4. 「泊松分布」：若随机变量 $\xi$ 可以取任何的非负整数值，其满足 $\displaystyle P\{\xi = k\} = \frac{\lambda^k}{k!} e^{-\lambda}$，则称 $\xi$ 服从参数为 $\lambda$ 的泊松分布，简记为 $\xi \sim P(\lambda)$。
    5. 「几何分布」：
    6. 「帕斯卡分布」：
    7. 「负二项分布」：
- **「连续型随机变量及其分布」**：连续型随机变量 $\xi$ 可以取区间 $[c, d]$ 中的任何值，并且满足其分布函数 $F(x)$ 是绝对连续函数，即存在可积函数 $p(x)$，使

    $$
    F(x) = \int_{-\infty}^{x} p(y) \, \mathrm{d}y
    $$

    称 $p(x)$ 为 $\xi$ 的**分布密度函数/Density Function**。进一步，我们可以对任意博雷尔点集 $B$ 进行积分：

    $$
    P\{\xi \in B\} = \int_B p(x) \, \mathrm{d}x
    $$

- **「正态分布」**：其密度函数为 

    $$
    p(x) = \dfrac{1}{\sqrt{2\pi}\sigma} e^{-(x-\mu)^2/2\sigma^2}, \enspace -\infty < x < \infty 
    $$

    期中 $\mu$ 为数学期望，$\sigma$ 为标准差。正态分布的分布函数为

    $$
    F(x) = \dfrac{1}{\sqrt{2\pi}\sigma} \int_{-\infty}^{x} e^{-(t-\mu)^2/2\sigma^2} \, \mathrm{d}t, \enspace -\infty < x < \infty
    $$

    一方面，虽然 $F(x)$ 无法用初等函数表示，但是可以证明这样确实定义了一个密度函数和分布函数：

    ???- Info "Proof"
        1. 显然 $p(x) \geq 0$；
        2. 下面验证 $F(\infty) = 1$：$\dfrac{x - \mu}{\sigma} = z$，则

        $$
        \int_{-\infty}^{\infty} \dfrac{1}{\sqrt{2 \pi} \sigma} e^{-\frac{(x - \mu)^2}{2 \sigma^2}} \, \mathrm{d}x = \int_{-\infty}^{\infty} \dfrac{1}{\sqrt{2 \pi}} e^{-\frac{z^2}{2}} \, \mathrm{d}z
        $$

        耦合成二维问题，并转换成极坐标$x = r \cos \varphi$，$y = r \sin \varphi$：

        $$\begin{aligned}
        \left( \int_{-\infty}^{\infty} \dfrac{1}{\sqrt{2 \pi}} e^{-\frac{x^2}{2}} \, \mathrm{d}x \right) \left( \int_{-\infty}^{\infty} \dfrac{1}{\sqrt{2 \pi}} e^{-\frac{y^2}{2}} \, \mathrm{d}y \right)
        &= \dfrac{1}{2 \pi} \int_{-\infty}^{\infty} \int_{-\infty}^{\infty} e^{-\frac{x^2 + y^2}{2}} \, \mathrm{d}x \, \mathrm{d}y \\ 
        &= \dfrac{1}{2 \pi} \int_{0}^{\infty} \int_{0}^{2 \pi} e^{-\frac{r^2}{2}} r \, \mathrm{d}r \, \mathrm{d}\varphi \\
        &= \int_{0}^{\infty} r e^{-\frac{r^2}{2}} \, \mathrm{d}r = 1
        \end{aligned}$$

        由 $\displaystyle\int_{-\infty}^{\infty} \dfrac{1}{\sqrt{2 \pi}} e^{-\frac{z^2}{2}} \, \mathrm{d}z$ 的非负性知

        $$
        \int_{-\infty}^{\infty} \dfrac{1}{\sqrt{2 \pi} \sigma} e^{-\frac{(x - \mu)^2}{2 \sigma^2}} \, \mathrm{d}x = \int_{-\infty}^{\infty} \dfrac{1}{\sqrt{2 \pi}} e^{-\frac{z^2}{2}} \, \mathrm{d}z = 1
        $$

    当 $\mu = 0$，$\sigma = 1$ 时，称为**标准正态分布**，记为 $N(0, 1)$，其分布函数为 $\Phi(x)$。我们可以将一般的正态分布的分布函数转化成标准正态分布的分布函数：

    $$\begin{aligned}
    &F(x) = P\{\xi < x\} = P\left\{\frac{\xi - \mu}{\sigma} < \frac{x - \mu}{\sigma}\right\} = \Phi\left(\frac{x - \mu}{\sigma}\right) \\ 
    &P\{\lvert \xi - \mu \rvert < k\sigma\} = P\left\{-k < \frac{\xi - \mu}{\sigma} < k\right\} = \Phi(k) - \Phi(-k) = 2\Phi(k) - 1
    \end{aligned}$$

- **「指数分布」**：
- **「埃尔朗分布」**：
- **「$\Gamma$分布」**：

### 2. 随机向量、随机变量的独立性

在某些随机现象中，每次试验的结果不能只用一个数来描述，所以引入随机向量。

- **「随机向量」**：若随机变量 $\xi_1(\omega), \xi_2(\omega), \cdots, \xi_n(\omega)$ 定义在同一概率空间 $(\Omega, \mathcal{F}, P)$ 上，则称

    $$
    \boldsymbol{\xi}(\omega) = (\xi_1(\omega), \xi_2(\omega), \cdots, \xi_n(\omega))
    $$

    构成一个 $n$ **维随机向量**，亦称 **$n$ 维随机变量**。显然，一维随机向量即为随机变量，$n$ 维随机向量 $\boldsymbol{\xi}$ 取值于 $n$ 维欧氏空间 $\mathbb{R}^n$。

    对于任意的 $n$ 个实数 $x_1, x_2, \cdots, x_n$

    $$
    \{\xi_1(\omega) < x_1, \xi_2(\omega) < x_2, \cdots, \xi_n(\omega) < x_n\} = \bigcap_{i=1}^{n} \{\xi_i(\omega) < x_i\} \in \mathcal{F}
    $$

    亦即对于 $\mathbb{R}^n$ 中的 $n$ 维矩形 $C_n = \prod\limits_{i=1}^{n} (-\infty, x_i)$，有 $\{\boldsymbol{\xi}(\omega) \in C_n\} \in \mathcal{F}$。利用测度论的方法还可证明，若 $B_n$ 为 $\mathbb{R}^n$ 上任一博雷尔点集，也有 $\{\boldsymbol{\xi}(\omega) \in B_n\} \in \mathcal{F}$。

- **「联合分布函数」**：称 $n$ 元函数

    $$
    F(x_1, x_2, \cdots, x_n) = P \{\xi_1(\omega) < x_1, \xi_2(\omega) < x_2, \cdots, \xi_n(\omega) < x_n\}
    $$

    为随机向量 $\boldsymbol{\xi}(\omega) = (\xi_1(\omega), \xi_2(\omega), \cdots, \xi_n(\omega))$ 的联合分布函数。

- **「联合分布函数的性质」**：完全可以类似于一元的情形：
    1. 还没写
- **「」**：
- **「」**：

 

- **「」**：



## Exercises

1. 还没写
2. 还没写
3. 还没写
4. 还没写
5. 还没写还没写
6. （Mill's Inequality）证明：对于服从标准正态分布的随机变量 $\xi$，有
    $$
    \dfrac{1}{\sqrt{2\pi}} \cdot \left(\dfrac{1}{x} - \dfrac{1}{x^3}\right) e^{-x^2/2} < P(\xi > x) < \dfrac{1}{\sqrt{2\pi}} \cdot \dfrac{1}{x} e^{-x^2/2}
    $$

    ???+ Info "Answer"
        1. 不等式左侧：激情分部积分

            $$
            \begin{aligned}
            \int_x^\infty e^{-t^2/2}\, dt &= \int_x^\infty \frac{1}{t}\cdot t e^{-t^2/2}\, dt \\
            &= \left[ \frac{1}{t} \cdot \int te^{-t^2/2}\, dt \right]_x^\infty - \int_x^\infty \left( \frac{1}{t} \right)' \left( \int te^{-t^2/2}\, dt \right) dt \\
            &= \frac{e^{-x^2/2}}{x} - \int_x^\infty \frac{e^{-t^2/2}}{t^2}\, dt
            \end{aligned}
            $$

            前半部分已经搞定了，下面积分后半部分：

            $$
            \begin{aligned}
            \int_x^\infty \frac{e^{-t^2/2}}{t^2}\, dt &= \int_x^\infty \frac{1}{t^3} \cdot te^{-t^2/2}\, dt \\
            &= \left[ \frac{1}{t^3} \cdot \int te^{-t^2/2}\, dt \right]_x^\infty - \int_x^\infty \left( \frac{1}{t^3} \right)' \left( \int te^{-t^2/2}\, dt \right) dt\\
            &= \frac{e^{-x^2/2}}{x^3} - 3\int_x^\infty \frac{e^{-t^2/2}}{t^4}\, dt
            \end{aligned}
            $$

            由于 $\dfrac{e^{-t^2/2}}{t^4}$ 一定恒为正的，合起来就有

            $$
            \begin{aligned}
            \int_x^\infty e^{-t^2/2}\, dt &= e^{-x^2/2} \left( \frac{1}{x} - \frac{1}{x^3} \right) + 3 \int_x^\infty \frac{e^{-t^2/2}}{t^4}\, dt \\
            &> e^{-x^2/2} \left( \frac{1}{x} - \frac{1}{x^3} \right)
            \end{aligned}
            $$

        2. 不等式右侧：还是激情分部积分

            $$
            \begin{aligned}
            \int_x^\infty e^{-t^2/2}\, dt &= \dfrac{1}{x} \int_x^\infty xe^{-t^2/2}\, dt \\
            &< \dfrac{1}{x} \int_x^\infty te^{-t^2/2}\, dt \\ 
            &= \dfrac{1}{x} e^{-x^2/2}
            \end{aligned}
            $$


<!-- ### Chapter 4 -->

<!-- ???+ Info "Answer"
    
    ???+ Info "Answer"
    ???+ Info "Answer"
    ???+ Info "Answer"
    ???+ Info "Answer"
    ???+ Info "Answer"
    ???+ Info "Answer"
    ???+ Info "Answer"
    ???+ Info "Answer" -->




