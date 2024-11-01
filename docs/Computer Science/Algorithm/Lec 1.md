# Balanced Tree and Amortized Analysis

## 1 Amortized Analysis

### 1.1 聚合分析

### 1.2 核算法

### 1.3 势能法

<!-- ???- Info "Example" -->

## 2 AVL Tree

AVL 数是一种平衡的二叉搜索树，我们首先约定下面一些东西：

- 空树的高度为 $-1$；
- 对于每个节点 `node`，其平衡因子定义为 $\textrm{BF}(\textrm{node})\coloneqq h_L - h_R$；

所以 AVL 树就是满足以下性质的二叉搜索树：

- 一个空的二叉树是一棵 AVL 树；
- 如果 $T$ 是一棵 AVL 树，那么其左右子树也是 AVL 树，并且 $\lvert\textrm{height}(T_L) - \textrm{height}(T_R)\rvert \leq 1$；

二叉树的删除、插入都和一般的二叉搜索树没有差别：插入需要首先进行一次失败的查找来确定插入的位置，删除需要和其后继节点交换之后删除。但是两个操作都可能引起树的不平衡，换句话说就会引起某个节点的平衡因子的绝对值大于 1。这样就需要进行一些旋转操作来保持树的平衡。

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

## 5 B+ Tree

B+ 树是一种多叉排序树，每个节点通常有多个子节点。一棵 B+ 树一般包含三种节点：根节点、内部节点和叶子节点，根节点可能是一个叶子节点，也可能是一个包含两个或者两个以上孩子节点的节点。一个 $M$ 阶的 B+ 树一般满足下面性质：

- 根节点要么是叶子节点，要么有 $2$ 到 $M$ 个孩子；
- 所有非叶子节点（除了根节点）有 $\lceil M/2 \rceil$ 到 $M$ 个孩子；
- 所有叶子节点都在同一层；
- 假设每个非根叶子节点也有 $\lceil M/2 \rceil$ 到 $M$ 个孩子；
