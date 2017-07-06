---
layout: post
title:  Josephus问题c++代码
categories: coding
---
据说著名犹太历史学家 Josephus有过以下的故事：在罗马人占领乔塔帕特后，39 个犹太人与Josephus及他的朋友躲到一个洞中，39个犹太人决定宁愿死也不要被人抓到，于是决定了一个自杀方式，41个人排成一个圆圈，由第1个人开始报数，每报数到第3人该人就必须自杀，然后再由下一个重新报数，直到所有人都自杀身亡为止。然而 Josephus 和他的朋友并不想遵从，Josephus要 他的朋友先假装遵从，他将朋友与自己安排在第16个与第35个位置，于是逃过了这场死亡游戏。这个游戏产生的一般性问题只能采用递推的方法解决，只有在特殊情况下才有好的显式表示。以下的代码算法用到了[该文献](http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.34.4643)中的公式。

```c++
/* 文献 1. Lorenz Halbeisen Eth et al., “The Josephus Problem,” J. THOR. NOMBRES BORDEAUX 9 (1997): 303--318. 给出了递推公式的推导并讨论了显示表示，其中间隔k=2时有很好的结果。 J(n,k,i)表示大小为n的环，从标号0开始，每k个杀一个，第i个被杀的人的编号。 */ 
#include <iostream> using namespace std; 
bool JosephusSimulate(int size, int step)//过程模拟 
{ 
  bool *ring=new bool[size]; 
  for(int i =0; i<size; i++) 
    ring[i]=true;//构造大小为size的动态数组 
  int indicator = -1; //数数的杀手指到的编号0~size-1 
  int counter = 0; //循环计数器 
  int surviver=size; //幸存者数目 
  while(surviver>0) //杀光光？ 
  { 
    indicator = (indicator+1)%size; 
    if(ring[indicator]== true) //活人算算杀不杀 
    { 
      counter = (counter+1)%step; //循环计数1~step(=0) 
      if(counter==0) 
      { 
        ring[indicator] = false;//杀人啦 
        cout <<indicator+1 <<",";//数组的编号是从0开始的,转换为1开始 
        surviver--; 
      } 
    } 
  } 
  delete[] ring;//销毁数组 
  ring = NULL; 
  return true; 
} 

int JosephusRecursion(int size, int step, int order)//递推算法， 
{ 
  //公式 J(n,k,1)=(k-1)mod n 
  // J(n+1,k,i+1)=(k+J(n,k,i))mod(n+1), 
  int indicator=(step-1)%(size-order+1); 
  for(int i=size-order+2; i<=size; i++) 
  { 
    indicator = (indicator+step)%i; 
  } 
  return indicator+1;//数组的编号是从0开始的,转换为1开始 
} 

int Josephus2(int size,int order)//step=2时的快速算法 
{ 
  //公式来自参考文献1 c=2(n-i)+1 
  //J(n,i)=2*(n-c*2^(log2(n/c))) 对数取下整 
  //2^(log2(n/c))作为整体计算，找小于且接近n/c的2的次幂 
  int c = 2*(size-order)+1; 
  int nc = size/c; int i=0; 
  while(nc>0) 
  { 
    nc = nc>>1; i++; 
  } 
  int indicator = (2*size) - (c<<i); 
  return indicator+1; 
} 

int main() 
{ 
  int size,step,order; 
  cout << "size?"; 
  cin >> size; 
  cout << "step?"; 
  cin >> step; 
  cout << "order?"; 
  cin >> order; //JosephusSimulate(size,step); 
  for(int i=1; i<=size; i++) 
  { 
    cout << JosephusRecursion(size,step,i) << endl; 
  } 
  //cout << Josephus2(size,order) << endl; return 0; }
```

