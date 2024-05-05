# Trees

## Concepts and Terminology

**Degree of a node**: the number of subtrees of the node.

**Degree of a tree**: the maximum degree of all nodes.

**Parent**: a node that has subtrees.

**Children**: the roots of the subtrees of a parent.

**Silblings**: the children of the same parent.

**Leaf/terminal node**: a node that has no children.

**Path from node A to node B**: a (unique) sequence of nodes starting from A and ending at B, such that each node is a child of the previous one.

**Length of path**: the number of edges on the path.

**Depth of a node**: the length of the unique path from the root to the node.

**Height of a node**: the length of the **longest** path from the node to a leaf.

**Height of a tree**: the height of the root.

**Ancestors of a node**: all nodes on the path from the node up to the root.

**Descendants of a node**: all nodes in its subtrees.

Every tree can be transformed into a binary tree with **FirstChild-NextSibling** representation.

## 1 Binary Trees

A **binary tree** is a tree in which no node can have more than two children.

**Expression Trees**: a binary tree used to represent expressions. Interesting.

### 1.1 Node Implementation

```C
typedef struct TreeNode {
    int val;
    int height;     // Not necessary
    struct TreeNode *left;
    struct TreeNode *right;
} TreeNode;
```

### 1.2 Basic Operations

!!! info
    这种版本的节点的定义包括了节点的高度，但是在一般的树中，这是没有必要的，只是在AVL树中，节点高度才尤其重要.在下面的操作中就干脆省略了.

=== "Constructor"
    ```C
    TreeNode *newTreeNode(int val) {
        TreeNode *node;
        node = malloc(sizeof(TreeNode));
        node->val = val;
        node->left = NULL;
        node->right = NULL;   
        return node;
    }
    ```

=== "Insertion and Deletion"
    这是在`n1->n2`中插入新节点`p`或者删除这个节点的操作.

    ```C
    TreeNode *p = newTreeNode(1);
    p->left = n2;
    n1->left = n1;

    TreeNode *del = p;
    n1->left = n2;
    free(del);
    ```

### 1.3 Traversals

遍历时间复杂度都是$O(n)$，迭代的空间复杂度是$O(n)$.

=== "Levelorder"

    层序遍历从顶部到底**逐层**遍历二叉树，并且按照从左到右的顺序遍历每一层的节点，从本质上来讲，层序遍历其实属于**广度优先遍历/Breadth-first Traversal**.我们一般借助**队列**来实现层序遍历.

    ```C
    int *levelOrder (TreeNode *root, int *size) {
        int front, rear;
        int index, *arr;
        TreeNode *node;
        TreeNode **queue = malloc(sizeof(TreeNode *) * MAX_SIZE);
        front = rear = 0;
        
        queue[rear++] = root;
        int *arr = malloc(sizeof(int) * MAX_SIZE);
        while (front < rear) {
            node = queue[front++];
            arr[index++] = node->val;
            if (node->left != NULL){
                queue[rear++] = node->left;
            }
            if (node->right != NULL){
                queue[rear++] = node-right;
            }
        }
        *size = index;
        arr - realloc(arr, sizeof(int) * index);
        free(queue);
        return arr;
    }
    
    ```

=== "Preorder"

    先访问根节点，再访问子树，左子树优先于右子树.

    ```C
    int *arr = malloc(sizeof(int) * MAX_SIZE);
    void preOrder(TreeNode *root, int *size, int *arr) {
        if (root == NULL)
            return;
        arr[(*size)++] = root->val;
        preOrder(root->left, size, arr);
        preOrder(root->right, size, arr);
    }
    arr = realloc(arr, sizeof(int) *(*size));
    ```

=== "Postorder"

    先访问子树，左子树先于右子树，再访问根节点.

    ```C
    void postOrder(TreeNode *root, int *size) {
        if (root == NULL)
            return;
        postOrder(root->left, size);
        postOrder(root->right, size);
        arr[(*size)++] = root->val;
    }
    ```

=== "Inorder & Recursive"

    先访问左子树，再访问根，最后访问右子树.

    ```C
    void inOrder(TreeNode *root, int *size) {
        if (root == NULL)
            return;
        inOrder(root->left, size);
        arr[(*size)++] = root->val;
        inOrder(root->right, size);
    }
    ```

=== "Inorder & Iterative"

    什么？你还想折磨自己？
    
    你需要在循环里边手动建一个堆栈来模仿系统堆栈的行为，想想都觉得受不了，消停写你的迭代版得了。

## 2 Binary Search Trees

二叉搜索树满足以下性质：

- 所有的节点都有一个以整数表示的键值，且互不相同；
- 所有左节点

=== "Find"

    ```C
    TreeNode *rec_find(TreeNode *root, int val) {
        if (root == NULL)
            return NULL;
        if (root->val < val)
            return find(root->right, val);
        else if (root->val > val)
            return find(root->left, val);
        else
            return root;
    ```

    ```C
    TreeNode *ite_find(TreeNode *root, int val) {
        while (root != NULL) {
            if (root->val < val)
                root = root->right;
            else if (root->val > val)
                root = root->left;
            else
                return root;
        }
        return NULL;
    }
    ```

=== "Find Min/Max"

    ```C
    TreeNode *ite_findMin(TreeNode *root) {
        if (root == NULL)
            return NULL;
        while (root->left != NULL)
            root = root->left;
        return root;
    }
    ```

    ```C
    TreeNode *rec_findMin(TreeNode *root) {
        if (root == NULL)
            return NULL;
        if (root->left == NULL)
            return root;
        return findMin(root->left);
    }
    ```

    ```C
    TreeNode *findMax(TreeNode *root) {
        if (root == NULL)
            return NULL;
        while (root->right != NULL)
            root = root->right;
        return root;
    }
    ```
    
    ```C
    TreeNode *rec_findMax(TreeNode *root) {
        if (root == NULL)
            return NULL;
        if (root->right == NULL)
            return root;
        return findMax(root->right);
    }
    ```

=== "Insert"

    ```C
    TreeNode *insert(TreeNode *root, int val) {
        if (root == NULL) {
            root = newTreeNode(val);
        } else if (root->val < val) {
            root->right = insert(root->right, val);
        } else if (root->val > val) {
            root->left = insert(root->left, val);
        }
    }
    ```

## 3 Heap/Priority Queue

### 3.1 Binary Heap

二叉堆首先是一个满足**堆性质**的完全二叉树，对于最大堆为例，所谓堆性质是：某个树的所有子树的根节点值都大于等于子节点值。同理，我们可以定义最小堆。

### 3.2 Heap Implementation

堆其实是一个完全二叉树，完全二叉树又很容易表示成数组，所以堆基于数组来实现，但是存储数组的时候很有讲究：数组的元素代表二叉树的节点值，索引代表层序遍历中节点在二叉树中的位置，所有的索引将由 `1` 开始，这样就可以很方便的通过索引来找到节点的父节点和子节点。下面是获取父节点、左子节点、右子节点的函数：

=== "getParent"

    ```c
    int getParent(int i) {
        return i / 2;
    }
    ```

=== "getLeft"

=== "getRight"

## 4 Disjoint Set

并查集只不过是数据结构画在图上很像树