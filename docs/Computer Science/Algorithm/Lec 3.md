# Algorithms

## Inverted File Index

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

## Backtracking

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


## Divide & Conquer

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

## Dynamic Programming

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

## Greedy Algorithm

## NP-Completeness

## Approximation Algorithm

## Local Search

## Randomized Algorithm

## Parallel Algorithm

## External Sorting
