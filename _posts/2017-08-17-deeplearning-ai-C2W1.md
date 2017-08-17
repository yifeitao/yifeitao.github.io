---
layout: post
title: deeplearning.ai深度学习课程 第二阶段第一周
categories: coding
tag: [机器学习, 深度学习]
---

本周课程开始讨论一些工程实践中的重要问题。

![幻灯片1](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L01\幻灯片1.JPG)

首先是数据集的划分问题。

![幻灯片2](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L01\幻灯片2.JPG)

由于深度学习面向的领域复杂，相互之间经验迁移困难，因此试验是决定超参数的主要方法。<!-- more -->

![幻灯片3](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L01\幻灯片3.JPG)

数据划分为训练集、验证集、测试集，深度学习和一般的机器学习划分数据的差别在于，如果数据量非常大，则验证集和测试集的比例可以调低。

![幻灯片4](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L01\幻灯片4.JPG)

主要要保证验证集和测试集的分布相同，而训练集则不强求。有时候没有测试集也是可以的。（人们习惯称没有验证集，但这是不准确的。）

![幻灯片1](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L02\幻灯片1.JPG)

接下来讨论机器学习中重要的概念：偏差和方差。

![幻灯片2](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L02\幻灯片2.JPG)

这些概念和一般的机器学习是一样的。

![幻灯片3](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L02\幻灯片3.JPG)

注意，有时候可能偏差和方差都很大。另外，要注意比较的基准，比如以人的识别率为基准。

![幻灯片4](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L02\幻灯片4.JPG)

高偏差和高方差同时存在时一般时某些区域偏差高，某些区域方差高。

![幻灯片5](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L02\幻灯片5.JPG)



![幻灯片7](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L02\幻灯片7.JPG)

解决方差高或偏差高要对症下药。比如偏差高则使用更复杂的模型，方差高则使用更多的数据或正则化。![幻灯片1](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L03\幻灯片1.JPG)

下面讨论正则化。

![幻灯片2](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L03\幻灯片2.JPG)

首先复习Logistic的正则化。一般用的比较多的是L2正则化。

![幻灯片3](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L03\幻灯片3.JPG)

神经网络则正则化要注意几点：1，代价函数的计算要多一项；2，W导数的计算要多一项，相当于W在梯度下降时先缩小了一些。![幻灯片1](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L03b\幻灯片1.JPG)

如何直观理解正则化会有效？

![幻灯片2](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L03b\幻灯片2.JPG)

正则化有效的一个直观解释是加上正则项后，参数w更倾向于取较小的数（接近0）,相当于某些节点不太起作用，简化了网络结构。

![幻灯片3](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L03b\幻灯片3.JPG)

第二个理解的角度是，w较小的时候，在激活函数中更接近线性区域，这样会简化网络结构。

![幻灯片1](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L04\幻灯片1.JPG)

接下来介绍另一种正则化方法Dropout。

![幻灯片2](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L04\幻灯片2.JPG)

思路就是以一定的概率使节点不起作用，也就是让节点的激活输出为0。

![幻灯片3](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L04\幻灯片3.JPG)

具体实现时，注意用一个概率分布来作为掩码来改变激活输出。此外，还要相应放大剩下的输出，使得接收节点的得到的总和维持不变。注意，前向运算和反向传播都需要掩码操作。

![幻灯片4](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L04\幻灯片4.JPG)

这样，在实际测试时，不用考虑Dropout的问题，按照一般的神经网络使用即可。

![幻灯片5](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L04\幻灯片5.JPG)

为什么Dropout会起作用呢？

![幻灯片6](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L04\幻灯片6.JPG)

直观的理解就是这样使得神经网络不依赖某个具体的输入特征，而是在某些特征缺失的情况下训练，更能适应未知的情况。

![幻灯片1](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L05\幻灯片1.JPG)

介绍一些其他的正则化方法。

![幻灯片2](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L05\幻灯片2.JPG)

首先是可以通过样本变换，生成更多的样本，这比采集样本要便宜。

![幻灯片3](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L05\幻灯片3.JPG)

其次，可以监测一些准确率的变化，提前退出训练的循环。但是这种提前退出法，试图一次性解决偏差和方差问题，可能效果并不会好。

![幻灯片1](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L06\幻灯片1.JPG)

接下来讨论如何优化计算。

![幻灯片2](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L06\幻灯片2.JPG)

首先，我们应当把训练集归一化，方法是减去均值后除以方差。注意验证集和测试集要用训练集的均值和方差处理。

![幻灯片3](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L06\幻灯片3.JPG)

归一化有用的直观解释是，把代价函数从不对称变成了对称，梯度下降时能更快到达底部。

![幻灯片1](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L07\幻灯片1.JPG)

接下来时参数的初始化问题。

![幻灯片2](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L07\幻灯片2.JPG)

参数大于1，进过多层网络后，会使得代价值指数级增长。参数小于1，进过多层网络后，会使得代价值指数级减小。这曾经时深度学习的障碍之一。

![幻灯片3](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L07\幻灯片3.JPG)

目前比较好的方法时，在参数初始化时归一化，对ReLU激活函数，w初始化时用0~1之间的随机数乘上一个缩放因子,注意它与前一层的大小相关。

[PPT略]

接下来介绍如何检查反向传播计算是否正确，最主要时检查导数计算是否正确。可以通过导数的极限定义来近似计算。

![幻灯片1](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L09\幻灯片1.JPG)

下面介绍具体的方法。

![幻灯片2](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L09\幻灯片2.JPG)

首先把所有的参数用一个向量来表示，注意这个转换是双向的。

![幻灯片3](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L09\幻灯片3.JPG)

然后，对每一个参数，计算导数的极限近似。

为了快速检查一致性，做差的平方和检验，一般$$10^{-7}$$是个检验标准，如果高于$$10^{-5}甚至$$$$10^{-3}$$则需要注意寻找代码中的错误了。

![幻灯片4](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L09\幻灯片4.JPG)

![幻灯片5](C:\Users\fidel\OneDrive\Workspace\yifeitao.github.io\img\deeplearning-ai-coursera\C2W1L09\幻灯片5.JPG)



在具体实现的时候有一些注意事项。





