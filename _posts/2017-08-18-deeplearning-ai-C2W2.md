---
layout: post
title: deeplearning.ai深度学习课程 第二阶段第二周
categories: coding
tag: [机器学习, 深度学习]
---

本周主要讨论的是梯度下降时的一些优化方法，这可以提高计算速度，甚至优化计算结果。<!-- more -->

![幻灯片1](\img\deeplearning-ai-coursera\C2W2L01\幻灯片1.JPG)

![幻灯片2](\img\deeplearning-ai-coursera\C2W2L01\幻灯片2.JPG)

mini-batch很好理解，就是样本太多时候，不一次性算完，而是分割成很多batch来逐个梯度下降，这样，能够尽快的利用样本进行梯度下降。实践中需要先随机化样本，使得样本分布尽量一致。

![幻灯片3](\img\deeplearning-ai-coursera\C2W2L01\幻灯片3.JPG)

注意，把所有的mini batch计算一遍叫做一次epoch，比一般的gd算法多了一重循环。

![幻灯片1](\img\deeplearning-ai-coursera\C2W2L02\幻灯片1.JPG)

如何理解呢？

![幻灯片2](\img\deeplearning-ai-coursera\C2W2L02\幻灯片2.JPG)



比较Batch和Mini-batch，注意代价函数曲线的变化。

![幻灯片3](\img\deeplearning-ai-coursera\C2W2L02\幻灯片3.JPG)

Mini-batch的两个极端情况，Batch方法每获得一次梯度下降时间太长，而Stochastic方法则没用到向量化，整个计算太慢。Mini-batch介于两者之间，即用到了向量化，也能够较快的获得梯度下降。

![幻灯片4](\img\deeplearning-ai-coursera\C2W2L02\幻灯片4.JPG)

Mini-batch的大小是个超参数，一般使用64、128、256或512，注意都是2的次幂。

![幻灯片1](\img\deeplearning-ai-coursera\c2w2l03\幻灯片1.JPG)

引入一个指数移动平均的概念。

![幻灯片2](\img\deeplearning-ai-coursera\c2w2l03\幻灯片2.JPG)

滚动式的加权平均历史值和当前实测值。

![幻灯片3](\img\deeplearning-ai-coursera\c2w2l03\幻灯片3.JPG)

历史值权值越高，曲线越平滑，也越向右偏。

![幻灯片3](\img\deeplearning-ai-coursera\C2W2L03b\幻灯片3.JPG)

怎么理解，可以将递推式展开，发现是把历史上的所有值加权，权重随时间间隔指数递减，大约在$$1/(1-\beta)$$处减到约1/3。

![幻灯片4](\img\deeplearning-ai-coursera\C2W2L03b\幻灯片4.JPG)

这种平均之所以有用，是因为它的计算非常简单，只需要存储一个变量即可。

![幻灯片2](\img\deeplearning-ai-coursera\C2W2L04\幻灯片2.JPG)

严格来说，还要解决一个bias问题，即在平均的初始阶段，历史值不够多的问题，一般除上一个归一化参数（权值之和）即可。

![幻灯片1](\img\deeplearning-ai-coursera\C2W2L05\幻灯片1.JPG)

加上momentum的gd算法就引入了指数移动平均。

![幻灯片2](\img\deeplearning-ai-coursera\C2W2L05\幻灯片2.JPG)

直观理解是将梯度下降量做平均，拉平那些非趋势的变化。

![幻灯片3](\img\deeplearning-ai-coursera\C2W2L05\幻灯片3.JPG)

具体实现时，先用导数更新v，再用v更新W。

![幻灯片1](\img\deeplearning-ai-coursera\C2W2L06\幻灯片1.JPG)

另外一个优化思路时RMSprop，RMS指的是root mean square。

![幻灯片2](\img\deeplearning-ai-coursera\C2W2L06\幻灯片2.JPG)



RMSprop的思路是记录导数值的RMS，反映其变化剧烈程度。对变化剧烈的方向，降低学习率，反之提高学习率。

![幻灯片1](\img\deeplearning-ai-coursera\C2W2L07\幻灯片1.JPG)

将momentum和RMSprop结合得到Adam算法。

![幻灯片2](\img\deeplearning-ai-coursera\C2W2L07\幻灯片2.JPG)

用momentum记录导数，导数平方的均值，并做bias修正，然后更新参数。注意为防止计算溢出而加了保护量$$\epsilon$$。

![幻灯片3](\img\deeplearning-ai-coursera\C2W2L07\幻灯片3.JPG)

Adam算法超参数的设定一般不用做太多的调整。Adam是Adaptive momentum esitimate的意思。![幻灯片1](\img\deeplearning-ai-coursera\C2W2L08\幻灯片1.JPG)

还有一种优化时逐渐减小学习率。

![幻灯片2](\img\deeplearning-ai-coursera\C2W2L08\幻灯片2.JPG)

直观理解就是越靠近最值，应当降低步长，以便于收敛。

![幻灯片3](\img\deeplearning-ai-coursera\C2W2L08\幻灯片3.JPG)

一般是一次epoch调整一次学习率。

![幻灯片4](\img\deeplearning-ai-coursera\C2W2L08\幻灯片4.JPG)

调整的公式有很多，如果一次训练时间很长，甚至可以手动调节学习率。

![幻灯片1](\img\deeplearning-ai-coursera\C2W2L09\幻灯片1.JPG)

梯度下降不能保证收敛到全局最优。

![幻灯片2](\img\deeplearning-ai-coursera\C2W2L09\幻灯片2.JPG)

但是现在人们认识到当数据维度很高时，局部最优点不是问题，而问题是鞍点很多，因为多个维度往一个方向凸的概率很低。

![幻灯片3](\img\deeplearning-ai-coursera\C2W2L09\幻灯片3.JPG)

鞍点问题用前面的优化方法可以得到缓解。



