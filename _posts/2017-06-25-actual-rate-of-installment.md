---
layout: post
title: 分期付款的实际年化利率
categories: investment
mathjax: true
---

假如你在马云家买了个苹果手机，花了5000块，使用蚂蚁花呗分期付款，假设标称的12期分期付款年化利率是8%，简单计算一下

```python
5000*(1+0.08)/12
```

每月还款数额为450块。

嗯，余额宝收益也有4%啊，所以8%的借款利率也不是太高啊，但是真的是这样吗？

真正的年化利率8%应该是什么意思呢？

应该是一年之后我再还那5400块的本息。这跟每个月还450有什么区别呢？

假设你还是每个月从工资中攒下来450块准备还手机钱，但是不是每月返还，而是放在余额宝里面，那么显然到一年之后，你不止攒下来5400块，这就是金融机构在你身上赚到的超过8%的利率的钱。

参考一下[货币的现金价值](http://yifeitao.com/2017/01/time-value-of-money.html)，简单点说，现在的1块钱和一年后的1块钱，对懂得投资的人来说，完全不是一回事，现在的1块钱，一年后不止1块钱，而一年后的1块钱，则现在不值一块钱，在金融术语里，把未来的钱，算成现在的价值，叫做贴现。

为了计算实际利率，我们需要假设这些陆续还掉的5400块钱，按这个实际利率折算到现在的价值恰好是5000块钱，我们假设第一次还钱是买手机1个月后，实际月利率为$$i$$，那么有如下方程

$$450/(1+i)+450/(1+i)^2+...+450/(1+i)^{12}=5000$$

这是一个等比数列，化简一下，得到

$$i/(1-(1+i)^{-12})=0.09$$

这个方程没有解析解，所以只能靠近似计算，一般可以用迭代法来解决这个问题。如果使用scipy来解，代码如下

```python
import sympy

i = sympy.symbols('i')
f = i / (1 - (1+i)**(-12)) - 0.09
print(sympy.solve(f , i))
```

正实数解为0.012，则年化利率大约为$$0.012*12=14.4\%$$

比标称的利率高了将近1倍。

一般的，假设标称的月利率为$$j$$，分期数为$$n$$,实际月利率为$$i$$,则

$$i/(1-(1+i)^{-n})=j+1/n$$

不过上述求解方法需要会写一点代码，其实excel也提供了类似的计算工具，这需要用到用到IRR这个公式，它代表内部投资收益率，可以理解为把一段时间内所有的收入支出折算为现值，让它们的和为0，从而得到这个收益率。

具体以上述买苹果手机为例，在excel 中的A1到A13格输入

-5000
450
450
450
450
450
450
450
450
450
450
450
450

A14格输入=IRR(A1:A13)，则同样可以求得月利率约为0.012。注意第0个月借入了5000，应该使用负数。

**最后的最后，一般如果按12个月或者24个月分期付款，实际利率大约为标称利率的2倍，作为一个经验公式，这样也够了。**
