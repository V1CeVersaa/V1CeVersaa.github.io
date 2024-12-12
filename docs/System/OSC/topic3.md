# Synchronization

## 竞争条件与临界区问题

并发或并行执行会影响多个进程共享数据的完整性。举一个有界缓冲区的例子：

这是由于生产者进程和消费者进程并发执行语句 `count++` 和 `count--`，虽然在 C 语言中看来，这是一个原子操作，但是在汇编层面看来，这其实是三条指令：

```asm
load R1, count
operate R1, 1
store R1, count
```

这三条指令并不是原子的，这六条指令甚至可以以（甚至）任意的顺序执行，导致 `count` 的值可以为 4、5、6 这三个值之一（若原来的值为 5），但显然只有 5 这个值是正确的。

这种**多个进程并发访问和操作同一数据并且执行结果与特定访问顺序有关**的情况被称为**竞争条件/Race Condition**。为了防止竞争条件，需要确保一次只有一个进程可以操作变量 `count`，为了实现这个目的，我们需要进程按照一定方式进行同步。

解决临界区问题的方法必须满足下面三条要求：

1. Mutual Exclusion/互斥访问：
2. Progress/空闲让进：
3. Bounded Waiting/有限等待：

## Peterson 方案

## 硬件同步支持

### 1. 单处理器：禁止中断

### 2. 内存屏障

> How a computer architecture determines what memory guarantees it will provide to an application program is known as its **memory model**.

### 3. 硬件指令

很多现代操作系统提供特殊硬件指令，用于检测和修改字的内容，或者作为**不可中断的指令 *原子/Atomically/Uninterruptable* 地交换两个字**，我们可以通过使用这些特殊指令，相对简单地解决临界区问题。这里使用指令 `test_and_set()` 和 `compare_and_swap()` 抽象了这些指令背后的主要概念。

`test_and_set()` 可以按照下面的代码来理解其功能：返回 `target` 的值，并将其修改成 `true`。

```C
bool test_and_set(bool *target) {
    bool rv = *target;
    *target = true;
    return rv;
}
```

可以利用 `test_and_set()` 来实现互斥：

```C
do {
    // Entry section
    while (test_and_set(&lock))
        ;   // Do nothing
    // Critical section
    // Exit section
    lock = false;
    // Remainder section
} while (true);
```

如果在 Entry Section 的时候，`lock` 已经被设置为 `true`，那么 `test_and_set()` 就会返回 `true`，并且将 `lock` 的值保持 `true` 不变，这样就会一直循环等待。直到 `lock` 被设置为 `false`，`test_and_set()` 返回 `false`，并且顺手将 `lock` 设置为 `true`，进入临界区，不让别的线程进入。之后退出临界区，将 `lock` 设置为 `false`，让别的线程进入。

倘若某个时刻 `lock` 为 `false`，很可能有不止一个线程调用了 `test_and_set()`，但是由于 `test_and_set()` 是原子的，所以只可能有一个线程返回 `false`。

但是 `test_and_set()` 并不能确保有限等待，下面就是一个例子：

<img class="center-picture" src="../../images/img-OSC/Synchronization-3.png" alt="drawing" width="550" />

谁也不知道 T2 会等到哪里去（这取决于调度），我们可以这样修改代码，这里共用的数据结构是 `#!C bool waiting[n]` 和 `#!C int lock`：

```C
do {
    waiting[i] = true;
    while (waiting[i] && test_and_set(&lock)) ;
    waiting[i] = false;

    // Critical section
    // Exit section
    j = (i + 1) % n;
    while ((j != i) && !waiting[j])
        j = (j + 1) % n;
    if (j == i)
        lock = false;
    else
        waiting[j] = false;

    // Remainder section
} while (true);
```

我们首先将 `waiting[i]` 置为 `true`，然后检查 `lock`，如果 `waiting[i]` 被释放**或者** `lock` 为 `false`，那么就进入临界区，同时上锁（第 3 行）。在退出临界区的时候，我们向下检查后面的线程，寻找下一个正在等待的线程（第 8 到 10 行），若是没有找到（`j == i`），那么就释放锁，这是因为没有线程在等待（第 11 行和第 12 行）；否则，就将 `waiting[j]` 置为 `false`，释放该线程，继续循环，让其进入临界区（第 14 行）。

???- Info "Illustration of Bounded Waiting for Test-and-Set Lock"
    <img class="center-picture" src="../../images/img-OSC/Synchronization-4.png" alt="illustration" width="550" />

`compare_and_swap()` 也是以原子的方式对两个字进行操作，但是是使用基于交换两个字的内容的机制：

