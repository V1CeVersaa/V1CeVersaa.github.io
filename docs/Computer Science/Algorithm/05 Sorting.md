# Chapter 5 Sorting

## 1 Insertion Sort

```C title="Insertion Sort"
void insertSort (int arr[], int len) {
    int i, j, tmp;
    for (i = 1; i < len; i++) {
        tmp = arr[i];
        for (j = i; j > 0 && arr[j - 1] > tmp; j--)
            arr[j] = arr[j - 1];
        arr[j] = tmp;
    }
}
```

进行 $n-1$ 趟排序，每一趟排序（第 $P$ 趟）都可以保证从 $0$ 到 $P-1$ 的元素是有序的，然后再插入第 $P$ 个元素。

- 最好情况的时间复杂度是 $O(N)$，这时整个数列是顺序的，开场就已经排好了；
- 最坏情况的时间复杂度是 $O(N^2)$，这种情况下数列是逆序的。
- 完全不需要另外一个数组，只需要临时变量，空间复杂度是 $O(1)$。

## 2 Shell Sort

希尔排序是插入排序的一种改进，它的时间复杂度会随具体实现（也就是增量序列的选取）而变化。

```C title="Shell Sort"
void shellSort(int arr[], int n) {
    int i, j, tmp;
    for (int inc = N / 2; inc > 0; inc /= 2) {  // Increment Sequence
        for (i = inc; i < N; ++i) {             // Insertion Sort
            tmp = arr[i];
            for (j = i; j >= inc; j -= inc) {
                if (tmp < arr[j - inc])
                    arr[j] = arr[j - inc];
                else
                    break;
            }
            a[j] = tmp;
        }
    }
}
```

- 希尔增量序列：如上面实现，$h_t=\lfloor N/2\rfloor, h_k = \lfloor h_{k+1}/2\rfloor$
    - 最坏复杂度 $O(N^2)$（即只在 1-sort 时进行了排序）。
- Hibbard 增量序列：$h_k = 2^k-1$
    - 最坏复杂度 $O(N^{3/2})$；
    - 平均复杂度 $O(N^{5/4})$。

## 3 Heap Sort

堆排序使用堆结构来进行排序：

- 算法一：将数组中的元素依次插入到堆中（可以是 $O(N)$ 线性建堆），然后依次从堆中取出最小元素
    - 时间复杂度 $O(N\log N)$；
    - 但是空间消耗翻倍了；
    ```C
    void heapSort(int arr[], int n) {
        BuildHeap(arr, n);                  // 最小堆, O(N)
        int tmp = malloc(sizeof(int) * n);
        for (int i = 0; i < n; ++i) 
            tmp[i] = DeleteMin(arr);       // O(logN)
        for (int i = 0; i < n; ++i) 
            arr[i] = tmp[i];
    }
- 算法二：
    - 以线性时间建最大堆（PercolateDown）；
    - 将堆顶元素与最后一个元素交换（相当于删除最大元素），然后进行 PercolateDown；
    - 依此循环，N-1 次删除后得到一个从小到大的序列。
    ```C
    void heapSort(int arr[], int n) {
        for (int i = n / 2; i >= 0; --i)    // Build Max Heap
            percolateDown(arr, i, n);
        for (int i = n - 1; i > 0; --i) {   // Delete Max
            swap(&arr[0], &arr[i]);
            percolateDown(arr, 0, i);
        }
    }
    ```
    - 平均比较次数为 $2N\log N - O(N\log\log N)$

## 4 Merge Sort

归并排序的时间复杂度在任何情况下都是 $O(N\log N)$，空间复杂度为 $O(N)$。

关键的操作是合并两个有序列表变成一个有序列表，归并操作则可以递归进行，分而治之，依次合并。

```C title="Merge Sort"
void mergeSort(int arr[], int n) {
    int *tmp = malloc(sizeof(int) * n);
    if (tmp != NULL) {
        mergeSortHelper(arr, tmp, 0, n - 1);
        free(tmp);
    } else {
        printf("No space for tmp array!\n");
    }
}

void mergeSortHelper(int arr[], int tmp[], int left, int right) {
    if (left < right) {
        int center = (left + right) / 2;
        mergeSortHelper(arr, tmp, left, center);
        mergeSortHelper(arr, tmp, center + 1, right);
        merge(arr, tmp, left, center + 1, right);
    }
}

