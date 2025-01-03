# Algorithms I

## 一、Inverted File Index

倒排索引/Inverted Index 是一种高效的文本检索数据结构，常用于搜索引擎和全文搜索中。它的核心思想是通过记录每个词汇/或词项）在哪些文档中出现，实现快速查找。倒排索引的结构类似于一本书的索引：先列出所有关键词，然后标注每个词出现在哪些文档中。其主要构成有两个部分：

1. 词项列表/Term List：包含所有出现在文档集中的唯一词项（即关键词）。
2. 倒排列表/Posting List：对于每个词项，记录该词项出现在哪些文档中，通常还包括位置信息（如词在文档中的位置）。

这里 *Inverted* 的意思是，相对于记录每个文档中包含哪些词汇，倒排索引是记录每个词汇出现在哪些文档中。PPT 中的典型例子是：我们可以得到一个表头为 `No.`: `Term`: `Times; (Doc ID: Places)` 的倒排索引，分别含义为：词汇出现频率的排行、词汇本身、词汇出现的次数，文档编号和位置。

Naive 的对文档中出现的每个词汇都进行索引显然是不合适的，比如一个系动词 `be` 就有 `is`、`am` 和 `are` 等等变换，并且我们对这些最常出现的词进行查找显然是不合适的，因为它们在文档中出现的频率太高。因此，我们需要对词汇进行预处理，比如进行词干提取/Word Stemming 和过滤停用词/Stop Words：

- 词干提取是一种文本归一化技术，用于将词汇还原为它们的词干/stem 或基本形式/root form。这样可以减少词项的数量，提升倒排索引的效率。
- 停用词是指在文本中频繁出现、但对文档主题或查询结果没有关键影响的词汇。常见的停用词有 the、is、and 等。这些词对内容理解或检索几乎没有贡献，因此通常会在索引过程中忽略。

搜索方式也很重要：可以使用树结构或者哈希表，哈希表查询非常快，但是范围查询就慢一点了，但是需要考虑哈希冲突；树结构查询速度慢一点，但是范围查询速度快，因为树结构是有序的。

搜索的性能衡量指标有两个：**召回率**和**准确率**。召回率（能搜索到多少）是指**检索到的相关文档数**与系统中**所有相关文档数**的比值，准确率（正确的是多少）是指**检索到的相关文档数**与**检索到的文档总数**的比值。

|               | Relevant | Irrelevant |
| :-----------: | :------: | :--------: |
|   Retrieved   |  $R_R$   |   $I_R$    |
| Not Retrieved |  $R_N$   |   $I_N$    |

这里的召回率和准确率分别为：$\dfrac{R_R}{R_R + R_N}$ 和 $\dfrac{R_R}{R_R + I_R}$。

!!! Note

    - (F) A word which has high term frequency in the whole document set must be a stop word. 因为终止词取决词的含义，而不是词频。


## 二、Backtracking

!!! Note

    - (T) What makes the time complexity analysis of a backtracking algorithm very difficult is that the number of solutions that do satisfy the restriction is hard to estimate.
        
        回溯算法的时间复杂度分析困难的原因在于满足约束条件的解的数量很难估计。

```cpp
#define __DEBUG__
using namespace std;

class Solution {
    vector<int> visited;

   public:
    void backtrack(vector<vector<int>> &res, vector<int> &nums, int index, vector<int> &perm) {
        if (index == nums.size()) {
            res.push_back(perm);
            return;
        } else {
            for (int i = 0; i < nums.size(); i++) {
                if (visited[i] || (i > 0 && nums[i] == nums[i - 1] && !visited[i - 1])) {
                    continue;
                }
                perm.push_back(nums[i]);
                visited[i] = 1;
#ifdef __DEBUG__
                cout << "DEBUG: ";
                for (int j : perm) cout << j << " ";
                cout << endl;
#endif
                backtrack(res, nums, index + 1, perm);
                visited[i] = 0;
                perm.pop_back();
            }
        }
    }

    vector<vector<int>> permuteUnique(vector<int> &nums) {
        vector<vector<int>> res;
        visited.resize(nums.size());
        vector<int> perm;
        backtrack(res, nums, 0, perm);
        return res;
    }
};
```

### Minimax Strategy & Alpha-Beta Pruning


<img class="center-picture" src="../assets/alpha-purning.png" alt="drawing" width="400" />

