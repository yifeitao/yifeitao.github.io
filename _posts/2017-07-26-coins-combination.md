---
5layout: post
title: 硬币组合问题
categories: coding
mathjax: true
---

假设我们有面值为1，2，5，10，25的硬币，那么组成面值$$m$$共有多少种可能的情况？这是美分的情况。

一般的假设我们有面值为$$(a_1,a_2,...a_n)  $$的硬币,其中$$ a_1<a_2<...<a_n$$，那么组成面值$$m$$共有多少种可能的情况？

按照一般找钱的顺序，我们从大钱开始考虑，这样剩下的面值才能比较迅速的减小。

### 1.递推式1

考虑美分的情况，假设我们要组成面值101，记组合数为f(101)，如果使用了一个25分的，那么剩下的情况数应该是f(76)，但是注意，这个f(76)已经不能使用25分的硬币了，简单起见，我们把硬币种类编号引入组合数，当可以用编号1~k时，组合数记为f(m,k)，所以上面的分析可以记为组合数f(101,5)，使用了一个25分时，剩下的情况数为f(76, 4)，针对25美分的使用，可以得到下表

| 25分个数 | 剩余        |
| ----- | --------- |
| 0     | f(101, 4) |
| 1     | f(76, 4)  |
| 2     | f(51, 4)  |
| 3     | f(26, 4)  |
| 4     | f(1, 4)   |

将第二列的数字相加，就得到了结果。现在要求的问题简化了，只需要考虑面值为1，2，5，10的情况，同样的以f(76, 4)为例，可以化简为f(76,3),f(66,3)...f(6,3)，这样递归迭代下去，我们最终要解决的子问题是f(m,1)，用一种面值来组成m，显然，只需要面值m能被$$a_1$$整除即可，由此结束了递归迭代。

$$ f(m, n) = f(m, n-1)  + f(m-a_n, n-1) + ...+f(m\%a_n, n-1)$$

按照这种思路，直接写成Java代码如下:

```java
    public int countCoins(int n, int[] coins) {
        if(n < 0) return 0;
        return countCoins(n, coins.length - 1, coins);
    }

    public int countCoins(int n, int level, int[] coins) {
        if(level == 0) {
            return n % coins[0] == 0 ? 1 : 0;
        }
        int ways = 0;
        for(int i = 0; i*coins[level] <= n; i++) {
            ways += countCoins(n-i*coins[level], level-1, coins);
        }
        return ways;
    }
```

### 2. 递推式1的动态规划

在1中，我们通过不断的减去大的硬币面值，求解各个子问题，得到最终的结果，不难发现，这些子问题存在很多重复，比如考虑如下的计算路径：f(101, 5)->f(76, 4)->f(16,3)...和f(101, 5)->f(26, 4)->f(16,3)...后面的计算时完全重合的，因此，如果把这些计算结果缓存起来，可以大大提高计算的速度，这就是动态规划的思想。我们需要建立如下的一张表，以下考虑计算f(6,5)

|      | 0    | 1    | 2    | 3    | 4    | 5    | 6    |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| 1    | 1    | 1    | 1    | 1    | 1    | 1    | 1    |
| 2    | 1    | 1    | 2    | 2    | 3    | 3    | 4    |
| 5    | 1    | 1    | 2    | 2    | 3    | 4    | 5    |
| 10   | 1    | 1    | 2    | 2    | 3    | 4    | 5    |
| 25   | 1    | 1    | 2    | 2    | 3    | 4    | 5    |

注意到我们的递推式，每次分解出很多项，那么在动态规划填表时，也就需要很多项目相加才行。动态规划时，先填满第一行，再根据递推式计算第二行，直到计算最后一行。

由此得到Java代码如下：

```java
    public int countCoins(int n, int[] coins) {
        if(n < 0) return 0;
        int[][] ways = new int[coins.length][n + 1];
        for(int j = 0; j <= n; j++) {
            ways[0][j] = j % coins[0] == 0 ? 1 : 0;
        }
        for(int i = 1; i < coins.length; i++) {
            for(int j = 0; j <= n; j++) {
                if(j < coins[i]) {
                    ways[i][j] = ways[i-1][j];
                }
                else {
                    for(int k = 0; k*coins[i] <= j; k++) {
                        ways[i][j] +=  ways[i-1][j-k*coins[i]];
                    }
                }
            }
        }
        return ways[coins.length - 1][n];
    }
```

注意到最后一行其实只需要计算最后一个元素。（因为它只跟前一行相关），所以上述代码还可以修改节约时间，不过代码会变得不太美观，这里就不写了。

### 3 递推式2及其动态规划

我们发现，递推式1中，一项被分解成多项，导致计算过程中做了相当多的加法，能不能简化一下呢？

还是考虑f(101,5)，我们可以这样考虑，首先不使用25美分，情况数为f(101,4)，其次是使用25美分的情况，那么至少要使用一个25美分，如果去掉这个25美分，则相当于剩下的76美分，既可以使用25美分，也可以不用，实际上就是f(76,5)，由此得到递推关系$$ f(m, n) = f(m-a_n, n) + f(m, n-1)$$，这样在动态规划填表时，每次取上一行的数与本行之前相距$$a_n$$的数相加。注意当$$m<a_n时，f(m, n) = f(m, n-1)$$。

由此得到动态规划的代码如下：

```java
    public int countCoins(int n, int[] coins) {
        if(n < 0) return 0;
        int[][] ways = new int[coins.length][n + 1];
        for(int j = 0; j <= n; j++) {
            ways[0][j] = j % coins[0] == 0 ? 1 : 0;
        }
        for(int i = 1; i < coins.length; i++) {
            for(int j = 0; j <= n; j++) {
                if(j < coins[i]) {
                    ways[i][j] = ways[i-1][j];
                }
                else {
                    ways[i][j] = ways[i-1][j] + ways[i][j-coins[i]];
                }
            }
        }
        return ways[coins.length - 1][n];
    }
```

### 4 递推式2的简化

仔细考察我们填表的过程，填第二行时，左边的较小元素和第一行一样，右边较大的元素在第一行的基础上加上本行较小的一个元素，所以其实只需要存储一行元素就行了，计算 $$f(m, n)$$时， $$f(m-a_n, n)$$在左边已经计算出来了，而$$f(m, n-1)$$直接使用自身存储便可。由此得到更加简化的动态规划代码：

```java
    public int countCoins(int n, int[] coins) {
        if(n < 0) return 0;
        int[] ways = new int[n + 1];
        for(int j = 0; j <= n; j++) {
            ways[j] = j % coins[0] == 0 ? 1 : 0;
        }
        for(int i = 1; i < coins.length; i++) {
            for(int j = coins[i]; j <= n; j++) {
                ways[j] += ways[j-coins[i]];
            }
        }
        return ways[n];
    }
```

考虑第一行，如果设置ways[0] = 1，j<coins[0]时，ways[j] = 0,那么第一行同样可以用递推式ways[j] += ways[j-coins[i]]得到。代码可进一步简化如下：

```java
    public int countCoins(int n, int[] coins) {
        if(n < 0) return 0;
        int[] ways = new int[n+1];
        ways[0] = 1;
        for(int i = 0; i < coins.length; i++) {
            for(int j = coins[i]; j <= n; j++) {
                ways[j] = ways[j] + ways[j-coins[i]];
            }
        }
        return ways[n];
    }
```