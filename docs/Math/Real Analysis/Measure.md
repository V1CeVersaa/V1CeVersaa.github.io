# A Little Measure Theory

!!! Abstract "参考"
    - Real Analysis by Folland
    - Measure, Integration & Real Analysis by Axler


几何中的最重要的问题之一就是如何测量平面内或者空间内的一个区域的面积或体积，微积分的出现给出了一个比较满意的解决方案，但是这仅仅对于由比较简单或者漂亮的曲线或者曲面所围成的区域有效。对于更加复杂的区域，甚至稍微复杂一点的 $\mathbb{R}$ 的子集，微积分的方法就显得力不从心了。理想来说，我们希望对于任意的 $n\in\mathbb{N}$，我们都能找到一个函数 $u$，它能够将 $\mathbb{R}^n$ 的子集 $E$ 映射到一个实数 $\mu(E)\in[0, \infty)$，这个实数就是 $E$ 的 $n$ 维**测度**，当 $E$ 是一个比较漂亮的区域时，$\mu(E)$ 应该和我们熟悉的积分公式一致。这个函数 $\mu$ 应该满足以下性质：

- **可数可加性**：如果 $E_1, E_2, \ldots$ 是一列互不相交的 $\mathbb{R}^n$ 的子集，那么 $\mu\left(\bigcup\limits_{n=1}^{\infty}E_n\right) = \sum\limits_{n=1}^{\infty}\mu(E_n)$；
- **平移不变性**：对于任意的 $t\in\mathbb{R}^n$，有 $\mu(E + t) = \mu(E)$；
- **单位立方体的测度**：$\mu([0, 1)^n) = 1$。

这样定义的函数就是我们最希望测度满足的性质，简直再美好不过了，一方面可数可加性保证了我们可以证明很多与极限相关的定理，而极限恰好就是分析的核心。另一方面评议不变性和单位立方体的测度为 $1$ 保证了这样的测度恰恰就是我们直觉里的“面积”或者“体积”。我们甚至还痴心妄想这样的测度可以给所有的集合都赋予一个测度，但是这是完成不了了，这是因为下面的证明：

???+ Info "证明"
    @Folland

上面的证明指出了一个非常重大的问题：那就是不可测集是存在的，但是问题并未到此为止。我们甚至还有更严峻的问题：如果我们稍稍了解一下马上就要提到的**外测度**，我们就会发现外测度是不满足可数可加性的，但是可数可加性又至关重要，因为它是我们证明很多极限定理的基础。于是我们想稍微耍耍花样：我们尝试稍稍修改外测度的定义，使得其满足可数可加性等非常棒的性质，并且加上一点点直觉，令测度与区间的长度相配合。然而这样的测度甚至在一维也是失败的，所以就有下面令人失望的结果：

**定理**：不存在一个函数 $\mu$ 满足下面的所有性质：

- $\mu$ 是一个从 $\mathbb{R}$ 的子集到 $[0, \infty]$ 的函数；
- 对于每一个 $\mathbb{R}$ 的开区间 $I$，有 $\mu(I) = \ell(I)$，其中 $\ell$ 是区间的长度；
- 对于每一个互不相交的 $\mathbb{R}$ 的子集 $A_1, A_2, \ldots$，有 $\mu\left(\bigcup\limits_{n=1}^{\infty}A_n\right) = \sum\limits_{n=1}^{\infty}\mu(A_n)$；
- 对于每一个 $\mathbb{R}$ 的子集 $A$ 与每一个 $t\in\mathbb{R}$，有 $\mu(A + t) = \mu(A)$。

???+ Info "证明"
    @Axler

我们已经看到了，这样的花招是行不通的，这样定义的测度其实就是外测度的翻版，满足了外测度的所有性质，或者说的更清楚一点，我们必须放弃那种简单将区间的大小概念扩展到更一般的子集的测度的想法。所以我们势必需要放弃上面定理的一些性质。我们应该放弃那些性质呢？

- 首先第二个性质不可以放弃，因为就特例来讲，我们希望区间的长度与测度相符合；
- 其次第三个性质绝对不可以放弃，不然我们就放弃了那么多和极限相关的定理，这还学啥分析啊；
- 最后第四个性质也不可以放弃，因为不满足平移不变性的测度就绝不是我们直觉上的测度。