```C
int compare_and_swap(int *value, int expected, int new_value) {
    int temp = *value;
    if (*value == expected)
        *value = new_value;
    return temp;
}
```

只有当 `*value` 的值等于 `expected` 的时候，才会将 `*value` 设置为 `new_value`，并且返回 `*value` 的原始值。

互斥的实现也是类似的，但是这里 `#!C compare_and_swap(&lock, 0, 1)` 和 `#!C test_and_set(&lock)` 的逻辑是反的，需要注意一下，但是两条指令**并没有本质区别**。

```C
while (true) {
    while (compare_and_swap(&lock, 0, 1) != 0)
        ;   // Do nothing
    // Critical section
    // Exit section
    lock = 0;
    // Remainder section
}
```

加上有限等待的实现，这里共用的数据结构是 `#!C bool waiting[n]` 和 `#!C int lock`：

```C
while (true) {
    waiting[i] = true;
    key = 1;
    while (waiting[i] && key == 1) 
        key = compare_and_swap(&lock, 0, 1);
    waiting[i] = false;

    // Critical section
    // Exit section
    j = (i + 1) % n;
    while ((j != i) && !waiting[j])
        j = (j + 1) % n;
    if (j == i)
        lock = 0;
    else
        waiting[j] = false;

    // Remainder section
}
```

x86 实现了 `cmpxchg` 这个指令，可以实现 `compare_and_swap()` 的功能，为了强制执行原子执行，可以使用 `lock` 前缀，使得在目标操作数更新的时候**锁定总线**。汇编的一般形式是 `#!asm lock cmpxchg <destination operand>, <source operand>`。ARM 也有类似的指令。

### 4. 原子变量

通常，指令 `compare_and_swap()` 并不直接用来实现互斥，而是作为实现别的工具的基本构建块。原子变量可以提供对基本数据类型的原子操作。有界缓冲区问题可以通过实现对整型变量的原子递增递减来解决：

```C
void increment(atomic_int *v) {
    int temp;
    do {
        temp = *v;
    } while (temp != compare_and_swap(v, temp, temp + 1));
}
```

我们不断地读取 `v` 的值，直到 `compare_and_swap()` 成功，这就保证了 `temp + 1` 的值确实是 `*v + 1`，也就是说递增操作正确。

## 互斥锁/Mutex Locks

上面提到的解决方案不但复杂，而且还很难被程序员使用。最简单的高层软件工具就是**互斥锁/Mutex Locks**，我们使用互斥锁保护临界区并且防止竞争条件。一个进程子啊进入临界区之前必须**申请/Acquire**锁，退出临界区的时候必须**释放/Release**锁。

```C
while (true) {
    acquire();
    // Critical section
    release();
    // Remainder section
}
```

每个互斥锁都有一个布尔变量 `available`，这个值表明这个锁是否可用，如果锁可用，调用 `acquire()` 就会成功，并将 `available` 设置为 `false`。如果一个进程尝试获取不可用的锁，那么这个进程就会**被阻塞**，直到锁可用。

另外，我们要求调用 `acquire()` 和 `release()` 都必须是原子的，这一般通过硬件的原子指令来实现，我们将使用 `compare_and_swap()` 来实现这两个函数。

```C
void acquire() {
    while (compare_and_swap(&available, 1, 0) != 1)
    // equal to compare_and_swap(&available, 0, 1)
        ;   // Do nothing, busy waiting
}

void acquire_naive() {
    while (available == 0)
        ;   // Do nothing, busy waiting
    available = 0;
}

void release() {
    available = 0;
}
```

这里的 `compare_and_swap(&available, 1, 0)` 会返回 `available` 的原始值，如果 `available` 的值为 `1`（可用），那么就将其设置为 `0`，并且返回 `1`，这样就可以进入临界区。如果 `available` 的值为 `0`（不可用），那么就会一直循环等待，直到 `available` 的值为 `1`。

我们这里实现的锁也被称为**自旋锁/Spinlock**，因为进程在等待锁可用的时候会一直自旋。自旋锁的缺点是需要**忙等待/Busy Waiting**，忙等待的时间是从申请锁到释放锁的时间。当有一个进程在临界区的时候，任何其他进程在进入临界区的时候必须要连续循环调用 `acquire()`。考虑有 N 个线程使用一个 CPU 的情况：只有一个线程可以进入临界区，其他 N - 1 个线程即使被分配到了 CPU，但都在自旋等待，这样会浪费大约 N-1/N 的 CPU 时间。

在保持互斥锁的结构不变的情况下，我们可以减少忙等待，只需要让别的等待的线程释放 CPU 就好了：

```C
void acquire() {
    while (compare_and_swap(&available, 1, 0) != 1)
        yield(); // give up CPU
}
```

