# Chapter 9: 聚类

## 1. 聚类任务

在无监督学习中，训练样本的标记信息是未知的，目标是通过对无标记训练样本的学习来揭示数据的内在性质及规律，此类任务中研究最多、应用最广的是**聚类/Clustering**。聚类的目标是将数据集中的样本划分为若干个通常是不相交的子集，每个子集称为一个**簇/Cluster**。通过这样的划分，每个簇可能对应于一些潜在的概念。

形式化地说，假定样本集 $D = \{\boldsymbol{x}_1, \boldsymbol{x}_2, \ldots, \boldsymbol{x}_m\}$ 包含 $m$ 个无标记样本，每个样本 $\boldsymbol{x}_i = (x_{i1}; x_{i2}; \ldots; x_{in})$ 是一个 $n$ 维特征向量，则聚类算法将样本集 $D$ 划分为 $k$ 个不相交的簇 $\{C_l \mid l=1,2,\ldots,k\}$，其中 $C_{l^{\prime}} \bigcap_{l \neq l^{\prime}} C_l = \varnothing$ 且 $D = \bigcup_{l=1}^k C_l$。相应地，我们用 $\lambda_j \in \{1,2,\ldots,k\}$ 表示样本 $\boldsymbol{x}_j$ 的簇标记/Cluster Label，即 $\boldsymbol{x}_j \in C_{\lambda_j}$。于是，聚类的结果可用包含 $m$ 个元素的簇标记向量 $\lambda = (\lambda_1, \lambda_2, \ldots, \lambda_m)$ 表示。

## 2. 性能度量

聚类性能度量也被称为聚类有效性指标/Vailidity Index。与监督学习中的性能度量作用相似，对聚类结果，我们需通过某种性能度量来评估其好坏；另一方面，若明确了最终要使用的性能度量，则可直接将其作为聚类过程的优化目标，从而更好地得到符合要求的聚类结果。我们希望聚类的**簇内相似度**/Intra-cluster Similarity 高且**簇间相似度**/Inter-cluster Similarity 低。

聚类性能度量大致有两类。一类是将聚类结果与某个**参考模型**/Reference Model 进行比较，称为**外部指标**/External Index；另一类是直接考察聚类结果而不用任何参考模型，称为**内部指标**/Internal Index。

对于数据集 $D = \{\boldsymbol{x}_1, \boldsymbol{x}_2, \ldots, \boldsymbol{x}_m\}$，假定通过聚类给出的簇划分为 $\mathcal{C} = \{C_1, C_2, \ldots, C_k\}$，参考模型给出的簇划分为 $\mathcal{C}^* = \{C_1^*, C_2^*, \ldots, C_k^*\}$。相应地，令 $\lambda$ 与 $\lambda^*$ 分别表示与 $\mathcal{C}$ 和 $\mathcal{C}^*$ 对应的簇标记向量。我们将样本两两配对考虑，定义

$$\begin{aligned}
a &= |SS|, \enspace SS = \{(\boldsymbol{x}_i, \boldsymbol{x}_j) \mid \lambda_i = \lambda_j, \lambda_i^* = \lambda_j^*, i < j\}, \\
b &= |SD|, \enspace SD = \{(\boldsymbol{x}_i, \boldsymbol{x}_j) \mid \lambda_i = \lambda_j, \lambda_i^* \neq \lambda_j^*, i < j\}, \\
c &= |DS|, \enspace DS = \{(\boldsymbol{x}_i, \boldsymbol{x}_j) \mid \lambda_i \neq \lambda_j, \lambda_i^* = \lambda_j^*, i < j\}, \\
d &= |DD|, \enspace DD = \{(\boldsymbol{x}_i, \boldsymbol{x}_j) \mid \lambda_i \neq \lambda_j, \lambda_i^* \neq \lambda_j^*, i < j\},
\end{aligned}$$

由于每一个样本对都只能出现在一个集合中，因此有 $a + b + c + d = m(m-1)/2$ 成立。基于上述定义，可导出一些常用的聚类性能度量**外部指标**：

- **Jaccard 系数**/Jaccard Coefficient/JC：

    $$\text{JC} = \frac{a}{a + b + c}.$$

- **FM 指数**/Fowlkes and Mallows Index/FMI：

    $$\text{FMI} = \sqrt{\frac{a}{a + b} \cdot \frac{a}{a + c}}.$$

