---
layout: post
title:  【译文】使用很少的图片构建强大的图片分类模型
categories: coding
---
文本翻译自[The Keras Blog](https://blog.keras.io/building-powerful-image-classification-models-using-very-little-data.html)。翻译的目的主要是放慢自己学习的速度，也许对其他人也会有帮助。以下为译文。

---

在这个教程中，我们会展示一些简单但有效的方法，使你可以用很少的训练样本——每个待识别的类别只有几百张到几千张图片——来构建强大的图片分类模型。

我们会使用如下的方法：

* 从头训练一个小的网络作为比较基准
* 使用预训练网络的bottleneck 特征
* 微调预训练网络的最后几层

这会让我们涉及以下的Keras 特性：

* ``fit_generator` `使用Python数据生成器来训练Keras模型
* ``ImageDataGenerator` `实时的图像增强
* 层冻结和模型微调
* ...其它

**注意：所有的示例都在2017年3月14日更新到了 Keras  2.0 API。运行这些代码需要Keras版本号大于等于2.0.0。**

#### 我们的设定：只有2000个样本（每类1000个）

我们从如下设定开始：

* 机器安装了Keras, SciPy, PIL。如果你有NVIDIA 显卡也可以用（需要安装cuDNN），不过由于我们处理的图片很少所以这不是必需的。
* 一个训练集目录和验证集目录，都包含以分类组织的子目录，这些子目录包含 .png或.jpg图片：

```
data/
    train/
        dogs/
            dog001.jpg
            dog002.jpg
            ...
        cats/
            cat001.jpg
            cat002.jpg
            ...
    validation/
        dogs/
            dog001.jpg
            dog002.jpg
            ...
        cats/
            cat001.jpg
            cat002.jpg
            ...
```

为了获取几百到几千张你感兴趣的分类的照片，你可以通过 [Flickr API](https://www.flickr.com/services/api/)下载特定标签的图片，它的协议比较友好。

在我们的例子中，使用两类图片，它们来自 [Kaggle](https://www.kaggle.com/c/dogs-vs-cats/data)：1000只猫和1000条狗（尽管原数据集有12,500只猫和12,500条狗，我们只使用每类最靠前的1000张）。再每个类别取400张图片作为验证集来评估模型。

这就只有很少的图片可供学习了，对一个图片分类问题而言这很不容易。这是一个有挑战的机器学习问题，但也很符合现实情况：在现实世界中，只获取小规模的数据集也是很昂贵的甚至是几乎不可能的（比如医疗学习）。从有限的数据获得最大的产出是一个合格的数据科学家的关键技能。

![](https://blog.keras.io/img/imgclf/cats_and_dogs.png)

这个问题有多难呢？在Kaggle 开始猫狗分类竞赛（一共25,000张图片）两年多后，出现了如下的评论：

> 在一个多年前的非正式调查中，计算机图像专家认为当前技术如果没有的的巨大进步，一个准确率高于60%的分类器都几乎是不可能的。作为参考，60%准确率的分类器将*12-image HIP*的猜测概率从1/4096提高到1/459。而现在的材料认为在这个任务上机器分类的正确率可以高达80%。

在竞赛结果中，顶级选手使用现代的深度学习技术，准确率可以高达98%。在我们的例子中，我们限制只用8%的数据集，问题会更难。

#### 深度学习在小数据问题中的作用

我经常听见这种说法“深度学习只有在你有庞大的数据时才有用”。虽然不是全错，但这种说法一定程度上是有误导作用的。当然，深度学习有从数据中自动学习特征的能力，通常只有在可用的数据量很大时才有可能——特别是当输入样本的维度很高时，比如图片。然而，卷积神经网络网络——深度学习的重要算法之一——是针对大多数感知问题（比如图片分类）的最佳模型，即使只有很少的数据可供学习也是如此。在一个小的图片数据集上从头训练一个卷积神经网络仍然可以获得不错的结果，而且不需要手动设计特征。卷积神经网络足够好了，它们是解决这类问题的正确工具。

但是更进一步，深度学习模型天然地适合更改应用场景：正如你将在本文中看到的，你可以将一个在大型数据集上训练的图片分类或语音识别模型，稍做修改后应用到完全不同的问题上。尤其是在计算机图形领域，很多预训练的模型（通常在ImageNet 数据集上）是公开可下载的，你可以使用它们在很少的数据上构建强大的图像模型。

#### 数据预处理和数据增强

为了更好的利用有限的样本，你需要使用一系列的随机变换来增强图片，这样模型就不会再重复使用完全相同的图片。这可以防止过拟合，模型能更好的泛化。

在Keras 中这可以通过`keras.preprocessing.image.ImageDataGenerator`类来实现。这个类提供如下功能：

* 设定训练时图片的随机变换和标准化操作
* 通过 `.flow(data, labels)`或`flow_from_directory(directory)`来实例化批量增强图片的生成器。这些生成器随即可以作为`fit_generator`，``evaluate_generator` 和`predict_generator`等Keras 模型方法的输入。

示例如下：

```python
from keras.preprocessing.image import ImageDataGenerator

datagen = ImageDataGenerator(
        rotation_range=40,
        width_shift_range=0.2,
        height_shift_range=0.2,
        rescale=1./255,
        shear_range=0.2,
        zoom_range=0.2,
        horizontal_flip=True,
        fill_mode='nearest')
```

这里只是一部分可配置项（更多的请参考[文档](http://keras.io/preprocessing/image/)。我们看一下上述可配置项的含义：

* `rotation_range` 是0~180的度数值，表示图片旋转的范围
* `width_shift` 和`height_shift` 是宽度、长度的百分比，代表图片平移的范围
* `rescale` 表示在其它处理之前对图片的乘数。我们的原始图片是由0~255之间的RGB值构成的，这种值模型处理起来太大了（在典型的学习率下），所以需要通过缩放因子1/255把值缩放到0~1之间
* `shear_range` 表示随机应用[错切](https://zh.wikipedia.org/wiki/错切)
* `zoom_range` 表示图片内的随机缩放
* `horizontal_flip` 表示随机地水平翻转图片——当没有水平不对称的假设时(例如，真实世界的图片)。
* `fill_mode` 表示在旋转或水平/垂直平移后，对新像素的填充策略

现在我们使用这个工具在临时文件夹中生成一些图片，直观感受一下这些增强策略的效果，为了图片可显示，这里不使用数值缩放因子。

```python
from keras.preprocessing.image import ImageDataGenerator, array_to_img, img_to_array, load_img

datagen = ImageDataGenerator(
        rotation_range=40,
        width_shift_range=0.2,
        height_shift_range=0.2,
        shear_range=0.2,
        zoom_range=0.2,
        horizontal_flip=True,
        fill_mode='nearest')

img = load_img('data/train/cats/cat.0.jpg')  #这是一个 PIL 图片
x = img_to_array(img)  # 这是一个 Numpy 数组，形状是 (3, 150, 150)
x = x.reshape((1,) + x.shape)  # 这是一个 Numpy 数组，形状是 (1, 3, 150, 150)

# 下面的 .flow() 命令生成一批随机变换的图片
# 然后保存到 `preview/` 目录
i = 0
for batch in datagen.flow(x, batch_size=1,
                          save_to_dir='preview', save_prefix='cat', save_format='jpeg'):
    i += 1
    if i > 20:
        break  # 否则生成器会一直循环下去
```

下面就是数据增强策略得到的图片。

![](https://blog.keras.io/img/imgclf/cat_data_augmentation.png)

#### 从头训练一个小卷积网络：40行代码达到80%准确率

卷积网络是解决图片分类问题的合适工具，我们先尝试训练一个作为基准线。由于样本很少，所以首先关注的问题是过拟合。过拟合发生于模型见过的样本太少，而不能泛化到新的数据，也就是说，模型开始使用一些不相关的特征来做预测。比如一个人只见过3张伐木工人的图片，和3张水手的图片，这些图片中只有一个伐木工人是戴帽子的，你可能会想戴帽子是伐木工人的特征而不是水手的，这样就会是一个糟糕的伐木工人/水手分类器。

数据增强是克服过拟合的方法之一，但是仅仅数据增强还不够，因为增强的样本之间是高度相关的。克服过拟合的关键是模型的熵容量——模型可以存储多少信息。模型能存储的信息越多，就有更大的潜力做到精确，它能利用更多的特征，但是有存储不相关特征的风险。而模型只能存储很少的信息时，则能聚焦到数据中找到的显著特征，这些特征更可能是真正问题相关的，能更好的泛化。

在这个例子中，我们使用一个只有少数几层、少数几个过滤器的小卷积网络，同时使用数据增强和dropout。Dropout 也能减轻过拟合，它可以防止一个层两次看到同样的模式，因此扮演了类似数据增强的角色（可以理解为数据增强和dropout都能破环数据中的随机相关性）。

下面的代码是我们的第一个模型，简单的3层卷积网络，卷积使用ReLU激活器，每层卷积紧接一个最大池化层。这和LeCun 在1990年代发表的图像分类模型结构很相似，除了当时没有使用ReLU激活器。

本实验的完整代码可以在[这里](https://gist.github.com/fchollet/0830affa1f7f19fd47b06d4cf89ed44d)找到。

```python
from keras.models import Sequential
from keras.layers import Conv2D, MaxPooling2D
from keras.layers import Activation, Dropout, Flatten, Dense

model = Sequential()
model.add(Conv2D(32, (3, 3), input_shape=(3, 150, 150)))
model.add(Activation('relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(32, (3, 3)))
model.add(Activation('relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))

model.add(Conv2D(64, (3, 3)))
model.add(Activation('relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))

#目前为止模型的输出维度 (height, width, features)
```

在此之上，使用两个全连接层。最后一层是单个单元，使用sigmoid 激活器，它非常适合二分类问题，相应的使用`binary_crossentropy` 来训练模型。

```python
model.add(Flatten())  # 3维数据特征转化为1维
model.add(Dense(64))
model.add(Activation('relu'))
model.add(Dropout(0.5))
model.add(Dense(1))
model.add(Activation('sigmoid'))

model.compile(loss='binary_crossentropy',
              optimizer='rmsprop',
              metrics=['accuracy'])
```

现在开始准备数据，使用`.flow_from_directory()`根据jpgs图片和相应的目录，生成批量的图片数据和相应的标签。

```python
batch_size = 16

# 用于训练的图片增强配置
train_datagen = ImageDataGenerator(
        rescale=1./255,
        shear_range=0.2,
        zoom_range=0.2,
        horizontal_flip=True)

# 用于测试的图片增强配置:只设定rescale
test_datagen = ImageDataGenerator(rescale=1./255)

# 生成器从'data/train' 文件夹中读取数据, 可以无限生成增强的图片数据
train_generator = train_datagen.flow_from_directory(
        'data/train',  # 目标文件夹
        target_size=(150, 150),  # 所有图片尺寸重设为 150x150
        batch_size=batch_size,
        class_mode='binary')  # binary_crossentropy 损失函数需要二值标签

# 一个类似的生成器，用于验证集数据
validation_generator = test_datagen.flow_from_directory(
        'data/validation',
        target_size=(150, 150),
        batch_size=batch_size,
        class_mode='binary')
```

现在可以使用生成器来训练模型了。每个轮次训练在GPU上需要20~30s，在CPU上需要300~400s。所以如果不是很着急，在CPU上运行是可行的。

```python
model.fit_generator(
        train_generator,
        steps_per_epoch=2000 // batch_size,
        epochs=50,
        validation_data=validation_generator,
        validation_steps=800 // batch_size)
model.save_weights('first_try.h5')  # 记得在训练后和训练中适时保存模型
```

这种方法在50轮次训练后，验证集准确率约为0.79~0.81（50次是随意设定的——因为模型很小，又用了比较强的dropout，不太容易会过拟合）。如果在Kaggle 刚发布这个竞赛的时候，我们的结果已经是最好的——而且只用了8%的数据，也没有优化网络结构和超参数。实际上在Kaggle 的竞赛中这个模型能排进前100（一共215个竞赛者）。所以估计至少有115个竞赛者没有用深度学习。

#### 使用预训练网络的bottleneck 特征：一分钟内达到90%准确率

更优雅的方法是利用在大数据集上的预训练网络。这些网络已经学到了在很多计算机图像问题上都有用的特征，相比那些只依赖问题本身可获得的数据的模型，利用这些特征可以达到更高的准确率。

我们使用VGG16 模型，它是在ImageNet 数据集上预训练的——本博客之前讨论过。由于ImageNet 的1000个分类中包括几个“猫”分类（波斯猫、暹罗猫等）和很多“狗”分类，这个模型已经学到很多和我们的分类问题相关的特征。实际上，仅仅需要记录数据经过模型后的softmax 预测值就可以很好的解决猫狗分类问题，都不需要使用bottleneck 特征。不过为了让方法能有更广泛的适应性，包括那些在ImageNet 中没有出现的分类，我们还是使用bottleneck 特征。

下面是VGG16 的结构：

![](https://blog.keras.io/img/imgclf/vgg16_original.png)

我们的策略如下：只使用这个模型的卷积部分，即全连接之前的所有层。然后在我们的数据上运行这个模型，使用两个numpy 数组记录所有的输出（即VGG16的bottleneck 特征：全连接层之前的最后一个激活层）。然后在这些记录的基础上，训练一个小的全连接网络。

我们之所以离线记录这些特征，而不是直接在冻结的卷积层之上增加全连接层训练，是因为这样计算更高效。运行VGG16 模型很费时，尤其是使用CPU时，而且我们只希望计算一次。不过注意这样就不能用数据增强了。

可以在[这里](https://gist.github.com/fchollet/f35fbc80e066a49d65f1688a7e99f069)找到完整的代码，从[Github](https://gist.github.com/baraldilorenzo/07d7802847aaad0a35d3)获取预训练权重。这里不再讨论模型怎样构造和加载——在很多Keras 的示例中已经讨论过了。不过需要看看如何使用图片生成器记录bottleneck 特征:

```python
batch_size = 16

generator = datagen.flow_from_directory(
        'data/train',
        target_size=(150, 150),
        batch_size=batch_size,
        class_mode=None,  # 这个生成器不产生标签
        shuffle=False)  # 保持数据顺序，先是1000只猫，然后是1000条狗
# 给定一个生成器yields批量的numpy数据，predict_generator会返回模型的输出
bottleneck_features_train = model.predict_generator(generator, 2000)
# 保存这些输出到 numpy数组
np.save(open('bottleneck_features_train.npy', 'w'), bottleneck_features_train)

generator = datagen.flow_from_directory(
        'data/validation',
        target_size=(150, 150),
        batch_size=batch_size,
        class_mode=None,
        shuffle=False)
bottleneck_features_validation = model.predict_generator(generator, 800)
np.save(open('bottleneck_features_validation.npy', 'w'), bottleneck_features_validation)
```

然后使用保存的数据训练一个小的全连接网络：

```python
train_data = np.load(open('bottleneck_features_train.npy'))
# 由于特征是按猫狗的顺序产生的，所有构造标签很简单
train_labels = np.array([0] * 1000 + [1] * 1000)

validation_data = np.load(open('bottleneck_features_validation.npy'))
validation_labels = np.array([0] * 400 + [1] * 400)

model = Sequential()
model.add(Flatten(input_shape=train_data.shape[1:]))
model.add(Dense(256, activation='relu'))
model.add(Dropout(0.5))
model.add(Dense(1, activation='sigmoid'))

model.compile(optimizer='rmsprop',
              loss='binary_crossentropy',
              metrics=['accuracy'])

model.fit(train_data, train_labels,
          epochs=50,
          batch_size=batch_size,
          validation_data=(validation_data, validation_labels))
model.save_weights('bottleneck_fc_model.h5')
```

由于网络很小，所以在CPU上训练也很快（每秒1个轮次）：

```
Train on 2000 samples, validate on 800 samples
Epoch 1/50
2000/2000 [==============================] - 1s - loss: 0.8932 - acc: 0.7345 - val_loss: 0.2664 - val_acc: 0.8862
Epoch 2/50
2000/2000 [==============================] - 1s - loss: 0.3556 - acc: 0.8460 - val_loss: 0.4704 - val_acc: 0.7725
...
Epoch 47/50
2000/2000 [==============================] - 1s - loss: 0.0063 - acc: 0.9990 - val_loss: 0.8230 - val_acc: 0.9125
Epoch 48/50
2000/2000 [==============================] - 1s - loss: 0.0144 - acc: 0.9960 - val_loss: 0.8204 - val_acc: 0.9075
Epoch 49/50
2000/2000 [==============================] - 1s - loss: 0.0102 - acc: 0.9960 - val_loss: 0.8334 - val_acc: 0.9038
Epoch 50/50
2000/2000 [==============================] - 1s - loss: 0.0040 - acc: 0.9985 - val_loss: 0.8556 - val_acc: 0.9075
```

准确率达到0.90~0.91，相当不错了。这是因为基础模型已经在标记过猫狗的样本数据上训练过了。

#### 微调预训练网络的最后几层

为了继续改进前面的结果，我们可以微调VGG16模型最后的卷积模块以及分类器。微调意味着从训练过的网络开始，在新的数据集上使用很小的权重更新来重新训练，本例可以分为3步：

* 初始化VGG16 网络的卷积部分加载权重
* 在此基础上增加我们前面训练的全连接网络并加载权重
* 冻结最后的卷积模块之前的层

![](https://blog.keras.io/img/imgclf/vgg16_modified.png)

注意：

* 为了微调模型，所有层都要从训练过的权重开始：比如你不能在预训练的卷积层上增加一个使用随机值初始化的全连接层。因为随机初始化的权重带来的大的更新会伤害卷积层的权重。所以在本例中我们先训练了一个全连接层的分类器，然后才将它和卷积层放在一起工作。
* 为了防止过拟合我们只微调最后的卷积层而不是整个网络，因为整个网络有非常大的熵容量因此很容易过拟合。底层的卷积网络学到的特征是更基础的特征，没有高层特征那么抽象，所以固定最开始几层的特征（更加基础的特征）只训练最后一层是合理的。
* 微调应该用很小的学习率，而且一般用SGD 优化器而不是那些自适应的优化器比如RMSProp。这是为了保持很小量级的权重更新，不伤害网络已经学到的特征。

可以在[这里](https://gist.github.com/fchollet/7eb39b44eb9e16e59632d25fb3119975)获得完整的试验代码。

初始化VGG16 网络加载权重后，增加我们前面训练的全连接层：

```python
# 在卷积层上增加分类器
top_model = Sequential()
top_model.add(Flatten(input_shape=model.output_shape[1:]))
top_model.add(Dense(256, activation='relu'))
top_model.add(Dropout(0.5))
top_model.add(Dense(1, activation='sigmoid'))

# 注意为了微调训练，全连接分类器也应该训练过
# classifier, including the top classifier,
# in order to successfully do fine-tuning
top_model.load_weights(top_model_weights_path)

# 添加到卷积层之上
model.add(top_model)
```

最后开始使用很小的学习率，微调模型：

```python
batch_size = 16

# 准备数据增强
train_datagen = ImageDataGenerator(
        rescale=1./255,
        shear_range=0.2,
        zoom_range=0.2,
        horizontal_flip=True)

test_datagen = ImageDataGenerator(rescale=1./255)

train_generator = train_datagen.flow_from_directory(
        train_data_dir,
        target_size=(img_height, img_width),
        batch_size=batch_size,
        class_mode='binary')

validation_generator = test_datagen.flow_from_directory(
        validation_data_dir,
        target_size=(img_height, img_width),
        batch_size=batch_size,
        class_mode='binary')

# 微调模型
model.fit_generator(
        train_generator,
        steps_per_epoch=nb_train_samples // batch_size,
        epochs=epochs,
        validation_data=validation_generator,
        validation_steps=nb_validation_samples // batch_size)
```

50轮次训练后，本方法可以到达0.94的准确率。很大的进步！

用下面的方法可以尝试争取准确率达到0.95：

* 更激进的数据增强
* 更激进的dropout
* 使用L1 和L2 正则化（又称“权重衰减”）
* 多微调一层（同时用更大的正则化）

本文到此结束！回顾一下，各部分试验的代码如下：

* [从头训练的卷积网络](https://gist.github.com/fchollet/0830affa1f7f19fd47b06d4cf89ed44d)
* [Bottleneck 特征](https://gist.github.com/fchollet/f35fbc80e066a49d65f1688a7e99f069)
* [微调](https://gist.github.com/fchollet/7eb39b44eb9e16e59632d25fb3119975)

如果关于这篇文章讨论的话题你有任何评论或建议可以到[Twitter](https://twitter.com/fchollet)。