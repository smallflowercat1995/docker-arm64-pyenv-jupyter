# docker-arm64-debian-pyenv-jupyter
## dockerhub
第一部分镜像：<a href="https://hub.docker.com/r/smallflowercat1995/debian-pyenv" target="_blank">https://hub.docker.com/r/smallflowercat1995/debian-pyenv</a>  
最终镜像：<a href="https://hub.docker.com/r/smallflowercat1995/debian-jupyter" target="_blank">https://hub.docker.com/r/smallflowercat1995/debian-jupyter</a>  
[![GitHub Workflow update Status](https://github.com/smallflowercat1995/docker-arm64-pyenv-jupyter/actions/workflows/actions.yml/badge.svg)](https://github.com/smallflowercat1995/docker-arm64-pyenv-jupyter/actions/workflows/actions.yml)[![GitHub Workflow dockerbuild Status](https://github.com/smallflowercat1995/docker-arm64-pyenv-jupyter/actions/workflows/docker-image.yml/badge.svg)](https://github.com/smallflowercat1995/docker-arm64-pyenv-jupyter/actions/workflows/docker-image.yml)![Watchers](https://img.shields.io/github/watchers/smallflowercat1995/docker-arm64-pyenv-jupyter) ![Stars](https://img.shields.io/github/stars/smallflowercat1995/docker-arm64-pyenv-jupyter) ![Forks](https://img.shields.io/github/forks/smallflowercat1995/docker-arm64-pyenv-jupyter) ![Vistors](https://visitor-badge.laobi.icu/badge?page_id=smallflowercat1995.docker-arm64-pyenv-jupyter) ![LICENSE](https://img.shields.io/badge/license-CC%20BY--SA%204.0-green.svg)
<a href="https://star-history.com/#smallflowercat1995/docker-arm64-pyenv-jupyter&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=smallflowercat1995/docker-arm64-pyenv-jupyter&type=Date&theme=dark" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=smallflowercat1995/docker-arm64-pyenv-jupyter&type=Date" />
    <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=smallflowercat1995/docker-arm64-pyenv-jupyter&type=Date" />
  </picture>
</a>

## 描述
1.为了实现 actions workflow 自动化更新 pyenv 源码，需要添加 `GITHUB_TOKEN` 环境变量，这个是访问 GitHub API 的令牌，可以在 GitHub 主页，点击个人头像，Settings -> Developer settings -> Personal access tokens ，设置名字为 GITHUB_TOKEN 接着要勾选权限，勾选repo、admin:repo_hook和workflow即可，最后点击Generate token，如图所示  
![account_token](https://github.com/smallflowercat1995/docker-arm64-pyenv-jupyter/assets/144557489/dfd8ad11-234c-4222-8af3-7fa8daf7f5b3)

2.赋予 actions[bot] 读/写仓库权限 -> Settings -> Actions -> General -> Workflow Permissions -> Read and write permissions -> save，如图所示
![repository_authorized](https://github.com/smallflowercat1995/docker-arm64-pyenv-jupyter/assets/144557489/a07265e9-ebe7-4a9c-a38c-888aa1195d02)

3.添加 hub.docker.com 仓库账号 DOCKER_USERNAME 在 GitHub 仓库页 -> Settings -> Secrets -> actions -> New repository secret

4.添加 hub.docker.com 仓库密码 DOCKER_PASSWORD 在 GitHub 仓库页 -> Settings -> Secrets -> actions -> New repository secret

5.以上流程如图所示  
![266819718-68c2268d-739c-444a-b88a-b7bfff18f3c0](https://github.com/smallflowercat1995/docker-arm64-pyenv-jupyter/assets/144557489/9397d43a-ac26-4833-98a3-8034c9b0e706)


6.转到 Actions -> update pyenv and pyenv-virtualenv 并且启动 workflow，实现自动化  
7.这是包含了 pyenv 和 jupyter 两个部分的 docker 构建材料  
8.主要目的是为了使用 jupyter 本来没想这么复杂，我就是觉得 pyenv 好，为了自己的追求，只能辛苦一下  
9.这个应该是可以改成分段构建的项目，我觉得怕中间出错，不敢把他们写成分段式构建，以后有机会我在改  
10.以下是思路：    
  * 先构建 pyenv 配置最新的 python 环境并打包复制到 jupyter 环境目录，最后终止容器，实在太慢，我都哭了 >_<  
  * 然后在 jupyter 环境将 pyenv 包解压配置环境变量安装 jupyter 然后维持其运行，这样容器就不会自己停止   

11.目录结构：  

    .  
    ├── build-pyenv                                  # 这个是构建 pyenv 并将其打包到 jupyter 环境目录  
    │   ├── docker-compose.yml                       # 这个是构建 pyenv 的 docker-compose.yml 配置文件  
    │   ├── Dockerfile                               # 这个是构建 pyenv 的 docker 构建文件  
    │   └── package                                  # 这个是构建 pyenv 的脚本文件所在目录   
    │       ├── install.sh                           # 这个是构建 pyenv 镜像的时候在容器内执行流程的脚本    
    │       ├── pyenv.tar.gz                         # 这个是 pyenv 官方源码包  
    │       ├── pyenv-virtualenv.tar.gz              # 这个是 pyenv-virtualenv 官方源码包   
    │       └── run_build                            # 这个是构建 pyenv 完成时最终会执行的打包拷贝脚本  
    ├── install-jupyter
    │   ├── docker-compose.yml                       # 这个是构建 jupyter 的 docker-compose.yml 配置文件，默认端口 8888  
    │   ├── Dockerfile                               # 这个是构建 jupyter 的 docker 构建文件  
    │   └── package                                  # 这个是构建 jupyter 的脚本文件、pyenv包文件所在目录  
    │       ├── install.sh                           # 这个是构建 jupyter 镜像的时候在容器内执行流程的脚本，默认密码 123456  
    │       ├── OpenJDK-jdk_linux_hotspot.tar.gz.00  # 这个是构建 jupyter OpenJDK-jdk_linux_hotspot.tar.gz.00 拆分包  
    │       ├── OpenJDK-jdk_linux_hotspot.tar.gz.01  # 这个是构建 jupyter OpenJDK-jdk_linux_hotspot.tar.gz.01 拆分包  
    │       ├── OpenJDK-jdk_linux_hotspot.tar.gz.02  # 这个是构建 jupyter OpenJDK-jdk_linux_hotspot.tar.gz.02 拆分包  
    │       ├── OpenJDK-jdk_linux_hotspot.tar.gz.03  # 这个是构建 jupyter OpenJDK-jdk_linux_hotspot.tar.gz.03 拆分包  
    │       ├── OpenJDK-jdk_linux_hotspot.tar.gz.04  # 这个是构建 jupyter OpenJDK-jdk_linux_hotspot.tar.gz.04 拆分包
    │       ├── ijava-1.3.0.zip                      # 这个是构建 jupyter ijava-1.3.0.zip java支持扩展包  
    │       └── run_jupyter                          # 这个是启动 jupyter 的脚本    
    └── update.sh                                    # 这个是 actions 所需要的自动更新 pyenv pyenv-virtualenv openjdk 和 python预编译包 脚本  

## 依赖
    arm64 设备
    docker 程序
    docker-compose python程序
    我目前能想到的必要程序就这些吧

## 构建命令
### 部分一：编译 pyenv 环境并打包到 docker-arm64-debian-pyenv-jupyter/install-jupyter/package 中
    # clone 项目
    git clone https://github.com/smallflowercat1995/docker-arm64-pyenv-jupyter.git
    # 进入目录
    cd docker-arm64-pyenv-jupyter/build-pyenv
    # 无缓存构建
    docker-compose build --no-cache
    # 构建完成后 后台启动 等待 pyenv 环境编译打包，之后这个容器会终止
    # 此后每次重新执行第一部分容器都会重新编译拿出压缩包
    docker-compose up -d --force-recreate
    # 也可以查看日志看看有没有问题 ,如果失败了就再重新尝试看看只要最后不报错就好。  
    docker-compose logs -f
### 部分二：编译 jupyter 环境
    # 进入目录
    cd ../install-jupyter/
    # 无缓存构建
    docker-compose build --no-cache
    # 构建完成后 后台启动
    docker-compose up -d --force-recreate
    # 也可以查看日志看看有没有失败 
    docker-compose logs -f

## 默认密码以及修改
    # 别担心我料到这一点了，毕竟我自己还要用呢
    # 首先访问 http://[主机IP]:8888 输入默认密码 123456
    # 然后如图打开终端 在终端内执行密码修改指令 需输入两次 密码不会显示属于正常现象 密码配置文件会保存到容器内的 $HOME/.jupyter/jupyter_server_config.json 
    jupyter-lab password
   ![dapj0](https://github.com/smallflowercat1995/docker-arm64-pyenv-jupyter/assets/144557489/672b5a13-6303-4503-be19-c9118d3f345c)
   ![dapj1](https://github.com/smallflowercat1995/docker-arm64-pyenv-jupyter/assets/144557489/802b1f24-db3d-4fb9-bc0c-9b3005b17353)

## 修改新增
    # 将在线克隆的方式注释了，太卡了，卡哭我了，哭了一晚上 >_< 呜呜呜
    # actions 自动获取 pyenv pyenv-virtualenv openjdk 和 python预编译包
    # update.sh 脚本拆分 openjdk 包
    # 已经将树莓派4B卖了，性能还是不够用
    # 可是项目不管也不行，索性用 github 自带 action 构建镜像提交到 hub.docker.com 仓库即时更新镜像
    # 切换离线安装为在线更新最新版 python 源码
    # 一些孩子总问我如何配置，我是不胜其扰啊，所以附上图片，你们老哥我年纪已经很大了求放过，呜呜呜，修改了描述文件，提供详细的描述，方便他人，呜呜，我真善良

# 声明
本项目仅作学习交流使用，用于查找资料，学习知识，不做任何违法行为。所有资源均来自互联网，仅供大家交流学习使用，出现违法问题概不负责。

## 感谢
jupyter 官网：https://jupyter.org/install    
大佬 pyenv：https://github.com/pyenv

## 参考
install jupyter-lab：https://jupyterlab.readthedocs.io/en/latest/getting_started/installation.html  
Common Extension Points：https://jupyterlab.readthedocs.io/en/latest/extension/extension_points.html   
pyenv：https://github.com/pyenv/pyenv  
virtualenv：https://github.com/pyenv/pyenv-virtualenv  
pyenv离线安装Python：https://blog.csdn.net/jorg_zhao/article/details/79493519
