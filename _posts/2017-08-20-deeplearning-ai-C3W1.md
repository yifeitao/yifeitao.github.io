---
layout: post
title: deeplearning.ai深度学习课程 第三阶段第一周
categories: coding
tag: [机器学习, 深度学习]
---

本周主要讨论深度学习项目中的策略问题。这应当是课程中最有特色的部分之一了，比较偏工程应用，而在很多偏理论的教材里面是不会讲这么系统的。<!-- more -->

![幻灯片1](\img\deeplearning-ai-coursera\C3W1L01\幻灯片1.JPG)

![幻灯片2](\img\deeplearning-ai-coursera\C3W1L01\幻灯片2.JPG)

为什么会有策略问题？现实中，当我们觉得深度网络表现得还不好时，有很多方法可以取调节，那么究竟要使用哪些方法呢，这时候就有一个策略选择的问题。

![幻灯片1](\img\deeplearning-ai-coursera\C3W1L02\幻灯片1.JPG)

首先介绍一下正交性的概念。

![幻灯片2](\img\deeplearning-ai-coursera\C3W1L02\幻灯片2.JPG)

老师举了老式电视机的例子，我个人的经验是目前的大多数投影仪的调节还是这样的，然后还有开车的例子，总的来说，正交性就是要达到一个按钮调节一个参数的效果，在某些天线中也有类似交叉耦合的概念，交叉耦合作为一个非正交性指标，是要尽量降低的。

![幻灯片3](\img\deeplearning-ai-coursera\C3W1L02\幻灯片3.JPG)

具体到深度学习中，有四种情况需要优化调节，我们在处理的时候要尽量一个一个来，所用的方法应该主要解决其中一个问题。这四种情况也好立即，就是从训练、验证、测试再到实用阶段。

![幻灯片1](\img\deeplearning-ai-coursera\C3W1L03\幻灯片1.JPG)

如何评估算法的好坏？首先要有标准，最好是用一个数字表示的。

![幻灯片2](\img\deeplearning-ai-coursera\C3W1L03\幻灯片2.JPG)

有两个标准时，不好比较。比如准确率和召回率可以统一用F1表示。

![幻灯片3](\img\deeplearning-ai-coursera\C3W1L03\幻灯片3.JPG)

另外一个例子是多个区域，可以用平均值来表示。

![幻灯片1](\img\deeplearning-ai-coursera\C3W1L04\幻灯片1.JPG)

有多个标准要满足怎么办？这时针对多个目标优化很困难。

![幻灯片2](\img\deeplearning-ai-coursera\C3W1L04\幻灯片2.JPG)

可以找到一个主要的优化目标，而将其他作为限制条件，只要满足即可。比如在满足召回率要求的前提下，准确率越高越好。

![幻灯片1](\img\deeplearning-ai-coursera\C3W1L05\幻灯片1.JPG)

接下来就是如何设定测试集和验证集的问题了。

![幻灯片2](\img\deeplearning-ai-coursera\C3W1L05\幻灯片2.JPG)

首先，验证集和测试集一定要来自同样的分布，否则相当于对着一个靶子训练了很久，结果打靶时靶子不再那儿。

![幻灯片3](\img\deeplearning-ai-coursera\C3W1L05\幻灯片3.JPG)

老师讲了一个真实的悲剧。

![幻灯片4](\img\deeplearning-ai-coursera\C3W1L05\幻灯片4.JPG)

总的来说，就是应当验证和测试你真正关心的目标。

![幻灯片1](\img\deeplearning-ai-coursera\C3W1L06\幻灯片1.JPG)

那么，验证集和测试集应当设置多大？

![幻灯片2](\img\deeplearning-ai-coursera\C3W1L06\幻灯片2.JPG)

传统的方式是类似6:2:2的分配。![幻灯片3](\img\deeplearning-ai-coursera\C3W1L06\幻灯片3.JPG)

在深度学习中，一般样本非常多，所以验证集只要够大，能够验证出算法和模型的性能即可。比如10000个数据。

