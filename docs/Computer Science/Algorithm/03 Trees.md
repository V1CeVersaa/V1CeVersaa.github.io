# Chapter 3 Trees

## 3.0 Concepts and Terminology

**degree of a node**: the number of subtrees of the node.

**degree of a tree**: the maximum degree of all nodes.

**parent**: a node that has subtrees.

**children**: the roots of the subtrees of a parent.

**silblings**: the children of the same parent.

**leaf/terminal node**: a node that has no children.

**path from node A to node B**: a (unique) sequence of nodes starting from A and ending at B, such that each node is a child of the previous one.

**length of path**: the number of edges on the path.

**depth of a node**: the length of the unique path from the root to the node.

**height of a node**: the length of the **longest** path from the node to a leaf.

**height of a tree**: the height of the root.

**ancestors of a node**: all nodes on the path from the node up to the root.

**descendants of a node**: all nodes in its subtrees.

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

