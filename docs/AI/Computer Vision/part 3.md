# Part 3: Lecture 12 to Lecture 18

!!! Abstract "Table of Contents"

    - [ ] [Lecture 12: Deep Learning Software](#lecture-12-deep-learning-software)
    - [x] [Lecture 13: Object Detection](#lecture-13-object-detection)
    - [x] [Lecture 14: Object Detectors](#lecture-14-object-detectors)
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

- `torch.nn.Sequential` 为顺序执行的容器，允许我们按照顺序堆叠多个网络层，自动处理层间链接；
- 网络结构包含三层：输入层到隐藏层的线性变换，ReLU 激活函数，隐藏层到输出层的线性变换，分别使用 `torch.nn.Linear` 和 `torch.nn.ReLU` 实现；
- 前向传播使用 `model(x)` 即可，它会自动按照顺序执行每一层；
- 调用 `torch.nn.functional.mse_loss` 自动计算均方损失，`loss.backward()` 自动计算模型中所有参数的梯度（`requires_grad=True` 的张量）；
- 使用 `with torch.no_grad()` 上下文管理器可以暂时禁用梯度计算，更新参数的时候禁用梯度计算，通过 `model.parameters()` 获取模型中所有参数；

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

- 使用 `torch.optim.Adam` 作为优化器，构造优化器的时候需要传入模型参数和学习率；
- 使用 `optimizer.step()` 更新模型参数，使用 `optimizer.zero_grad()` 清零梯度；

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

- PyTorch 允许通过继承 `torch.nn.Module` 来创建自定义神经网络模块，其中 `torch.nn.Module` 是所有神经网络模块的基类；
- 自定义神经网络模块都应该实现 `forward` 方法（Should be overridden by all subclasses），`forward` 方法定义了前向传播的计算过程；
- 自定义类的 `__init__` 方法**必须调用**父类的 `__init__` 方法，这样才能正确初始化模块系统。
- 子模块通过属性赋值的方式自动注册，PyTorch 会追踪这些子模块的参数。

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

- 更复杂一些的例子，但是原理没有变化，主要是表示我们可以在容器（比如 `torch.nn.Sequential`）中使用自定义的模块。

???- Info "Code: DataLoader"

???- Info "Code: Static Graphs with JIT"

    ```py
    import torch

    def model(x, y, w1, w2a, w2b, prev_loss):
        w2 = w2a if prev_loss < 5.0 else w2b
        y_pred = x.mm(w1).clamp(min=0).mm(w2)
        loss = (y_pred - y).pow(2).sum()
        return loss

    N, D_in, H, D_out = 64, 1000, 100, 10

    x = torch.randn(N, D_in)
    y = torch.randn(N, D_out)
    w1 = torch.randn(D_in, H)
    w2a = torch.randn(H, D_out)
    w2b = torch.randn(H, D_out)

    graph = torch.jit.script(model)

    prev_loss = 5.0
    learning_rate = 1e-6
    for t in range(500):
        loss = graph(x, y, w1, w2a, w2b, prev_loss)

        loss.backward()
        prev_loss = loss.item()
    ```

    ```py
    import torch

    @torch.jit.script
    def model(x, y, w1, w2a, w2b, prev_loss):
        w2 = w2a if prev_loss < 5.0 else w2b
        y_pred = x.mm(w1).clamp(min=0).mm(w2)
        loss = (y_pred - y).pow(2).sum()
        return loss
        
    N, D_in, H, D_out = 64, 1000, 100, 10

    x = torch.randn(N, D_in)
    y = torch.randn(N, D_out)
    w1 = torch.randn(D_in, H)
    w2a = torch.randn(H, D_out)
    w2b = torch.randn(H, D_out)

    prev_loss = 5.0
    learning_rate = 1e-6
    for t in range(500):
        loss = model(x, y, w1, w2a, w2b, prev_loss)

        loss.backward()
        prev_loss = loss.item()
    ```

TensorFlow 就不写了，现在除了初学者用一用 Keras 之外，前沿很少用了，等到之后可能接触到使用 TensorFlow 的代码的时候再速通。

## Lecture 13: Object Detection

计算机视觉的基本任务可以分为：分类/Classification、语义分割/Semantic Segmentation、目标检测/Object Detection、实例分割/Instance Segmentation。四个问题，其中分类没有空间信息，语义分割只考虑像素，不考虑对象，而目标检测和实例分割考虑对象。

<img class="center-picture" src="../assets/13-1.png" width=600 />

迁移学习-特征提取：在比较大的训练集上训练模型，然后将知识迁移到别的具有较小数据集的新任务上。方法之一是训练一整个神经网络，移除最顶上的层，冻结下面的所有预训练网络层，然后使用得到的网络提取特征，在这些特征上训练新的线性模型。得到的效果一般不错：

<img class="center-picture" src="../assets/13-2.png" width=600 />

迁移学习-模型微调：从预训练的神经网络开始，去除最后一层，在原地方添加一个新的随机初始化的全连接层，然后使用新的数据集训练这个网络。使用技巧包括：

- 使用较小的学习率，比如使用原来学习率十分之一的学习率；
- 先训练特征提取再微调；
- 冻结较低的网络层，节约计算资源；
- 在测试模式下使用 BatchNorm。

迁移学习是常态，比如使用 Fast-RNN 的物体检测以及综合视觉和语言的多模态应用，并且可以帮助训练更快收敛。当然，如果训练数据和时间充分，随机初始化也可能媲美迁移学习。

目标检测的任务与挑战：

- 输入：一个 RGB 图像；
- 输出：一组检测到的对象，对每个对象预测类别标签/Category Label 和边界框/Bounding Box。类别标签是从已知的确定的类别之中选择的，边界框为矩形，一般给出四个参数：`x`、`y`、`width`、`height`。
- 多个输出：每个图像都可能有不同数目的物品，因此模型需要能够动态地输出可变数量的检测结果；
- 多种类别输出：不仅仅需要预测类别标签，还需要预测边界框，同时处理不同类型的任务；
- 大尺寸图像：图像一般从小尺寸的 $224 \times 224$ 转移到较大尺寸/分辨率的图像。

最常见的边界框都是轴对称的，和图像的坐标轴平行；很少有旋转的、不一定和坐标轴平行的定向框/Oriented Boxes。一般的模态检测/Modal Detection 任务输出的边界框只覆盖物体可见的那一部分，非模态检测/Amodal Detection 任务输出的边界框会覆盖物体的整个范围，即使物体的一部分被遮挡。

Intersection of Union/交并比：衡量模型预测的边界框好不好，定义为真实的边界框和预测的边界框的交集和并集的比值。也被称为 Jaccard Index/Jaccard Similarity。交并比大于 0.5 就可以认为预测边界框比较好，大于 0.9 就可以认为预测边界框和真实边界框几乎一致。

我们将**检测单一目标**的问题分为 Where 和 What 两个问题：

- 首先将一个图片经过神经网络变换成一个 4096 维的特征向量；
- 定位问题/Where：将其视为一个回归问题，经过全连接层输出四个参数，与正确的边界框的四个数据产生 L2 损失 $L_{\text{reg}}$；
- 分类问题/What：就是一个分类问题，添加全链接层预测物体属于各个类别的分数，使用 Softmax 损失 $L_{\text{cls}}$；
- 总损失：$L = L_{\text{cls}} + \lambda L_{\text{reg}}$。超参数 $\lambda$ 平衡两个损失的权重；
- 常见的做法是通过迁移学习，使用 ImageNet 预训练的模型上开始训练。

这种方法局限很直接：框架假设每张图片只有一个物体，但是实际中一张图片可能有很多个物体。拒绝方法之一是使用滑动窗口/Sliding Window，核心思想是使用一个固定大小的窗口，在图片的不同位置、不同尺度上滑动，再对裁剪出来的窗口进行单目标检测。

可是滑动窗口的问题在于可能的窗口位置数目太大了：对于一个尺寸为 $H \times W$ 的图片，如果使用一个 $h \times w$ 的窗口，那么可能的窗口位置数目就是 $(W - w + 1) \times (H - h + 1)$，对所有可能的窗口大小求和，就是 $\frac{H(H + 1)}{2} \times \frac{W(W + 1)}{2}$。数量级爆炸。

Region Proposal/区域提议：与其暴力穷举每一个可能的窗口，不图先用简单的方法提议一小部分可能包含物体的候选区域，然后再将其送到神经网络中进行分类和回归。方法通常基于一些启发式规则或者简单的图像特征，优势是速度很快，Selective Search 可以在几秒钟在 CPU 上生成大约 2000 个候选区域。

<img class="center-picture" src="../assets/13-3.png" width=600 />

Region-Based CNN/R-CNN：结合了 Region Proposal 和 CNN 的检测方法。

- 对于输入图像，进行区域提议，生成大约 2000 个候选区域/Regions of Interest/RoI；
- 对于每一个候选区域，强制缩放到一个固定尺寸，比如 $224 \times 224$，这是为了方便输入神经网络；
- 将 Wraped Image Regions 独立的输入一个预训练的神经网络进行前向传播，提取特征，对得到的特征进行分类；
- 在最后一步，还进行边界框回归，预测一个变换参数 $(t_x, t_y, t_w, t_h)$，对候选区域进行变换，使其更接近真实边界框。

<img class="center-picture" src="../assets/13-4.png" width=600 />

Box Regression/边界框回归的过程使用 L2 正则化，鼓励预测的边界框保持不变。我们也注意到这样的变换其实是有 Scale/Translation 不变性的，因为 CNN 在裁剪之后并不会感受到绝对的尺寸和位置的变化。

R-CNN 的训练：打标签，对每一个区域提议分类为 Postive、Negative 和 Neutral，通过计算和 Ground Truth 的 IoU 阈值为 0.5 和 0.3 进行分类。裁剪区域并缩放到 $224 \times 224$ 的尺寸，扔进 CNN 提取特征。对于每一个正例预测类型并且回归边界框，对每一个负例仅仅预测类型。

在测试的时候，按照区域提议、CNN 提取特征、运行分类和回归的顺序进行，同时需要确定阈值来确定预测结果。但引申出两个问题：CNN 经常会输出互相覆盖的边界框，同时阈值应该如何确定？

对第一个问题，使用非极大值抑制/Non-Maximum Suppression/NMS 来解决。步骤如下：

1. 选择下一个得分最高的边界框；
2. 计算当前选择的框和所有未处理框的 IoU，如果 IoU 大于阈值，则删除该框；
3. 重复步骤 1 直到没有剩余的边界框。

<img class="center-picture" src="../assets/13-5.png" width=600 />

上图中的橙色框就是第一个删掉的框，因为其和蓝色框重叠太多了。但是在物体高度密集，互相严重遮挡的情况下，NMS 其实会错误的抑制掉了实际检测到不同物体的好框，这个问题到当时（2022 年）还没有很好的解决方案。

我们使用 Mean Average Precision/mAP 来衡量模型的好坏。过程如下：

1. 对每一个测试图片运行带 NMS 的目标检测；
2. 对每一个类别，计算平均准确率 $\operatorname*{AP}$，其定义为准确率-召回率曲线下的面积，方法如下
    1. 按照分数从高到低的顺序，对每一个预测结果，如果其和某一个 Ground Truth 的 IoU 大于 0.5，则认为其是一个正例，否则为负例，计算当前的准确率和召回率；
    2. 绘制准确率-召回率曲线，计算曲线下的面积，即为 $\operatorname*{AP}$。
3. 计算所有类别的 $\operatorname*{AP}$ 的平均值，即为 $\operatorname*{mAP}$。
4. 对于 COCO $\operatorname*{mAP}$ 的计算，对多种 IoU 阈值对应的 $\operatorname*{mAP}$ 求平均。

<img class="center-picture" src="../assets/13-6.png" width=600 />

## Lecture 14: Object Detectors

上次讲到原先 R-CNN 的 Overlapping Proposals 引发了很多重复性的工作，一些像素被处理了很多次，我们希望避免这种情况，于是有了 Fast R-CNN：

1. Backbone Network/骨干卷积网络：首先将整张图片输入到骨干神经网络中，一般是 VGG 或者 ResNet，得到一个特征图；
2. Region Proposal：需要一个外部提议算法，从特征图生成一系列可能包含物体的 RoL；
3. 裁剪并且调整大小之后，将图片输入到专门处理信息的 Per-Region Network 之中，对提取到的区域特征进行分类和边界框回归。

其中大部分计算都集中在骨干网络之中，Per-Region Network 多是相对轻量的网络，比如我们如果要基于 AlexNet 做 Fast R-CNN，那么前五层卷积层被使用为骨干网络，后两层全连接层被使用为 Per-Region Network。Fast R-CNN 和 Slow R-CNN 的架构比较如下：

<img class="center-picture" src="../assets/14-0.png" width=600 />

对于对 RoL 的裁剪和缩放，我们需要回忆感受野的概念，注意到对于输出的图片的每一个点，其都和输入图片的感受野的某一个点有着一定的对应关系，于是我们可以建立起输入坐标系统和输出坐标系统之间的对应关系，来将特征图中的 RoL 反过来对应输入图片的边界框：

<img class="center-picture" src="../assets/14-1.png" width=600 />

RoL Pool：      

## Lecture 15: Image Segmentation

## Lecture 16: Recurrent Neural Networks

## Lecture 17: Attention

## Lecture 18: Vision Transformers
