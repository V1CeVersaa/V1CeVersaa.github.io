# Chapter 3 Trees

## 3.0 Concepts and Terminology

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

## 3.1 Binary Trees

A **binary tree** is a tree in which no node can have more than two children.

### 3.1.1 Node Implementation

```C
typedef struct TreeNode {
    int val;
    int height;     // Not necessary
    struct TreeNode *left;
    struct TreeNode *right;
} TreeNode;
```

### 3.1.2 Basic Operations

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

### 3.1.3 Traversals

=== "Level Order"

    层序遍历从顶部到底**逐层**遍历二叉树，并且按照从左到右的顺序遍历每一层的节点，从本质上来讲，层序遍历其实属于**广度优先遍历/Breadth-first Traversal**.我们一般借助**队列**来实现层序遍历.

    层序遍历的时间复杂度是$O(n)$，空间复杂度是$O(n)$.

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
    ```C
    void preOrder(TreeNode *root, int *size){

    }