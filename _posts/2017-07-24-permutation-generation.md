---
layout: post
title: 全排列生成算法实现
categories: coding
mathjax: true
toc: true
tag: 算法
---

我们知道n个相异元素的全排列种数为n!，那么由程序如何生成n个相异元素的排列呢，对此问题的研究很多，本文首先用Java实现了《算法设计与分析基础》一书中4.3节的三个算法。<!--more-->

## 1 插入法

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

##  2 JohnsonTrott算法

在Johnson-Trotter算法中，每次循环都进行一次满足条件的相邻元素的交换，直到不存在满足条件的可交换的元素，此时说明所有排列的情况均已输出，算法结束。

具体过程如下：

1. 初始化所有元素的移动方向为左，输出序列本身
2. 移动最大的可移动的元素(当元素移动方向上的元素比自己小时，才能移动)
3. 反转所有比移动元素大的所有元素的移动方向
4. 重复2~3步，直到不能移动为止

### 具体例子

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

## 3 字典序生成法

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

## 4 序数法

这个方法把n!个排列与0~n!-1之间的数一一对应起来，这样，我们就可以按照0~n!-1的次序，逐一生成相关的排列。这个对应的关键在于0~n!-1之间的数m，可以用如下的方式表示：
$$m=a_{n-1}\cdot (n-1)!+a_{n-2}\cdot (n-2)!+...+a_1\cdot 1!$$,其中$$0\leq a_i\leq i$$， 

故m对应序列$$(a_{n-1}, a_{n-2},...a_1)$$，现在再把这个序列和排列一一对应起来，n-1位的序列对应n位的排列。

$$a_i$$ 表示排列p中的数i+1所在位置的右边比它小的数的个数。比如对于排列p=4213，4,3,2的逆序数分别为3，0，1，由此对应为$$(a_2,a_1,a_0)$$，反过来呢，如果知道了逆序数$$(a_2,a_1,a_0)==(3,0,1)$$,也可以一一恢复出排列来。比4小的有3个，4只能放最左边，比3小的为0个，3只能放最右边，比2小的一个，2放第二个位置，剩下的放1，故为4213。

| $$N$$ | $$a_3a_2a_1$$ | $$p_1p_2p_3p_4$$ | $$N$$ | $$a_3a_2a_1$$ | $$p_1p_2p_3p_4$$ |
| ----- | ------------- | ---------------- | ----- | ------------- | ---------------- |
| 0     | 000           | 1234             | 12    | 200           | 1423             |
| 1     | 001           | 2134             | 13    | 201           | 2413             |
| 2     | 010           | 1324             | 14    | 210           | 1432             |
| 3     | 011           | 2314             | 15    | 211           | 2431             |
| 4     | 020           | 3124             | 16    | 220           | 3412             |
| 5     | 021           | 3214             | 17    | 221           | 3421             |
| 6     | 100           | 1243             | 18    | 300           | 4123             |
| 7     | 101           | 2143             | 19    | 301           | 4213             |
| 8     | 110           | 1342             | 20    | 310           | 4132             |
| 9     | 111           | 2341             | 21    | 311           | 4231             |
| 10    | 120           | 3142             | 22    | 320           | 4312             |
| 11    | 121           | 3241             | 23    | 321           | 4321             |

Java代码如下：

```java
    public static ArrayList<int[]> getPermutations(int n) {
        ArrayList<int[]> permutations = new ArrayList<>();
        if (n <= 0) return permutations;
        int[] factorials = new int[n+1];
        factorials[0] = 1;
        for(int i = 1; i <=n; i++) {
            factorials[i] = i * factorials[i - 1];
        }// init factorial array
        for(int m = 0; m < factorials[n]; m++) {
            int remainder = m;
            int[] permutation = new int[n];
            for(int i = n-1; i >=0; i--) {
                int count = remainder / factorials[i];
                remainder = remainder % factorials[i];
                setPosition(permutation, count, i + 1);
            }
            permutations.add(permutation);
        }
        return permutations;
    }

    private static void setPosition(int[] permutation, int count, int num) {
        int zeros = 0;
        for(int i = permutation.length - 1; i >=0; i--) {
            if(permutation[i] == 0) zeros++;
            if(zeros == count + 1) {
                permutation[i] = num;
                break;
            }
        }
    }
```

## 5 轮转法

基准序列$$p_1p_2...p_{n-1}p_n$$，先逐步生成以$$p_1$$开头的所有排列：

1. 先生成以$$p_1p_2...p_{n-2}$$开头的所有排列$$p_1p_2...p_{n-2}p_{n-1}p_{n}$$和$$p_1p_2...p_{n-2}p_{n}p_{n-1}$$
2. 再生成以$$p_1p_2...p_{n-3}$$打头的排列，除了前述2个排列外，再将其后三位从左至右轮转2次，得到4个新排列，一共6个排列；
3. 再生成以$$p_1p_2...p_{n-4}$$打头的排列，除了前述6个排列外，再将其后四位从左至右轮转3次，得到18个新排列，一共24个排列；
4. 依次类推，一直到生成以$$p_1$$开头的所有排列为止。

