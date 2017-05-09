---
layout: post
title: 台大机器学习课程作业0
categories: coding
---
## 1 概率和统计

（1）证：①$$N=1$$时，$$K=0 $$或$$ K=1$$，此时$$C(1,0)=C(1,1)=1$$结论成立；

②假设$$N=t$$时，结论成立，则$$C(t,k)=\frac{t!}{K!(t-K)!} (0\leq K\leq t)$$

③则$$N=t+1$$时，$$C(t+1,k)=C(t,k)+C(t,k-1)$$，代入②，$$C(t+1,k)=\frac{t!}{K!(t-K)!} + \frac{t!}{(K-1)!(t-K+1)!} = \frac{(t+1)!}{K!(t+1-K)!}  (0\leq K\leq t)$$结论成立

$$K=t+1$$时，$$C(t+1,K) = 1$$结论成立，故$$0\leq K \leq t+1$$ 时结论成立。

综合①②③，对$$N\geq1$$结论均成立。

（2）①$$\frac {C(10,4)}{2^{10}}$$

由于时间关系，改用onenote手写了

https://github.com/yifeitao/lml/blob/master/ntuml/homework/hw0/hw0_solution_handwritten.pdf