<!-- ![alt text](./Lec3-imgs/5-alpha-purning.png) -->


## 三、Divide & Conquer

### Substitution Method

### Recursion-tree Method

### Master Theorem

递归的时间复杂度递推公式具有如下形式：

$$
T(n) = aT(\frac{n}{b}) + f(n), \enspace a\geq 1, b\geq 2
$$

其中 $a$ 是分了多少个子问题，$b$ 与子问题划分方式有关，是子问题输入长度的收缩因子，$f(n)$ 则是合并各个子问题的解需要的时间。主定理有下面三种叙述形式：

!!! Note "原始版本"
    对于递推式 $T(n) = a T(n/b) + f(n)$，$a \geq 1, b \geq 2$，有：

    1. 若对于某个 $\varepsilon$ 有 $f(n) = O(n^{\log_b a - \varepsilon})$，则 $T(n) = \Theta(n^{\log_b a})$；
    2. 若 $f(n) = \Theta(n^{\log_b a})$，则 $T(n) = \Theta(n^{\log_b a} \log n)$；
    3. 若对于某个 $\varepsilon$ 有 $f(n) = \Omega(n^{\log_b a + \varepsilon})$，且对于某个常数 $c < 1$ 和所有足够大的 $n$ 有 $a f(n/b) \leq c f(n)$，则 $T(n) = \Theta(f(n))$。

!!! Note "Form I"

    1. 若对于某个常数 $c > 1$ 有 $a f(n/b) = c f(n)$，则 $T(n) = \Theta(n^{\log_b a})$；
    2. 若 $a f(n/b) = f(n)$，则 $T(n) = \Theta(n^{\log_b a} \log n) = \Theta(f(n) \log n)$；
    3. 若对于某个常数 $c < 1$ 有 $a f(n/b) = c f(n)$，则 $T(n) = \Theta(f(n))$。

Form I 完全可以从直观理解：

1. 第一种说明：每次分治对于 $f(n)$ 的影响很大，将它分得很小，所以复杂度由前半部分控制；
2. 第二种说明：每次分治对于 $f(n)$ 的影响适中，将它分得适中，所以复杂度是共同影响；
3. 第三种说明：每次分治对于 $f(n)$ 的影响很小，将它分得很大，所以复杂度由后半部分控制。


!!! Note "Form II"
    对于递推式 $T(n) = a T(n/b) + \Theta(n^k \log^p n)$，$a \geq 1, b > 1, k \geq 0, p \geq 0$，有：

    1. 若 $a > b^k$，则 $T(n) = \Theta(n^{\log_b a})$；
    2. 若 $a = b^k$，则 $T(n) = \Theta(n^k \log^{p+1} n)$；
    3. 若 $a < b^k$，则 $T(n) = \Theta(n^k \log^p n)$。

## 四、Dynamic Programming

动态规划（Dynamic Programming）：简称 DP，是一种求解多阶段决策过程最优化问题的方法。在动态规划中，通过把原问题分解为相对简单的子问题，先求解子问题，再由子问题的解而得到原问题的解。动态规划的核心思想是：

- 把「原问题」分解为「若干个重叠的子问题」，每个子问题的求解过程都构成一个 「阶段」。在完成一个阶段的计算之后，动态规划方法才会执行下一个阶段的计算。
- 在求解子问题的过程中，按照「自顶向下的记忆化搜索方法」或者「自底向上的递推方法」求解出「子问题的解」，把结果存储在表格中，当需要再次求解此子问题时，直接从表格中查询该子问题的解，从而避免了大量的重复计算。

能够使用动态规划方法解决的问题必须满足以下三个特征：

1. 最优子结构性质：**最优子结构**指的是一个问题的最优解包含其子问题的最优解。如果原问题的最优解包含子问题的最优解，则说明该问题满足最优子结构性质。
2. 重叠子问题性质：在求解子问题的过程中，有大量的子问题是重复的，一个子问题在下一阶段的决策中可能会被多次用到。如果有大量重复的子问题，那么只需要对其求解一次，然后用表格将结果存储下来，以后使用时可以直接查询，不需要再次求解。
3. 无后效性：子问题的解（状态值）只与之前阶段有关，而与后面阶段无关。当前阶段的若干状态值一旦确定，就不再改变，不会再受到后续阶段决策的影响。


### Matrix Chain Multiplication

<img class="center-picture" src="../assets/matrix-mul.png" alt="drawing" width="500" />