- **Rand 指数**/Rand Index/RI：

    $$\text{RI} = \frac{2(a + d)}{m(m-1)}.$$

显然，上述性能度量的结果值均在 $[0,1]$ 区间，值越大越好。

考虑聚类结果的簇划分 $\mathcal{C} = \{C_1, C_2, \ldots, C_k\}$，定义

$$\begin{aligned}
\text{avg}(C) &= \frac{2}{|C|(|C|-1)} \sum_{1 \leq i < j \leq |C|} \text{dist}(\boldsymbol{x}_i, \boldsymbol{x}_j), \\
\text{diam}(C) &= \max_{1 \leq i < j \leq |C|} \text{dist}(\boldsymbol{x}_i, \boldsymbol{x}_j), \\
d_{\min}(C_i, C_j) &= \min_{\boldsymbol{x} \in C_i, \boldsymbol{x}^{\prime} \in C_j} \text{dist}(\boldsymbol{x}, \boldsymbol{x}^{\prime}), \\
d_{\text{cen}}(C_i, C_j) &= \text{dist}(\boldsymbol{\mu}_i, \boldsymbol{\mu}_j),
\end{aligned}$$

其中，$\text{dist}(\cdot, \cdot)$ 用于计算两个样本之间的距离；$\boldsymbol{\mu}$ 代表簇 $C$ 的中心点 $\boldsymbol{\mu} = \frac{1}{|C|}\sum_{\boldsymbol{x} \in C} \boldsymbol{x}$。显然，$\text{avg}(C)$ 对应于簇 $C$ 内样本间的平均距离，$\text{diam}(C)$ 对应于簇 $C$ 内样本间的最远距离，$d_{\min}(C_i, C_j)$ 对应于簇 $C_i$ 与簇 $C_j$最近样本间的距离，$d_{\text{cen}}(C_i, C_j)$ 对应于簇 $C_i$ 与簇 $C_j$ 中心点间的距离。基于上述定义，可导出一些常用的聚类性能度量**内部指标**：

- **DB 指数**/Davies-Bouldin Index/DBI：

    $$\text{DBI} = \frac{1}{k} \sum_{i=1}^k \max_{j \neq i} \left( \frac{\text{avg}(C_i) + \text{avg}(C_j)}{d_{\text{cen}}(\boldsymbol{\mu}_i, \boldsymbol{\mu}_j)} \right).$$

- **Dunn 指数**/Dunn Index/DI：

    $$\text{DI} = \min_{1 \leq i \leq k} \left\{ \min_{j \neq i} \left\{ \frac{d_{\min}(C_i, C_j)}{\max_{1 \leq l \leq k} \text{diam}(C_l)} \right\} \right\}.$$

显然，$\text{DBI}$ 的值越小越好，而 $\text{DI}$ 则相反，值越大越好。

## 3. 距离计算

对函数 $\text{dist}(\cdot, \cdot)$，若它是一个距离度量/Distance Measure，则需满足一些基本性质：

- **非负性**/Non-negativity：$\text{dist}(\boldsymbol{x}_i, \boldsymbol{x}_j) \geq 0;$
- **同一性**/Identity：$\text{dist}(\boldsymbol{x}_i, \boldsymbol{x}_j) = 0 \Leftrightarrow \boldsymbol{x}_i = \boldsymbol{x}_j;$
- **对称性**/Symmetry：$\text{dist}(\boldsymbol{x}_i, \boldsymbol{x}_j) = \text{dist}(\boldsymbol{x}_j, \boldsymbol{x}_i);$
- **直递性**/Triangle Inequality：$\text{dist}(\boldsymbol{x}_i, \boldsymbol{x}_j) \leq \text{dist}(\boldsymbol{x}_i, \boldsymbol{x}_k) + \text{dist}(\boldsymbol{x}_k, \boldsymbol{x}_j).$

给定样本 $\boldsymbol{x}_i = (x_{i1}; x_{i2}; \ldots; x_{in})$ 与 $\boldsymbol{x}_j = (x_{j1}; x_{j2}; \ldots; x_{jn})$，最常用的是**闵可夫斯基距离**/Minkowski Distance：

