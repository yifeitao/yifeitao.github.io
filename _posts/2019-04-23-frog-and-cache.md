---
layout: post
title:  青蛙与缓存：简化实用版动态规划
categories: coding
tag: 算法， python
mathjax: true
toc: true
---

## 1. 从一只青蛙说起

![青蛙](https://i.imgur.com/zuhczaLm.jpg)

话说有一只青蛙，想要跳下`n`级台阶下水塘，它每次可以跳1个台阶或者2个台阶，那么请问它一共有多少种跳法下水塘(比如，`n=30`时)？

用数学的语言来看，我们需要求一个青蛙跳的函数`f(n)`，对这种自变量取值为非负整数的函数，我们可以从比较小的情况开始考虑，不难得到`f(1)=1, f(2)=2`，问题是以后的穷举越来越麻烦。

想象你就是那只青蛙，面对`n`级台阶，第一次你可以先跳1级，那么剩下`n-1`级，有`f(n-1)`种跳法，第一次也可以跳两级，那么剩下`n-2`级，有`f(n-2)`种跳法，所以这个问题的答案并不陌生，是神奇的斐波拉契数列：


$$
\begin{aligned} F_{0} &=0 \\ F_{1} &=1 \\ F_{n} &=F_{n-1}+F_{n-2} \quad(\mathrm{n} \geq 2) \end{aligned}
$$
解决这类求函数值问题的第一步，是找到一个递推式。我们把递推式翻译成python代码：

```python
def fib(n):
    if n==0:
        return 1
    if n==1:
        return 1
    return fib(n-1)+fib(n-2)
```

```
%%time
fib(30)

Wall time: 269 ms
832040
```

运行时间`284ms`，有够慢的，为什么慢？因为重复计算实在太多，以计算`f(5)`为例，调用关系如下：

```
f(5)==>f(4), f(3)
f(4)==>f(3), f(2), f(3)==>f(2), f(1)
f(3)==>f(2), f(1), f(2)==>f(1), f(0), f(2)==>f(1), f(0), f(1)
f(2)==>f(1), f(0), f(1), f(1), f(0), f(1), f(0), f(1)
f(1), f(0), f(1), f(1), f(0), f(1), f(0), f(1)
```

那么一个很自然的想法是我们把中间计算结果都缓存下来，幸运的是，python中自带了这个“电池”。

```python
from functools import lru_cache
@lru_cache()
def fib(n):
    if n==0:
        return 1
    if n==1:
        return 1
    return fib(n-1)+fib(n-2)
```

```
%%time
fib(30)
Wall time: 0 ns
832040
```

快到没计量出时间来。python中`lru_cache`的基本原理是构建一个字典，字典的`key`为调用参数，`value`就是该参数的计算结果。大致等价于如下代码：

```python
def fib(n):
    if n in fib.cache:
        return fib.cache[n]
    if n==0:
        ans = 1
    elif n==1:
        ans = 1
    elif:
        ans = fib(n-1)+fib(n-2)
    fib.cache[n] = ans
    return ans
fib.cache = {}
```

当然，针对这个问题，我们可以使用更加细致的缓存方法， 乃至去掉递归改用循环（相当于只保留两个缓存，大大减少了空间占用，但是如果我们要反复计算各个`n`值，那么或许前一个方法才更合适）：

```python
def fib(n):
    a, b = 0, 1
    for i in range(n):
        a, b = b, a+b
    return a
```

本题等同于 [leetcode 70](https://leetcode-cn.com/problems/climbing-stairs), 在leetcode上的python3解答如下：

```python
from functools import lru_cache
class Solution:
    @lru_cache()
    def climbStairs(self, n: int) -> int:
        if n==0:
            return 1
        if n==1:
            return 1
        return self.climbStairs(n-1)+self.climbStairs(n-2)
```

执行用时52 ms，内存消耗13.2MB。

## 2. 简化实用版动态规划

我们从这只青蛙中取得比较通用的启示，解决类似的可构造递推函数的问题：

1. 寻找一个递推关系，建立递归函数，问题变成多个子问题的求解；
2. 为了防止反复计算同样的子问题，使用缓存，用空间换时间。

在一般的算法教材或面试题解中，会花不少时间来设计这个缓存结构，在实际的工程问题中，我们可能对多使用一些缓存空间没有那么敏感，因此只需要开发递归函数，再加上通用的缓存方案就基本解决问题了。只有在缓存空间成为问题时，我们才需要进一步去考虑适应问题的更小的缓存。

为了检验这套方案，我们再看几道题，直接在leetcode上再找几个来刷。

### [ 最大子序和](https://leetcode-cn.com/problems/maximum-subarray/)

给定一个整数数组 `nums` ，找到一个具有最大和的连续子数组（子数组最少包含一个元素），返回其最大和。

**示例:**

> 输入: [-2,1,-3,4,-1,2,1,-5,4],
> 输出: 6
> 解释: 连续子数组 [4,-1,2,1] 的和最大，为 6。

我们考虑数组中每一个位置结尾能得到的最大和的递推关系。
$$
\begin{aligned} & f(0)=nums(0) \\& f(k)=max(f(k-1), 0)+nums(k) \quad(k>0) \end{aligned}
$$
基于此不难得到最终结果为
$$
ans = max_{i=0}^n(f(i))
$$
在leetcode中翻译成python3代码如下：

```python
from functools import lru_cache
class Solution:
    def maxSubArray(self, nums: List[int]) -> int:
        self.nums = nums
        return max(self.f(i) for i in range(len(nums)))
    
    @lru_cache()
    def f(self, k):
        if k == 0:
            return self.nums[0]
        else:
            return max(self.f(k-1), 0) + self.nums[k]
```

执行耗时76 ms，内存消耗13.7 MB。

### [ 最小路径和](https://leetcode-cn.com/problems/minimum-path-sum/)

给定一个包含非负整数的 *m* x *n* 网格，请找出一条从左上角到右下角的路径，使得路径上的数字总和为最小。

**示例:**

> 输入:
> [
>   [1,3,1],
>   [1,5,1],
>   [4,2,1]
> ]
> 输出: 7
> 解释: 因为路径 1→3→1→1→1 的总和最小。


将矩阵中每个位置作为右下角，求最小路径和，不难得到如下递推公式：
$$
\begin{aligned} 
& f(0, 0)=grid(0, 0) \\
& f(x, 0)=f(x-1, 0)++grid(x, 0) \quad(x>0) \\
& f(0, y)=f(0, y-1)++grid(0, y) \quad(y>0) \\
& f(x, y)=min(f(x-1, y), f(x, y-1))+grid(x, y) \quad(x>0, y>0) 
\end{aligned}
$$
在leetcode中翻译成python3代码如下：

```python
from functools import lru_cache
class Solution:
    def minPathSum(self, grid: List[List[int]]) -> int:
        self.grid = grid
        return self.f(len(grid)-1, len(grid[0])-1)
    @lru_cache()
    def f(self, x, y):
        if x == 0 and y == 0:
            return self.grid[0][0]
        elif y == 0:
            return self.f(x-1, 0) + self.grid[x][0]
        elif x == 0:
            return self.f(0, y-1) + self.grid[0][y]
        else:
            return min(self.f(x-1,y), self.f(x,y-1)) + self.grid[x][y]
```

执行耗时1052ms，内存消耗13.9M。