假设我们计算 $n\times n$ 个矩阵的乘法 $\mathbf{M}_1\cdots \mathbf{M}_n$​，其中 $\mathbf{M}_i$​ 是一个规模为 $r_{i-1}\times r_i$​ 的矩阵。令计算矩阵乘法 $\mathbf{M}_i\cdots \mathbf{M}_j$​ 的最优成本为 $m_{ij}$​，那么我们可以得到以下递推关系式：

$$
m_{ij} = \begin{cases} 0 & \text{if } i = j \\ \min\limits_{i\leq k < j} \{m_{ik} + m_{k+1,j} + r_{i-1}r_kr_j\} & \text{if } i < j \end{cases}
$$

计算这个

## 五、Greedy Algorithm

贪心算法每一步都考虑的局部最优。如果局部最优蕴含全局最优，那么贪心算法就是最优的。也就是证明贪心算法的正确性需要证明下面两件事：

- **贪心选择性质**：我们证明每一步都是局部最优的，贪心算法得到的每一个中间值都是最优解的一部分。
- **最优子结构性质**：我们证明每一步的最优解合并可以得到全局最优解。

### 1. 活动选择问题

给定一个活动集合 $S = \{a_1, a_2, \cdots, a_n\}$，其中每个活动 $a_i$ 都有一个开始时间 $s_i$ 和结束时间 $f_i$，且 $0\leq s_i < f_i < \infty$。如果选择活动 $a_i$ 和 $a_j$，定义其兼容为 $f_i \leq s_j$ 或者 $f_j \leq s_i$。活动选择问题就是要找到一个最大兼容活动集合。

假设输入顺序是按照 $n$ 个活动结束时间从小到大排序的，我们简单设计两种动态规划策略：

1. 设 $S_{i, j}$ 为活动 $a_i$ 和 $a_j$ 的最大兼容活动集合（开始时间在 $a_i$ 结束之后，结束时间在 $a_j$ 开始之前），且其大小为 $c_{i, j}$。那么我们可以得到递推关系式：

    $$
    c_{i, j} = \max\{c_{i, k} + c_{k, j} + 1 \;|\; f_i \leq s_k \leq f_k \leq s_j\} 
    $$

    这里的加一是因为 $S_{i, k}$ 和 $S_{k, j}$ 之间还有一个活动 $a_k$。注意到这个解法的思想更接近矩阵乘法顺序命题，我们会选择中间的最优并且分为左右子问题进行递归。

2. 设 $S_i$ 为活动 $a_1, a_2, \cdots, a_i$ 的最大兼容活动集合，设其大小为 $c_i$。那么我们可以得到递推关系式：

    $$
    c_i = \max\{c_{k(i)} + 1, c_{i-1}\}
    $$

    其中 $k(i)$ 表示在 $1\leq k \leq i$ 中 $f_k \leq s_i$ 的最大的 $k$，也就是**不与 $a_i$ 重叠的最晚结束的活动**：我们考虑最后一个活动是否在解的集合中，并且分成两种情况考虑。

第二种方式需要 $O(n^2)$ 的时间来解决，因为我们需要连续计算 $k(i)$，而第一种方式明面上需要 $O(n^3)$ 的时间来解决，但是实际上加入最优二叉搜索树的平方优化可以将复杂度降低到 $O(n^2)$。

我们来设计一个简单并且正确的贪心算法：令 $S_k = \{a_i\in S \;|\; s_i \geq f_k\}$，也就是 $S_k$ 是所有在 $a_k$ 之后开始的活动。我们作出贪心选择：首先选择 $a_1$（可以选择最早结束的活动），然后在 $S_1$ 中选择一个最早结束的活动 $a_i := \arg\min\{f_i\}$，然后继续迭代地选择接下来的活动。下面证明这个算法的正确性，也就是**活动选择问题的贪心选择性质**和**活动选择问题的最优子结构性质**：

**活动选择问题的贪心选择性质**：考虑任意非空子问题 $S_k$，令 $a_m$ 是 $S_k$ 中**结束时间最早**的活动，则 $a_m$ 在 $S_k$ 的**某个**（并不是所有）最大兼容活动子集中。

