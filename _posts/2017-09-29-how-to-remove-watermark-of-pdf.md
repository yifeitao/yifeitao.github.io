---
layout: post
title: 如何移除pdf中的水印
categories: geek
---

## 1 文本水印

如果这个水印完全是一种文本信息，可用考虑使用linux命令行解决，主要用到sed和pdftk工具，命令如下，三个步骤分别为解压pdf，剔除水印，压缩为pdf。

```shell
pdftk original.pdf output uncompressed.pdf uncompress
sed -e "s/watermarktextstring/ /" uncompressed.pdf > unwatermarked.pdf
pdftk unwatermarked.pdf output fixed.pdf compress
```

参考[这里](pdftk unwatermarked.pdf output fixed.pdf && mv fixed.pdf unwatermarked.pdf)。

## 2 复杂对象 

如果水印是更加复杂的对象，一般是图像，就需要使用pdf编辑器将其删除，推荐福昕阅读器领鲜版。

进入特色功能- >PDF编辑工具->编辑对象，一般就可以选中水印对象删除了，问题是一般每一页都有水印，需要自动化手段。

使用AHK之类的自动化脚本工具一般都能搞定。

我用过最有趣的是Sikuli脚本工具实现自动化，等有时间再补上细节。