# Part 4: Lecture 16 to Lecture 18

!!! Abstract "Table of Contents"

    - [x] [Lecture 16: Recurrent Neural Networks](#lecture-16-recurrent-neural-networks)
    - [ ] [Lecture 17: Attention](#lecture-17-attention)
    - [ ] [Lecture 18: Vision Transformers](#lecture-18-vision-transformers)

## Lecture 16: Recurrent Neural Networks

迄今为止，我们使用的都是前馈神经网络，输入和输出是一对一的关系。但是对于很多情况，比如序列输入或者输出，以及神经网络需要与时间序列相关的信息，前馈神经网络就无能为力了，因此我们引入循环神经网络/Recurrent Neural Network/RNN。简单结构与分类如下：

<img class="center-picture" src="../assets_1/16-1.png" width=600 />

- 一对一：比如图像识别任务，Image -> Label；
- 一对多： 例如图像描述任务，Image -> Description (Sequence of Words)；
- 多对一：比如视频分类任务：Sequence of Images -> Label；
- 多对多：比如机器翻译任务，Sequence of Words -> Sequence of Words；

循环神经网络的核心想法是对一个向量在每一步应用相同的循环公式，其生成的新状态都和旧状态和当前输入相关：

<img class="center-picture" src="../assets_1/16-2.png" width=600 />

RNN 的计算图如下，对于 Many to Many 的情况，我们需要在每一个时刻根据当前状态和输入计算出下一个时刻的隐藏状态，并且根据隐藏状态计算出输出。这种情况的损失计算方法为：对每一时刻的输出计算损失再求和。

<img class="center-picture" src="../assets_1/16-3.png" width=600 />

对于 One to Many 的情况，我们只需要根据输入利用循环方程不断更新隐藏状态，直到生成足够多的输出。对于 Many to One 的情况，我们只需要在最后一步利用隐藏状态计算出输出。

Many to Many 的情况可以拆分成 Many to One 的情况和 One to Many 的情况，这种也被称为 Sequence-to-Sequence 模型。前半部分将输入序列编码成一个向量，后半部分从一个输入向量产生输出序列。

<img class="center-picture" src="../assets_1/16-4.png" width=600 />

Language Modeling 是一个经典的问题，具体细节暂且不表，需要注意的是输入的处理：一个经典的想法是将输入编码为独热码，但是这会使得输入矩阵过于稀疏，并且难以处理长序列。因此我们使用词嵌入/Word Embedding 来将输入编码为密集向量。

<img class="center-picture" src="../assets_1/16-5.png" width=600 />

RNN 的反向传播也是一个问题，问题来自于其结构：对于循环公式而言，我们需要将梯度从当前状态传播到前一个状态，也就是沿着时间展开 Back Propagation Through Time/BPTT。注意到如果我们在自然语言处理领域处理长序列，我们可以很容易达到非常长的序列，比如你正在看的这篇笔记到这里已经有了两万余字符，这样展开的 RNN 就会非常深，因此需要考虑一下如何处理。大概想法是 Truncated BPTT，也就是只展开一小段时间，然后进行反向传播。

<img class="center-picture" src="../assets_1/16-6.png" width=600 />

下图是一个 Image Captioning 的例子，输入是一张图片，骨干网络输出一个特征图，将特征图喂给 RNN 生成描述。

<img class="center-picture" src="../assets_1/16-7.png" width=600 />

对于经典的 Vanilla RNN 有

$$\begin{aligned}
h_t &= \tanh(W_{hh} h_{t-1} + W_{xh} x_t + b_h) \\
&= \tanh \left( (W_{hh} \quad W_{xh}) \begin{pmatrix} h_{t-1} \\ x_t \end{pmatrix} + b_h \right) \\
&= \tanh \left( W \begin{pmatrix} h_{t-1} \\ x_t \end{pmatrix} + b_h \right).
\end{aligned}$$

<img class="center-picture" src="../assets_1/16-8.png" width=600 />

可以看到，当我们对 $h$ 进行反向传播的时候，每一步都会乘以一个 $W_{hh}$，当层数一多，就会出现两种问题：

- 梯度爆炸/Gradient Exploding：来自于 $W_{hh}$ 的最大特征值大于 1，解决方法是梯度裁剪/Gradient Clipping，如果梯度太大了，就对梯度进行缩放：

    ```python
    grad_norm = np.sum(grad * grad)
    if grad_norm > threshold:
        grad = grad * threshold / grad_norm
    ```

- 梯度消失/Gradient Vanishing：来自于 $W_{hh}$ 的最大特征值小于 1，解决方法只能是修改 RNN 架构，比如下面的长短期记忆网络/Long Short-Term Memory/LSTM：

!!! Info 

    很经典的一篇 Blog：[Understanding LSTM Networks](https://colah.github.io/posts/2015-08-Understanding-LSTMs/) 中提到：***LSTMs are explicitly designed to avoid the long-term dependency problem***.

LSTM 架构在每一个时间点考虑两个向量：Cell State 和 Hidden State，和四个门：Input Gate、Output Gate、Forget Gate、Update Gate。

<img class="center-picture" src="../assets_1/16-9.png" width=600 />

<img class="center-picture" src="../assets_1/16-10.png" width=600 />

分析梯度流可以发现，对 $C_t$ 的梯度流会直接流经 $C_{t-1}$，记忆单元直接在时间步之间传递信息，这是因为 $C_t$ 是直接将 $C_{t-1}$ 和 $f_t$ 进行逐位相乘得到的，因此反向传播只需要执行加法，也就是不会出现梯度消失的问题。这样的设计也很类似 ResNet 的残差连接部分。

上述聊的是单层的 RNN，还可以设计更复杂的多层 RNN，比如下面的双层 RNN 就是将一个单层 RNN 的输出作为另一个单层 RNN 的输入：

<img class="center-picture" src="../assets_1/16-11.png" width=600 />

另一个变种是门控循环单元/Gated Recurrent Unit/GRU，结构更加简单，只有两个门：Reset Gate 和 Update Gate，并且将 Cell State 和 Hidden State 合并为单个状态。

<img class="center-picture" src="../assets_1/16-12.png" width=600 />

<img class="center-picture" src="../assets_1/16-13.png" width=600 />

## Lecture 17: Attention



## Lecture 18: Vision Transformers

