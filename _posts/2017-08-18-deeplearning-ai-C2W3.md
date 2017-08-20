---
layout: post
title: deeplearning.ai深度学习课程 第二阶段第三周
categories: coding
tag: [机器学习, 深度学习]
---

本周主要讨论超参数的调节，以及深度学习的框架。<!-- more -->

![幻灯片1](\img\deeplearning-ai-coursera\C2W3L01\幻灯片1.JPG)

![幻灯片2](\img\deeplearning-ai-coursera\C2W3L01\幻灯片2.JPG)

根据不同的优化算法，可以调节的超参数非常多，其中学习率是最重要的参数之一。

![幻灯片3](\img\deeplearning-ai-coursera\C2W3L01\幻灯片3.JPG)

超参数的选取不建议使用grid方法，而是用随机方法，因为每个超参数的影响力不一样。

![幻灯片4](\img\deeplearning-ai-coursera\C2W3L01\幻灯片4.JPG)

参数的选取可以用从粗到细的方法，缩放到最优的区域。

![幻灯片1](\img\deeplearning-ai-coursera\C2W3L02\幻灯片1.JPG)

接下来讨论参超参数的缩放问题。

![幻灯片2](\img\deeplearning-ai-coursera\C2W3L02\幻灯片2.JPG)

有些参数可以均匀随机选取。比如神经网络层数、某层的节点个数。

![幻灯片3](\img\deeplearning-ai-coursera\C2W3L02\幻灯片3.JPG)





有些参数比如学习率则适合在对数坐标上均匀随机选取。（这些参数一般接近0）具体实现时，先随机选取指数，再求幂。

![幻灯片4](\img\deeplearning-ai-coursera\C2W3L02\幻灯片4.JPG)

一些接近1的参数，可以用1减去后，在对数坐标上均匀选取。

如何理解：有时候参数变化的比例比绝对值要重要。

![幻灯片1](\img\deeplearning-ai-coursera\C2W3L03\幻灯片1.JPG)

调参的两种基本思路。

![幻灯片2](\img\deeplearning-ai-coursera\C2W3L03\幻灯片2.JPG)

调参的经验在各种领域不通用；模型训练好后，随着时间的推移，也需要重新测试调参。

![幻灯片3](\img\deeplearning-ai-coursera\C2W3L03\幻灯片3.JPG)

熊猫法是训练单个模型，视情况调参；鱼子酱法是一次并行训练多个模型。用哪种主要取决于计算资源的多寡。

![幻灯片1](\img\deeplearning-ai-coursera\C2W3L04\幻灯片1.JPG)

接下来讨论另一个优化手段，activation的归一化。

![幻灯片2](\img\deeplearning-ai-coursera\C2W3L04\幻灯片2.JPG)

直观理解也很简单，不过就是把归一化手段不但用到输入层，也用到了隐藏层。

![幻灯片3](\img\deeplearning-ai-coursera\C2W3L04\幻灯片3.JPG)

具体实现时，在归一化后，再用两个参数控制它的均值和方差，这两个参数不用作为超参数给定，而是像w一样作为参数用梯度下降优化。（在这种情况下，参数b已经没有意义，可以设为0）

![幻灯片1](\img\deeplearning-ai-coursera\C2W3L05\幻灯片1.JPG)

具体如何实现？

![幻灯片2](\img\deeplearning-ai-coursera\C2W3L05\幻灯片2.JPG)

前向计算时，每层多一个步骤。

如果使用tensorflow，该优化功能已经内置实现了，直接调用即可。

![幻灯片3](\img\deeplearning-ai-coursera\C2W3L05\幻灯片3.JPG)

注意这个优化一般结合mini-batches一起使用。

![幻灯片4](\img\deeplearning-ai-coursera\C2W3L05\幻灯片4.JPG)

这个优化可以结合adam算法等一起使用（注意梯度下降的参数变为3个）。

![幻灯片1](\img\deeplearning-ai-coursera\C2W3L06\幻灯片1.JPG)

为啥有效呢？第一个直观解释跟样本的归一化是一样的，可以使得各个节点的影响力相当。

![幻灯片2](\img\deeplearning-ai-coursera\C2W3L06\幻灯片2.JPG)

另外一个解释需要引入输入分布变化的概念，当测试样本的分布和输入样本不一样时，效果会比较差。

![幻灯片3](\img\deeplearning-ai-coursera\C2W3L06\幻灯片3.JPG)

在深度网络后面一些层的节点来看，前面几层节点的分布是时刻变化的，因此不能很好的适应，而归一化则能缓解这个问题。

![幻灯片4](\img\deeplearning-ai-coursera\C2W3L06\幻灯片4.JPG)

此外，归一化还带来了一定的正则化的作用。因为每个mini-batch使用不同的参数缩放，引入了一定的噪声。

![幻灯片1](\img\deeplearning-ai-coursera\C2W3L07\幻灯片1.JPG)

测试样本可能是单个单个的，那么测试样本怎么做相应的变化呢？

![幻灯片2](\img\deeplearning-ai-coursera\C2W3L07\幻灯片2.JPG)

可以用指数移动平均的方法在训练阶段记录相应的均值和方差，用于测试阶段。

![幻灯片1](\img\deeplearning-ai-coursera\softmax-new\幻灯片1.JPG)

如何使用深度网络进行多分类？

![幻灯片2](\img\deeplearning-ai-coursera\softmax-new\幻灯片2.JPG)

最后一层的节点数等于分类数。

![幻灯片3](\img\deeplearning-ai-coursera\softmax-new\幻灯片3.JPG)

[这几张ppt有问题]

总的来说，就是每个节点输出一个概率值，它是在最终求得的Z值基础上，先用e做底指数化，再求每个节点占指数化后总和的占比。之所以叫softmax，是因为直接取0~1分布的叫hardmax，使用softmax求的cost更合理。

![幻灯片4](\img\deeplearning-ai-coursera\softmax-new\幻灯片4.JPG)

直接使用softmax，也可以做多分类，只不过边界都是线性的，而用于深度网络最后一层，则可以做复杂边界的多分类。

![幻灯片1](\img\deeplearning-ai-coursera\C2W3L08\幻灯片1.JPG)

介绍一下各种框架。

![幻灯片2](\img\deeplearning-ai-coursera\C2W3L08\幻灯片2.JPG)

选取框架的三个原则：易用、计算速度、真正的开源。

![幻灯片1](\img\deeplearning-ai-coursera\C2W3L09\幻灯片1.JPG)

介绍其中一种tensorflow。

![幻灯片2](\img\deeplearning-ai-coursera\C2W3L09\幻灯片2.JPG)

![幻灯片3](\img\deeplearning-ai-coursera\C2W3L09\幻灯片3.JPG)

tensorflow是构建一个计算图，只需要描述前向计算过程，框架自动完成反向传播。注意理解tensor的概念，session的概念，constant、placeholder等概念。

