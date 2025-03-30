# Part 3: Lecture 12 to Lecture 18

!!! Abstract "Table of Contents"

    - [ ] [Lecture 12: Deep Learning Software](#lecture-12-deep-learning-software)
    - [ ] [Lecture 13: Object Detection](#lecture-13-object-detection)
    - [ ] [Lecture 14: Object Detectors](#lecture-14-object-detectors)
    - [ ] [Lecture 15: Image Segmentation](#lecture-15-image-segmentation)
    - [ ] [Lecture 16: Recurrent Neural Networks](#lecture-16-recurrent-neural-networks)
    - [ ] [Lecture 17: Attention](#lecture-17-attention)
    - [ ] [Lecture 18: Vision Transformers](#lecture-18-vision-transformers)

## Lecture 12: Deep Learning Software

> 这段有点过时了，PPT 上介绍的是 PyTorch 1.10，现在版本都到 2.6 了。但是 PyTorch 的 API 变化不大，所以还是可以参考的。

深度学习框架的核心价值：

- 快速原型设计能力；
- 自动计算梯度；
- 在 GPU/TPU 上高效运行；

PyTorch 的核心概念分为三部分：Tensor、Autograd、nn.Module：

- Tensor：类似于 NumPy 的数组，但可以在 GPU 上运行；
- Autograd：根据 Tensor 构建计算图并且自动计算梯度的包；
- nn.Module：神经网络层的抽象，可以存储状态和更多的可学习权重。

我们使用代码来解释：

???- Info "Code: Tensor"

    ```python 
    import torch

    device = torch.device("cpu")
    # device = torch.device("cuda:0")

    N, D_in, H, D_out = 64, 1000, 100, 10

    x = torch.randn(N, D_in, device=device)
    y = torch.randn(N, D_out, device=device)
    w1 = torch.randn(D_in, H, device=device)
    w2 = torch.randn(H, D_out, device=device)

    learning_rate = 1e-6
    for t in range(500):
        h = x.mm(w1)
        h_relu = h.clamp(min=0)
        y_pred = h_relu.mm(w2)
        loss = (y_pred - y).pow(2).sum()

        grad_y_pred = 2 * (y_pred - y)
        grad_w2 = h_relu.t().mm(grad_y_pred)
        grad_h_relu = grad_y_pred.mm(w2.t())
        grad_h = grad_h_relu.clone()
        grad_h[h < 0] = 0
        grad_w1 = x.t().mm(grad_h)

        w1 -= learning_rate * grad_w1
        w2 -= learning_rate * grad_w2
    ```

???- Info "Code: Autograd I"

    ```python
    import torch

    N, D_in, H, D_out = 64, 1000, 100, 10

    x = torch.randn(N, D_in)
    y = torch.randn(N, D_out)
    w1 = torch.randn(D_in, H, requires_grad=True)
    w2 = torch.randn(H, D_out, requires_grad=True)

    learning_rate = 1e-6
    for t in range(500):
        y_pred = x.mm(w1).clamp(min=0).mm(w2)
        loss = (y_pred - y).pow(2).sum()

        loss.backward()

        with torch.no_grad():
            w1 -= learning_rate * w1.grad
            w2 -= learning_rate * w2.grad
            w1.grad.zero_()
            w2.grad.zero_()
    ```

- 使用 `requires_grad=True` 创建的 Tensor 会记录计算图，并自动计算梯度；
- 前向传播正常进行，但是我们不需要记录中间值，而 PyTorch 会在计算图中帮助我们记录；
- 使用 `loss.backward()` 自动计算梯度，梯度记录在所有需要梯度的 Tensor 的 `grad` 属性中，每一次调用 `loss.backward()` 都会在原有的梯度基础上**累加**，在反向传播结束的时候，计算图会被释放；
- 使用 `with torch.no_grad()` 上下文管理器可以暂时禁用梯度计算，例如在更新参数的时候；
- 使用 `w1.grad.zero_()` 手动清零梯度，缺失这一步会导致梯度累加问题，这是因为 `.backward()` 方法会累加梯度，而不是直接赋值。
- 对每一个 `requires_grad=True` 的 Tensor 进行的操作都会添加到计算图中，例如 `clamp`、`mm` 等，这些操作的结果 Tensor 也会自动添加 `requires_grad=True` 属性。


上面的代码其实会产生这样一个计算图：

<img class="center-picture" src="../assets/12-1.png" width=600 />

对于计算图来说，定义的 Python 函数和定义的 Autograd 算子略有不同：定义算子需要首先定义一个 `Function` 的子类，然后重写 `forward` 和 `backward` 方法。

???- Info "Code: Autograd II"

    ```python
    def sigmoid(x):
        return 1 / (1 + (-x).exp())

    class Sigmoid(torch.autograd.Function):
        @staticmethod
        def forward(ctx, input):
            output = 1 / (1 + (-input).exp())
            ctx.save_for_backward(output)
            return output
            
        @staticmethod
        def backward(ctx, grad_output):
            output, = ctx.saved_tensors
            return grad_output * output * (1 - output)

    def sigmoid(x):
        return Sigmoid.apply(x)
    ```



???- Info "Code: nn.Module I"

    ```py
    import torch

    N, D_in, H, D_out = 64, 1000, 100, 10

    x = torch.randn(N, D_in)
    y = torch.randn(N, D_out)

    model = torch.nn.Sequential(
        torch.nn.Linear(D_in, H),
        torch.nn.ReLU(),
        torch.nn.Linear(H, D_out),
    )

    learning_rate = 1e-2

    for t in range(500):
        y_pred = model(x)
        loss = torch.nn.functional.mse_loss(y_pred, y)

        loss.backward()

        with torch.no_grad():
            for param in model.parameters():
                param -= learning_rate * param.grad

        model.zero_grad()
    ```

???- Info "Code: nn.Module II"

    ```py
    import torch

    N, D_in, H, D_out = 64, 1000, 100, 10

    x = torch.randn(N, D_in)
    y = torch.randn(N, D_out)

    model = torch.nn.Sequential(
        torch.nn.Linear(D_in, H),
        torch.nn.ReLU(),
        torch.nn.Linear(H, D_out),
    )

    learning_rate = 1e-4
    optimizer = torch.optim.Adam(model.parameters(), lr=learning_rate)

    for t in range(500):
        y_pred = model(x)
        loss = torch.nn.functional.mse_loss(y_pred, y)

        loss.backward()

        optimizer.step()
        optimizer.zero_grad()
    ```

???- Info "Code: nn.Module III"

    ```py
    import torch

    class TwoLayerNet(torch.nn.Module):
        def __init__(self, D_in, H, D_out):
            super(TwoLayerNet, self).__init__()
            self.linear1 = torch.nn.Linear(D_in, H)
            self.linear2 = torch.nn.Linear(H, D_out)

        def forward(self, x):
            h_relu = self.linear1(x).clamp(min=0)
            y_pred = self.linear2(h_relu)
            return y_pred

    N, D_in, H, D_out = 64, 1000, 100, 10

    x = torch.randn(N, D_in)
    y = torch.randn(N, D_out)

    model = TwoLayerNet(D_in, H, D_out)

    optimizer = torch.optim.SGD(model.parameters(), lr=1e-4)

    for t in range(500):
        y_pred = model(x)
        loss = torch.nn.functional.mse_loss(y_pred, y)

        loss.backward()

        optimizer.step()
        optimizer.zero_grad()
    ```

???- Info "Code: nn.Module IV"

    ```py
    import torch

    class ParallelBlock(torch.nn.Module):
        def __init__(self, D_in, D_out):
            super(ParallelBlock, self).__init__()
            self.linear1 = torch.nn.Linear(D_in, D_out)
            self.linear2 = torch.nn.Linear(D_in, D_out)

        def forward(self, x):
            h1 = self.linear1(x)
            h2 = self.linear2(x)
            return (h1 * h2).clamp(min=0)

    N, D_in, H, D_out = 64, 1000, 100, 10

    x = torch.randn(N, D_in)
    y = torch.randn(N, D_out)

    model = torch.nn.Sequential(
        ParallelBlock(D_in, H),
        ParallelBlock(H, H),
        torch.nn.Linear(H, D_out),
    )

    learning_rate = 1e-4
    optimizer = torch.optim.Adam(model.parameters(), lr=learning_rate)

    for t in range(500):
        y_pred = model(x)
        loss = torch.nn.functional.mse_loss(y_pred, y)

        loss.backward()

        optimizer.step()
        optimizer.zero_grad()
    ```





## Lecture 13: Object Detection

## Lecture 14: Object Detectors

## Lecture 15: Image Segmentation

## Lecture 16: Recurrent Neural Networks

## Lecture 17: Attention

## Lecture 18: Vision Transformers
