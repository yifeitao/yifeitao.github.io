---
layout: post
title:  机器学习与待定系数法
categories: coding
---

注意，这只是为了加深理解而想到的一个类比，既然是类比，就有它不确切的地方。

在初等数学中，我们就开始使用待定系数法，比如我们知道平面上三个点A、B、C的坐标，相求它们的外接圆方程，由于我们知道这个方程的基本形式，只是有一些系数待定（圆心坐标a、b和半径r），所以用待定系数构建方程，将A、B、C坐标值带入方程可以得到关于待定系数的三元一次方程组，进而得到三个参数。

在这里，我们首先假设了函数的形态，它包含了部分待定系数，然后通过数据带入函数，求解得到待定系数。机器学习，尤其是有监督学习，跟这个过程有相似之处。

在机器学习时，我们首先假设一个分类或回归模型，这个模型包含了一些待定的系数，比如对于Logistics回归，权重是待定的，对于一定结构的神经网络，权重是待定的，然后我们输入数据，让算法学习的过程就相当于求解待定系数的过程。

跟初等数学中待定系数法不同的是，机器学习的没有绝对正确的一个函数，而只是一个针对某个指标优化的函数，模型如果针对训练的数据绝对正确，会出现过拟合现象。机器学习在模型的假设空间里找一组“好”的系数，而初等数学是找一组正确的系数。

只管的看，待定的系数越多，需要的数据也就越多，所有复杂的神经网络能较好的应对大数据样本的学习。而一个模型如果待定的系数很少，给它过多的数据学习并没有多大的作用，就像求一个圆的方程，三个数据点就够了，再多也是浪费。

