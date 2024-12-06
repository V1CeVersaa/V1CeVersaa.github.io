# Trees and Amortized Analysis

## 1 Amortized Analysis

$$
\mathrm{worst\ case\ bound} \geq \mathrm{amortized\ bound} \geq \mathrm{average\ case\ bound}
$$

<!-- ?worst-case bound≥amortized bound≥average-case bound -->

### 1.1 聚合分析

### 1.2 核算法

### 1.3 势能法

<!-- ???- Info "Example" -->

## 2 AVL Tree

AVL 数是一种平衡的二叉搜索树，我们首先约定下面一些东西：

- 空树的高度为 -1；
- 对于每个结点 `node`，其平衡因子定义为 $\textrm{BF}(\textrm{node}) =  h_L - h_R$；

所以 AVL 树就是满足以下性质的二叉搜索树：

- 一个空的二叉树是一棵 AVL 树；
- 如果 $T$ 是一棵 AVL 树，那么其左右子树也是 AVL 树，并且 $\lvert\textrm{height}(T_L) - \textrm{height}(T_R)\rvert \leq 1$，也就是其平衡因子的绝对值不超过 1。

二叉树的删除、插入都和一般的二叉搜索树没有差别：插入需要首先进行一次失败的查找来确定插入的位置，删除需要和其后继结点交换之后删除。但是两个操作都可能引起树的不平衡，换句话说就会引起某个结点的平衡因子的绝对值大于 1。这样就需要进行一些旋转操作来保持树的平衡。

### 3.2 Implementation

=== "LL Rotation"

    ```cpp
    AVLTreeNode *AVLTree::LeftLeftRotation(AVLTreeNode *k2) {
        AVLTreeNode *k1 = k2->left;
        k2->left = k1->right;
        k1->right = k2;
        k2->height = max(Height(k2->left), Height(k2->right)) + 1;
        k1->height = max(Height(k1->left), k2->height) + 1;
        return k1;
    }
    ```

=== "RR Rotation"

    ```cpp
    AVLTreeNode *AVLTree::RightRightRotation(AVLTreeNode *k1) {
        AVLTreeNode *k2 = k1->right;
        k1->right = k2->left;
        k2->left = k1;
        k1->height = max(Height(k1->left), Height(k1->right)) + 1;
        k2->height = max(Height(k2->right), k1->height) + 1;
        return k2;
    }
    ```

=== "LR Rotation"

    ```cpp
    AVLTreeNode *AVLTree::LeftRightRotation(AVLTreeNode *k3) {
        k3->left = RightRightRotation(k3->left);
        return LeftLeftRotation(k3);
    }
    ```

=== "RL Rotation"

    ```cpp
    AVLTreeNode *AVLTree::RightLeftRotation(AVLTreeNode *k1) {
        k1->right = LeftLeftRotation(k1->right);
        return RightRightRotation(k1);
    }
    ```

插入、移除和打印的代码都进行了简单的封装：

=== "Insert"

    ```cpp
    AVLTreeNode *AVLTree::Insert(int x, AVLTreeNode *tree) {
        if (tree == nullptr) {
            tree = new AVLTreeNode(x, nullptr, nullptr);
            if (tree == nullptr) {
                throw std::runtime_error("ERROR: create avltree node failed!");
            }
        } else if (x < tree->data) {
            tree->left = Insert(x, tree->left);
            if (Height(tree->left) - Height(tree->right) == 2) {
                if (x < tree->left->data) {
                    tree = LeftLeftRotation(tree);
                } else {
                    tree = LeftRightRotation(tree);
                }
            }
        } else if (x > tree->data) {
            tree->right = Insert(x, tree->right);
            if (Height(tree->right) - Height(tree->left) == 2) {
                if (x > tree->right->data) {
                    tree = RightRightRotation(tree);
                } else {
                    tree = RightLeftRotation(tree);
                }
            }
        }
        tree->height = max(Height(tree->left), Height(tree->right)) + 1;
        return tree;
    }
    ```

=== "Remove"

    ```cpp
    pass;
    ```

=== "Print"

    ```cpp
    void AVLTree::print(AVLTreeNode *tree, int key, int direction) {
        if (tree != nullptr) {
            if (direction == 0) {
                std::cout << tree->data << " is root" << std::endl;
            } else {
                std::cout << tree->data << " is " << key << "'s "
                        << (direction == 1 ? "right child" : "left child")
                        << std::endl;
            }
            print(tree->left, tree->data, -1);
            print(tree->right, tree->data, 1);
        }
    }

    void AVLTree::print() {
        if (root != nullptr) {
            print(root, root->data, 0);
        }
    }
    ```


