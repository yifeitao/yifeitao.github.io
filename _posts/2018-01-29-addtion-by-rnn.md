---
layout: post
title:  基于RNN实现加法
categories: coding
tag: 机器学习
---
知乎上有人问题了个有趣的问题：

[深度学习能够学会加法吗？](https://www.zhihu.com/question/39727411)

撇开所谓的哲学意义不谈，已经证明了通过RNN可以模拟实现图灵机，这篇神奇的论文看[这里](https://arxiv.org/abs/1410.5401)。我的大致理解是，图灵机也是一种模式匹配，而只要有足够多的学习样本，RNN总是可以学会这种模式匹配的。

假设我们要让神经网络学会3位数的加法，比如111+222=333，123+987=110，注意为了简单期间，我们不考虑最高位的进位。

加法可视为两个加数构造的序列来预测作为和的序列，因此可以用RNN来实现。示意图如下：输入序列、输出序列长度均为3，使用一层RNN存储进位信息。输入输出均使用one-hot编码后，输入特征数为20，输出特征数为10，中间层使用RNN，其隐藏节点数设为32。

![addtion-by-rnn-1](/img/addtion-by-rnn-1.png)

使用keras搭了一下模型，图示如下：

![addtion-by-rnn-2](/img/addtion-by-rnn-2.png)

代码如下：

注意为了画上述示意图，需要安装Graphviz

```python
# -*- coding: utf-8 -*-

from keras.models import Sequential
from keras.utils import plot_model
from keras import layers
import numpy as np

import os
os.environ["PATH"] += os.pathsep + 'C:/Program Files (x86)/Graphviz2.38/bin/'

class CharacterTable(object):
    """
    one-hot encode/decode
    """
    def __init__(self, chars):
        self.chars = sorted(set(chars))
        self.char_indices = dict((c, i) for i, c in enumerate(self.chars))
        self.indices_char = dict((i, c) for i, c in enumerate(self.chars))

    def encode(self, C, num_rows):
        x = np.zeros((num_rows, len(self.chars)))
        for i, c in enumerate(C):
            x[i, self.char_indices[c]] = 1
        return x

    def decode(self, x, calc_argmax=True):
        if calc_argmax:
            x = x.argmax(axis=-1)
        return ''.join(self.indices_char[x] for x in x)

TRAINING_SIZE = 50000
DIGITS = 3

chars = '0123456789'
ctable = CharacterTable(chars)

questions = []
expected = []
seen = set()
print('Generating data...')
while len(questions) < TRAINING_SIZE:
    a = ''.join(np.random.choice(list('0123456789')) for i in range(DIGITS))
    b = ''.join(np.random.choice(list('0123456789')) for i in range(DIGITS))
    key = tuple(sorted((a, b)))
    if key in seen:
        continue
    seen.add(key)

    ans = str((int(a[::-1]) + int(b[::-1]))%1000).zfill(DIGITS)[::-1]
    
    questions.append((a,b))
    expected.append(ans)
print('Total addition questions:', len(questions))

print('Vectorization...')
x = np.zeros((len(questions), DIGITS, len(chars)*2), dtype=np.bool)
y = np.zeros((len(questions), DIGITS, len(chars)), dtype=np.bool)
for i, (a, b) in enumerate(questions):
    x[i] = np.column_stack((ctable.encode(a, DIGITS), ctable.encode(b, DIGITS)))
for i, ans in enumerate(expected):
    y[i] = ctable.encode(ans, DIGITS)
    
print('Split data...')
indices = np.arange(len(y))
np.random.shuffle(indices)
x = x[indices]
y = y[indices]

split_at = len(x) - len(x) // 10
(x_train, x_val) = x[:split_at], x[split_at:]
(y_train, y_val) = y[:split_at], y[split_at:]

print('Training Data:')
print(x_train.shape)
print(y_train.shape)

print('Validation Data:')
print(x_val.shape)
print(y_val.shape)

HIDDEN_SIZE = 32
BATCH_SIZE = 128

print('Build model...')
model = Sequential()

model.add(layers.SimpleRNN(HIDDEN_SIZE, input_shape=(DIGITS, len(chars)*2), return_sequences=True))
model.add(layers.TimeDistributed(layers.Dense(len(chars))))
model.add(layers.Activation('softmax'))
model.compile(loss='categorical_crossentropy',
              optimizer='adam',
              metrics=['accuracy'])

print('Plot model...')
model.summary()
plot_model(model, to_file='model.png')

print('Training...')
ITER = 20
for iteration in range(ITER):
    print()
    print('-' * 50)
    print('Iteration', iteration)
    model.fit(x_train, y_train,
              batch_size=BATCH_SIZE,
              epochs=1,
              validation_data=(x_val, y_val))
    print("10 validate examples:")
    for i in range(10):
        ind = np.random.randint(0, len(x_val))
        rowx, rowy = x_val[np.array([ind])], y_val[np.array([ind])]
        preds = model.predict_classes(rowx, verbose=0)
        question = ctable.decode(rowx[0][:,:10]) + '+' + ctable.decode(rowx[0][:,10:])
        correct = ctable.decode(rowy[0])
        guess = ctable.decode(preds[0], calc_argmax=False)
        print('Q', question[::-1], end=' ')
        print('A', correct[::-1], end=' ')
        print('√' if correct == guess else '×', end=' ')
        print(guess[::-1])
```

能在较短时间内训练到100%的准确率。毕竟，这个模式识别起来不太复杂。

至于如何让机器理解什么是加法，这就是另外一个问题了，毕竟我们也难以理解人类是如何学会理解加法的，甚至人类是否理解加法都不知道。