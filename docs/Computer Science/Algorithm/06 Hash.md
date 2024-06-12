# Hashing

## Hash Table

**哈希表/Hash Table** 也被称为散列表，将关键字值映射到表中的一个位置来访问记录，以加快查找的速度，哈希表需要支持查找关键词是否在表中，查询关键词，插入关键词，删除关键词等操作。

哈希表通常使用一个数组来实现，哈希表的每个位置都叫做一个**桶/Bucket**，一个桶可以有多个**槽/Slot**，当多个关键字对应一个位置的时候，将不同的关键词存放在同一个位置的不同槽中。

哈希表的核心是**哈希函数/Hash Function**，我们通过哈希函数将**关键字/标识符/Identifier** 映射到哈希表中的一个位置/索引。

对于大小为 `b`，最多有 `s` 个槽的哈希表，定义 $T$ 为哈希表关键字可能的所有不同值的个数，$n$ 为哈希表中所有不同关键字的个数，关键字密度定义为 $n / T$， 装载密度定义为 $\lambda = n / (sb)$。

当存在 $i_1 \neq i_2$ 但是 $h(k_1) = h(k_2)$ 的时候，我们称发生了**碰撞/Collision**，当把一个新的标识符映射到一个已经满了的桶的时候，我们称发生了**溢出/Overflow**。

在没有溢出的情况下，哈希表的**查找**时间、**插入**时间、**删除**时间都是 $O(1)$，但是在发生溢出的情况下，哈希表的性能会下降。

哈希函数应该满足以下条件：

- 尽可能易于计算，并且减少碰撞的可能性；
- 应该均匀分布/unbiased，即 $P(h(k) = i) = 1 / b$，这样的哈希函数称之为**均匀哈希函数/Uniform Hash Fuction**；
- 对于整数的哈希，比如 $f(x) = x\ \mathrm{ mod }\ \text{Tablesize}$，其中模应该最好选择为素数，因为这样对于随机输入，关键字的分布就会变得更加均匀。

## Solving Collisions

- **分离链接/Sepatate Chaining**：把有限大小的槽换成一个链表，将哈希映射到同一个值的所有元素都保存在这个链表之中。
    ```C
    #define ElementType int
    typedef struct ListNode *Position;
    typedef struct HashTable *HashTable;
    typedef Position List;
    struct ListNode{
        ElementType val;     // Key Stored
        Position Next;       // Next Node in List 
    };
    struct HashTable{
        int TableSize;       // Size of Hash Table
        List *TheLists;      // Array of Buckets
    };
    ```
- **开放寻址/Open Addressing**：使用多个哈希函数 $h_1(x)$, $h_2(x)$, $\cdots$, $h_n(x)$，与增量函数 $f_i(x)$，其中每个哈希函数 $h_i(x)$ 都通过主哈希函数与增量函数来计算，亦即具有 $h_i(x) = \mathrm{hash}(x) + f_i(x)\ \mathrm{mod}\ \text{TableSize}$ 的形式，增量函数有很多种选择，因此衍生出不同的寻址方法，常见的有**线性探测/Linear Probing**，**二次探测/Quadratic Probing**，**双重哈希/Double Hashing** 等。使用开放寻址的哈希表的装载密度 $\lambda$ 不能超过 $0.5$，否则会导致性能下降。
- **线性探测/Linear Probing**：
- **二次探测/Quadratic Probing**：亦即增量函数 $h_i(x) = i ^ 2$，**如果使用二次探测，且表的大小为指数时，那么当表至少有一半是空的时，总能插入一个新的元素**。

