---
layout: post
title: bandwagonhost安装
categories: geek
comments: true
---

bandwagonhost是一个比较廉价的VPS服务商，目前最便宜的大约$20每年。它支持支付宝付款，具体购买过程再次不再赘述。

访问地址 https://bandwagonhost.com/

备用地址 https://bwh1.net/

购买完毕后 进入 Client Area > My Products & Services，可以看到购买的主机，可以看到ip地址，通过kiwivm control panel可以进行一些基本的操作。

通过install new os可以安装新的操作系统，这里建议安装debian-8.0-x86_64。

安装完成后，会生成root账号的密码，以及ssh登陆的端口号，需要记下来。

一般vps主机的管理需要shell工具，windows 系统下推荐 [xshell](https://www.netsarang.com/products/xsh_overview.html)。

还需要sftp工具，可以使用[filezilla](https://filezilla-project.org/download.php)。

它们的配置需要ip地址，用户名root，以及密码和端口号。

xshell登陆远程主机后。开始安装科学上网相关服务。

## 1 V2Ray的安装

为什么推荐[V2Ray](https://www.v2ray.com/)，可以把它理解为ShadowSocket的升级版，它兼容ShadowSocket协议，而且支持更加先进的其他协议。

首先升级系统，安装curl工具。

```shell
apt-get update
apt-get upgrade
apt-get install curl
```

V2Ray官方有一键安装脚本，相当省心。

```shell
bash <(curl -L -s https://install.direct/go.sh)
```

此脚本会自动安装以下文件：

- `/usr/bin/v2ray/v2ray`：V2Ray 程序；
- `/etc/v2ray/config.json`：配置文件；

此外，还会增加启动项服务：

- `/lib/systemd/system/v2ray.service`

我们需要修改的就是config.json配置文件，其实它的默认配置就能用了，但是我们这里加上shadowsocket服务。

文件怎么修改呢？可以使用nano或vim远程修改，如果不习惯远程修改，也可以用filezilla下载后本地修改完再上传。

下面是照抄官网的一个配置：

```json
{
  "log" : {
    "access": "/var/log/v2ray/access.log", // 访问日志文件
    "error": "/var/log/v2ray/error.log",   // 错误日志文件
    "loglevel": "warning"                  // 错误日志等级，可选 debug / info / warning / error
  },
  "inbound": {
    "port": 37192, // 主端口
    "protocol": "vmess",    // 主传入协议，参见协议列表
    "settings": {
      "clients": [
        {
          "id": "3b129dec-72a3-4d28-aeee-028a0fe86e22",  // 用户 ID，客户端须使用相同的 ID 才可以中转流量
          "level": 1  // 用户等级，自用 VPS 可设为 1；共享 VPS 请设为 0。
        }
      ]
    }
  },
  "outbound": {
    "protocol": "freedom",  // 主传出协议，参见协议列表
    "settings": {}
  },
  "inboundDetour": [
    {
      "protocol": "shadowsocks",   // 开启 Shadowsocks
      "port": 30001, // 监听 30001 端口
      "settings": {
        "method": "aes-256-cfb", // 加密方式，支持 aes-256-cfb 和 aes-128-cfb
        "password": "v2ray",     // 密码，必须和客户端相同
        "udp": false             // 是否开启 UDP 转发
      }
    },
    {
      "protocol": "shadowsocks",   // 开启 Shadowsocks
      "port": 30002, // 监听 30002 端口，由于 Shadowsocks 的限制，多用户的时候只能开多个端口
      "settings": {  // 配置和上述类似
        "method": "aes-256-cfb",
        "password": "v2ray-2",
        "udp": false
      }
    }
  ],
  "outboundDetour": [
    {
      "protocol": "blackhole",  // 额外的传出协议，参见协议列表
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "strategy": "rules",
    "settings": {
      "rules": [
        {
          "type": "field",  // 路由设置，默认将屏蔽所有局域网流量，以提升安全性。
          "ip": [
            "0.0.0.0/8",
            "10.0.0.0/8",
            "100.64.0.0/10",
            "127.0.0.0/8",
            "169.254.0.0/16",
            "172.16.0.0/12",
            "192.0.0.0/24",
            "192.0.2.0/24",
            "192.168.0.0/16",
            "198.18.0.0/15",
            "198.51.100.0/24",
            "203.0.113.0/24",
            "::1/128",
            "fc00::/7",
            "fe80::/10"
          ],
          "outboundTag": "blocked"
        }
      ]
    }
  }
}
```

具体可以参考官网的解释，这里要提醒的是，注意**json格式的配置文件是不支持注释的**，所以一定要删掉注释，shadowsocket如果只配置一个端口，注意删掉第二个的同时也删掉中间那个逗号。

修改完毕后重启服务。

```shell
service v2ray restart
```

以上服务端就搞定了，首先依然可以使用一般的shadowsocket客户端连接shadowsocket协议。

此外，当然还支持V2Ray的协议，安装包地址 https://github.com/v2ray/v2ray-core/releases

以windows为例，客户端就是一个绿色软件，命令行工具，同样需要修改配置文件config.json，以下为一个样例配置：

```json
{
  "log": {
    "loglevel": "warning"
  },
  "inbound": {
    "port": 1080, //本地代理端口
    "listen": "127.0.0.1",
    "protocol": "socks",
    "settings": {
      "auth": "noauth",
      "udp": false,
      "ip": "127.0.0.1"
    }
  },
  "outbound": {
    "protocol": "vmess",
    "settings": {
      "vnext": [
        {
          "address": "your-ip", // 服务器ip
          "port": your-port, //和服务器配置一致
          "users": [
            {
              "id": "your-id", //和服务器配置一致
              "alterId": 64, //和服务器配置一致
              "security": "auto"
            }
          ]
        }
      ]
    },
    "mux": {
      "enabled": true
    }
  },
  "outboundDetour": [
    {
      "protocol": "freedom",
      "settings": {},
      "tag": "direct"
    }
  ],
  "dns": {
    "servers": [
      "8.8.8.8",
      "8.8.4.4",
      "localhost"
    ]
  },
  "routing": {
    "strategy": "rules",
    "settings": {
      "domainStrategy": "IPIfNonMatch",
      "rules": [
        {
          "type": "field",
          "port": "1-52",
          "outboundTag": "direct"
        },
        {
          "type": "field",
          "port": "54-79",
          "outboundTag": "direct"
        },
        {
          "type": "field",
          "port": "81-442",
          "outboundTag": "direct"
        },
        {
          "type": "field",
          "port": "444-65535",
          "outboundTag": "direct"
        },
        {
          "type": "chinasites",
          "outboundTag": "direct"
        },
        {
          "type": "field",
          "ip": [
            "0.0.0.0/8",
            "10.0.0.0/8",
            "100.64.0.0/10",
            "127.0.0.0/8",
            "169.254.0.0/16",
            "172.16.0.0/12",
            "192.0.0.0/24",
            "192.0.2.0/24",
            "192.168.0.0/16",
            "198.18.0.0/15",
            "198.51.100.0/24",
            "203.0.113.0/24",
            "::1/128",
            "fc00::/7",
            "fe80::/10"
          ],
          "outboundTag": "direct"
        },
        {
          "type": "chinaip",
          "outboundTag": "direct"
        }
      ]
    }
  }
}

```

同样注意json不支持注释。

启动v2ray.exe，代理 127.0.0.1:1080就开始工作了，配置你的浏览器使用socket5协议代理，地址配置为127.0.0.1:1080就可以开始科学上网了。

iOS客户端推荐。

* [Shadowing](**https://itunes.apple.com/cn/app/shadowing/id1194879940?mt=8**): 售价￥6，支持shadowsocket协议。
* [Shadowrocket](https://itunes.apple.com/cn/app/shadowrocket/id932747118?mt=8): 售价￥18，支持shadowsocket协议和V2Ray的新协议。

## 2 OpenConnect server的安装

这是少数还比较好用的VPN方案了，可以使用Cisco的anyconnect作为客户端，各个平台都有。

OpenConnect server安装一直比较麻烦，不过也有人开发了一键安装脚本，经实测bandwagonhost下debian8.0系统相当适合。

[作者的教程](https://www.fanyueciyuan.info/fq/ocserv-debian.html)

[脚本地址](https://github.com/fanyueciyuan/eazy-for-ss/tree/master/ocservauto)

具体安装时，使用如下命令

```shell
apt-get install wget
wget http://git.io/p9r8 --no-check-certificate -O ocservauto.sh
bash ocservauto.sh
```

如果个人使用，简单点使用用户名密码登陆，整个安装过程只需要输入你想要设定的用户名密码即可。

windows客户端官网下载比较麻烦，这里给出一个下载地址 http://ftp.spbexchange.ru/net/vpn/

客户端的配置相当简单，注意ip地址后要加端口号，然后在警告时信任你自己的服务器。