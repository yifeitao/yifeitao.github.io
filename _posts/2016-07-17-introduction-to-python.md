---
layout: slide
title: Python语言入门
author: yifeitao
date: 2016-07-17 
theme: black
transition: linear
mathjax: true
lang: zh-CN
titlepage: true
categories: coding
---



这是一个简单介绍Python的Slide，鼓励团队成员学习Python，用于数据分析等。

<!-- more -->

## 为什么要学习一门新的语言？

- 丰富你的工具箱
    - 匠人精神
    - 锤子与钉子
- 滚雪球

..

## Why Python？

- Python是
    - 解释型语言
    - 面向对象语言
    - 动态语言
    - 高级语言
    - 自带电池
- Python应用
    - Dropbox
    - 豆瓣网
    - 数据分析——从爬虫到机器学习

..

## The Zen of Python

```
>>> import this
The Zen of Python, by Tim Peters

Beautiful is better than ugly.
Explicit is better than implicit.
Simple is better than complex.
Complex is better than complicated.
Flat is better than nested.
Sparse is better than dense.
Readability counts.
Special cases aren't special enough to break the rules.
Although practicality beats purity.
Errors should never pass silently.
Unless explicitly silenced.
In the face of ambiguity, refuse the temptation to guess.
There should be one-- and preferably only one --obvious way to do it.
Although that way may not be obvious at first unless you're Dutch.
Now is better than never.
Although never is often better than *right* now.
If the implementation is hard to explain, it's a bad idea.
If the implementation is easy to explain, it may be a good idea.
Namespaces are one honking great idea -- let's do more of those!
```

...

## 开发环境与版本

- 开发环境
    - IDLE
    - PyCharm
    - Anaconda
- 版本
    - Python2
    - Python3

..

## Python基本语法

- `print("Hello，world")`
- 行和缩进
- 多行语句
- Python引号
- Python注释
- Python空行
- 等待用户输入`raw_input("?")`
- 同一行显示多条语句
- 多个语句构成代码组
- 命令行参数

..

## 变量赋值

```python
a = b = c = 1
a, b, c = 1, 2, "python"
a, b = b, a
```

..

## 标准数据类型

- Numbers
- String
- List
- Tuple
- Dictionary

..

## Numbers

- int(有符号整型)
- long(长整型[也可以代表八进制和十六进制])
- float(浮点型)
- complex(复数)

..

## String

- 索引
- +，*

..

## List

- 切片
- 嵌套

..

## Tuple

- 只读列表

..

## Dictionary

- 键值对
- dict = {}

..

## Python 运算符

- 算术运算符(+-*/% ** //)
- 比较运算符(== != <> < > <= >= )
- 赋值运算符(= += -= *= /= %=，**= //=)
- 位运算符 (& \| ^ ~ << >>)
- 逻辑运算符(and or not)
- 成员运算符(in not in)
- 身份运算符(is is not)

..

## Python条件语句

```python
if condition_1:
    statement_block_1
elif condition_2:
    statement_block_2
else:
    statement_block_3
```

..

## Python循环语句

```python
while <condition>:
    <statement_block_1>
else:
 	<statement_block_2>

for <variable> in <sequence>:
    <statements>
else:
    <statements>
```
..

## Python函数

```python
# 计算面积函数
def area(width, height):
    return width * height
```

- 必备参数
- 关键字参数
- 默认参数
- 不定长参数

...

## 进阶内容

- 面向对象编程
- 匿名函数与函数式编程
- GUI
    - Tkiner
    - pyqt
- Web

..

## 自带电池

- Pip系统
- 数据分析库
    - Numpy
    - scipy
    - Pandas
    - Matplotlib
    - scikit-learn

...
## 如何学习

- 用起来
    - 当计算器用
    - 当matlab用
- 教程推荐
    - 菜鸟教程 http://www.runoob.com/
    - Python基础教程
    - Python Cookbook

...

## Thanks!
## 讨论时间



