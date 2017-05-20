---
layout: post
title: 台大机器学习课程作业7
categories: coding
tag: 机器学习
---
所有关于台大机器学习公开课、机器学习基石、机器学习技法的内容使用github统一更新，本文已经可能已经失效。请访问 [repo](https://github.com/yifeitao/lml/tree/master/ntuml)。

13~20代码 

```python
import numpy as np
from scipy import stats
import random
import matplotlib.pyplot as plt

def binSplitDatasSet(dataSet, feature, value):
    mat0 = dataSet[dataSet[:,feature] < value]
    mat1 = dataSet[dataSet[:,feature] >= value]
    return mat0, mat1

def creatTree(dataSet):
    feat, val = chooseBestSplit(dataSet)
    if feat == None: return val # 叶子节点直接返回预测值
    retTree = {}
    retTree['spInd'] = feat
    retTree['spVal'] = val
    lSet, rSet = binSplitDatasSet(dataSet, feat, val)
    retTree['left'] = creatTree(lSet)
    retTree['right'] = creatTree(rSet)
    return retTree

def creatDecisionStump(dataSet):
    feat, val = chooseBestSplit(dataSet)
    retTree = {}
    retTree['spInd'] = feat
    retTree['spVal'] = val
    lSet, rSet = binSplitDatasSet(dataSet, feat, val)
    retTree['left'] = classifyLeaf(lSet)
    retTree['right'] = classifyLeaf(rSet)
    return retTree
    
def classifyLeaf(dataSet):
    return stats.mode(dataSet[:,-1])[0][0]

def gini(dataSet):
    N = dataSet.shape[0]
    p1 = np.sum(dataSet[:,-1]==-1)/N
    p2 = np.sum(dataSet[:,-1]==1)/N
    return 1 - p1**2 - p2 ** 2

def chooseBestSplit(dataSet):
    m, n = dataSet.shape
    #所有预测值相等的情况
    if np.sum(dataSet[:,-1]==-1)==m:
        return None, -1
    if np.sum(dataSet[:,-1]==1)==m:
        return None, 1
    S =  dataSet.shape[0]*gini(dataSet)
    
    bestS = np.Inf
    bestIndex = 0
    bestValue = 0
    for featIndex in range(n-1):
        sortedVal = np.unique(dataSet[:,featIndex])
        for valIndex in range(len(sortedVal)-1):
            val = (sortedVal[valIndex] + sortedVal[valIndex+1]) / 2 
            mat0, mat1 = binSplitDatasSet(dataSet, featIndex, val)
            newS = mat0.shape[0]*gini(mat0) + mat1.shape[0]*gini(mat1)
            if newS < bestS:
                bestS = newS
                bestIndex = featIndex
                bestValue = val
    if S==bestS:
        return None, classifyLeaf(dataSet)
    return bestIndex, bestValue

def predict(retTree, x):
    p = retTree
    while type(p)==dict and p['spInd']!=None:
        if x[p['spInd']] < p['spVal']:
            p = p['left']
        else:
            p = p['right']
    else:
        return p
    
def bagging(dataSet):
    m, n = dataSet.shape
    bag = []
    for i in range(m):
        index = random.randint(0,m-1)
        bag.append(dataSet[index,:])
    return np.array(bag)

def creatRandomForest(dataSet, T):
    rf = []
    for i in range(T):
        bag = bagging(dataSet)
        tree = creatTree(bag)
        rf.append(tree)
    return rf

def creatRandomForest_prune(dataSet, T):
    rf = []
    for i in range(T):
        bag = bagging(dataSet)
        tree = creatDecisionStump(bag)
        rf.append(tree)
    return rf

def rf_predict(rf, x):
    count = 0
    for tree in rf:
        p = predict(tree, x)
        if p==1:
            count=count+1
    if count>len(rf)/2:
        return 1
    return -1

def dt_error(tree, dataSet):
    m, n = dataSet.shape
    count=0
    for i in range(m):
        x = dataSet[i,:-1]
        if predict(tree, x)!=dataSet[i,-1]:
             count = count+1
    return count/m

def rf_error(rf, dataSet):
    m, n = dataSet.shape
    count=0
    for i in range(m):
        x = dataSet[i,:-1]
        if rf_predict(rf, x)!=dataSet[i,-1]:
             count = count+1
    return count/m
    
dataSet = np.loadtxt('hw7_train.html')
retTree = creatTree(dataSet)
print(retTree)
print(dt_error(retTree, dataSet))


dataSet2 = np.loadtxt('hw7_test.html')
print(dt_error(retTree, dataSet2))

T = 300

rf = creatRandomForest(dataSet, T)
e_in_list=[]
for tree in rf:
    e_in = dt_error(tree, dataSet)
    e_in_list.append(e_in)
plt.figure()
plt.hist(e_in_list)
plt.show()
print(np.average(e_in_list))

e_g_list=[]
for t in range(T):
    err = rf_error(rf[:t], dataSet)
    e_g_list.append(err)
plt.figure()
plt.plot(e_g_list)
plt.show()
print(e_g_list[-1])

e_g_list2=[]
for t in range(T):
    err = rf_error(rf[:t], dataSet2)
    e_g_list2.append(err)
plt.figure()
plt.plot(e_g_list2)
plt.show()
print(e_g_list2[-1])

rf2 = creatRandomForest_prune(dataSet, T)
e_in_list=[]
for tree in rf2:
    e_in = dt_error(tree, dataSet)
    e_in_list.append(e_in)
plt.figure()
plt.hist(e_in_list)
plt.show()
print(np.average(e_in_list))

e_g_list=[]
for t in range(T):
    err = rf_error(rf2[:t], dataSet)
    e_g_list.append(err)
plt.figure()
plt.plot(e_g_list)
plt.show()
print(e_g_list[-1])

e_g_list2=[]
for t in range(T):
    err = rf_error(rf2[:t], dataSet2)
    e_g_list2.append(err)
plt.figure()
plt.plot(e_g_list2)
plt.show()
print(e_g_list2[-1])
```