然后将基准序列从左到右轮转一次，生成以$$p_2$$开头的所有排列，依次类推，直到生成以$$p_n$$开头的所有排列。

java代码如下：

```java
    public static ArrayList<int[]> getPermutations(int n) {
        ArrayList<int[]> permutations = new ArrayList<>();
        if (n <= 0) return permutations;
        int[] first = new int[n];
        for(int i = 0; i < n; i++) {
            first[i] = i + 1;
        }
        for (int i = 0; i < n; i++) {
            if(i > 0) {
                rotateLeft(first, 0, n);
            }
            int[] base = first.clone();
            permutations.addAll(rotateBase(base));
        }
        return permutations;
    }

    private static ArrayList<int[]> rotateBase(int[] base) {
        ArrayList<int[]> permutations = new ArrayList<int[]>();
        permutations.add(base);
        for(int prefixSize = base.length - 2; prefixSize >= 1; prefixSize--) {
            int currentSize = permutations.size();
            for(int i = 0; i < currentSize; i++) {
                int[] last = permutations.get(i);
                for(int j = 0; j < base.length - prefixSize - 1; j++) {
                    int[] rotated = last.clone();
                    rotateLeft(rotated, prefixSize, base.length);
                    permutations.add(rotated);
                    last = rotated;
                }
            }
        }
        return permutations;
    }

    private static void rotateLeft(int[] permutation, int start, int end) { 
      // rotate from left to right
        int temp = permutation[start];
        for(int i = start; i < end - 1; i++) {
            permutation[i] = permutation[i + 1];
        }
        permutation[end-1] = temp;
    }
```

## 6 回溯法

我们将问题形象化，假如你手里有编号为1、2、3的3张扑克牌和编号为1、2、3的三个盒子。现在需要将这3张扑克牌分别放入3个盒子里，并且每个盒子有且只有一张扑克牌。总共有几种放法呢？

首先你来到了1号盒子面前，你现在手里有3张扑克牌，先放哪一张好呢？很显然三者都要尝试，那就姑且约定一个顺序：每次到一个盒子面前，都先放1号，再放2号，最后放3号。于是你在一号盒子里放入了编号为1的扑克牌。来到2号盒子面前，由于之前的1号扑克牌已经不在手中，按照之前约定的顺序，你将2号牌放到了2号盒子里。3号也是同样。你又往后走当你来到第4个盒子面前，诶，没有第四个盒子，其实我们不需要第4个盒子，因为手中的扑克牌已经放完了。

你发现了吗？当你走到第四个盒子前的时候，已经完成了一种排列，即“1 2 3”。然而并没有到此结束，产生了一种排列之后，你需要立即返回。现在你已经退到了3号盒子面前，你需要取回之前放在3号盒子中的扑克牌，再去尝试看看还能否放别的扑克牌，从而产生一个新的排列。于是你取回了3号牌，但由于你手中只有3号牌，你只能再次退回到2号盒子面前。

你回到2号盒子后，收回了2号牌。现在你的手中有2张牌了，分别是2号和3号牌。按照之前的约定，现在需要往2号盒子中放3号扑克牌（上次放的是2号牌）。放好后，你来到3号盒子面前，将手中仅剩的2号牌放入了3号盒子。又来到了4号盒子面前，当然没有4号盒子。此时又产生了一个新的排列“1 3 2”。

接下来按照刚才的步骤去模拟，便会依次生成所有排列：“2 1 3”、“2 3 1”、“3 1 2”和“3 2 1”。

Java代码实现如下：

```java
    public static ArrayList<int[]> getPermutations(int n) {
        ArrayList<int[]> permutations = new ArrayList<>();
        if (n <= 0) return permutations;
        boolean[] visited = new boolean[n];
        int[] current = new int[n];
        dfs(permutations, current, visited, 0);
        return permutations;
    }

    private static void dfs(ArrayList<int[]> permutations, int[] current, boolean[] visited, int step) {
        int n = current.length;
        if(step == n) {
            permutations.add(current.clone());
            return;
        }
        for(int i = 0; i < n; i++) {
            if(!visited[i]) {
                current[step] = i + 1;
                visited[i] = true;
                dfs(permutations, current, visited, step + 1);
                visited[i] = false;
            }
        }
    }
```

当然，如果改用栈，也可以变成非递归的版本。

## 后记

对一个问题用不同的算法解决，可以综合复习各种算法思路。

另外重要的一点就是，如果看过一个算法没有写代码实现过，很可能会有一些没有真正理解的细节存在。

如果以后再发现好的算法，还会再补充。