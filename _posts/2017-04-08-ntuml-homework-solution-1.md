---
layout: post
title: 台大机器学习课程作业1
categories: coding
tag: 机器学习
---
所有关于台大机器学习公开课、机器学习基石、机器学习技法的内容使用github统一更新，本文已经可能已经失效。请访问 [repo](https://github.com/yifeitao/lml/tree/master/ntuml) 。

15~17代码

```python
import numpy as np
import random
import matplotlib.pyplot as plt

def sign(num):
    return 1 if num > 0 else -1
    
def load_xy(fname):
    data = np.loadtxt(fname)
    m, _ = data.shape
    x = np.hstack((np.ones((m, 1)), data[:,:-1])) 
    y = data[:,-1]
    return x, y

def PLA_naive(x, y):
    m, n = x.shape 
    w = np.zeros(n)
    steps = 0
    last_mistake = -1
    i = 0
    m_correct = 0
    while m_correct < m:
        if sign(x[i].dot(w)) != y[i]:
            m_correct = 0
            w = w + y[i]*x[i]
            steps = steps + 1
            last_mistake = i
        else:
           m_correct = m_correct + 1 
        i = i + 1 if i < m - 1 else 0;
    return w, steps, last_mistake
    
def PLA_random(x, y, alpha = 1.0):
    m, n = x.shape
    w = np.zeros(n)
    steps = 0
    indexs = np.arange(m)
    random.shuffle(indexs)
    pointer = 0
    m_correct = 0
    while m_correct < m:
        i = indexs[pointer]
        if sign(x[i].dot(w)) != y[i]:
            m_correct = 0
            w = w + alpha*y[i]*x[i]
            steps = steps + 1
        else:
           m_correct = m_correct + 1 
        pointer = pointer + 1 if pointer < m - 1 else 0;
    return w, steps
    
x, y = load_xy('hw1_15_train.html')

_,steps,last_mistake = PLA_naive(x, y)
print(steps,last_mistake)

times = 2000
all_steps = []
for k in range(times):
    _,steps = PLA_random(x, y)
    all_steps.append(steps)
print(np.average(all_steps))
plt.hist(all_steps)

all_steps = []
for k in range(times):
    _,steps = PLA_random(x, y, 0.5)
    all_steps.append(steps)
print(np.average(all_steps))
plt.hist(all_steps)
```

18~20代码

```python
import numpy as np
import random
import matplotlib.pyplot as plt

def load_xy(fname):
    data = np.loadtxt(fname)
    m, _ = data.shape
    x = np.hstack((np.ones((m, 1)), data[:,:-1])) 
    y = data[:,-1]
    return x, y

def sign(x):
    vfunc = np.vectorize(lambda t: 1 if t > 0 else -1)
    return vfunc(x)

def test(x, y, w):
    m, _ = x.shape
    return np.sum(y!=sign(x.dot(w))) / m

def PLA_pocket(x, y, updates=50):
    m, n = x.shape
    w = np.zeros(n)
    pocket_w = w.copy()
    pocket_error = test(x ,y, w)
    indexs = np.arange(m)
    for t in range(0,updates):
        mistakes = indexs[y!=sign(x.dot(w))]
        if mistakes.size == 0: break
        i = random.choice(mistakes)
        w = w + y[i]*x[i]
        error = test(x ,y, w)
        if error < pocket_error:
            pocket_w = w
            pocket_error = error
    return pocket_w

def PLA_fixed(x, y, updates=50):
    m, n = x.shape
    w = np.zeros(n)
    indexs = np.arange(m)
    for t in range(0,updates):
        mistakes = indexs[y!=sign(x.dot(w))]
        if mistakes.size == 0: break
        i = random.choice(mistakes)
        w = w + y[i]*x[i]
    return w

x, y = load_xy('hw1_18_train.html')
x_test, y_test = load_xy('hw1_18_test.html')

times = 200
all_errors=[]
for i in range(times):
    w = PLA_pocket(x, y)
    error = test(x_test, y_test, w)
    all_errors.append(error)
print(np.average(all_errors))
plt.hist(all_errors)

all_errors=[]
for i in range(times):
    w = PLA_fixed(x, y)
    error = test(x_test, y_test, w)
    all_errors.append(error)
print(np.average(all_errors))
plt.hist(all_errors)

all_errors=[]
for i in range(times):
    w = PLA_pocket(x, y, 100)
    error = test(x_test, y_test, w)
    all_errors.append(error)
print(np.average(all_errors))
plt.hist(all_errors)
```