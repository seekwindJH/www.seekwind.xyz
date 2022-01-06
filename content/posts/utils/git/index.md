---
title: "Git基本命令使用方法"
date: 2022-01-03T21:28:35+08:00
draft: false
---

<!--more-->

* 查看Git配置信息。

```shell
git config -l # 查看全部配置信息
git config http.proxy # 查看某个配置信息
git config --replace-all http.proxy http://127.0.0.1:10809 # 修改配置信息
```

* 本地初始化一个Git项目或者从远程仓库下载一个Git项目。

```shell
git init # 初始化当前文件夹为一个Git项目
git clone url [to_path] # 从远程仓库下载G一个it项目
```

* 查看当前Git项目的状态。

```shell
git status [filename] # 也可以不追加文件名
```

* 添加所有文件到暂存区。

```shell
git add .
```

* 提交暂存区中的内容到本地仓库。

```shell
git commit -m "message"
```

有时候，我们不希望让某些文件纳入版本控制，则需要在项目根目录下创建`.gitignore`文件。

```
.hugo_build.lock
.vscode
.idea
.vscode/
.idea/
```

* 将项目提交到远程仓库。

```shell
git push [url]
```

当我们第一次提交项目时，需要在远程仓库(例如github、gitee)创建新项目，然后将项目clone到本地，最后将clone得到的所有东西复制进我们的项目目录。最后，我们的项目就可以`git push`到新创建的远程仓库项目了。

有关Git的更多内容，详见[Gitee All-about-git](https://gitee.com/all-about-git)