!!! Info "证明"

    使用反证法：令 $A_k$ 是 $S_k$ 的一个最大兼容活动子集，且 $a_j$ 是 $A_k$ 中**结束时间最早**的活动。若 $a_j = a_m$，那么已经证明好了；如果 $a_j \neq a_m$，那么我们可以构造一个新的集合 $A_k' = A_k - \{a_j\} \cup \{a_m\}$，这个集合中的活动显然是不相交的。直观上看，这个集合只不过是将 $a_j$ 替换为 $a_m$，而 $a_m$ 是 $S_k$ 中结束时间最早的活动，因此 $a_m$ 不可能和 $A_k$ 中的其他活动冲突。由于 $|A_k| = |A_k'|$，因此得出结论 $A_k'$ 也是 $S_k$ 的一个最大兼容活动子集，且它包含 $a_m$。这就完成了证明。

    这个证明思想被称为**交换参数法**，假设存在最优选择，且某个元素可能不在我们的贪心选择中，那么我们通过交换贪心选择和最优选择中的元素，构造出一个不差于“最优选择”的解。

**活动选择问题的最优子结构性质**：在活动选择问题中，**用贪心策略选择** $a_1$ 之后得到子问题 $S_1$，那么问题 $a_1$ 和子问题 $S_1$ 的最优解合并一定可以得到原问题的一个最优解。

!!! Info "证明"

    使用反证法：利用贪心策略选择 $a_1$ 其实意味着第一个事件的结束时间是最早的。假设 $a_1$ 和子问题 $S_1$ 的最优解合并得到的解 $C$ 不是原问题的一个最优解。假设 $C'$ 是原问题的一个最优解，且 $|C'| > |C|$，我们将 $a_1$ 替换掉 $C'$ 的第一个元素得到的解 $C''$ 一定不会使结果变差，也就是 $|C''| \geq |C'| > |C|$，那么将 $C''$ 除去 $a_1$ 后，剩余的部分其实也是子问题 $S_1$ 的一个解 $C''_1$，由于 $|C''| > |C|$，所以 $|C''_1| > |C_1|$，这和 $C_1$ 是子问题 $S_1$ 的最优解矛盾，因此原问题的最优解一定是 $a_1$ 和子问题 $S_1$ 的最优解合并得到的解。

对称地，如果我们从后往前选择最晚开始的活动，也可以得到一样的答案，但是作出的选择可能不同。

我们查看一下时间复杂度：在输入活动已经按照结束时间排序的前提下，我们只需要线性遍历一遍所有活动就可以，这样的时间复杂度是 $O(n)$。如果没有排序，我们需要 $O(n\log n)$ 的时间来排序，因此总的时间复杂度为 $O(n\log n)$。

考虑一个变种问题，**区间调度问题**：我们现在的问题不再是最大化兼容集合的大小，我们要求所有的活动都必须举办，并且将所有活动分配到最少的教室中，使得每个教室内的活动不冲突。算法和上面的很相似：我们将所有活动按照开始时间排序，设置初始教室数量为 1，然后从前往后遍历，每次选择一个活动时，我们都看当前教室有没有一间使得活动不冲突，如果有，就放到这间教室，如果没有，就新开一间教室。

!!! Example "讲义上的例子"

    <img class="center-picture" src="../assets/Greedy-1.png" alt="drawing" width="500" />

    我们可以直接断言 (a) 的解一定不是最优解，因为我们新开一个教室的条件是现存的所有教室内的活动都和这个活动冲突，可以看见在 (a) 内最多只有三个活动一起执行，所以一定有一种安排不需要第四个教室，而 (b) 正好就是这种安排。

### 2. 调度问题

假设我们有 $n$ 个任务，每个任务 $i$ 都有一个正的完成的需要时间 $l_i$ 和一个权重 $w_i$，假定我们只能串行执行这些任务，不能并行执行，显然我们有 $n!$ 种调度方法，我们要找一种算法，使得总的加权周转时间最短，这里的加权周转时间指的是 $\sum\limits_{i = 1}^{n}w_iC_i(\sigma)$，其中 $\sigma$ 是我们的调度方法，$C_i(\sigma)$ 是从整个流程开始到任务 $i$ 执行完毕的时间。所以我们就有优化问题：

$$
T = \min\limits_\sigma \sum_{i = 1}^{n} w_iC_i(\sigma)
$$

考虑一下不含权重的调度问题，我们当然是选择时间最短的任务先执行，加入了权重之后，如果所有任务的时间相同，我们应该先将权重大的任务放在前面，所以就引导我们考虑一个量 $w_i/l_i$，也就是单位时间内的权重，权重大时间短的任务的单位时间权重更大，显然是优先执行的。所以我们就设计出了一种贪心算法。