既然想好了，那么让我们开始吧。

## 测度的简单尝试：外测度

外测度是一种构造的比较失败的“测度”，但是确实是使用区间长和覆盖的方式来定义测度的一种尝试。我们来简要回顾一下：

**定义**：一个开区间 $I$ 的**区间长度**定义为

$$
\ell(I) = \begin{cases}
    b - a & \text{if } I = (a, b) \text{ for some } a, b \in \mathbb{R} \text{ and } a < b, \\
    0 & \text{if } I = \varnothing, \\
    \infty & \text{if } I = (-\infty, a) \text{ or } I = (a, \infty) \text{ for some } a \in \mathbb{R}, \\
    \infty & \text{if } I = \mathbb{R}.
\end{cases}
$$

**定义**：一个集合 $A\subset \mathbb{R}$ 的**外测度** $\lvert A\rvert$ 定义为：

$$
\lvert A\rvert = \inf\left\{\sum_{n=1}^{\infty}\ell(I_n) \mid A\subset \bigcup_{n=1}^{\infty}I_n,\enspace I_1, I_2, \ldots\text{ are open intervals of } \mathbb{R}\right\}.
$$

外测度有很多好的性质，下面列举一些：

**定理**：所有 $\mathbb{R}$ 的可数子集的外测度都是 $0$。

**定理**：如果 $A\subset B \subset\mathbb{R}$，那么 $\lvert A\rvert \leqslant \lvert B\rvert$。

**定义**：对于 $t\in \mathbb{R}$ 与 $A\subset \mathbb{R}$，定义**平移/Translation** $A + t = \{x + t \mid x\in A\}$。

**定理**：外测度满足平移不变性，也就是说，对于任意 $A\subset \mathbb{R}$ 与 $t\in \mathbb{R}$，有 $\lvert A + t\rvert = \lvert A\rvert$。

**定理**：外测度满足可数次可加性，也就是说对一列 $\mathbb{R}$ 的子集 $\left\{A_n\right\}_{n=1}^{\infty}$，有

$$
\left\lvert \bigcup_{n=1}^{\infty}A_n\right\rvert \leqslant \sum_{n=1}^{\infty}\left\lvert A_n\right\rvert.
$$

**定义**：对于 $A\subset \mathbb{R}$，定义 $A$ 的**开覆盖**为 $\mathbb{R}$ 的一族开区间 $\mathcal{C}$ 使得 $A$ 为 $\mathcal{C}$ 中所有集合的并集的子集。$A$ 的**有限子覆盖**为 $\mathcal{C}$ 的一个有限子集。

**定理**：所有 $\mathbb{R}$ 的有界闭集都有有限子覆盖。

**定理**：若 $a < b \in \mathbb{R}$，那么 $\left\lvert [a, b]\right\rvert = b - a$。
<!-- 2.14 outer measure of a closed interval
Suppose a, b ∈ R, with a < b. Then | [a, b]| = b − a -->

**定理**：外测度不满足可加性，也就是说存在不可数集 $A\subset \mathbb{R}$ 与 $B\subset \mathbb{R}$ 使得 $A\cap B = \varnothing$ 且 $\lvert A\cup B\rvert < \lvert A\rvert + \lvert B\rvert$。

<!-- 2.18 nonadditivity of outer measure
There exist disjoint subsets A and B of R such that
|A∪ B| = |A|+|B|.
 -->

## 代数基础：sigma algebra

**定理**：对于一个集合 $X$，$\mathcal{A}$ 为 $X$ 的子集的集合，那么 $X$ 上包含 $\mathcal{A}$ 的所有 $\sigma$-代数的交集是 $X$ 上的一个 $\sigma$-代数。

**定义**：$\mathbb{R}$ 上包含所有开子集的最小 $\sigma$-代数称为 $\mathbb{R}$ 上的**Borel $\sigma$-代数**，记为 $\mathcal{B}(\mathbb{R})$。Borel $\sigma$-代数的元素称为**Borel 集**。

<!-- 
We have defined the collection of Borel subsets of R to be the smallest σ-algebra on R containing all the open subsets of R. We could have defined the collection of Borel subsets of R to be the smallest σ-algebra on R containing all the open intervals (because every open subset of R is the union of a sequence of open intervals).
 -->



## 测度的一般定义

## Lebesgue 测度