void merge(int arr[], int tmp[], int leftPos, int rightPos, int rightEnd) {
    int leftEnd = rightPos - 1;
    int tmpPos = leftPos
    int numElements = rightEnd - leftPos + 1;
    while (leftPos <= leftEnd && rightPos <= rightEnd)
        if (arr[leftPos] <= arr[rightPos])
            tmp[tmpPos++] = arr[leftPos++];
        else
            tmp[tmpPos++] = arr[rightPos++];
    while (leftPos <= leftEnd)
        tmp[tmpPos++] = arr[leftPos++];
    while (rightPos <= rightEnd)
        tmp[tmpPos++] = arr[rightPos++];
    for (int i = 0; i < numElements; ++i, rightEnd--)
        arr[rightEnd] = tmp[rightEnd];
}
```

## 5 Quick Sort

已知的实际运行最快的排序算法：

- 最坏复杂度 $O(N^2)$；
- 最优复杂度 $O(N\log N)$；
- 平均复杂度 $O(N\log N)$。

选择一个基准元素（枢轴 pivot），将数组分成两个子数组，左边的元素都小于等于基准元素，右边的元素都大于等于基准元素，然后对两个子数组进行快排、合并。

- 选取 pivot：
    - 错误方法：pivot = arr[0]（对于排好序的数组仍会消耗 $O(N^2)$ 的时间）；
    - 安全方法：pivot = random element in arr；
        - 但随机数生成也有开销。
    - 三数中值分割法：pivot = (left + center + right) / 3。
- 小数组：
    - 对于小的 $N$（$N\leq 20$），快速排序慢于插入排序。
    - 可以在递归到 $N$ 较小的情况下改为插入排序。

```C title="Quick Sort"
void quickSort(int *arr, int len) {
    quickSortHelper(arr, 0, len - 1);
}

void quickSortHelper(int *arr, int left, int right) {
    if (left + cutoff < right) {                 // Cutoff for small arrays
        int pivot = median3(arr, left, right);
        int i = left, j = right - 1;
        while (1) {
            while (arr[++i] < pivot) ;
            while (arr[--j] > pivot) ;
            if (i < j) 
                swap(&arr[i], &arr[j]);
            else
                break;
        }
        swap(&arr[i], &arr[right - 1]);
        quickSortHelper(arr, left, i - 1);
        quickSortHelper(arr, i + 1, right);
    } else 
        insertSort(arr + left, right - left + 1);
}

int median3(int *arr, int left, int right) {
    int center = (left + right) / 2;
    if (arr[left] > arr[center]) 
        swap(&arr[left], &arr[center]);
    if (arr[left] > arr[right])
        swap(&arr[left], &arr[right]);
    if (arr[center] > arr[right])
        swap(&arr[center], &arr[right]);
    swap(&arr[center], &arr[right - 1]);
    return arr[right - 1];
}

void swap(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}
```

## 6 Bucket Sort

如果输入数据都小于 $M$，则可以用一个大小为 $M$ 的数组来记录某个值出现了多少次，这个数组称为桶（bucket）：

- 桶初始化为 0，遍历输入数据，将每个数据对应的桶加 1
- 最后遍历桶中的所有元素，对于 bucket[x] = y，将 x 输出 y 次

时间复杂度 $O(N+M)$。

```C title="Bucket Sort"
void bucketSort(int *arr, int len) {
    int *bucket = malloc(sizeof(int) * len);
    if (bucket != NULL) {
        for (int i = 0; i < len; i++)   // Initialize Bucket
            bucket[i] = 0;
        for (int i = 0; i < len; i++)   // Counting
            bucket[arr[i]]++;
        for (int i = 0, j = 0; i < len; i++) {
            while (bucket[i] > 0) {
                arr[j++] = i;
                bucket[i]--;
            }
        }
        free(bucket);
    } else {
        printf("No space for bucket!\n");
    }
}
```

## 7 Radix Sort

从低位（LSD，Least Significant Digit）到高位（MSB），对每一位进行进行排序：时间复杂度为 $O(P(N+B))$，其中 $P$ 为轮数，$N$ 为元素个数，$B$ 为桶个数。

## 8 Stability

- 对于一个序列，如果存在两个相等的元素：
    - 排序后它们的相对位置不变，则称这个排序算法是稳定的；
    - 排序后它们的相对位置发生了变化，则称这个排序算法是不稳定的。
- 稳定排序：冒泡、归并、插入、基数；
- 不稳定排序：快排、希尔、堆排、选择。