**调度问题的贪心选择性质**：令 $i$ 当前使得 $\dfrac{w_i}{l_i}$ 最大的任务，则当前问题下一定有令事件 $i$ 排在最首位的最优调度方式。

!!! Info "证明"
    还是使用交换参数法，如果存在最优解使得事件 $i$ 在首位，那么证明完毕；反之，我们将事件 $i$ 和前面一个事件 $j$ 交换，注意到交换前后其余时间的加权周转时间是不变的，而很容易证明交换后对时间 $i$ 和事件 $j$ 的“局部”周转时间是递减的，所以交换后的解一定不差于最优解。这就保证了我们的贪心选择性质。

**调度问题的最优子结构性质**：在调度问题 S 中，我们使用贪心策略首先选择了最大的 $\dfrac{w_i}{l_i}$ 的任务 $i$，那么剩下的子问题 $S_1$（在除了 $i$ 之外的任务重寻找一个最小化加权周转时间之和的解）的最优解 $C_1$ 和 $i$ 的最优解合并一定可以得到原问题的一个最优解。

!!! Info "证明"
    很简单的反证法：如果 $C$ 不是最优解，就一定有一个最优解 $C'$ 使得对应的加权周转时间 $T' < T$，那么我们将 $C'$ 中的任务 $i$ 不断交换到最前面，情况就一定不会变差，所以剩下的就是 $S_1$ 的另一个解 $C_1'$，但是这个解要比 $C_1$ 更优，这就和 $C_1$ 是最优解矛盾。

### 3. 贪心算法的范式

贪心算法通过作出一系列选择来求出问题的最优解，在每一个决策点，贪心算法作出其当前看来最优的选择，这种启发式策略并不保证一定会找到最优解，但是对一些问题确实有效。下面是设计贪心算法的范式：

- 将最优化问题转换成下面形式：做出一次选择后，只剩下一个子问题需要求解；
- 证明作出贪心选择之后，原问题总是存在最优解；
- 证明作出贪心选择后，剩下的子问题满足最优子结构性质。 

大多数问题来讲，贪心选择性质和最优子结构性质是两个关键因素：贪心选择性质保证我们可以通过局部最优解来构造全局最优解，在选择的时候，可以直接作出当前问题看来最优的选择，而不必考虑子问题的解；最优子结构问题保证了将子问题的最优解和贪心选择结合到一起的确可以生成原问题的最优解。

### 4. Huffman 编码

!!! Note

    - (T) A binary tree that is not full cannot correspond to an optimal prefix code.
    
        A **full binary tree** is a tree in which every node has either zero children or two children. And in this definition, the problem is trivial.

Huffman 编码试图找到一个字母表期望长度最小的前缀编码，回忆香农定义的信息熵：对于一个离散随机变量 $X$，其信息熵定义为 $H(X) = -\sum\limits_{x}p(x)\log_2p(x)$，其中 $p(x)$ 是 $X$ 取值为 $x$ 的概率。使用以 2 为底的对数是为了保证信息熵的单位是比特，在平均意义下，信息熵可以理解为对于一个随机变量 $X$，我们需要多少比特来表示它。举个例子：

!!! Example "PPT 上的例子"
    假定有 8 匹马参加的一场赛马比赛，它们的获胜概率分别为 $(\dfrac{1}{2}, \dfrac{1}{4}, \dfrac{1}{8}, \dfrac{1}{16}, \dfrac{1}{64}, \dfrac{1}{64}, \dfrac{1}{64}, \dfrac{1}{64})$，那么这场比赛的信息熵为 $H(X) = -\sum\limits_{i = 1}^{8}p_i\log_2p_i = 2$。如果我们要把哪匹马会赢的信息告诉给别人，其中一个策略是发送胜出的马的编号，这样对于任何一匹马都需要 3 个比特。但由于概率不是均等的，明智的方法是对概率大的马用更短的编码，对概率小的马用更长的编码。例如使用以下编码：$0, 10, 110, 1110, 111100, 111101, 111110, 111111$，这样平均每匹马需要 2 个比特，比等长的比特数更短。

通常使用一棵二叉树来进行字符译码，这种树被称为字典树/Trie。若是所有的字符都位于字典树的叶子节点，不会位于内部节点，这也就保证了这样的编码是前缀编码，也就是任何一个字符的编码都不是另一个字符的前缀，树上的 01 编码被称为前缀码。

