---
title: "Linux常用命令"
date: 2021-12-04T22:09:45+08:00
lastmod: 2021-12-04T22:09:45+08:00
tags:
    - linux
categories:
    - linux
---

## 1. SSH

Ubuntu下安装SSH-server服务。

```shell
sudo apt-get install openssh-server
```

允许远程通过Root用户连接SSH。修改配置文件`/etc/ssh/sshd_config`中的`PermitRootLogin yes`。

## 2. 挂载硬盘

### 1. 在Ubuntu中挂载NTFS分区

```shell
fdisk -l
ntfsfix /dev/sdc1
```

修改配置文件/etc/fstab。在文件末尾添加行。

```
/dev/sdc1 /home/seekwind/data  ntfs-3g  rw  0  0
```

挂载磁盘。

```shell
mount -a
```