---
layout: post
title: 使用netlify改善github pages服务
categories: geek
---

一直很喜欢github pages，所以一直用着，但是有两个问题一直很难一起解决：

1. github因为某事件屏蔽了百度的爬虫，博客在百度上搜不到，通过在个人主机或coding pages建立镜像，然后用dnspod分流的方法可以解决；
2. github pages支持强制https，支持自定义域名，但还不支持自定义域名的强制https。可以用cloudfare的cdn服务解决。

但是上述两个问题很难同时解决，虽然我有个人主机，但是懒得用来托管博客。今天发现netlify服务解决了两个问题。基本步骤如下：

1. netlify在注册后，可以申请权限接通你的github pages的repo；
2. 然后简单配置一下部署命令，对jekyll来说，命令为`jekyll build`，生成的文件目录配置为`_site`
3. netlify可以修改子域名为`yoursite.netlify.com`，然后也可以配置自定义域名，将dns的CNAME记录指向`yoursite.netlify.com`即可。
4. 开启https服务（可以用自己的证书，也可以用netlify自带的Let's Encrypt证书），以及强制的https转换。
5. 以后，只要你向github提交更新，netlify就会通过钩子自动重新执行jekyll build命令部署站点。

测试了一下，国内访问会被cdn到日本节点，速度还算可以。

