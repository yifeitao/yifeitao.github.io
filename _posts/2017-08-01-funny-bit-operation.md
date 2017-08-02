---
layout: post
title: 有趣的位操作
categories: coding
mathjax: true
---

位操作总给人一种直接安排计算机0/1的感觉，这里搜集整理一些有趣的题目。<!-- more -->

### 1 交换

请编写一个函数，函数内不使用任何临时变量，直接交换两个数的值。

```java
public int[] exchangeAB(int[] AB) {
        AB[0] = AB[0]^AB[1];
        AB[1] = AB[0]^AB[1];
        AB[0] = AB[0]^AB[1];
        return AB;
    }
```

### 2. 加法

请编写一个函数，将两个数字相加。不得使用+或其他算数运算符。

```java
public int addAB(int A, int B) {
        while(B != 0) {
            A = A ^ B; //异或，相当于无进位加法
            B = ((A^B) & B) << 1; // 所有的进位
        }
        return A;
    }
```

这个二分查找要写准确，其实比较困难。而且关键是虽然查找的时间复杂度是$$O(logN)$$，但是插入时插入点后的数组需要复制，依然是$$O(N)$$时间复杂度。

### 3  比较大小

请编写一个方法，找出两个数字中最大的那个。条件是不得使用if-else等比较和判断运算符。

```java
    public int getMax(int a, int b) {//a, b符号不同，取正值，a,b符号相同，考察a-b符号
        int sa = sign(a);
        int sb = sign(b);
        int sc = sign(a - b);
        
        int use_sa = sa^sb; //a, b符号不同，使用a的符号
        int use_sc = flip(use_sa); //a, b符号相同，使用a-b的符号
        int k = sa * use_sa + sc * use_sc; //结合use_sa、use_sc的 0/1取值，相当于 if-else 
        int q = flip(k);
        return a * k + b * q; //结合k、q的0/1取值，相当于 if-else 
    }
    
    public int sign(int x) {//该函数的返回值为 0/1 
        return (x>>>31)^1;
    }
    
    public int flip(int bit) {
        return 1^bit;
    }
```

