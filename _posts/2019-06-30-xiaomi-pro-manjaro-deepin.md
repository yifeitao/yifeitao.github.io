---
layout: post
title:  小米笔记本Pro Manjaro Deepin 配置备忘
categories: coding
tag: [geek, linux]
---

虽然Windows10 有了WSL，用作开发的易用性提高了许多，但是偶尔还是有需要Linux系统的时候，所以需要装双系统，小米笔记本Pro支持扩展**M2 SATA接口**固态硬盘，在这块硬盘划出128G用于Linux系统即可。选择Manjaro系统搭配 Deepin 桌面这样的组合，是综合考虑了Manjaro 的驱动友好，软件及其丰富，以及Deepin 桌面的美观与对中文的开箱即用的良好支持。

当前版本：Manjaro Deepin 18.02

## 0x00 准备工作

* 系统镜像[下载地址](https://manjaro.org/download/deepin/)
* 使用rufus软件将系统镜像刻录到U盘，建议选择DD写入模式
* 关闭小米笔记本Pro BIOS的安全启动 [可参考](https://jingyan.baidu.com/article/77b8dc7fa8b3c06175eab66d.html)

## 0x01 安装

使用U盘启动系统后，使用Live镜像的安装指引程序安装系统。

启动时选择第二项boot（non-free),Manjaro自带的驱动精灵会帮你安装好所需驱动，笔记本双显卡则会帮你安装bumblebee。

注意为了和Windows10和平共处，需要使用自定义分区方案：

* win10系统的硬盘内有个efi的分区（格式为FAT32，一般大小为100M），需要指定为/boot/efi分区，注意选择保留不要格式化
* 新划出的128G系统挂载 / 分区，如果需要休眠到硬盘，最好建立swap分区，一般大小和内存大小一致即可。

注意当前版本可能会遇到一个问题，第一次连接Wifi网络总是报告密码错误，需要用终端使用命令行连接Wifi，安装时操作一次后，使用中再没遇到过这个问题。

```shell
sudo nmcli device wifi connect SSID-NAME password SSID-PASSWORD
```

## 0x02 安装后基本配置

### 1 笔记本双显卡设置

查看显卡NVIDIA状态

```shell
lspci| grep -i vga
```

测试 Bumblebee 是否工作：

```
optirun glxgears -info
```

如果需要不依赖Bumblebee来使用CUDA, 为开启NVIDIA显卡，运行:

```
sudo tee /proc/acpi/bbswitch <<< ON
```

### 2.时间和日期

如果安装的是双系统，注意Manjaro Setting Manager > Time and Date勾选以下选项
--set time and date automatically
--hardware clock in local time zone

### 3 源镜像与系统更新

* 排列源

```
sudo  pacman-mirrors -i -c China -m rank  
```

\#增加archlinuxcn库和antergos库

```
echo -e "\n[archlinuxcn]\nSigLevel = TrustAll\nServer = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch\n\n[antergos]\nSigLevel = TrustAll\nServer = https://mirrors.tuna.tsinghua.edu.cn/antergos/\$repo/\$arch\n"|sudo tee -a /etc/pacman.conf
```

* 升级系统：

```
sudo pacman -Syyu
```

* 安装archlinuxcn签名钥匙&antergos签名钥匙

```
sudo pacman -S --noconfirm archlinuxcn-keyring antergos-keyring
```

* 软件管理界面开启AUR支持。
* 安装增强的命令行软件管理工具yay

```
sudo pacman -S yay
```

### 4 安装中文字体和输入法

* 安装中文字体
```
sudo pacman -S --noconfirm wqy-microhei wqy-microhei-lite wqy-bitmapfont wqy-zenhei adobe-source-han-sans-cn-fonts adobe-source-han-serif-cn-fonts noto-fonts-cjk && fc-cache -fv
```

* 安装谷歌输入法

```
sudo pacman -S --noconfirm fcitx-im fcitx-configtool fcitx-googlepinyin 
```

* 配置fcitx， 配置完需要重启

```
sudo echo -e "export GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\nexport XMODIFIERS=@im=fcitx">>~/.xprofile
```

### 5  Windows硬盘挂载

/etc/fatab 新增

```
/dev/nvme0n1p3 /mnt/c ntfs defaults 0 2
/dev/sda1 /mnt/d ntfs defaults 0 2
```

### 6 VPN 和 SSH

* 导入OpenVPN配置

```
sudo nmcli connection import type openvpn file xxx.ovpn
```

* 恢复备份的ssh配置

```
cp -r path/to/bak/.ssh ~/.ssh
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa 
```

## 0x03 软件备忘

使用pacman或yay安装

* chrome
* intellij-idea-ultimate-edition
* deepin-wine, deepin-wxwork（需要导入如下字体映射配置）

```
vim zh-font.reg 
```

```
REGEDIT4
 
[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink]
"Lucida Sans Unicode"="wqy-microhei.ttc"
"Microsoft Sans Serif"="wqy-microhei.ttc"
"MS Sans Serif"="wqy-microhei.ttc"
"Tahoma"="wqy-microhei.ttc"
"Tahoma Bold"="wqy-microhei.ttc"
"SimSun"="wqy-microhei.ttc"
"Arial"="wqy-microhei.ttc"
"Arial Black"="wqy-microhei.ttc"
```

```
deepin-wine regedit zh-font.reg 
```

* easystroke
* variety
* nextcloud
* git-cola
* postman-bin
* xmind （removed "--add-modules=java.se.ee" in /usr/share/xmind/XMind/XMind.ini ）
* python-tensorflow-opt-cuda  python-pytorch-cuda 
* nvidia-docker
* ipython jupyter 
* youdao-dict  deepin-wine-thunderspeed 
* netease-cloud-music
* tusk
* typora
* visual-studio-code-bin
* wps-office
* dbeaver-ce
* foxitreader