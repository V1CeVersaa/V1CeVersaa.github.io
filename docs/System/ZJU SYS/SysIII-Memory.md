# ZJU System III: Memory Hierarchy

## 内存类型与局部性原理

根据用途的差别，我们可以将内存层次结构分为：寄存器/Register、高速缓存/Cache、主存/Main Memory、磁盘/Disk。

根据介质的不同，我们可以看见下面这些可能的介质：

- 机械存储器：声波/扭矩波延迟线存储器、磁芯存储器、磁鼓存储器；
- 电子存储器：SRAM/静态随机存取存储器（速度快，成本高）、DRAM/动态随机存取存储器（主存常用技术）、SDRAM/同步动态随机存取存储器、Flash/闪存、ROM/只读存储器。
- 光学存储器。

<img class="center-picture" src="../assets_mem/1.png" width=500 />

- **时间局部性/Temporal Locality**：如果一个数据项被引用，他在不就得将来很可能会被再次引用。
- **空间局部性/Spatial Locality**：如果一个数据项被引用，那么与它相邻的数据项也很可能被引用。

## Cache

Cache：最初定义为 A safe place for hiding or storing things.

- 地址离开处理器后访问的第一个/最高的内存层次结构；
- 利用缓冲技术复用常用的数据项，提升访问速度。

Cache Hit/Miss：处理器能/不能在缓存中找到请求的数据。性能指标包括：命中率/Hit Rate、缺失率/Miss Rate、命中时间/Hit Time、缺失惩罚/Miss Penalty。

Block/Line Run：对 Cache 管理的基本单位。A fixed collection of data containing the requested word, received from the main memory and placed into the cache.

Cache 充分利用了内存架构的局部性原理：

- 时间局部性：访问过的数据在时间尺度上很快就会被再次访问；
- 空间局部性：接下来需要访问的数据很可能是和当前访问的数据是临近的。

缓存缺失的时间开销来自于两个方面：

- 响应时间/Latency：获取该块的第一个字的时间；
- 带宽/Bandwidth：获取该块的剩余字的时间。

缓存缺失的原因：

- 强制性缺失/Compulsory：第一次引用对应的数据块的时候会发生；
- 容量性缺失/Capacity：缓存空间有限，数据块被丢弃后又被访问；
- 冲突性缺失/Conflict：程序重复引用映射到缓存的同一位置的不同数据块。

缓存的本质是用于提升对慢速内存访问时间的小型快速存储器，在计算机架构中无处不在，比如：

- 寄存器：软件管理着的变量的缓存；
- 一级缓存是二级缓存的缓存；
- 二级缓存是主存的缓存；
- 内存是磁盘/虚拟内存的缓存；
- TLB 是页表的缓存，分支预测器甚至是指令缓存的缓存。

下面是一个典型的内存系统：

<img class="center-picture" src="../assets_mem/2.png" width=500 />

Cache 设计的核心问题：我们如何知道访问的数据是否在 Cache 内？如果在的话，我们怎么知道它在 Cache 的哪个位置？如果不在的话，我们应该将哪些数据块从缓存中丢弃？

## Topic 1: Block Placement

> Where can a block be placed in the upper level/main memory?
>
> Fully Associative, Set Associative, Direct Mapped

**Direct Mapped**/直接映射缓存：一个内存块只能出现在缓存的一个特定的位置，映射函数通常是 $\mathrm{Cache Index} = \mathrm{Block Address} \mod \mathrm{Cache Size}$。

<!-- 

  * 分支预测器缓存预测信息

## 缓存组织结构
- **多级缓存组织**：通常包括L1指令/数据缓存、L2统一缓存、主内存和磁盘
- **分离式与统一式缓存**：
  * **统一缓存**：所有内存请求通过单一缓存，硬件需求少但性能较低
  * **分离式I&D缓存**：指令和数据使用单独缓存，需要额外硬件但有优化（指令缓存只读）
- **Intel Pentium缓存示例**：
  * 片上L1指令缓存：4路组相联，32字节块，128组，16KB
  * 片上L1数据缓存：4路组相联，32字节块，128组，16KB
  * 片外L2统一缓存：4路组相联，32字节块，1024-16384组，128KB-2MB

## 缓存设计四大问题
1. **数据块放置问题**（Block placement）：
   * 数据块可放在哪里？（全相联、组相联、直接映射）
2. **数据块标识问题**（Block identification）：
   * 如何找到缓存中的数据块？（标记/块号）
3. **数据块替换问题**（Block replacement）：
   * 缓存缺失时替换哪个数据块？（随机、LRU、FIFO）
4. **写策略问题**（Write strategy）：
   * 写操作如何处理？（写回或写直达，配合写缓冲）

这些概念共同构成了现代计算机系统中缓存和内存层次结构的基础，是提高系统性能的核心技术。
 -->

## Topic 2: Block Identification

> How is a block found if it is in the upper level/main memory?
>
> Tag/Block Number

## Topic 3: Block Replacement

> Which block should be replaced on a Cache/main memory miss?
>
> Random, LRU, FIFO

## Topic 4: Write Strategy

> What happens on a write?
>
> Write-through, Write-back