$$\text{dist}_{\text{mk}}(\boldsymbol{x}_i, \boldsymbol{x}_j) = \left( \sum_{u=1}^n |x_{iu} - x_{ju}|^p \right)^{\frac{1}{p}} = \lVert \boldsymbol{x}_i - \boldsymbol{x}_j \rVert_p.$$

闵可夫斯基距离显然满足度量的四条性质，同时其对 $p$ 单调递增。

- 当 $p = 2$ 时，闵可夫斯基距离即**欧氏距离**/Euclidean Distance：

    $$\text{dist}_{\text{ed}}(\boldsymbol{x}_i, \boldsymbol{x}_j) = \lVert \boldsymbol{x}_i - \boldsymbol{x}_j \rVert_2 = \sqrt{\sum_{u=1}^n |x_{iu} - x_{ju}|^2}.$$

- 当 $p = 1$ 时，闵可夫斯基距离即**曼哈顿距离**/Manhattan Distance：

    $$\text{dist}_{\text{man}}(\boldsymbol{x}_i, \boldsymbol{x}_j) = \lVert \boldsymbol{x}_i - \boldsymbol{x}_j \rVert_1 = \sum_{u=1}^n |x_{iu} - x_{ju}|.$$

我们通常是基于某种形式的距禇来定义**相似度度量**/Similarity Measure，距离越大，相似度越小。然而，用于相似度度量的距离未必需要满足距离度量的所有基本性质，尤其是三角不等式。例如在某些任务中我们可能会定义这样的相似度度量：人和猿相似，人和人马相似，但是人马和猿不相似。这样的不满足三角不等式的距离称为**非度量距离**/Non-metric Distance。

本节中的距离计算式都是事先定义好的，但在不少现实任务中我们可能难以确定合适的距离计算式，这可通过**距离度量学习**/Distance Metric Learning 来实现。

<!--
我们常将样本属性分为"连续属性"(continuous attribute)和"离散属性"(categorical attribute)。一般情况下，属性值都定义在某个有限区间上。然而，在讨论距离计算时，属性上是否定义了"序"关系更为重要。例如定义域为 $\{1,2,3\}$ 的离散属性与连续属性的性质更接近一些，能直接在属性值上计算距离："1"与"2"比较接近，与"3"比较远，这样的属性称为"有序属性"(ordinal attribute)；而定义域为 $\{\text{飞机},\text{火车},\text{轮船}\}$ 这样的离散属性则不能直接在属性值上计算距离，称为"无序属性"(non-ordinal attribute)。显然，闵可夫斯基距离可用于有序属性。

对有序属性可采用 VDM (Value Difference Metric) [Stanfill and Waltz, 1986]。令 $m_{u,a}$ 表示在属性 $u$ 上取值为 $a$ 的样本数，$m_{u,a,i}$ 表示在第 $i$ 个样本簇中在属性 $u$ 上取值为 $a$ 的样本数，$k$ 为样本簇数，则属性 $u$ 上两个离散值 $a$ 与 $b$ 之间的 VDM 距离为

$$\text{VDM}_p(a,b) = \sum_{i=1}^k\left|\frac{m_{u,a,i}}{m_{u,a}} - \frac{m_{u,b,i}}{m_{u,b}}\right|^p.$$ (9.21)

于是，将闵可夫斯基距离和 VDM 结合即可处理混合属性。假定有 $n_c$ 个有序属性、$n-n_c$ 个无序属性，不失一般性，令有序属性排列在无序属性之前，则

$$\text{MinkovDM}_p(x_i,x_j) = $$\text{MinkovDM}_p(x_i,x_j) = \left(\sum_{u=1}^{n_c}|x_{iu}-x_{ju}|^p + \sum_{u=n_c+1}^n \text{VDM}_p(x_{iu},x_{ju})\right)^{\frac{1}{p}}.$$ (9.22)

当样本空间中不同属性的重要性不同时，可使用"加权距离"(weighted distance)。以加权闵可夫斯基距离为例：

$$\text{dist}_{\text{wmk}}(x_i,x_j) = (w_1\cdot|x_{i1}-x_{j1}|^p + \ldots + w_n\cdot|x_{in}-x_{jn}|^p)^{\frac{1}{p}},$$ (9.23)

其中权重 $w_i \geq 0(i=1,2,\ldots,n)$ 表征不同属性的重要性，通常 $\sum_{i=1}^n w_i = 1$。
-->

## 4. 原型聚类

