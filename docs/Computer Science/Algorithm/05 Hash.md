
## Hash Map

### 基本概念

**哈希表(*hash map*)**通过建立**键`key`**与**值`value`**之间的映射，实现高效的元素查询，具体而言，想哈希表输入一个键，就可以在$O(1)$时间内获得它对应的值`value`。哈希表的常见操作有：初始化、查询操作、添加键值对和删除键值对。

最简单的情况是使用一个数组实现一个哈希表，数组中的每个空位称为一个桶`bucket`，查询操作就是找到`key`所对应的桶，并且在桶中获取其`value`。

哈希表的核心之一是**哈希函数(*hash function*)**：我们输入一个`key`，就可以通过哈希函数得到这个`key`对应的数值在哈希表中的位置。简而言之，哈希函数的作用是将一个较大的输入空间映射到一个较小的输出空间。

哈希函数的计算过程分为以下两步：

- 通过某种哈希算法`hash()`计算得到哈希值。
- 将哈希值对桶数量`capacity`取模，获取这个`key`对应的索引`index`。

很多情况下，输入空间远远大于输出空间，这样**理论上一定会存在“多个输入对应着相同的输出”的情况**。我们将这种多个输入对应同一个输出的情况称为**哈希冲突(*hash collision***)。哈希冲突会导致查询结果错误，严重影响哈希表的可用性，最差的解决方法是对哈希表进行扩容，但是这样需要大量的数据搬运和重复的哈希值计算，效率很低。我们一般使用下面的两种策略：

- 改良哈希表的数据结构，**使得哈希表可以在存在哈希冲突的时候继续工作**。
- 仅仅在必要的时候，亦即当哈希冲突比较严重的时候，才执行扩容操作。

哈希表的结构改良方法包括“**链式地址**”与“**开放寻址**”。

### 链式地址

在原始的哈希表中，每个桶仅仅可以存放一个键值对，链式地址将每个桶通过链表实现，将键值对作为链表节点，将所有发生冲突的键值对都存放在一个链表中。基于链表地址实现的哈希表的操作方法发生了以下变化：

- 查询元素：输入`key`，根据哈希函数得到桶的索引，接着访问链表的头节点，遍历链表并且不断对比`key`以查找目标键值对。
-   添加元素：先通过哈希函数的结果访问链表的头节点，然后将新的节点添加到链表之中。
-   删除元素：根据哈希函数的结果访问链表的头节点，接着遍历链表以查找目标节点，并将其删除。

链式地址存在着下面的局限性：

- 占用空间增大：链表之中存在着节点指针，相比于单纯的数组更加占用存储空间。
- 查询效率变低：因为需要线性遍历链表来查找相应的元素。

### 哈希算法

哈希冲突的出现频率完全由键值对的分布情况决定，而其又直接由哈希函数决定，这是由`index = hash(key) % capacity`决定的，当哈希表容量`capacity`固定的时候，哈希算法`hash()`决定了输出值。所以哈希函数的目标就是：**一面保持哈希表使用的高效性，一面尽可能避免哈希冲突**。

首先，我们应该知道哈希算法在别的领域的应用：

- **密码存储**：系统一般不会存储用户的明文密码，而是存储密码的哈希值，如果输入的哈希值与密码的哈希值相匹配，就认为输出密码正确。
- **数据完整性检查**：数据发送方可以计算数据的哈希值并且一起发送，接收方可以重新计算接受到的数据的哈希值，并且和接收到的哈希值进行比较，如果两者匹配，就认为数据完整。

一般而言，哈希函数应该具有以下特点：

- 确定性：对于相同的输入，应该有相同的输出。这才能保证哈希表的可靠性。
- 高效性：计算哈希值的过程应该足够快，开销小。
- 均匀分布：键值对的分布越均匀，哈希冲突的发生概率就越低。

如果我们考虑到哈希函数在别的领域的应用，哈希函数也应该具有以下特点：

- 单向性：无法通过哈希值反推出有关输入数据的任何信息。
- 抗碰撞性：应该很难找到两个不同的输入，使得它们的哈希值相同。
- 雪崩效应：输入的微小变化都应当导致输出的显著的不可预测的变化。