## 3 Splay Tree

## 4 Red-Black Tree

一棵红黑树是满足下面性质的二叉搜索树：

1. 每个结点或者是红色的，或者是黑色的；
2. 根结点和每个叶结点（`NIL`）是黑色的；
3. 如果一个结点是红色的，那么它的两个子结点都是黑色的；
4. 对每个结点，从该结点到其所有后代叶结点的简单路径上，均包含相同数目的黑色结点。

这里的叶子结点 `NIL` 被重新定义了，定义成空的没有子结点的黑色结点。同时，我们称 `NIL` 为外部结点，其余有键值的结点为内部结点。合法红黑树不存在只有一个非底部结点（有两个 `NIL` 作为子结点）作为子结点的红色结点。

**性质**：一个有 $N$ 个内部节点（不包括叶子结点）的红黑树，其高度最大为 $2\log_2(N+1)$。首先显然有 $N \geq 2 \mathit{bh} - 1$，也就是 $\mathit{bh} \leq \log_2(N+1)$；然后显然有 $2^\mathit{bh} \geq \mathit{h}(\mathit{Tree})$。这就完成了证明。

**插入**：红黑树插入的核心思路是：先按照二叉搜索树的方式插入，将需要插入的结点插入到红黑树的根部，由于红色结点并不改变红黑树的黑高，所以先将插入的结点染成红色，然后再进行调整，令其满足红黑树的性质。值得注意的是，尽管红黑树有从顶向下的调整方式，但是我们这里讨论的方式都是从底



## 5 B+ Tree

B+ 树是一种多叉搜索树，每个结点通常有多个子结点。一棵 B+ 树一般包含三种结点：根结点、内部结点和叶子结点，根结点可能是一个叶子结点，也可能是一个包含两个或者两个以上孩子结点的结点。一个 $M$ 阶的 B+ 树一般满足下面性质：

- 根结点要么是叶子结点，要么有 $2$ 到 $M$ 个孩子（至多有 $M$ 个子树，2021 期中）；
- 所有非叶子结点（除了根结点）有 $\lceil M/2 \rceil$ 到 $M$ 个孩子；
- 所有叶子结点都在同一层。

对于常见的 $M$，比如 $M = 4$，我们一般称这样的树为一棵 $2$-$3$-$4$ 树。特别的，对于 B+ 树，将它的叶子结点拼接起来，实际上就是一个有序数列。由于 B+ 树在空间最浪费的情况下是一棵 $\lceil M/2 \rceil$ 叉树，所以 B+ 树的深度是 $O(\lceil \log \lceil M/2 \rceil N \rceil)$。

一般来说，B+ 树的每个结点存储的内容分为两部分，一部分是键，另一部分是键分割出的指向子树的指针，比如一棵典型的 $2$-$3$-$4$ 树的结点结构如下：

B+ 树的插入和查找都非常自然，查找只需要对着非叶子结点的键进行比较，查找正确的子树的位置，直到找到叶子结点，遍历叶子结点的每一个键就可以。决定查找的时间复杂度有两个重要因素：一个是树的高度，另一个是每一层搜索需要的时间。树的高度非常好计算，最差的情况也是每个结点都存 $\lceil M/2 \rceil$ 个结点，因此最大高度是 $O(\log_{\lceil M/2 \rceil} N)$ 的。然后每一层因为键值是排好序的，因此用二分查找找到要去哪个孩子结点，复杂度为 $O(\log_2 M)$，综合可得搜索的时间复杂度为 $O(\log N)$。

插入的方法也很简单，只需要注意一件事：如果这个插入导致了 B+ 树的性质不再成立，即导致其家长结点的子结点数量为 $M+1$ 时，我们需要将这个结点平均分裂成两个，此时显然有两个子树的结点数量都不小于 $\lceil M+1 \rceil$。但这还不够，分裂导致家长结点的家长结点的子结点变多，所以我们还得向上递归。

```c
Btree Insert ( ElementType X,  Btree T ) { 
    Search from root to leaf for X and find the proper leaf node;
    Insert X;
    while ( this node has M+1 keys ) {
        split it into 2 nodes with ceil((M+1)/2) and floor((M+1)/2) keys.
    if (this node is the root)
        create a new root with two children;
    check its parent;
    }
}
```