原型/Prototype 是指样本空间中的具有代表性的点，原型聚类也称为基于原型的聚类/Prototype-based Clustering。原型聚类算法假设聚类结构能通过一组原型刻画，先对原型进行初始化，然后对原型进行迭代更新求解。采用不同的原型表示、不同的求解方式，将产生不同的算法。

## 4.1 k 均值算法



<!-- 
### 4.1 k 均值算法

给定样本集 $D = \{x_1,x_2,\ldots,x_m\}$，"k 均值"(k-means)算法针对聚类所得划分 $C = \{C_1,C_2,\ldots,C_k\}$ 最小化平方误差

$$E = \sum_{i=1}^k\sum_{x\in C_i}||x-\mu_i||_2^2,$$ (9.24)

其中 $\mu_i = \frac{1}{|C_i|}\sum_{x\in C_i}x$ 是簇 $C_i$ 的均值向量。直观来看，式(9.24)在一定程度上刻画了簇内样本围绕簇均值向量的紧密程度，$E$ 值越小则簇内样本相似度越高。

最小化式(9.24)并不容易，找到最优解需要考虑样本集 $D$ 所有可能的划分，这是一个 NP 难问题[Aloise et al., 2009]。因此，k 均值算法采用了贪心策略，通过迭代优化来近似求解式(9.24)。算法流程如图 9.2 所示，其中第 1 行对原型进行初始化，在第 4-8 行与第 9-16 行的迭代过程中，算法交替进行两个步骤：首先，对当前原型划分结果保持不变，在第 18 行将当前簇划分结果返回。

下面以表 9.1 的西瓜数据集 4.0 为例来示示 k 均值算法的学习过程。为方便起见，我们将编号为 $i$ 的样本称为 $x_i$，这是一个包含"密度"与"含糖率"两个属性值的二维向量。

假定聚类簇数 $k = 3$，算法开始时随机选取三个样本 $x_{15},x_{12},x_{27}$ 作为初始均值向量，即

$$\mu_1 = (0.463;0.237),\quad \mu_2 = (0.343;0.099),\quad \mu_3 = (0.532;0.472).$$

考察样本 $x_1 = (0.697;0.460)$，它与当前均值向量 $\mu_1,\mu_2,\mu_3$ 的距离分别为 0.369,0.556,0.166，因此 $x_1$ 将被划入簇 $C_3$；类似的，对数据集中的所有样本考察一遍后，可得当前簇划分

$$C_1 = \{x_5,x_6,x_7,x_8,x_9,x_{10},x_{13},x_{14},x_{15},x_{17},x_{18},x_{19},x_{20},x_{23}\};$$

$$C_2 = \{x_{11},x_{12},x_{16}\};$$

$$C_3 = \{x_1,x_2,x_3,x_4,x_{21},x_{22},x_{24},x_{25},x_{26},x_{27},x_{28},x_{29},x_{30}\}.$$

于是，可从 $C_1$、$C_2$、$C_3$ 分别求出新的均值向量

$$\mu_1' = (0.473;0.214),\quad \mu_2' = (0.394;0.066),\quad \mu_3' = (0.623;0.388).$$

更新当前均值向量后，不断重复上述过程，如图 9.3 所示，第五轮迭代产生的结果与第四轮迭代相同，于是算法停止，得到最终的簇划分。

### 4.2 学习向量量化

与 k 均值算法类似，"学习向量量化"(Learning Vector Quantization，简称 LVQ)也试图找到一组原型向量来刻画聚类结构，但与一般聚类算法不同的是，LVQ 假设数据样本带有类别标记，学习过程利用样本的这些监督信息来辅助聚类。

给定样本集 $D = \{(x_1,y_1),(x_2,y_2),\ldots,(x_m,y_m)\}$，每个样本 $x_j$ 是由 $n$ 个属性描述的特征向量 $(x_{j1};x_{j2};\ldots;x_{jn})$，$y_j \in \mathcal{Y}$ 是样本 $x_j$ 的类别标记。LVQ 的目标是学习得到一组 $n$ 维原型向量 $\{p_1,p_2,\ldots,p_q\}$，每个原型向量代表一个聚类簇，簇标记 $t \in \mathcal{Y}$。

