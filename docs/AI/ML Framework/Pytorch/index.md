# Pytorch

先在这随便记一点

> [PyTorch Internals](http://blog.ezyang.com/2019/05/pytorch-internals/)

## Table of Contents

Slicing a tensor returns a **view** into the same data, so modifying it will also modify the original tensor. To avoid this, you can use the `clone()` method to make a copy of a tensor.

```python
a = torch.tensor([[1, 2, 3, 4], [5, 6, 7, 8]])
b = a[0, 1:]
b[0] = 0
print(a)

# tensor([[1, 0, 3, 4],
#         [5, 6, 7, 8]])
```

切片操作创建的是原始数据的"视图"(view)
视图和原始tensor共享相同的内存空间
这样做可以节省内存，提高效率
但也意味着修改视图会影响原始数据

`view()` 是 PyTorch 中用来改变张量形状的一个函数，一个重要作用是在不改变张量数据的情况下，返回一个具有不同形状的新张量视图。特点如下：

- 共享内存：`view()` 返回的新张量与原始张量共享底层数据，这意味着对新张量的修改会影响原始张量，对两个张量使用 `data_ptr()` 可以验证这一点；
- 元素数量不变：`view()` 操作前后，张量中的元素总数必须保持不变，我们可以在 `view()` 中使用 `-1` 参数，PyTorch 会自动计算该维度的大小，使得总元素数量保持不变；
- 连续性要求：`view()` 要求张量必须是连续的/Contiguous。如果张量不连续，需要先调用 `.contiguous()` 或使用 `.reshape()` 替代。
- 按照行优先处理元素，因此不能用于矩阵转置，对于转置操作，应使用 `.t()`、`.transpose()` 或 `.permute()`。

```python
x0 = torch.randn(2, 3, 4)
x1 = x0.transpose(1, 2).view(8, 3)                  # 不连续，RuntimeError
x2 = x0.transpose(1, 2).contiguous().view(8, 3)     # 连续
```


<!-- 

## 基本概念

`view()` 是 PyTorch 中用于改变张量形状的一个重要函数。它的主要作用是在不改变张量数据的情况下，返回一个具有不同形状的新张量视图。

## 主要特点

1. **共享内存**：`view()` 返回的新张量与原始张量共享底层数据。这意味着对新张量的修改会影响原始张量，反之亦然。

2. **元素数量不变**：`view()` 操作前后，张量中的元素总数必须保持不变。

3. **使用 -1 参数**：可以在 `view()` 中使用单个 `-1` 参数，PyTorch 会自动计算该维度的大小，使得总元素数量保持不变。

4. **连续性要求**：`view()` 要求张量必须是连续的（contiguous）。如果张量不连续，需要先调用 `.contiguous()` 或使用 `.reshape()` 替代。

## 常见用法

### 1. 展平张量（Flattening）

```python
x = torch.tensor([[1, 2, 3], [4, 5, 6]])  # 形状为 (2, 3)
x_flat = x.view(-1)  # 形状为 (6,)
```

### 2. 添加或移除维度

```python
# 将一维向量转为行向量（添加维度）
x = torch.tensor([1, 2, 3, 4])  # 形状为 (4,)
x_row = x.view(1, -1)  # 形状为 (1, 4)

# 将一维向量转为列向量
x_col = x.view(-1, 1)  # 形状为 (4, 1)
```

### 3. 改变多维张量的形状

```python
x = torch.arange(24)  # 形状为 (24,)
x_reshaped = x.view(2, 3, 4)  # 形状为 (2, 3, 4)
```

## 使用限制

1. **不能用于转置**：`view()` 函数按行优先顺序（row-major order）处理元素，因此不能用于矩阵转置。对于转置操作，应使用 `.t()`、`.transpose()` 或 `.permute()`。

2. **不能用于非连续张量**：某些操作（如转置）会使张量变为非连续状态，此时直接使用 `view()` 会失败。解决方法：
   - 使用 `.contiguous().view()`
   - 使用 `.reshape()`（内部会自动处理连续性问题）

## view() 与 reshape() 的区别

- `view()` 要求张量必须是连续的，否则会报错
- `reshape()` 更灵活，可以处理非连续张量，内部会在需要时自动调用 `.contiguous()`
- 两者在处理连续张量时行为相同

## 实际应用示例

```python
# 创建一个形状为 (2, 3, 4) 的张量
x = torch.tensor([
    [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]],
    [[13, 14, 15, 16], [17, 18, 19, 20], [21, 22, 23, 24]]
])

# 使用 view() 改变形状
x_reshaped = x.view(4, 6)

# 使用 -1 参数自动计算维度
x_auto = x.view(-1, 6)  # 等同于 x.view(4, 6)

# 共享内存示例
x_flat = x.view(-1)
x_flat[0] = 100  # 这会同时修改 x[0,0,0]
```

## 注意事项

1. 在处理复杂的形状变换时，特别是涉及轴交换的操作后，最好使用 `.reshape()` 而不是 `.view()`。

2. 如果需要创建一个独立的张量副本（不共享内存），应使用 `.clone()` 方法。

3. 在深度学习中，`view()` 常用于网络架构中的形状调整，如将卷积层的输出展平后传入全连接层。

希望这个解释对您有所帮助！如果您有任何其他问题，请随时提问。
 -->
