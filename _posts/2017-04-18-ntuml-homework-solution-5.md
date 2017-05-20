---
layout: post
title: 台大机器学习课程作业5
categories: coding
tag: 机器学习
---
所有关于台大机器学习公开课、机器学习基石、机器学习技法的内容使用github统一更新，本文已经可能已经失效。请访问[repo](https://github.com/yifeitao/lml/tree/master/ntuml) 。

13~20代码

```python
import numpy as np
import matplotlib.pyplot as plt

def ridge_regression(X, y, lamda):
    n, d = X.shape
    return np.linalg.inv((X.T.dot(X)+lamda*np.eye(d))).dot(X.T).dot(y)

def error(X, y, w):
    y_predict = np.sign(X.dot(w))
    return np.sum(y!=y_predict) / y.size

def load_xy(fname):
    data = np.loadtxt(fname)
    m, _ = data.shape
    x = np.hstack((np.ones((m, 1)), data[:,:-1])) 
    y = data[:,-1:]
    return x, y

X, y = load_xy('hw4_train.html')
X_test, y_test = load_xy('hw4_test.html')

#13
w = ridge_regression(X, y, 11.26)
e_in = error(X, y, w)
e_out = error(X_test, y_test, w)
print('13#:','e_in:',e_in, 'e_out:', e_out)

#14,15
all_e_in, all_e_out = [], []
min_e_in, min_e_out = 1,1
for i in range(2, -11, -1):
    lamda = 10**i
    w = ridge_regression(X, y, lamda)
    e_in = error(X, y, w)
    e_out = error(X_test, y_test, w)
    all_e_in.append(e_in)
    all_e_out.append(e_out)
    if e_in < min_e_in:
        min_e_in = e_in
        min_e_in_w = w
        min_e_in_i = i
        min_e_in_out = e_out
    if e_out < min_e_out:
        min_e_out = e_out
        min_e_out_w = w
        min_e_out_i = i
        min_e_out_in = e_in
print('14#:','index',min_e_in_i, 'e_in',min_e_in, 'e_out',min_e_in_out)
plt.plot(range(2, -11, -1), all_e_in)
plt.show()

print('15#:','index',min_e_out_i, 'e_in', min_e_out_in, 'e_out',min_e_out)
plt.figure()
plt.plot(range(2, -11, -1), all_e_out)
plt.show()

#16,17
X_train, y_train = X[:120], y[:120]
X_val, y_val = X[120:], y[120:]

all_e_train, all_e_val = [], []
min_e_train, min_e_val = 1,1
for i in range(2, -11, -1):
    lamda = 10**i
    w = ridge_regression(X_train, y_train, lamda)
    e_train = error(X_train, y_train, w)
    e_val = error(X_val, y_val, w)
    e_out = error(X_test, y_test, w)
    all_e_train.append(e_train)
    all_e_val.append(e_val)
    if e_train < min_e_train:
        min_e_train = e_train
        min_e_train_w = w
        min_e_train_i = i
        min_e_train_out = e_out
        min_e_train_val = e_val
    if e_val < min_e_val:
        min_e_val = e_val
        min_e_val_w = w
        min_e_val_i = i
        min_e_val_out = e_out
        min_e_val_train = e_train
print('16#:','index', min_e_train_i, 'e_train', min_e_train, 'e_val',min_e_train_val, 'e_out',min_e_train_out)
plt.plot(range(2, -11, -1), all_e_train)
plt.show()

print('17#:','index',min_e_val_i, 'e_train',min_e_val_train, 'e_val',min_e_val, 'e_out',min_e_val_out)
plt.figure()
plt.plot(range(2, -11, -1), all_e_val)
plt.show()

#18
w =  ridge_regression(X, y, 10**min_e_val_i)
e_in = error(X, y, w)
e_out = error(X_test, y_test, w)
print('18#:','e_in',e_in, 'e_out',e_out)

#19

X_folds, y_folds = [], []
step = y.size // 5
for j in range(5):
    X_folds.append(X[j*step:(j+1)*step])
    y_folds.append(y[j*step:(j+1)*step])

min_e_cv = 1
all_e_cv = []
for i in range(2, -11, -1):
    lamda = 10**i
    all_e_val = []
    for j in range(5):
        X_val, y_val = X_folds[j], y_folds[j]
        del X_folds[j]
        del y_folds[j]
        X_train = np.vstack(X_folds)
        y_train = np.vstack(y_folds)
        w = ridge_regression(X_train, y_train, lamda)
        X_folds.insert(j,X_val)
        y_folds.insert(j,y_val)
        all_e_val.append(error(X_val, y_val, w))
    e_cv = np.average(all_e_val)
    all_e_cv.append(e_cv)
    if e_cv < min_e_cv:
        min_e_cv = e_cv
        min_e_cv_i = i
print('19#:',min_e_cv_i, min_e_cv)
#20
w =  ridge_regression(X, y, 10**min_e_cv_i)
e_in = error(X, y, w)
e_out = error(X_test, y_test, w)
print('20#:',e_in, e_out)
```