LVQ 算法描述如图 9.4 所示。算法第 1 行先对原型向量进行初始化，例如对第 $q$ 个原型从类别标记为 $t_q$ 的样本中随机选取一个作为原型向量初值。算法第 2～12 行对原型向量进行迭代优化。在每一轮迭代中，算法随机选取一个有标记训练样本，找出与其距离最近的原型向量，并根据两者的类别标记是否一致来对原型向量进行相应的更新。在第 12 行中，若算法的停止条件已满足(例如已达到最大迭代轮数，或原型向量更新很小甚至不再更新)，则将当前原型向量作为最终结果返回。

显然，LVQ 的关键是第 6-10 行，即如何更新原型向量。直观上看，对样本 $x_j$，若最近的原型向量 $p_r$ 与 $x_j$ 的类别标记相同，则令 $p_r$ 向 $x_j$ 的方向靠拢，如第 7 行所示，此时新的原型向量为

$$p_r' = p_r + \eta\cdot(x_j-p_r),$$ (9.25)

$p_r'$ 与 $x_j$ 之间的距离为

$$||p_r'-x_j||_2 = ||p_r+\eta\cdot(x_j-p_r)-x_j||_2 = (1-\eta)\cdot||p_r-x_j||_2.$$ (9.26)

令学习率 $\eta \in (0,1)$，则原型向量 $p_r$ 在更新为 $p_r'$ 之后将更接近 $x_j$。

类似的，若 $p_r$ 与 $x_j$ 的类别标记不同，则新后的原型向量量与 $x_j$ 之间的距离将增大为 $(1+\eta)\cdot||p_r-x_j||_2$，从而更远离 $x_j$。

在学得一组原型向量 $\{p_1,p_2,\ldots,p_q\}$ 后，即可实现对样本空间 $\mathcal{X}$ 的簇划分。

-->

### 4.2 学习向量量化

### 4.3 高斯混合聚类

<!-- 分。对任意样本 $x$，它将被划入与其距离最近的原型向量所代表的簇中；换言之，每个原型向量 $p_i$ 定义了与其相关的一个区域 $R_i$，该区域中每个样本与 $p_i$ 的距离不大于它与其他原型向量 $p_{i'}(i'\neq i)$ 的距离，即

