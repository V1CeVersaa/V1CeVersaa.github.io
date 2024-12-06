# 一般凸方法

## 凸函数的定义与性质

**定义**：函数 $f$ 称为凸函数/Convex Function，如果其定义域为凸集，且对 $\forall \boldsymbol{x}, \boldsymbol{y} \in \mathrm{dom}\;f$，$\alpha \in [0, 1]$，有如下不等式成立：

$$
f(\alpha \boldsymbol{x} + (1 - \alpha) \boldsymbol{y}) \le \alpha f(\boldsymbol{x}) + (1 - \alpha) f(\boldsymbol{y})
$$

这里的凸函数定义完全不依赖于可微性，而前面我们得到的优化算法都是基于光滑函数的梯度，因此我们必须找到一个能替代梯度的东西，后面我们会看到次梯度的概念。

**定理**：函数 $f$ 是凸函数，当且仅当其上境图/Epigraph $\mathrm{epi}\;(f)$ 是凸集，这里的上境图定义如下：

$$
\mathrm{epi}\;(f) = \{(\boldsymbol{x}, t) \in \mathrm{dom}\; f \times \mathbb{R} \;|\; t \ge f(\boldsymbol{x})\}
$$

**定理**：如果 $f$ 是凸函数，那么 $f$ 的所有次水平集/Sublevel Set $\mathcal{L}_f(\beta)$ 要么是空集要么是凸集，这里的次水平集定义如下：

$$
\mathcal{L}_f(\beta) = \{\boldsymbol{x} \in \mathrm{dom}\;f \;|\; f(\boldsymbol{x}) \le \beta\}
$$

**性质**：对任何熟练到点 $\bar{\boldsymbol{x}} \in \mathrm{dom}\; f$ 的序列 $\{\boldsymbol{x}_k\} \subset \mathrm{dom}\; f$，有：$\mathop{\lim\inf}\limits_{k\to\infty} f(\boldsymbol{x}_k) \geqslant f(\bar{\boldsymbol{x}})$，这个结论也就是说 $f$ 是下半连续的；

???- Info "证明"
    注意到，序列 $\{(\boldsymbol{x}_k, f(\boldsymbol{x}_k))\}$ 属于闭集 $\mathrm{epi}\;(f)$，我们分为其有子序列收敛于

<!-- 对任何收敛到点 \bar{\boldsymbol{x}}\in\mathrm{dom}\; f 的序列 \{\boldsymbol{x}_k\}\subset\mathrm{dom}\; f ，
有： \begin{align}\mathop{\lim\inf}_{k\to\infty}f(\boldsymbol{x}_k)\ge f(\bar{\boldsymbol{x}})\end{align} （该结
论也就是说 f 是下半连续的）；
• 对任何收敛到点 \bar{\boldsymbol{x}}\not\in\mathrm{dom}\;f 的序列 \{\boldsymbol{x}_k\}\subset\mathrm{dom}\;f
，有 \begin{align} \lim_{k\to\infty}f(\boldsymbol{x}_k)=+\infty \end{align} ；
• f 的次⽔平集要么是空集，要么是闭凸的；
• 设 f 是在 Q 上的闭凸函数，且在 Q 上的次⽔平集有界，则 \begin{align} \min_{\boldsymbol{x}\in Q}f(\boldsymbol{x}) \end{align} 是可解的；
• 设 f 是在 Q 上的闭凸函数，且最优集 \begin{align}X^*=\mathop{\arg\min}_{\boldsymbol{x}\in Q}f(\boldsymbol{x})\end{align} ⾮空有界，那么 Q 上函数 f 的所有⽔平集都是空的或者有界的。
其中 \lim\inf 代表下极限，有 \begin{align} \liminf_{k\to\i -->
## 连续性与可微性

## 分离定理

## 次梯度

## 一般复杂度下界

## 性能估计

## 次梯度方法

## 有限维优化算法

