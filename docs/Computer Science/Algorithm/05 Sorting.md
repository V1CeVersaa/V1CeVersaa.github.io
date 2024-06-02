# Chapter 5 Sorting

## 5.1 Insertion Sort

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


## Merge Sort

归并排序的时间复杂度在任何情况下都是 $O(N\log N)$。