$$R_i = \{x\in\mathcal{X}\mid||x-p_i||_2\leq||x-p_{i'}||_2,i'\neq i\}.$$ (9.27)

由此形成了对样本空间 $\mathcal{X}$ 的簇划分 $\{R_1,R_2,\ldots,R_q\}$，该划分通常称为"Voronoi剖分"(Voronoi tessellation)。

下面我们以表 9.1 的西瓜数据集 4.0 为例来演示 LVQ 的学习过程。令 9-21 号样本的类别标记为为 $c_2$，其他样本的类别标记为 $c_1$。假定 $q = 5$，即学习目标是找到 5 个原型向量 $p_1,p_2,p_3,p_4,p_5$，并假定其对应的类别标记分别为 $c_1,c_2,c_1,c_1,c_1$。

算法开始时，根据样本的类别标记和簇的预设类别标记对原型向量进行随机初始化，假定初始化为样本 $x_{25},x_{12},x_{18},x_{23},x_{29}$。在第一轮迭代中，假定随机选取的样本为 $x_1$，该样本与当前原型向量量 $p_1,p_2,p_3,p_4,p_5$ 的距离分别为 0.283,0.506,0.434,0.260,0.032。由于 $p_5$ 与 $x_1$ 距离最近且两者具有相同的类别标记 $c_1$，假定学习率 $\eta = 0.1$，则 LVQ 更新后 $p_5$ 得到的原型向量值量

$$p_5' = p_5 + \eta\cdot(x_1-p_5)$$
$$= (0.725;0.445) + 0.1\cdot((0.697;0.460)-(0.725;0.445))$$
$$= (0.722;0.442).$$

将 $p_5$ 更新为 $p_5'$ 后，不断重复上述过程，不同轮数之后的聚类结果如图 9.5 所示。

### 4.3 高斯混合聚类

与 k 均值、LVQ 用原型向量来刻画聚类结构不同，高斯混合(Mixture-of-Gaussian)聚类采用概率模型来表达聚类原型。

我们先简单回顾一下(多元)高斯分布的定义。对 $n$ 维样本空间 $\mathcal{X}$ 中的随机向量 $x$，若其概率密度函数为

$$p(x) = \frac{1}{(2\pi)^{\frac{n}{2}}|\Sigma|^{\frac{1}{2}}}e^{-\frac{1}{2}(x-\mu)^{\text{T}}\Sigma^{-1}(x-\mu)},$$ (9.28)

其中 $\mu$ 是 $n$ 维均值向量，$\Sigma$ 是 $n\times n$ 的协方差矩阵，由式(9.28)可看出，高斯分布完全由均值向量 $\mu$ 和协方差矩阵 $\Sigma$ 这两个参数确定。为了明确显示这高斯分布与相应参数的依赖关系，将概率密度函数记为 $p(x|\mu,\Sigma)$。

我们可以定义高斯混合分布

$$p_{\mathcal{M}}(x) = \sum_{i=1}^k \alpha_i\cdot p(x|\mu_i,\Sigma_i),$$ (9.29)

该分布由 $k$ 个混合成分构成，每个混合成分对应一个高斯分布，其中 $\mu_i$ 与 $\Sigma_i$ 是第 $i$ 个高斯混合成分的参数，而 $\alpha_i > 0$ 为相应的"混合系数"(mixture coefficient)，$\sum_{i=1}^k \alpha_i = 1$。

假设样本的生成过程由高斯混合分布给出：首先，根据 $\alpha_1,\alpha_2,\ldots,\alpha_k$ 定义的先验分布选择高斯混合成分，其中 $\alpha_i$ 为选择第 $i$ 个混合成分的概率；然后，根据被选择的混合成分的概率密度函数进行采样，从而生成相应的样本。

若训练集 $D = \{x_1,x_2,\ldots,x_m\}$ 由上述过程生成，令随机变量 $z_j \in \{1,2,\ldots,k\}$ 表示生成样本 $x_j$ 的高斯混合成分，其取值未知。显然，$z_j$ 的先验概率对应于 $\alpha_i(i=1,2,\ldots,k)$。根据贝叶斯定理，$z_j$ 的后验分布对应于

$$p_{\mathcal{M}}(z_j=i|x_j) = \frac{P(z_j=i)\cdot p_{\mathcal{M}}(x_j|z_j=i)}{p_{\mathcal{M}}(x_j)} = \frac{\alpha_i\cdot p(x_j|\mu_i,\Sigma_i)}{\sum_{l=1}^k \alpha_l\cdot p(x_j|\mu_l,\Sigma_l)}.$$ (9.30)

换言之，$p_{\mathcal{M}}(z_j=i|x_j)$ 给出了样本 $x_j$ 由第 $i$ 个高斯混合成分生成的后验概率，为方便叙述，将其记为 $\gamma_{ji}(i=1,2,\ldots,k)$。

当高斯混合分布(9.29)已知时，高斯混合聚类将把样本集 $D$ 划分为 $k$ 个簇 $C = \{C_1,C_2,\ldots,C_k\}$，每个样本 $x_j$ 的簇标记 $\lambda_j$ 如下确定：

$$\lambda_j = \arg\max_{i\in\{1,2,\ldots,k\}} \gamma_{ji}.$$ (9.31)

因此，从原型聚类的角度来看，高斯混合聚类是采用概率模型(高斯分布)对原型进行刻画，划分规则则由原型对应的后验概率确定。

那么，对于式(9.29)，模型参数 $\{(\alpha_i,\mu_i,\Sigma_i)|1\leq i\leq k\}$ 如何求解呢？显然，给定样本集 $D$，可采用极大似然估计，即最大化对数似然

$$LL(D) = \ln\left(\prod_{j=1}^m p_{\mathcal{M}}(x_j)\right) = \sum_{j=1}^m\ln\left(\sum_{i=1}^k \alpha_i\cdot p(x_j|\mu_i,\Sigma_i)\right),$$ (9.32)

常采用 EM 算法进行迭代优化求解。下面我们做个简单的推导。

若参数 $\{(\alpha_i,\mu_i,\Sigma_i)|1\leq i\leq k\}$ 能使式(9.32)最大化，则由 $\frac{\partial LL(D)}{\partial \mu_i} = 0$ 有

$$\sum_{j=1}^m \frac{\alpha_i\cdot p(x_j|\mu_i,\Sigma_i)}{\sum_{l=1}^k \alpha_l\cdot p(x_j|\mu_l,\Sigma_l)}(x_j-\mu_i) = 0,$$ (9.33)

由式(9.30)以及 $\gamma_{ji} = p_{\mathcal{M}}(z_j=i|x_j)$，有

$$\mu_i = \frac{\sum_{j=1}^m \gamma_{ji}x_j}{\sum_{j=1}^m \gamma_{ji}},$$ (9.34)

即各混合成分的均值可通过样本加权平均来估计，样本权重是每个样本属于该成分的后验概率。类似的，由 $\frac{\partial LL(D)}{\partial \Sigma_i} = 0$ 可得

$$\Sigma_i = \frac{\sum_{j=1}^m \gamma_{ji}(x_j-\mu_i)(x_j-\mu_i)^{\text{T}}}{\sum_{j=1}^m \gamma_{ji}}.$$ (9.35)

对于混合系数 $\alpha_i$，除了要最大化 $LL(D)$，还需满足 $\alpha_i \geq 0$，$\sum_{i=1}^k \alpha_i = 1$。考虑 $LL(D)$ 的拉格朗日形式

$$LL(D) + \lambda\left(\sum_{i=1}^k \alpha_i-1\right),$$ (9.36)

其中 $\lambda$ 为拉格朗日乘子。由式(9.36)对 $\alpha_i$ 的导数为 0，有

$$\sum_{j=1}^m \frac{p(x_j|\mu_i,\Sigma_i)}{\sum_{l=1}^k \alpha_l\cdot p(x_j|\mu_l,\Sigma_l)} + \lambda = 0,$$ (9.37)

两边同乘以 $\alpha_i$ 对所有样本求和可知 $\lambda = -m$，有

$$\alpha_i = \frac{1}{m}\sum_{j=1}^m \gamma_{ji},$$ (9.38)

即每个高斯成分的混合系数由样本属于该成分的平均后验概率确定。

由上述推导即可得到高斯混合模型的 EM 算法：在每步迭代中，先根据当前参数来计算每个样本属于各个高斯成分的后验概率(E步)，再根据式(9.34)、(9.35)和(9.38)更新模型参数 $\{(\alpha_i,\mu_i,\Sigma_i)|1\leq i\leq k\}$ (M步)。

高斯混合聚类算法描述如图 9.6 所示。算法第 1 行对高斯混合分布的模型参数进行初始化。然后，在第 2-12 行基于 EM 算法对模型参数进行迭代更新。若 EM 算法的停止条件满足(例如已达到最大迭代轮数，或似然函数值 $LL(D)$ 增长很少甚至不再增长)，则在第 14-17 行根据高斯混合分布确定簇划分，在第 18 行返回最终结果。

以表 9.1 的西瓜数据集 4.0 为例，令高斯混合成分的个数 $k = 3$。算法开始时，假定将高斯混合分布的模型参数初始化为：$\alpha_1 = \alpha_2 = \alpha_3 = \frac{1}{3}$；$\mu_1 = x_6$，$\mu_2 = x_{22}$，$\mu_3 = x_{27}$；$\Sigma_1 = \Sigma_2 = \Sigma_3 = \begin{pmatrix}0.1 & 0.0\\ 0.0 & 0.1\end{pmatrix}$。

在第一轮迭代中，先计算样本由各混合成分生成的后验概率。以 $x_1$ 为例，由式(9.30)算出后验概率 $\gamma_{11} = 0.219$，$\gamma_{12} = 0.404$，$\gamma_{13} = 0.377$。所有样本的后验概率算完后，得到如下新的模型参数：

$$\alpha_1' = 0.361,\quad \alpha_2' = 0.323,\quad \alpha_3' = 0.316$$

$$\mu_1' = (0.491;0.251),\quad \mu_2' = (0.571;0.281),\quad \mu_3' = (0.534;0.295)$$

$$\Sigma_1' = \begin{pmatrix}0.025 & 0.004\\ 0.004 & 0.010\end{pmatrix},\quad \Sigma_2' = \begin{pmatrix}0.023 & 0.004\\ 0.004 & 0.017\end{pmatrix},\quad \Sigma_3' = \begin{pmatrix}0.024 & 0.005\\ 0.005 & 0.016\end{pmatrix}$$

模型参数更新后，不断重复上述过程，不同轮数之后的聚类结果如图 9.7 所示。 -->

## 5. 密度聚类

## 6. 层次聚类
