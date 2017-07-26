---
layout: post
title: 全排列生成算法实现一
categories: coding
mathjax: true
---

我们知道n个相异元素的全排列种数为n!，那么由程序如何生成n个相异元素的排列呢，对此问题的研究很多，本文首先用Java实现了《算法设计与分析基础》一书中4.3节的三个算法。

### 1 插入法

这种算法最直观，基于排列的递推定义。符合所谓减治法的思想，或者说是数学归纳法的思想，如果n-1个元素已经排好，我们只需要把第n个元素插入这些排列中所有可能的位置即可，每个元素有n个位置可以插入，刚好是(n-1)!*n=n!种情况。如果插入的时候，方向先从右到左，再从左到右循环，那么每两个相邻的排列将只有最小的差异，即只有某两个相邻元素相异。比如已经有12,21则12从右到左插入3，21从左到右插入3，最终得到123,123,312,321,231,213。具体的Java代码如下，这是一个递归算法。

```java
public static ArrayList<int[]> getPermutations(int n) {
        ArrayList<int[]> permutations = new ArrayList<>();
        if(n <= 0) return permutations;
        if(n == 1) {
            permutations.add( new int[]{1});
            return permutations;
        }
        ArrayList<int[]> remainders = getPermutations(n-1);
        for(int i = 0; i < remainders.size(); i++) {
            int[] remainder = remainders.get(i);
            for(int j = 0; j < n; j++) {
                int[] permutation = new int[n];
                if(i % 2 ==0) {//insert from right to left
                    System.arraycopy(remainder, 0, permutation, 0, n - 1- j);
                    permutation[n - 1 - j] = n;
                    System.arraycopy(remainder, n - 1 - j, permutation, n - j, j);
                }
                else {//inset from left to right
                    System.arraycopy(remainder, 0, permutation, 0, j);
                    permutation[j] = n;
                    System.arraycopy(remainder, j, permutation, j + 1, n - 1- j);
                }
                permutations.add(permutation);
            }
        }
        return permutations;
	}
```

###  2 JohnsonTrott算法

在Johnson-Trotter算法中，每次循环都进行一次满足条件的相邻元素的交换，直到不存在满足条件的可交换的元素，此时说明所有排列的情况均已输出，算法结束。

具体过程如下：

1. 初始化所有元素的移动方向为左，输出序列本身
2. 移动最大的可移动的元素(当元素移动方向上的元素比自己小时，才能移动)
3. 反转所有比移动元素大的所有元素的移动方向
4. 重复2~3步，直到不能移动为止

## 具体例子

上面的算法流程有些抽象，现在举个例子来加深理解。假设现在要计算$$\{1,2,3\}$$所有排列。首先是将所有元素的移动方向为标记为向左，我们可以表示成这样$$\{\overleftarrow{1},\overleftarrow{2},\overleftarrow{3}\}$$，然后根据算法流程中的步骤2，移动最大的可移动元素。这里的可移动元素是指在其移动方向上的相邻元素比自己小时，例如$$\overleftarrow{2},\overleftarrow{3}$$都是可移动元素，因为在他们的移动方向上(左移)的相邻元素:1,2分别比2,3小，而每次都只移动这些可移动元素中最大的那个项。接着，在每次交换完成之后，寻找所有比当前交换元素大的元素，将他们的移动方向反转一下。

下面列出$$\{1,2,3\}$$在计算过程中所有的情况
$$
\begin{align}
&\{\overleftarrow{1},\overleftarrow{2},\overleftarrow{3}\}\\
&\{\overleftarrow{1},\overleftarrow{3},\overleftarrow{2}\}\\
&\{\overleftarrow{3},\overleftarrow{1},\overleftarrow{1}\}\\
&\{\overrightarrow{3},\overleftarrow{2},\overleftarrow{1}\}\\
&\{\overleftarrow{2},\overrightarrow{3},\overleftarrow{1}\}\\
&\{\overleftarrow{2},\overleftarrow{1},\overrightarrow{3}\}\\
\end{align}
$$

Java代码如下：

```java
public static ArrayList<int[]> getPermutations(int n) {
        ArrayList<int[]> permutations = new ArrayList<>();
        if (n <= 0) return permutations;
        int[] first = new int[n];
        boolean[] mobile = new boolean[n];
        for(int i = 0; i < n; i++) {
            first[i] = i + 1;
            mobile[i] = true;//true:left; false:right;
        }
        permutations.add(first);

        while(true) {
            int[] last = permutations.get(permutations.size()-1).clone();
            int k = findLargestMobile(last, mobile);
            if(k == -1) break;
            int max = last[k];
            int neighbor = mobile[k] ? k - 1 : k + 1;
            swap(last, k, neighbor);
            swap(mobile, k, neighbor);
            reverseLarger(last, mobile, max);
            permutations.add(last);
        }
        return permutations;
    }

    private static int findLargestMobile(int[] array, boolean[] mobile) {
        int k = -1;// -1 means can't find mobile element
        int max = -1;
        for(int i = 0; i < array.length; i++) {
            int j = mobile[i] ? i - 1: i + 1;
            if(j < 0 || j >= array.length) continue;
            if(array[i] > array[j] && array[i] > max) {
                max = array[i];
                k = i;
            }
        }
        return k;
    }

    private static void reverseLarger(int[] array, boolean[] mobile, int max) {
        for(int i = 0; i < array.length; i++) {
            if(array[i] > max) mobile[i] = !mobile[i];
        }
    }

    private static void swap(int[] array, int i, int j) {
        int temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }

    private static void swap(boolean[] array, int i, int j) {
        boolean temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
```

### 3 字典序生成法

字典序生成法在当前已经生成的排列上寻找下一个字典序的排列：

1. 找到最长的递减序列后缀，记这个序列的前一个元素为i，如果找不到i，则证明已经生成了最后一个完全倒序的排列，生成完毕。
2. 在前述后缀中，找到比元素i大的最小元素j，并交换i和j；
3. 将后缀逆序排列。
4. 重复1到3。

比如排列123654，首先找到后缀654，在找到中间最小大于3的4，交换得到124653，然后将后缀逆序得到124356,又如排列123645，找到后缀5，交换得到123654，后缀只有一个，逆序后不变仍未123654。

具体的Java代码如下：

```java
public static ArrayList<int[]> getPermutations(int n) {
        ArrayList<int[]> permutations = new ArrayList<>();
        if(n <= 0) return permutations;
        int[] first = new int[n];
        for(int i = 0; i < n; i++) first[i] = i + 1;
        permutations.add(first);

        while(true) {
            int[] last = permutations.get(permutations.size()-1).clone();
            int i = n - 1;
            while(i > 0) {
                if(last[i] > last[i-1]) {
                    break;
                }
                i--;
            }
            if(i==0) break;

            int j = n - 1;
            while(j >= i) {
                if(last[j]>last[i-1]) {
                    break;
                }
                j--;
            }
            swap(last, i-1, j);

            int k = n - 1;
            while(i < k) {
                swap(last, i, k);
                i++;
                k--;
            }
            permutations.add(last);
        }
        return permutations;
    }
```

