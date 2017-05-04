---
layout: post
title: 台大机器学习课程作业7
categories: coding
---
to do: pdf here 待检查正确性

13~20代码 

```python
import numpy as np
from scipy import stats

def binSplitDatasSet(dataSet, feature, value):
    mat0 = dataSet[dataSet[:,feature] > value]
    mat1 = dataSet[dataSet[:,feature] <= value]
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

#def predict(tree)
    
def classifyLeaf(dataSet):
    return stats.mode(dataSet[:,-1])

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
    
dataSet = np.loadtxt('hw7_train.html')
retTree = creatTree(dataSet)
print(retTree)
```

