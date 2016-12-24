---
layout: post
title:  Google加密搜索、DNS污染和hosts文件
date:   2010-11-21 21:16:48 +0800
categories: geek
---
阅读提示：这是一篇简单粗暴的科普文章，不涉及技术细节，更不涉及非技术细节。

## 1GoogleSSL加密搜索

所谓加密，即使用比一般的http协议更安全的https协议，我们知道由于存在关键词过滤，在Google撤退到香港后，搜索类似“温度”和“胡萝卜”等词语时会被重置链接，而使用https协议的SSL加密搜索则不存在这个问题。

GoogleSSL搜索的官方地址是[https://www.google.com/](https://www.google.com/)， 你使用这个地址搜索，会跳转到专用域名[https://encrypted.google.com/](https://encrypted.google.com/)， 然后你会发现它无法访问，这是一个典型的被DNS污染的地址，有耐心有好奇心的请往下看。

## 2什么是DNS？

以Windows 操作系统为例，打开连接属性中的Internet协议（就是你配置ip地址的地方），可以看到设置DNS服务器地址的选项。

DNS是域名系统(Domain Name System)的缩写。可以简单粗暴的做如下理解：我们用户上网站需要访问诸如www.google.com 的域名（网址），而对于计算机网络而言，传递数据则需要知道IP地址，而DNS正是解决域名和IP对应关系的，通过DNS服务器，我们对域名的访问被翻译成对IP地址的访问。

现在你可以做一个小实验，在运行中（win+R）输入cmd启动命令行，再输入`ping www.google.cn`，可以看到类似如下的结果。

```
C:\Users\Fidel>ping www.google.cn

正在 Ping www.google.cn [203.208.39.212] 具有 32 字节的数据:
来自 203.208.39.212 的回复: 字节=32 时间=148ms TTL=54
来自 203.208.39.212 的回复: 字节=32 时间=148ms TTL=54
来自 203.208.39.212 的回复: 字节=32 时间=157ms TTL=54
来自 203.208.39.212 的回复: 字节=32 时间=158ms TTL=54

203.208.39.212 的 Ping 统计信息:
    数据包: 已发送 = 4，已接收 = 4，丢失 = 0 (0% 丢失)，
往返行程的估计时间(以毫秒为单位):
    最短 = 148ms，最长 = 158ms，平均 = 152ms
```

我们得到了一个来自ip地址的回复，计算机网络正是通过DNS服务器知道访问www.google.cn 需要到这个ip地址的。

实际上，DNS是一个有些复杂的层次系统，但我们简单理解为一个将域名翻译成IP地址的服务器即可。

## 3什么是DNS污染？

依然简单粗暴的理解：就是有人通过种种手段使得DNS服务器把域名翻译成错误的IP地址。现在再做一个小实验，ping encrypted.google.com，你会得到一个无法连通的IP。
```
C:\Users\Fidel>ping encrypted.google.com

正在 Ping encrypted.google.com [203.98.7.65] 具有 32 字节的数据:
请求超时。
请求超时。
请求超时。
请求超时。

203.98.7.65 的 Ping 统计信息:
    数据包: 已发送 = 4，已接收 = 0，丢失 = 4 (100% 丢失)，
```

它的真实IP地址其实不是你得到的IP，DNS服务器欺骗了你，导致你用浏览器访问[https://encrypted.google.com/](https://encrypted.google.com/) 会走入死胡同。

## 4 hosts文件

首先我们要找到hosts文件，在windows系统里，它的位置通常在`C:\Windows\System32\drivers\etc`

你可以用记事本等文本编辑器打开这个文件（如果你想修改这个文件，在win7中注意用管理员权限运行记事本）。

你会看到类似如下的条目
```
127.0.0.1 localhost
#0.0.0.0 www.baidu.com
```
其中以#开头的是注释，不会起作用。

简单粗暴的理解，hosts文件是你自己电脑上的DNS服务器，可以把域名翻译成IP地址。因此，在浏览器中，访问127.0.0.1和访问localhost是等价的。而且这个DNS服务器是**最优先查找**的。

现在如果我们知道了被DNS污染的网站的可以访问的真正的IP，在hosts文件中加上一条即可。（即上述条目的第三条）

`173.194.33.100 encrypted.google.com`

这时候再pingencrypted.google.com，会去访问`173.194.33.100。（不保证此ip您能访问）

如果你看哪个网站不爽，以后死也不用，可以加上类似这样一条。（即去掉上述条目第二条的#号）
`0.0.0.0 www.baidu.com`

## 5 获知网站的可访问真实IP

除了DNS污染外，网站往往还会被IP定点封锁。虽然很多大型网站如twitter都有诸多对应的IP地址，但是可能被封锁到一个不剩，所以**并不是每个网站都可以获得可访问的真实IP**。

但依然有些被DNS污染的网站还存有可访问的真实IP，比如encrypted.google.com。

通常有两种办法找IP，第一种就是搜索“encrypted.google.com可访问IP”，总会有热心人在网上告知大家的，但往往并不保证时效性。

第二种是使用专业的查询服务获取域名的多个IP，如使用[http://just-ping.com/](http://just-ping.com/) 查询encrypted.google.com会得到一系列的对应ip地址，我们再使用本机的ping命令实验哪个ip能通即可。（有可能都不能用哦）

## 6总结

hosts文件是本机的DNS服务器，通过修改hosts文件可以解决DNS污染问题，但前提是你获取到了被污染域名的可访问IP。
