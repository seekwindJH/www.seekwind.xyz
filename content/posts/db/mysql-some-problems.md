---
title: "Mysql Some Problems"
date: 2022-01-11T20:26:07+08:00
draft: false
---

本文介绍MySQL5.7在Linux上部署时会遇到的坑。

<!--more-->

### 1. 下载MySQL5.7 Linux Genic安装包

```shell
wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.36-linux-glibc2.12-x86_64.tar.gz
```

### 2. 缺失的MySQL依赖函数库

在Ubuntu20中，可能会遇到缺失so文件的情况，只需运行一下命令来安装缺失的so文件。

```shell
apt install libncurses*
```

### 3. 设置时区

设置正确的时区，才能确保MySQL日志等的自动生成时间是正确的。

```shell
tzselect
cp /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
```

最后确认时区是否已经调整完毕。

```shell
time -R
```

### 4. 首次启动MySQL需要增加init选项

初始化数据库，MySQL会自动创建一系列默认数据库与默认文件。这些数据库与文件是MySQL正确运行所必须的。

```shell
mysqld --initialize-insecure --user=root
```

以后台方式启动MySQL。

```shell
nohup mysqld -u root & > /dev/null
```


### 5. 修改root用户密码并设置远程登录权限

首次登录MySQL，在没有修改配置文件的情况下，在Linux中保持root身份，即可免密码登录MySQL的root用户。

```shell
mysql -uroot
```

```sql
use mysql;
update mysql.user set authentication_string=password('your_password') where user='root';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'your_password';
flush privileges;
```