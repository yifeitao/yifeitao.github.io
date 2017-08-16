---
layout: post
title: deeplearning.ai深度学习课程 第一阶段第四课
categories: coding
tag: [机器学习, 深度学习]
---

![幻灯片1](\img\deeplearning-ai-coursera\C1W4L01\幻灯片1.JPG)

这一周把两层的神经网络推广到多层，也就是所谓的深度神经网络。<!-- more -->

![幻灯片2](\img\deeplearning-ai-coursera\C1W4L01\幻灯片2.JPG)

深度学习这个词，本质上并没有太多新的技术与概念引入，感觉更多的还是工程上的概念。

![幻灯片3](\img\deeplearning-ai-coursera\C1W4L01\幻灯片3.JPG)

这里介绍了一些深度神经网络中的标记惯例，我发现老师喜欢不厌其烦的讲这些东西，然后我也发现熟悉这些表达看似没什么，实际上对加深理解很有帮助，这样你看到公式的时候，不再是一头雾水状。注意L层神经网络不包括输入层。所以层的标记覆盖了0~L，另外参数的层次标记以终止点为准，因此是1~L。

![幻灯片4](\img\deeplearning-ai-coursera\C1W4L01\幻灯片4.JPG)

先看看前向计算过程。

![幻灯片5](\img\deeplearning-ai-coursera\C1W4L01\幻灯片5.JPG)

其实能理解2层神经网络，就能理解这个，只不过是一个简单的推广，注意从第1层到第L层共L次计算，样本横向堆叠，参数W置于输入A的左侧。

![幻灯片1](\img\deeplearning-ai-coursera\C1W4L02\幻灯片1.JPG)

接下来老师介绍了代码调试中的一个技巧，就是检查运算中的矩阵大小是否匹配。

![幻灯片2](\img\deeplearning-ai-coursera\C1W4L02\幻灯片2.JPG)

注意按照本课程的记法，参数W置于A的左侧，通过矩阵乘法将A变换到下一层，因此W的大小是$$n^{[l]}, n^{[l-1]}$$。

![幻灯片3](\img\deeplearning-ai-coursera\C1W4L02\幻灯片3.JPG)

当m个样本一起运算时，注意样本是横向堆叠的。

![幻灯片1](\img\deeplearning-ai-coursera\C1W4L03\幻灯片1.JPG)

为什么深度了之后就效果好呢？

![幻灯片2](\img\deeplearning-ai-coursera\C1W4L03\幻灯片2.JPG)

第一个直观解释是通过不同的层次，逐渐综合出复杂的特征来。

![幻灯片3](\img\deeplearning-ai-coursera\C1W4L03\幻灯片3.JPG)

第二个直观解释是，类比电路设计的原理，通过多层的开关网络，可以简化开关的设计，每个开关（神经元）只考虑简单的几种情况。老师非常喜欢用Intuition这个词，非常符合我的学习习惯。

![幻灯片1](\img\deeplearning-ai-coursera\C1W4L04\幻灯片1.JPG)

综合来看一下如果建立深度神经网络的每一个单元。

![幻灯片2](\img\deeplearning-ai-coursera\C1W4L04\幻灯片2.JPG)

如果能把这个模块图记下来，再弄清楚求导的链式法则，基本上就能很快自己推出计算公式了。其实图很好记，注意在图的右侧的层标号是$$l$$，左侧是$$l-1$$。

![幻灯片3](\img\deeplearning-ai-coursera\C1W4L04\幻灯片3.JPG)

注意前向过程的初始输入是$$X$$，反向过程的初始输入是$$dA^{[L]}$$。

![幻灯片4](\img\deeplearning-ai-coursera\C1W4L04\幻灯片4.JPG)

再次仔细考察一下两个过程。

![幻灯片5](\img\deeplearning-ai-coursera\C1W4L04\幻灯片5.JPG)

注意计算过程的输入、输出与缓存分别是什么。计算本身很好理解，先做线性组合，再做激活函数变换。

![幻灯片6](\img\deeplearning-ai-coursera\C1W4L04\幻灯片6.JPG)

注意计算中用到了前向过程得到的$$A^{[l-1]}$$与$$Z^{[l]}$$，左边这几个公式就是链式法则的反复应用（前向计算定义了这些变量间的关系），然后要不要转置之类的，可以用检查矩阵大小的方式对齐。

![幻灯片7](\img\deeplearning-ai-coursera\C1W4L04\幻灯片7.JPG)

注意两个过程的初始输入。

![幻灯片1](\img\deeplearning-ai-coursera\C1W4L05\幻灯片1.JPG)

参数与超参数的讨论。

![幻灯片2](\img\deeplearning-ai-coursera\C1W4L05\幻灯片2.JPG)

在机器学习算法中，都有类似的问题，往往首先要人为决定一些结构或参数（这就是超参数），再在此前提下，通过数据的学习，决定出具体的参数。超参数的存在使得机器学习的所谓调参有时候像玄学。可能需要经验支撑。

![幻灯片3](\img\deeplearning-ai-coursera\C1W4L05\幻灯片3.JPG)

可以通过试验的方法来调参。在此过程中可以实时监控cost，发现情况不对劲可以提前结束。

![幻灯片1](\img\deeplearning-ai-coursera\C1W4L06\幻灯片1.JPG)

最后讨论一下神经网络技术跟脑科学究竟有什么关系。

![幻灯片2](\img\deeplearning-ai-coursera\C1W4L06\幻灯片2.JPG)

总的来说，老师认为这只是一个比喻（信号->激励->信号），而且有些过时，脑神经远比整个模型复杂，而且现在依然是一团迷。深度学习的研究者与工程师从实用的角度来研究居多，而不必去关心这种类比。

**第一课小结**：其实四周课程学下来，总的来说没听到太多全新的东西，但是老师很擅长解释必要的细节，我第一次感觉能随时手推出神经网络计算公式了，甚至有了给其他人讲解的信心。几次作业由于代码桩过于完善，所以很简单，不过我想，现在的神经网络都有成熟的类库可用，关键还是理解整个计算过程，作业的整个代码写得很专业，可以作为自己写代码时的参考。