实现方法：添加一个队列，当别的线程发现锁是不可用的时候，将这个线程的进程状态调到 SLEEP，将其加到这个队列中，并且调用 `schedule()` 函数。

自旋锁被认为当**锁定时间很短**的时候，多处理器系统锁定机制的首选。

锁要么是**争用的/Contended**，要么是**非争用的/Uncontended**。如果线程在尝试获取锁的时候被阻塞，那么认为这个锁是争用的；如果线程在尝试获取锁的时候有可用锁，那么认为这个锁是非争用的。争用锁可以遇到**高争用/High Contention**（相对大量的线程尝试获取锁）或者**低争用/Low Contention**（尝试获取锁的线程很少）。一般高争用的锁会降低并发程序的整体性能。

> "Contended" describes a lock that different threads are trying to acquire at the same time, "Heavily-contended" if numerous threads are all trying to acquire the same lock, "uncontended" describing cases where a thread doesn't have any competition to acquire a lock.

## 信号量/Semaphores

互斥锁被认为是最简单的同步工具，信号量提供了一种更复杂/强大的同步工具。**信号量/Semaphore** 包含着一个整型变量，除了初始化之外，这个整型变量只可以被两个**原子操作** `wait()` 和 `signal()` 访问。

可以通过下面的方式定义 `wait()` 和 `signal()`：

```C
void wait(int s) {
    while (s <= 0)
        ;   // Do nothing, busy waiting
    s--;
}

void signal(int s) {
    s++;
}
```

信号量分为**二进制信号量/Binary Semaphores**和**计数信号量/Counting Semaphores**。二进制信号量的值只能是 0 或者 1，最类似于互斥锁，在没有互斥锁的系统上，可以使用二进制信号量来提供互斥。计数信号量的值不受限值，可以用于控制访问拥有多个实例的某种资源，信号量的初始值可以作为可用资源的数量，当该进程需要资源的时候，就会调用 `wait()`，当资源被释放的时候，就会调用 `signal()`。

考虑下面的并发问题：有两个并发进程，`P1` 需要执行语句 `S1`，`P2` 需要执行语句 `S2`，但是要求只有在 `S1` 执行之后才能执行 `S2`。我们创建信号量 `sem` 并且将其初始化为 `0`。`P1` 执行 `S1` 之后调用 `signal(sem)`，`P2` 在执行 `S2` 之前调用 `wait(sem)`。这样就可以保证 `S2` 在 `S1` 之后执行。

> Can implement a counting semaphore as a binary semaphore.

这样的信号量其实也具有忙等待的问题，我们可以通过这样的想法来修改 `wait()` 和 `signal()` 的定义：当一个进行执行操作 `wait()` 并且发现信号量的值不为正值的时候，就必须等待；然而，这个进程不是忙等待而是阻塞自己，将这个进程放到与信号量相关的进程队列中，并且将该进程状态切换成等待状态，然后调用 `schedule()`。

这样我们就修改信号量的数据结构，添加一个队列，并且修改 `wait()` 和 `signal()` 的定义：

```C
typedef struct {
    int value;
    struct process *list;
} semaphore;

void wait (semaphore *s) {
    s->value--;
    if (s->value < 0) {
        add_to_list(s->list, current_process);
        block();
    }
}

void signal (semaphore *s) {
    s->value++;
    if (s->value <= 0) {
        process *p = remove_from_list(s->list);
        wakeup(p);
    }
}
```

这里的 `block()` 操作将调用 `wait()` 的进程放在合适的等待队列中；`wakeup()` 操作将等待队列中的一个合适的进程移动到就绪队列中。下面是一个 demo 程序，可以看到虽然有 `while (true)` 循环，但是几乎没有忙等待了，只在 `wait()` 和 `signal()` 的时候才会有少量的忙等待：

```C
semaphore sem = {1, NULL};
do {
    wait(sem);      // have busy waiting
    // Critical section, with no busy waiting
    signal(sem);    // have busy waiting
    // Remainder section
} while (true);
```

使用信号量的系统也有可能遇见死锁：两个或多个线程各自在无穷等待别的正在等待的进程持有的资源/产生的事件。下面是一个简单的例子：

<img class="center-picture" src="../../images/img-OSC/Synchronization-5.png" alt="deadlock" width="550" />

`P1` 持有 `S` 等待 `Q`，`P2` 持有 `Q` 等待 `S`。

使用信号量的系统也有可能遇见饥饿：无限期的阻塞/Indefinite Blocking，具体而言就是一个进程很可能永远不会从信号量的等待队列中取出。

死锁一定会导致饥饿，但是饥饿不一定会导致死锁。

## 优先级反转/Priority Inversion


