---
layout: post
title: deeplearning.ai深度学习课程 第一阶段第二周
categories: coding
tag: [机器学习, 深度学习]
---

![幻灯片1](\img\deeplearning-ai-coursera\C1W2L01\幻灯片1.JPG)

第二课开始介绍神经网络的基础。从二分类讲起，这是最基本也很常用的一类问题。<!-- more -->

![幻灯片2](\img\deeplearning-ai-coursera\C1W2L01\幻灯片2.JPG)

深度学习中的Hello World问题是猫的判定问题。建模的时候，还是要弄清楚输入输出。彩色图像最简单的预处理就是按三原色和像素点来建立一个长为$$3ab$$的输入向量。

![幻灯片3](\img\deeplearning-ai-coursera\C1W2L01\幻灯片3.JPG)

在这门课中，输入矩阵X的表示和很多教材有点区别，样本按列排列，特征则按行排列，本质上都没有什么区别，但是这样写应该能节省不少矩阵转置操作。

![幻灯片1](\img\deeplearning-ai-coursera\C1W2L02\幻灯片1.JPG)

接下来老师讲了Logistic回归，这个算法虽然简单，但是很实用，而且可视为神经网络的基础单元或者最简形式，在此之前，我还真没仔细联系过这两个算法。

![幻灯片2](\img\deeplearning-ai-coursera\C1W2L02\幻灯片2.JPG)

Logistic回归的直观想法是，我们要做二分类预测，往往其实给不出100%确定的结论，那么用一个概率来表示预测值，因此我们想把特征值线性组合得到的分数变成一个0~1之间的概率值，而且中间以0.5为分界点，这个函数一般就采用了Sigmoid函数。![幻灯片3](\img\deeplearning-ai-coursera\C1W2L02\幻灯片3.JPG)

我们需要一个代价函数，计算预测的准确性，从而衡量我们给出的Logistic回归参数是否比较好。更准确的说，应该是根据代价函数最小化来反推Logistic回归参数，这就是机器学习一般的思路。

![幻灯片4](\img\deeplearning-ai-coursera\C1W2L02\幻灯片4.JPG)

先计算一个样本的损失函数，在对所有的样本取平均。

一个样本的损失函数$$L(\widehat{y}, y)=-(ylog\widehat{y}+(1-y)(1-log\widehat{y}))$$，直观上来看，根据$$y$$的取值，是一个分段函数，能够较好的反应预测的损失，比如$$y=1$$时，$$L(\widehat{y}, y)=-log\widehat{y}$$，$$\widehat{y}\rightarrow1$$时，$$L(\widehat{y}, y)\rightarrow0$$。严格来说，这个函数是通过极大似然法建立的。简单点说，是把所有预测的概率相乘，求它的最大值，这个在台大的机器学习公开课里面讲得比较清楚。

![幻灯片1](\img\deeplearning-ai-coursera\C1W2L03\幻灯片1.JPG)

接下来讨论损失函数最优化问题的基本算法——梯度下降法。

![幻灯片2](\img\deeplearning-ai-coursera\C1W2L03\幻灯片2.JPG)

这么课程甚至没有对微积分做太多的先导知识假设，而是从梯度的物理意义来描述。不过即使微积分算得很熟练，从直观上去理解也还是很有帮助的。梯度下降法，就是在函数平面上，往梯度的方向（切线方向）的相反方向移动，尝试到达最低点。所以这个代价函数，应该设计成凸函数。

![幻灯片3](\img\deeplearning-ai-coursera\C1W2L03\幻灯片3.JPG)

老师还介绍了惯用的符号。

接下来介绍了导数的概念，这里就省略了，建议忘了的人还是找本微积分教材看看，个人推荐《普林斯顿微积分读本》，入门来看很好。

[PPT略]

![幻灯片1](\img\deeplearning-ai-coursera\C1W2L06\幻灯片1.JPG)

接下来具体讨论Logistics回归的梯度下降。