![幻灯片4](\img\deeplearning-ai-coursera\C3W1L06\幻灯片4.JPG)

测试集也类似，只要绝对数量够多就行。甚至有时候是可以省略的。

![幻灯片1](\img\deeplearning-ai-coursera\C3W1L07\幻灯片1.JPG)

还有些情况要重新设定验证/测试集合甚至标准。

![幻灯片2](\img\deeplearning-ai-coursera\C3W1L07\幻灯片2.JPG)

比如，用户增加了新的需求，有了新的关注点。

![幻灯片3](\img\deeplearning-ai-coursera\C3W1L07\幻灯片3.JPG)

这种情况下首先考虑制定新的标准，然后再考虑如何针对这个标准来优化模型。

![幻灯片4](\img\deeplearning-ai-coursera\C3W1L07\幻灯片4.JPG)

如果发现验证集/测试集过于理想化，则要考虑根据实际情况更改验证集/测试集。

![幻灯片1](\img\deeplearning-ai-coursera\C3W1L08\幻灯片1.JPG)

为什么要把算法和人作比较？

![幻灯片2](\img\deeplearning-ai-coursera\C3W1L08\幻灯片2.JPG)

可以把人的准确率等视为贝叶斯错误的上限，因为人很擅长图形识别类似的工作。

![幻灯片3](\img\deeplearning-ai-coursera\C3W1L08\幻灯片3.JPG)

同时当机器学习的效果比人差时，可以做一些针对性分析，或让人帮助机器。

![幻灯片1](\img\deeplearning-ai-coursera\C3W1L08B\幻灯片1.JPG)

引入一个新的概念：可以避免的偏差。

![幻灯片2](\img\deeplearning-ai-coursera\C3W1L08B\幻灯片2.JPG)

![幻灯片3](\img\deeplearning-ai-coursera\C3W1L08B\幻灯片3.JPG)

![幻灯片4](\img\deeplearning-ai-coursera\C3W1L08B\幻灯片4.JPG)

把人的标准近似认作理论上限，那么训练误差和人的误差之间的差值，则认为是可以避免的偏差。

![幻灯片1](\img\deeplearning-ai-coursera\C3W1L09\幻灯片1.JPG)



![幻灯片2](\img\deeplearning-ai-coursera\C3W1L09\幻灯片2.JPG)

如何界定人的错误标准，还是要视情况而定，一般如何用于模拟贝叶斯标准，则越小越好，如果用于证明算法的有效性，则不妨取一般性的数据。

![幻灯片3](\img\deeplearning-ai-coursera\C3W1L09\幻灯片3.JPG)

在不同的训练误差和验证误差的情况下，人的误差可能影响可消除的偏差与方差之间的大小关系。

![幻灯片4](\img\deeplearning-ai-coursera\C3W1L09\幻灯片4.JPG)

总的来说，我们要定义好上限标准，然后分析到底是可消除的偏差大，还是方差大。

![幻灯片1](\img\deeplearning-ai-coursera\C3W1L10\幻灯片1.JPG)

算法有没有可能比人表现好呢？

![幻灯片2](\img\deeplearning-ai-coursera\C3W1L10\幻灯片2.JPG)

一般来说很难，而且由于接近了理论极限，算法取得改进的可能越来越小。

![幻灯片3](\img\deeplearning-ai-coursera\C3W1L10\幻灯片3.JPG)

不过在结构化数据的分析，甚至某些语音识别与图像识别的具体问题上，算法都超越了人。

![幻灯片1](\img\deeplearning-ai-coursera\C3W1L11\幻灯片1.JPG)

总结一下，如何提高模型的性能呢？

![幻灯片2](\img\deeplearning-ai-coursera\C3W1L11\幻灯片2.JPG)

首先要明确监督学习中的两大目标，训练好和验证好。

![幻灯片3](\img\deeplearning-ai-coursera\C3W1L11\幻灯片3.JPG)

在人的误差，训练误差，验证误差间有两个间隔，分析哪个间隔要优化，然后实用对应的方法，最好是让一个方法只减小一种间隔。