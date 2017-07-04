---
layout: post
title:  Ubuntu9.10 Firefox 使用Tor上网七步傻瓜配置
categories: geek
---
### S1：添加软件源

系统——系统管理——软件源——其他软件——添加

deb http://deb.torproject.org/torproject.org karmic main

### S2：注册软件源

终端运行

```bash
gpg --keyserver keys.gnupg.net --recv 886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -
```

### S3：安装软件

终端运行

```shell
apt-get update
apt-get install tor tor-geoipdb vidalia
```

或者用新立得安装tor tor-geoipdb vidalia

### S4：获取网桥

致信到bridges@torproject.org，强烈建议使用Gmail发信，信件标题为get bridges。

### S5：配置Vidalia

设定——网络——我的ISP阻挡了我对Tor网络的连接

将S4获取的地址添加上去

### S6：配置Firefox

安装插件FoxyProxy。

### S7：配置FoxyProxy

文件——Tor向导，一路Next即可。然后添加需要使用Tor访问的网址,如*.torproject.com/*，*.blogspot.com/*等等。

###  使用中的问题

1. 访问https://check.torproject.org/测试是否成功使用Tor网络。可能需要重启系统。
2. Viadalia对已经运行的Tor无法加载，只能是一起启动，否则会报错说端口被占用，这时候可以终端运行 sudo kill all tor 先结束Tor的运行，再启动Viadalia。
3. 软件运行都正常，但还是很难连上Tor网络，可能需要添加更多更新的网桥，可再次发信获取。