我们使用这样的方法构造 Huffman 编码树：

1. 统计待编码字符的频率，根据统计出来的频率构建一个最小堆，堆中的每一个元素是一个节点，节点的值为字母的频率，我们要在这个优先队列中快速取出频率最小的两个节点；
2. 从最小堆中反复取出两个频率最小的节点，创建两个节点的父节点，父节点不代表任何一个字母，但是其有值，这个值为两个字节点频率之和，这个过程不断重复，知道堆只剩下一个节点为止，这个节点就是 Huffman 树的根节点；
3. 从 Huffman 树的根节点开始，对于每一个叶子节点，我们可以得到一个编码，如果左子树是 0，右子树是 1，那么从根节点到这个叶子节点的路径就是这个叶子节点的编码。

伪代码如下：

```C
void Huffman (PriorityQueue heap[ ], int C){
    consider the C characters as C single node binary trees,
    and initialize them into a min heap;
    for (i = 1; i < C; i++) { 
        create a new node;
        /* be greedy here */
        delete root from min heap and attach it to left_child of node;
        delete root from min heap and attach it to right_child of node;
        weight of node = sum of weights of its children;
        /* weight of a tree = sum of the frequencies of its leaves */
        insert node into min heap;
   }
}
```

下面证明 Huffman 编码的正确性：

**Huffman 编码的贪心选择性质**：设 $C$ 为一个字母表，其中每个字符 $c\in C$ 都有一个频率 $c.freq$，令 $x$ 和 $y$ 是 $C$ 中频率最低的两个字符。那么存在 $C$ 的一个最优前缀码，$x$ 和 $y$ 的码字长度相同，且只有最后一个二进制位不同。

!!! Info "证明"
    我们的思路是交换参数：令 $T$ 表示任意一个最优前缀码所对应的编码树，对其进行修改，得到表示另外一个最优前缀码的编码树，使得在新树中，$x$ 和 $y$ 是深度最大的叶结点，且它们为兄弟结点。如果可以构造这样一棵树，那么 $x$ 和 $y$ 的码字将有相同长度，且只有最后一位不同。而构造这棵树的代价是极其低的，如果最优解对应的编码树是 $T$，若 $x$ 和 $y$ 所在的节点确实是最深的叶子节点，这就正好是我们想要的，反之，我们就将最深的两个叶子节点和 $x$ 与 $y$ 交换，这样构造出的编码树的代价就一定小于等于原来的树，而原来的树是最优的，因此新的树必定也是最优的。

**Huffman 编码的最优子结构性质**：设 $C$ 为一个字母表，其中每个字符 $c\in C$ 都有一个频率 $c.freq$，令 $x$ 和 $y$ 是 $C$ 中频率最低的两个字符。令 $C'$ 为 $C$ 去掉字符 $x$ 和 $y$，加入一个新字符 $z$ 后的字母表。我们给 $C'$ 也定义频率集合，不同之处只是 $z.freq = x.freq + y.freq$。令 $T'$ 为 $C'$ 的任意一个最优前缀码树，那么我们可以将 $T'$ 中叶结点 $z$ 替换为一个以 $x$ 和 $y$ 为孩子的内部结点得到一个 $C$ 的一个最优前缀码树 $T$。

!!! Info "证明"
    记 $B(T)$ 为树 $T$ 的代价，即所有字母的期望编码长度。为事实上我们很容易验证 
    
    $$
    B(T') = B(T) - x.freq - y.freq,
    $$
    因为 $T'$ 就相当于把 $T$ 中 $x$ 和 $y$ 的频率代价上移一层。
    
    然后我们可以用反证法证明这一引理。假设 $T$ 不是 $C$ 的最优前缀编码树，即存在树 $T''$ 使得 $B(T'') < B(T)$。根据前面的引理，我们将 $T''$ 中的 $x$ 和 $y$ 和它们的父结点替换成 $z$，得到一个新树 $T'''$，其中 $z.freq = x.freq + y.freq$。
    
    那么我们有 $B(T''') = B(T'') - x.freq - y.freq < B(T) - x.freq - y.freq = B(T')$，这与 $T'$ 是 $C'$ 的最优前缀编码树矛盾。因此我们的假设是错误的，$T$ 必定是 $C$ 的最优前缀编码树。
