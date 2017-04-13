---
layout: post
title: 台大机器学习课程作业3
categories: coding
---
to do: pdf here

13~15代码

```python
import numpy as np
import matplotlib.pylab as plt

def generate(N, flips_rate):
    x1 = np.random.uniform(-1,1,1000)
    x2 = np.random.uniform(-1,1,1000)
    f = np.sign(x1**2+x2**2-0.6)
    y = np.where(np.random.rand(N) < flips_rate, -f, f).T
    return x1, x2, y

def generate_X(N, flips_rate):
    x1, x2, y = generate(N, flips_rate)  
    X = np.vstack((np.ones_like(x1), x1, x2)).T
    return X, y

def generate_Z(N, flips_rate):
    x1, x2, y = generate(N, flips_rate)
    Z = np.vstack((np.ones_like(x1), x1, x2,x1*x2,x1**2,x2**2)).T
    return Z, y

def error(X, y, w):
    y_predict = np.sign(X.dot(w))
    return np.sum(y!=y_predict) / y.size

N = 1000
flips_rate = 0.1

all_e_in = []
for i in range(1000):
    X, y = generate_X(N, flips_rate)
    w = np.linalg.pinv(X).dot(y)
    e_in = error(X ,y ,w)
    all_e_in.append(e_in)
print(np.average(all_e_in))
plt.hist(all_e_in)

all_e_out = []
all_w3 = []
for i in range(1000):
    X, y = generate_Z(N, flips_rate)
    w = np.linalg.pinv(X).dot(y)
    Xt, yt = generate_Z(N, flips_rate) 
    e_out = error(Xt ,yt ,w)
    all_e_out.append(e_out)
    all_w3.append(w[3])
print(np.average(all_w3), np.average(all_e_out))
plt.hist(all_e_out)
plt.hist(all_w3)
```

18~20代码

```python
import numpy as np

def sigmoid(s):
    return 1.0 / (1 + np.exp(-s))

def sgd_lr(X ,y, alpha, T):    
    N, d = X.shape    
    w = np.zeros(d)
    for i in range(T):
        n = i % N
        Xn = X[n]
        yn = y[n]
        w = w + alpha*sigmoid(-yn*Xn.dot(w))*(yn*Xn)
    return w

def gd_lr(X ,y, alpha, T):    
    N, d = X.shape    
    w = np.zeros(d)
    for i in range(T):
        delta = np.average((sigmoid(-y*X.dot(w))*(-y)).reshape(N,1)*X, axis = 0)
        w = w - alpha*delta
    return w

def error(X, y, w):
    N, _ = X.shape
    return np.sum(np.sign(X_test.dot(w))!=y_test) / N
    
data = np.loadtxt('hw3_train.html')
X = data[:,:-1]
y = data[:,-1]
data2 = np.loadtxt('hw3_test.html')
X_test = data2[:,:-1]
y_test = data2[:,-1]
N, _ = X_test.shape

w1 = gd_lr(X, y, 0.001, 2000)
print(w1,error(X_test, y_test, w1))

w2 = gd_lr(X, y, 0.01, 2000)
print(w2,error(X_test, y_test, w2))

w3 = sgd_lr(X, y, 0.001, 2000)
print(w3,error(X_test, y_test, w3))
```

