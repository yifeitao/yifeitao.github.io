---
layout: post
title: 一个office2016导致的“操作系统当前配置不能运行此程序”的错误
categories: life
---

最近新装了一台电脑windows 10后，还没装几个程序，但是老是在系统启动的时候弹出一个“操作系统当前配置不能运行此程序”的错误窗口，虽然关闭后也不影响使用，但是心里总觉得很难受。

首先看了一下任务管理器，发现是COM Surrogate 的进程错误，转到错误发生的程序，发现时SysWOW64中的dllhost，然后就找不到进一步的信息了

在网上查了很多资料也没个靠谱的说法，包括微软的官方论坛给出的都是类似系统重置类的大杀器。不过有个英文的帖子在针对类似问题的时候，提到了事件查看器，我都快忘了还有这个好东西。

打开事件查看器（不好找的话可以用caotana搜索），查看windows日志中的应用程序项，发现了更详细的错误信息：

```xml
- <Event xmlns="http://schemas.microsoft.com/win/2004/08/events/event">
- <System>
  <Provider Name="Application Error" /> 
  <EventID Qualifiers="0">1000</EventID> 
  <Level>2</Level> 
  <Task>100</Task> 
  <Keywords>0x80000000000000</Keywords> 
  <TimeCreated SystemTime="2017-03-18T11:57:47.860844200Z" /> 
  <EventRecordID>3278</EventRecordID> 
  <Channel>Application</Channel> 
  <Computer>DESKTOP-27TUG97</Computer> 
  <Security /> 
  </System>
- <EventData>
  <Data>DllHost.exe</Data> 
  <Data>10.0.14393.0</Data> 
  <Data>5789917a</Data> 
  <Data>OLMAPI32.DLL</Data> 
  <Data>16.0.4266.1003</Data> 
  <Data>55ceb06d</Data> 
  <Data>c0000005</Data> 
  <Data>00142f92</Data> 
  <Data>56c</Data> 
  <Data>01d29fded6a55333</Data> 
  <Data>C:\Windows\SysWOW64\DllHost.exe</Data> 
  <Data>C:\Program Files (x86)\Microsoft Office\Root\Office16\OLMAPI32.DLL</Data> 
  <Data>ff76f0a1-b49f-46da-999a-e97f06a639cf</Data> 
  <Data /> 
  <Data /> 
  </EventData>
  </Event>
```

原来是Office16的锅，然后也没再花时间研究具体的原因，把office2016修复了一下完事。

这个事情的启示是，作为一个程序员，不要忘了写错误日志，也不要忘了用错误日志。