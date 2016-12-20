---
layout: post
title:  clips语言优秀资源列表
date:   2016-12-18 23:19:17 +0800
categories:
---
在机器学习技术大热的当下，专家系统可能是一种有些“过时”的技术，但依然有它的适用场景，clips语言是C语言开发的开源专家系统语言，我在项目开发中学习使用了该语言，以下是我搜集整理的一些clips语言相关的优秀资源。在备忘之余希望能对其他人有所帮助。后续将不定期更新。

## 基本资源

* [新版官网](http://www.clipsrules.net/)
* [旧版官网](http://clipsrules.sourceforge.net/)：可能需要科学上网才能访问。
* [文档列表](http://www.clipsrules.net/?q=Documentation)：User’s Guide浅显易懂，非常值得一读，需要深入了解可以看看Basic Programming Guide与Advanced Programming Guide。
* [教材中文版](https://book.douban.com/subject/1879505/)：教材由clips开发者撰写，包括专家系统的基础知识与设计实现，以及具体的clips语言的语法与使用。[电子版下载地址](http://download.csdn.net/detail/heliuwei1991/9180309)
* [stackoverflow](http://stackoverflow.com/questions/tagged/clips)：clips开发者的有在stackoverflow回答问题。

## 函数库

* [日期处理](https://github.com/mattsmi/CLIPS_Date_Functions)

## 工具

* [Virtual Studio插件](https://github.com/ricksladkey/ClipsLanguage)：语法高亮等。

## .Net封装

clips适合嵌入到软件中执行规则推理，使用C#开发界面，则需要将clips封装到.Net。封装的思路主要为PInvoke或C++/CLI。

* [CLIPS .NET](http://www.clipsrules.net/?q=Downloads/CLIPSNET)：clips官方开发了一个.Net Wrapper，而且包含了Winform和WPF各四个示例，封装方法为C++/CLI，接口较少，不支持自定义函数。
* [CLIPSNet (SourceForge)](https://sourceforge.net/projects/clipsnet/)：使用PInvoke技术封装，使得风格不像面向对象语言，更新到2015年。
* [CLIPSNet (github)](https://github.com/yisha7/CLIPSNet)：我维护的一个.Net Wrapper，封装方法为C++/CLI，更新clips和.Net Framework到最新版，接口较多，支持自定义函数。
