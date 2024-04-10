# Chapter 4 Heap/Priority Queue

## 4.1 ADT Model

Heap/Priority Queue

- Object: A finite ordered list with zero or more elements.
- Operations:
  - `PriorityQueue Initialize(int MaxElements)`: Create and return an empty priority queue.
  - `void Insert(ElementType X, PriorityQueue H)`: Insert the element X into the priority queue H.
  - `ElementType DeleteMin(PriorityQueue H)`: Delete the minimum element from the priority queue H.
  - `ElementType FindMin(PriorityQueue H)`: Return the minimum element from the priority queue H.
- Order Property: The priority queue H is a min-heap if for every node X with parent P in H, the key in P is less than or equal to the key in X, and is a max-heap if the key in P is greater than or equal to the key in X.
- Heap Property: A binary heap is a complete binary tree that satisfies the heap order property.

## 4.2 Binary Heap

### 4.2.1 Heap Implementation

堆其实是一个完全二叉树，完全二叉树又很容易表示成数组，所以堆基于数组来实现，但是存储数组的时候很有讲究：数组的元素代表二叉树的节点值，索引代表层序遍历中节点在二叉树中的位置，所有的索引将由 `1` 开始，这样就可以很方便的通过索引来找到节点的父节点和子节点。下面是获取父节点、左子节点、右子节点的函数：

=== "getParent"

    ```c
    int getParent(int i) {
        return i / 2;
        }
    ```

=== "getLeft"

=== "getRight"