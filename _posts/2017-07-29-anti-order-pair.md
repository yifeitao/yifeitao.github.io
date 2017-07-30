---
layout: post
title: 逆序对计数问题
categories: coding
mathjax: true
---

有一组数，对于其中任意两个数组，若前面一个大于后面一个数字，则这两个数字组成一个逆序对。计算给定数组中的逆序对个数。

### 1 暴力搜索

显然可以把每一对数字都检查一遍，$$n$$个数供需检查$$n(n-1)/2$$组，时间复杂度为$$O(n^2)$$。Java代码如下：

```java
public int count(int[] A) {
        int count = 0;
        for(int i = 1; i < A.length; i++) {
            for(int j = 0; j < i; j++) {
                if(A[j] > A[i]) count++;
            }
        }
        return count;
    }
```

### 2. 二分查找

考察1中的代码，我们一次检查了以A[1]到A[n-1]结尾的数字对，即数组每增加一个元素，计算一次之前的元素有多少比自己大。如果之前的元素是有序的，那么通过二分查找，可以很快的找到新元素的位置（注意该位置要越过所有相等的元素），该位置后面的元素就是所求的逆序对个数，然后将新元素插入该位置。Java代码如下：

```java
    public int count(int[] A) {
        int count = 0;
        for(int i = 1; i < A.length; i++) {
            int num = A[i];
            int p = find(A, 0, i, num);
            count += (i - p);
            for(int j = i; j > p; j--) {
                A[j] = A[j-1];
            }
            A[p] = num;
        }
        return count;
    }

    private int find(int[] A, int start, int end, int x) {//注意为左闭右开区间
        int mid = (start + end) / 2;
        if(A[mid] == x) {//注意相等时的处理
            while(A[mid] == x) mid++;
            return mid;
        }
        if(A[mid] > x) {
            return mid == start ? start : find(A, start, mid, x);
        }
        else {
            return mid + 1 == end ? end : find(A, mid + 1, end, x);
        }
    }
```

这个二分查找要写准确，其实比较困难。而且关键是虽然查找的时间复杂度是$$O(logN)$$，但是插入时插入点后的数组需要复制，依然是$$O(N)$$时间复杂度。

### 3  二叉查找树

2中的方法提示我们，需要找到一种插入与查找都是$$O(logN)$$时间复杂度的数据结构与算法，可以用一个二叉树来实现，对每个节点，使得其右子树中的节点都大于自己，而左子树的小于等于自己，当插入一个新节点时，维护该节点的右子树大小。

```java
    public int count(int[] A) {
        Node root = new Node(A[0]);
        int count = root.getAnti(A[0]);
        for(int i = 1; i < A.length; i++) {
            root.insert(A[i]);
            count += root.getAnti(A[i]);
        }
        return count;
    }

    class Node {
        int rightSize = 0;
        Node left, right;
        int val;
        public Node(int val) {
            this.val = val;
        }

        public void insert(int val) {
            if(val <= this.val) { //注意相等归到左边
                if(left!=null) {
                    left.insert(val);
                }
                else {
                    left = new Node(val);
                }
            }
            else {
                if(right!=null) {
                    right.insert(val);
                }
                else {
                    right = new Node(val);
                }
                rightSize++;
            }
        }

        public int getAnti(int val) {
            if(val == this.val) return rightSize;
            if(val > this.val) return right.getAnti(val);
            return rightSize + 1 + left.getAnti(val);
        }
    }
```

这个数据结构其实能动态维护逆序数的个数，如果数组是流式进入的，也能随时得出结果。时间复杂度为$$O(NlogN)$$。

### 4 归并排序

求逆序数，可以这样递归求解，把数组分为左右两部分，先求两部分单独的逆序数，再求右半部分小于左半部分的数量，三者的和就是结果。问题是怎么求右半部分小于左半部分的数量，如果两部分都是有序的，那么可以在线性时间进行归并排序，计算相应的逆序数。比如两个序列 {1，3，6}和{2，4，5，7}，在归并时出现左大于右时，共有 {3，2}、{6，4}，{6，5}三种情况，其中{3，2}时，注意到左边比3大的同样比2大，因此情况计数为2。类似的，每次出现左大于右时，应当考虑左边剩下的数字也大于右边。这里相当于给右边每个元素一个计数，这里很微妙的是，由于归并方向是从左到右，如果计数记在左边，则{6，4}和{6，5}会出现重复计数。

```java
    public int count(int[] A) {
        int[] aux = new int[A.length]; //辅助归并的数组
        return mergeCount(A, aux, 0, A.length);
    }

    public int mergeCount(int[] A, int[] aux, int start, int end) {//注意区间左闭右开
        int mid = (start + end) / 2;
        if(mid == start) return 0;
        int left = mergeCount(A, aux, start, mid);
        int right = mergeCount(A, aux, mid, end);

        System.arraycopy(A, start, aux, start, end - start);
        int i = start;
        int j = mid;
        int count = 0;
        for(int k = start; k < end; k++) {
            if(i >= mid) A[k] = aux[j++];
            else if(j >= end) A[k] = aux[i++];
            else if(aux[i] > aux[j]) {
                A[k] = aux[j++];
                count += (mid - i);//注意计数的个数是左边大于aux[j]的元素数量。
            }
            else {
                A[k] = aux[i++];
            }
        }
        return left + right + count;
    }
```

这种方法的效率和归并排序是一样的，为$$O(NlogN)$$。

