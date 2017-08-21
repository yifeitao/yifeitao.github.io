---
layout: post
title: deeplearning.ai深度学习课程 第三阶段第二周
categories: coding
tag: [机器学习, 深度学习]
---

本周主要继续深度学习项目中的策略问题。分析一些更复杂的工程实践场景与应对方法。<!-- more -->

![幻灯片1](\img\deeplearning-ai-coursera\C3W2L01\幻灯片1.JPG)

首先介绍错误分析方法。

![幻灯片2](\img\deeplearning-ai-coursera\C3W2L01\幻灯片2.JPG)

算法表现不如预期时，可以人工看看到底什么地方出错了，在验证集出错的样本中挑一部分来人工分析。看看能否针对性改进。

![幻灯片3](\img\deeplearning-ai-coursera\C3W2L01\幻灯片3.JPG)

简单来说，可以统计各个样本出错的原因，从而找到哪些影响效果的主要原因。

![幻灯片1](\img\deeplearning-ai-coursera\C3W2L02\幻灯片1.JPG)

第二个问题时如果数据标记就是错的要不要更正。

![幻灯片2](\img\deeplearning-ai-coursera\C3W2L02\幻灯片2.JPG)

深度学习算法对训练集中的错误鲁棒性还是很好的，除非错误是有偏向而不是随机的，一般不用特别处理。

![幻灯片3](\img\deeplearning-ai-coursera\C3W2L02\幻灯片3.JPG)

在验证集中，我们可以在错误分析时，统计因标记错误导致的错误，如果影响不大则不处理，如果影响大才处理。

![幻灯片4](\img\deeplearning-ai-coursera\C3W2L02\幻灯片4.JPG)

注意测试集要一并处理，同时要考虑那些算法计算正确的例子是否有标记错误。

![幻灯片1](\img\deeplearning-ai-coursera\C3W2L03\幻灯片1.JPG)

建立一个机器学习系统时，刚开始不要搞得太复杂，越快建立起一个基本的系统越好。

![幻灯片2](\img\deeplearning-ai-coursera\C3W2L03\幻灯片2.JPG)

先快速建立第一版系统，然后分析差距，修改迭代。

![幻灯片1](\img\deeplearning-ai-coursera\C3W2L04\幻灯片1.JPG)

如何应对训练集与测试集不同分布的情况。

![幻灯片2](\img\deeplearning-ai-coursera\C3W2L04\幻灯片2.JPG)

![幻灯片3](\img\deeplearning-ai-coursera\C3W2L04\幻灯片3.JPG)

注意一定要让验证集与测试集同分布，再取到足够多验证集与测试集后，其余的都作为训练集。

![幻灯片1](\img\deeplearning-ai-coursera\C3W2L05\幻灯片1.JPG)

当训练集与验证/测试集的分布不同时，如何进行偏差、方差分析呢？

![幻灯片2](\img\deeplearning-ai-coursera\C3W2L05\幻灯片2.JPG)

我们需要再训练集中划分一小部分出来作为训练验证集，由此建立了四个标准线：人为错误，训练错误、训练验证错误、验证错误。![幻灯片3](\img\deeplearning-ai-coursera\C3W2L05\幻灯片3.JPG)

这四个标准从上到下的间隔依次为可避免的偏差、数据失配、方差。

![幻灯片4](\img\deeplearning-ai-coursera\C3W2L05\幻灯片4.JPG)

实际上，更精确的，可以建立两种数据分布各个标准线做更细致的分析。

![幻灯片1](\img\deeplearning-ai-coursera\C3W2L06\幻灯片1.JPG)

那么如何应对数据失配呢？

![幻灯片2](\img\deeplearning-ai-coursera\C3W2L06\幻灯片2.JPG)

没有什么系统性的方法。可以先做错误分析，看看两者之间的差异到底在哪里，然后再针对性的使训练样本与验证集更相似或收集更多的相似的训练样本。

![幻灯片3](\img\deeplearning-ai-coursera\C3W2L06\幻灯片3.JPG)

其中有一种方法是在训练样本中人工加一些扰动，使其更像验证/测试样本。

![幻灯片4](\img\deeplearning-ai-coursera\C3W2L06\幻灯片4.JPG)

注意这种方式，可能使得模型对某些样本过拟合。

![幻灯片1](\img\deeplearning-ai-coursera\C3W2L07\幻灯片1.JPG)

神经网络之间的是否可以迁移？

![幻灯片2](\img\deeplearning-ai-coursera\C3W2L07\幻灯片2.JPG)

如何两个问题有相似性，是可能进行迁移的，把先前训练好的神经网络（预训练）的最后一层或几层去掉，然后用新的样本训练最后一层或几层（样本少时）甚至训练整个神经网络（样本多时），这样借用了预训练神经网络的结构与初始参数。

![幻灯片3](\img\deeplearning-ai-coursera\C3W2L07\幻灯片3.JPG)

迁移学习要可行需要一些条件：输入要相同，预训练的样本更多，在底层次上预训练的特征要对后训练的有帮助。

![幻灯片1](\img\deeplearning-ai-coursera\C3W2L08\幻灯片1.JPG)

还有一种方法叫多目标训练。

![幻灯片2](\img\deeplearning-ai-coursera\C3W2L08\幻灯片2.JPG)

同样一个输入，要决定几组输出的类别。

![幻灯片3](\img\deeplearning-ai-coursera\C3W2L08\幻灯片3.JPG)

这时候最后一层有多个节点，代价函数是几个输出的代价函数的和。注意如果某个输出不明确，可以在计算时忽略，依然可以作为整个模型的样本。

![幻灯片4](\img\deeplearning-ai-coursera\C3W2L08\幻灯片4.JPG)

多目标学习同样有几个条件：几个学习目标应当有公用的底层特征，针对每个目标的样本数要相当，样本要足够多，可以训练较大的神经网络适应所有的目标。

![幻灯片1](\img\deeplearning-ai-coursera\C3W2L09\幻灯片1.JPG)

随着大数据和深度网络的兴起，出现了所谓的端到端深度学习。

![幻灯片2](\img\deeplearning-ai-coursera\C3W2L09\幻灯片2.JPG)

简单来说，就是构建深度学习系统时，直接映射输入和最终输出，而不经过复杂的人工建模的中间过程。

![幻灯片3](\img\deeplearning-ai-coursera\C3W2L09\幻灯片3.JPG)

但是还是要根据情况具体分析，有些时候，分步骤能节省大量的复杂度，比如人脸识别先进行人脸定位。

![幻灯片4](\img\deeplearning-ai-coursera\C3W2L09\幻灯片4.JPG)

机器翻译由于目前双语资料库够大，已经能够端到端处理。而用X光照片估计年龄则由于样本不足不能直接端到端处理。

![幻灯片1](\img\deeplearning-ai-coursera\C3W2L10\幻灯片1.JPG)

具体什么情况适合端到端处理呢？

![幻灯片2](\img\deeplearning-ai-coursera\C3W2L10\幻灯片2.JPG)

可以考虑一下端到端处理的优缺点。优点是：让数据直接说话，不太需要人为设计；缺点是需要大量的训练样本，没办法利用一些很好的人工设计的模块。

![幻灯片3](\img\deeplearning-ai-coursera\C3W2L10\幻灯片3.JPG)

所以关键问题是：你是否有足够多的数据来训练一个复杂的函数，能够完成你需要的映射。

第三阶段学到这里结束了，还真是干货满满，希望以后遇到问题时能少走一些弯路。

等着剩下的两个阶段继续开课了。