![幻灯片2](\img\deeplearning-ai-coursera\C1W2L06\幻灯片2.JPG)

首先回顾Logistic回归计算损失函数的过程，这看起来平淡无奇，但是神经网络的前向计算也是类似的，首先求得线性组合结果$$z$$，然后通过激励函数将其变成 $$a$$，然后作为输出和预期值比较。

![幻灯片3](\img\deeplearning-ai-coursera\C1W2L06\幻灯片3.JPG)

而求损失函数导数的过程，根据求导的链式法则，则刚好是反过来的。这里需要注意一些推导的细节，中间结果反复使用，比如$$\frac {da}{dz}=a(1-a)$$，目的是减轻程序中的计算量。

![幻灯片4](\img\deeplearning-ai-coursera\C1W2L06\幻灯片4.JPG)



m个样本的损失函数的梯度计算其实主要是求一个平均值。![幻灯片5](\img\deeplearning-ai-coursera\C1W2L06\幻灯片5.JPG)

不过这里的主要技巧是如何把这个过程用尽量少的符号表示，对应到程序计算时，就是直接使用向量化的计算来一次性搞定。

![幻灯片6](\img\deeplearning-ai-coursera\C1W2L06\幻灯片6.JPG)

最终的伪码总结了计算过程，体现了先前向计算，后反向计算的全过程。

这个计算过程有两重循环，通过向量化计算，都可以消除掉。

![幻灯片1](\img\deeplearning-ai-coursera\C1W2L07\幻灯片1.JPG)

向量化计算在matlab中是标配，而在python中，借助numpy库，也可以实现，这些库屏蔽了硬件细节，我们只需要写向量化的代码即可，加速的问题就交给库了。

![幻灯片2](\img\deeplearning-ai-coursera\C1W2L07\幻灯片2.JPG)

所谓的向量化，简单理解就是把向量当成整体来计算来写代码。即使只用CPU，也是支持向量化的。

![幻灯片3](\img\deeplearning-ai-coursera\C1W2L07\幻灯片3.JPG)

![幻灯片4](\img\deeplearning-ai-coursera\C1W2L07\幻灯片4.JPG)

介绍更多的例子，只要有可能，都规避循环操作。

![幻灯片5](\img\deeplearning-ai-coursera\C1W2L07\幻灯片5.JPG)

![幻灯片6](\img\deeplearning-ai-coursera\C1W2L07\幻灯片6.JPG)

常见的向量化操作包括向量的内积、乘积、以及针对单个向量所有元素的运算等。

![幻灯片7](\img\deeplearning-ai-coursera\C1W2L07\幻灯片7.JPG)

通过向量化消除内存循环。

![幻灯片1](\img\deeplearning-ai-coursera\C1W2L08\幻灯片1.JPG)

![幻灯片2](\img\deeplearning-ai-coursera\C1W2L08\幻灯片2.JPG)

![幻灯片3](\img\deeplearning-ai-coursera\C1W2L08\幻灯片3.JPG)

![幻灯片4](\img\deeplearning-ai-coursera\C1W2L08\幻灯片4.JPG)

![幻灯片5](\img\deeplearning-ai-coursera\C1W2L08\幻灯片5.JPG)

最终也消除了外层循环，我的个人经验是可以随时检查矩阵乘法是否匹配，以免犯一些低级错误。不过，有些循环是无法消除的，比如迭代次数的循环。

![幻灯片1](\img\deeplearning-ai-coursera\C1W2L09\幻灯片1.JPG)



![幻灯片2](\img\deeplearning-ai-coursera\C1W2L09\幻灯片2.JPG)

![幻灯片3](\img\deeplearning-ai-coursera\C1W2L09\幻灯片3.JPG)

![幻灯片4](\img\deeplearning-ai-coursera\C1W2L09\幻灯片4.JPG)

numpy中的广播概念其实很简单，基本上是符合人的直觉的，就是一种矩阵的自动复制与匹配过程。

