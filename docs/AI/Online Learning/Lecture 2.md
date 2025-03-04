# Topic 2: Multi-Armed Bandits


## 1 多臂赌博机问题

到目前为止，我们讨论的所有主题都考虑了具有完整信息反馈的问题。从本讲开始，我们将转向更具挑战性的部分信息反馈设置。这类问题的经典例子是多臂赌博机问题，这里我们讨论 [Auer et al., 2002] 引入的对抗性版本。

该问题模拟了一个赌徒在赌场中连续拉动一台老虎机/Slot Machine 的手柄，希望最大化奖励的情况。一台老虎机有时被称为“单臂赌博机”，因此这个问题被称为多臂赌博机。形式上，学习者有 $K$ 个可用的臂/动作，在每个时间点 $t = 1, \ldots, T$，

1. 学习者选择一个动作 $a_t \in [K]$，同时环境决定损失向量 $\ell_t \in [0, 1]^K$，
2. 学习者随后遭受并观察损失 $\ell_t(a_t)$。

显然，这只是专家问题的部分信息版本，区别在于学习者必须在每轮实际选择一个动作，然后只观察该动作的损失，而不是整个损失向量$\ell_t$。按照惯例，我们从记号 $i$ 和 $N$ 转换为 $a$ 和 $K$，分别表示特定动作和动作总数。

为简单起见，我们只考虑遗忘环境/oblivious environment，因此可以等价地认为损失向量是在游戏开始前生成的（尽管可能是随机生成的）。我们通过期望遗憾来衡量算法的性能

$$\mathbb{E}[\mathcal{R}_T] = \mathbb{E}\left[\sum_{t=1}^T \ell_t(a_t)\right] - \min_{a\in[K]} \sum_{t=1}^T \ell_t(a),$$

其中期望是相对于算法的随机性。

这个问题（或一般的部分信息问题）的挑战在于众所周知的**探索-利用权衡/Exploration-Exploitation Tradeoff**。一方面，选择之前遭受小损失的动作很诱人（利用），但另一方面，也有动机选择其他动作，看看它们是否能有更小的损失（探索）。

但由于这个问题与专家问题如此接近，让我们首先看看是否可以用专家算法来解决它。明显的障碍是我们没有完整的损失向量来输入专家算法。然而，假设我们根据分布$p_t$选择$a_t$，那么我们可以按以下方式构造损失向量的估计器

$$\hat{\ell}_t(a) = \frac{\ell_t(a)}{p_t(a)}\mathbf{1}\{a = a_t\} = \begin{cases}
\frac{\ell_t(a_t)}{p_t(a_t)} & \text{如果 } a = a_t, \\
0 & \text{否则}.
\end{cases}$$

这个简单技巧被称为逆倾向得分加权（inverse propensity score weighting）或简称为重要性加权（importance weighting）。显然，这个估计器可以使用可用信息计算，更重要的是，它是无偏的：对于任何$a \in [K]$，

$$\mathbb{E}_t[\hat{\ell}(a)] = (1 - p_t(a)) \times 0 + p_t(a)\frac{\ell_t(a)}{p_t(a)} = \ell_t(a)$$

其中$\mathbb{E}_t[\cdot]$是给定过去的$a_t$随机抽取的条件期望。因此，由于我们（至少现在）只关心期望遗憾，似乎我们可以简单地使用任意专家算法的预测$p_t$来抽取$a_t$，然后将$\hat{\ell}_t$输入该算法。确实，对于任何$a \in [K]$，我们有

$$\mathbb{E}\left[\sum_{t=1}^T \ell_t(a_t)\right] - \sum_{t=1}^T \ell_t(a) = \mathbb{E}\left[\sum_{t=1}^T \langle p_t, \hat{\ell}_t \rangle - \sum_{t=1}^T \hat{\ell}_t(a)\right]$$

其中最后一项正是专家算法的（期望）遗憾。我们已经证明专家问题的最优遗憾是$\mathcal{O}(\sqrt{T \ln K})$。这是否意味着我们已经为多臂赌博机问题找到了一个具有$\mathcal{O}(\sqrt{T \ln K})$遗憾的简单算法？

答案是否定的 —— 我们在上述论证中忽略的是，专家算法接收的损失范围不再是$[0, 1]$！实际上，由于重要性加权，损失可能非常大，因此遗憾不再仅仅是$\mathcal{O}(\sqrt{T \ln K})$。作为一个简单的修复，我们可以通过进行少量均匀探索来强制对重要性权重设置下界

$$p_t = (1 - \alpha)\hat{p}_t + \frac{\alpha}{K}\mathbf{1} \tag{1}$$

其中$\hat{p}_t$现在是专家算法的预测，$\mathbf{1}$是全1向量，$\alpha$是稍后要指定的参数。那么显然我们有$\hat{\ell}(a) \leq K/\alpha$，因此如果我们将$\frac{\alpha}{K}\hat{\ell}_t \in [0, 1]^K$输入专家算法，我们有

$$\begin{aligned}
\mathbb{E}\left[\sum_{t=1}^T \langle p_t, \hat{\ell}_t \rangle - \sum_{t=1}^T \hat{\ell}_t(a)\right] &\leq \frac{\alpha}{K}\mathbb{E}\left[\sum_{t=1}^T \hat{\ell}_t(a_t)\right] + \mathbb{E}\left[\sum_{t=1}^T \langle \hat{p}_t, \hat{\ell}_t \rangle - \sum_{t=1}^T \hat{\ell}_t(a)\right] \\
&\leq \alpha T + \frac{K}{\alpha}\mathbb{E}\left[\sum_{t=1}^T \left\langle \hat{p}_t, \frac{\alpha}{K}\hat{\ell}_t \right\rangle - \sum_{t=1}^T \frac{\alpha}{K}\hat{\ell}_t(a)\right] \\
&= \mathcal{O}\left(\alpha T + \frac{K}{\alpha}\sqrt{T \ln K}\right)
\end{aligned}$$

其中第二步是由$\mathbb{E}_t[\hat{\ell}_t(a_t)] = \sum_{a=1}^K p_t(a)\frac{\ell_t(a)}{p_t(a)} = \sum_{a=1}^K \ell_t(a) \leq K$，最后一步是通过应用专家算法的遗憾界。最后，通过选择最优的$\alpha$，我们得到阶为$\mathcal{O}(T^{\frac{2}{3}}K^{\frac{1}{3}}(\ln K)^{\frac{1}{3}})$的遗憾界，这比完整信息设置的最优界要大得多。因此，尽管重要性加权估计器是无偏的，而且我们只关心期望中的遗憾，但估计器的范围或实际上是方差仍然很重要。
