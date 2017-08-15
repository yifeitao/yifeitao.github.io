---
layout: post
title: deeplearning.ai深度学习课程 第一阶段第三课
categories: coding
tag: [机器学习, 深度学习]
---

![幻灯片1](\img\deeplearning-ai-coursera\C1W3L01\幻灯片1.JPG)

这节课开始讲一般的神经网络。

![幻灯片2](\img\deeplearning-ai-coursera\C1W3L01\幻灯片2.JPG)

首先给出了一个概览，课程中研究的神经网络只有一个隐藏层，这很实用也能说明问题。老师给出的计算图，表达力很好，很快就能明白所谓的前向计算和反向计算是怎么一回事。

![幻灯片1](\img\deeplearning-ai-coursera\C1W3L02\幻灯片1.JPG)

首先，考察一个样本的前向计算过程。

![幻灯片2](\img\deeplearning-ai-coursera\C1W3L02\幻灯片2.JPG)

一般惯称的k层神经网络，是不把输入层算在内的。除开输入层和输出层，其他的被称为中间层。使用参数矩阵W，可以一次性将向量X映射到向量Z。把X放在W右边，所以W的维度是输出x输入。

![幻灯片3](\img\deeplearning-ai-coursera\C1W3L02\幻灯片3.JPG)

![幻灯片4](\img\deeplearning-ai-coursera\C1W3L02\幻灯片4.JPG)



考察单个节点，其实就是做一个Logistic运算。

![幻灯片5](\img\deeplearning-ai-coursera\C1W3L02\幻灯片5.JPG)

而整个计算过程，每一个隐藏节点或输出层节点都对应一个Logistic计算过程。

![幻灯片6](\img\deeplearning-ai-coursera\C1W3L02\幻灯片6.JPG)

将每一层的多个计算过程纵向堆叠起来成矩阵计算，这样每一层可以用一次Logistic计算来表达。

![幻灯片7](\img\deeplearning-ai-coursera\C1W3L02\幻灯片7.JPG)

对2层神经网络，单个样本的前向计算过程总结为4步。

![幻灯片1](\img\deeplearning-ai-coursera\C1W3L03\幻灯片1.JPG)

下面开始扩展到m个样本的计算，关键还是如何通过向量化消除掉循环。

![幻灯片2](\img\deeplearning-ai-coursera\C1W3L03\幻灯片2.JPG)

首先不难给出m个样本分别计算时的循环形式。

![幻灯片3](\img\deeplearning-ai-coursera\C1W3L03\幻灯片3.JPG)

然后可以把关于样本循环的X、A、Z等都横向堆叠起来形成矩阵。

![幻灯片4](\img\deeplearning-ai-coursera\C1W3L03\幻灯片4.JPG)

![幻灯片5](\img\deeplearning-ai-coursera\C1W3L03\幻灯片5.JPG)

老师用不同的颜色的三个样本解释了一遍如何向量化，其实如果矩阵乘法熟一点很好理解。将循环与向量化后的计算过程仔细查看，能够建立其最简单的直觉和最复杂的矩阵计算之间的关系，更加复杂的理解才不是空中楼阁。

![幻灯片6](\img\deeplearning-ai-coursera\C1W3L03\幻灯片6.JPG)

最后，针对m个样本的计算过程依然是总结为4个步骤，矩阵计算的意义保证了它的正确性，而从记忆的层面来讲，首先是记住样本是横向堆叠的，这样相应的Z，A也是横向堆叠的，然后是每一层一个线性组合，一个激励函数，每一层最终的计算过程和单个的Logistc回归是类似的。

![幻灯片1](\img\deeplearning-ai-coursera\C1W3L04\幻灯片1.JPG)

接下来讨论一下激活函数，从Logistic回归算法引入，建立了神经网络模型，现在要替换掉Sigmoid函数了。

![幻灯片2](\img\deeplearning-ai-coursera\C1W3L04\幻灯片2.JPG)

![幻灯片3](\img\deeplearning-ai-coursera\C1W3L04\幻灯片3.JPG)

一般都是用tanh函数替代Sigmoid函数，因为它的均值在0附近，而为了加快计算梯度下降，现代的神经网络用得最多的是ReLu函数或者它的变种。注意，每个神经元的激活函数不一定要一样，一般输出层的激活函数需要根据问题类型来选择，比如二分类问题还是一般使用Sigmod函数，而回归问题甚至直接输出线性组合结果而不需要激活函数。

![幻灯片1](\img\deeplearning-ai-coursera\C1W3L05\幻灯片1.JPG)

![幻灯片2](\img\deeplearning-ai-coursera\C1W3L05\幻灯片2.JPG)

为什么需要激活函数，而不直接输出线性组合结果呢？因为如果没有激活函数，则多层神经网络的优势就提现不出来，再多的层次组合也仍然是输入的直接的线性组合。

![幻灯片1](\img\deeplearning-ai-coursera\C1W3L06\幻灯片1.JPG)

接下来讨论这些常见激活函数的导数，这是反向传播计算时的关键。

![幻灯片2](\img\deeplearning-ai-coursera\C1W3L06\幻灯片2.JPG)

![幻灯片3](\img\deeplearning-ai-coursera\C1W3L06\幻灯片3.JPG)

![幻灯片4](\img\deeplearning-ai-coursera\C1W3L06\幻灯片4.JPG)

这都是很简单的导数计算，注意的是可以利用前向计算时已有的结果。

![幻灯片1](\img\deeplearning-ai-coursera\C1W3L07\幻灯片1.JPG)

反向计算时，实际上还是利用求导数的链式反则，从最后的输出的代价函数往前推算。

![幻灯片2](\img\deeplearning-ai-coursera\C1W3L07\幻灯片2.JPG)

使用梯度下降法的核心问题还是计算代价函数相对于各个参数的导数。

![幻灯片3](\img\deeplearning-ai-coursera\C1W3L07\幻灯片3.JPG)

这些计算基于链式法则。在写代码的时候，注意矩阵形状的匹配，能检测出很多bug。

![幻灯片1](\img\deeplearning-ai-coursera\C1W3L08\幻灯片1.JPG)

![幻灯片2](\img\deeplearning-ai-coursera\C1W3L08\幻灯片2.JPG)

整个计算过程其实和Logistic回归是类似的，只不过需要计算多个轮次。

![幻灯片3](\img\deeplearning-ai-coursera\C1W3L08\幻灯片3.JPG)

使用计算图更容易看出链式法则的关系。

![幻灯片4](\img\deeplearning-ai-coursera\C1W3L08\幻灯片4.JPG)

![幻灯片5](\img\deeplearning-ai-coursera\C1W3L08\幻灯片5.JPG)

将单个样本的计算过程横向堆叠，就可以得到m个样本的向量化计算过程。

![幻灯片1](\img\deeplearning-ai-coursera\C1W3L09\幻灯片1.JPG)

接下来讨论参数的初始化问题。

![幻灯片2](\img\deeplearning-ai-coursera\C1W3L09\幻灯片2.JPG)

为什么W不能初始化为全0，因为如果这样，每一层的输出始终都是相同的，就失去了设置多个神经元的意义。

![幻灯片3](\img\deeplearning-ai-coursera\C1W3L09\幻灯片3.JPG)

一般W初始化为较小的数0.01，因为如果设置得太大，如果激活函数是Sigmoid，则梯度下降太慢。