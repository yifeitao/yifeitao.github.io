---
layout: post
title:  .Net框架中的算法与数据结构
categories: coding
toc: true
tag: 算法
---
最近复习基础算法，顺带浏览了一下[.Net框架的源码](https://referencesource.microsoft.com/)，通过本文简要总结一下.Net框架中常见数据结构和算法的实现。

## 1 集合类

### 1.1 List<T>

`List<T>`使用动态数组实现，列表为空时，数组长度为0，加入第一个数据后，数组长度为16，以后当长度不够时会加倍，这时需要新建长数组，并完成复制操作，所以数据量预计很大时，建议指定初始化时的`capacity`,否则会进行很多复制操作。没有进行数组的自动缩减，而是提供了显式的`TrimExcess`方法，当数组使用率低于90%时，会去除数组中未使用部分，此外也可显式设定`Capacity`，这些方法都会产生复制操作。支持二分查找和排序，算法都使用数组的。

### 1.2 LinkedList<T>

使用双向环形链表实现，内部直接保存的只有一个head节点。

### 1.3 Stack<T>  Queue<T>

基本类似List<T>，都使用动态数组实现，默认大小均为4，

### 1.4 Dictionary<TKey,TValue>

字典使用散列表实现，具体使用的是桶加链表的实现，键值对使用数组存储（初始大小和桶大小相同），链表指针使用的是数组的index，桶的大小由大于指定capacity的一个最小质数确定，最小为3，最大为7199369。Tkey的哈希值去除符号位后对桶大小取模得到Hash位置，当键值对数组不够用时需要扩大(使用质数数组中的下一个大小)，桶的大小也随之扩大，如果冲突数超过100，则重新进行Hash。

### 1.5 SortedSet<T> SortedDictionary<TKey, TValue>

`SortedDictionary<TKey, TValue>`本质上使用`SortedSet<T> `实现的，而`SortedSet<T> `则是经典的红黑树结构。

待续...

