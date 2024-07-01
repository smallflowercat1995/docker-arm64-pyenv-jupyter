# docker-arm64-debian-pyenv-jupyter
## dockerhub
镜像仓库链接：[https://hub.docker.com/r/smallflowercat1995/alpine-pyenv-jupyter](https://hub.docker.com/r/smallflowercat1995/alpine-pyenv-jupyter)  
[![GitHub Workflow update Status](https://github.com/smallflowercat1995/docker-arm64-pyenv-jupyter/actions/workflows/actions.yml/badge.svg)](https://github.com/smallflowercat1995/docker-arm64-pyenv-jupyter/actions/workflows/actions.yml)[![GitHub Workflow dockerbuild Status](https://github.com/smallflowercat1995/docker-arm64-pyenv-jupyter/actions/workflows/docker-image.yml/badge.svg)](https://github.com/smallflowercat1995/docker-arm64-pyenv-jupyter/actions/workflows/docker-image.yml)![Watchers](https://img.shields.io/github/watchers/smallflowercat1995/docker-arm64-pyenv-jupyter) ![Stars](https://img.shields.io/github/stars/smallflowercat1995/docker-arm64-pyenv-jupyter) ![Forks](https://img.shields.io/github/forks/smallflowercat1995/docker-arm64-pyenv-jupyter) ![Vistors](https://visitor-badge.laobi.icu/badge?page_id=smallflowercat1995.docker-arm64-pyenv-jupyter) ![LICENSE](https://img.shields.io/badge/license-CC%20BY--SA%204.0-green.svg)
<a href="https://star-history.com/#smallflowercat1995/docker-arm64-pyenv-jupyter&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=smallflowercat1995/docker-arm64-pyenv-jupyter&type=Date&theme=dark" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=smallflowercat1995/docker-arm64-pyenv-jupyter&type=Date" />
    <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=smallflowercat1995/docker-arm64-pyenv-jupyter&type=Date" />
  </picture>
</a>

## 描述
1.为了实现 actions workflow 自动化更新 ijava 和 OpenJDk ，需要添加 `GITHUB_TOKEN` 环境变量，这个是访问 GitHub API 的令牌，可以在 GitHub 主页，点击个人头像，Settings -> Developer settings -> Personal access tokens ，设置名字为 GITHUB_TOKEN 接着要勾选权限，勾选repo、admin:repo_hook和workflow即可，最后点击Generate token，如图所示  
![account_token](https://github.com/smallflowercat1995/docker-arm64-pyenv-jupyter/assets/144557489/dfd8ad11-234c-4222-8af3-7fa8daf7f5b3)  
2.赋予 actions[bot] 读/写仓库权限 -> Settings -> Actions -> General -> Workflow Permissions -> Read and write permissions -> save，如图所示  
![repository_authorized](https://github.com/smallflowercat1995/docker-arm64-pyenv-jupyter/assets/144557489/a07265e9-ebe7-4a9c-a38c-888aa1195d02)   
3.添加 hub.docker.com 仓库账号 DOCKER_USERNAME 在 GitHub 仓库页 -> Settings -> Secrets -> actions -> New repository secret   
4.添加 hub.docker.com 仓库密码 DOCKER_PASSWORD 在 GitHub 仓库页 -> Settings -> Secrets -> actions -> New repository secret  
5.以上流程如图所示  
![266819718-68c2268d-739c-444a-b88a-b7bfff18f3c0](https://github.com/smallflowercat1995/docker-arm64-pyenv-jupyter/assets/144557489/9397d43a-ac26-4833-98a3-8034c9b0e706)  
6.转到 Actions  

    -> update ijava and OpenJDK 并且启动 workflow，实现自动化下载 ijava 和 OpenJDK文件   
    -> Clean Git Large Files 并且启动 workflow，实现自动化清理 .git 目录大文件记录  
    -> Docker Image CI 并且启动 workflow，实现自动化构建镜像并推送云端  
    -> Remove Old Workflow Runs 并且启动 workflow，实现自动化清理 workflow 并保留最后三个  
    
7.这是包含了 pyenv 和 jupyter 的 docker 构建材料  
8.主要目的是为了使用 jupyter 本来没想这么复杂，我就是觉得 pyenv 好，为了自己的追求，只能辛苦一下  
9.以下是思路：    
  * 先构建 pyenv 配置最新的 python 环境并安装 jupyter 然后维持其运行，这样容器就不会自己停止，实在太慢，我都哭了 >_<  

10.目录结构：  

      .                                                       
      ├── Dockerfile                                         # 这个是 构建 pyenv+jupyter 的 Dockerfile 配置文件  
      ├── README.md                                          # 这个是 描述 文件  
      ├── docker-compose.yml                                 # # 这个是构建 pyenv+jupyter 的 docker-compose.yml 配置文件  
      ├── package                                            # 这个是构建 pyenv+jupyter 的脚本文件材料所在目录   
      │   ├── OpenJDK-jdk_alpine-linux_hotspot.tar.gz.00     # 这个是构建依赖 OpenJDK-jdk_alpine-linux_hotspot.tar.gz.00 拆分包      
      │   ├── OpenJDK-jdk_alpine-linux_hotspot.tar.gz.01     # 这个是构建依赖 OpenJDK-jdk_alpine-linux_hotspot.tar.gz.01 拆分包  
      │   ├── OpenJDK-jdk_alpine-linux_hotspot.tar.gz.02     # 这个是构建依赖 OpenJDK-jdk_alpine-linux_hotspot.tar.gz.02 拆分包  
      │   ├── OpenJDK-jdk_alpine-linux_hotspot.tar.gz.03     # 这个是构建依赖 OpenJDK-jdk_alpine-linux_hotspot.tar.gz.03 拆分包  
      │   ├── OpenJDK-jdk_alpine-linux_hotspot.tar.gz.04     # 这个是构建依赖 OpenJDK-jdk_alpine-linux_hotspot.tar.gz.04 拆分包  
      │   ├── ijava-1.3.0.zip                                # 这个是支持 java环境的内核文件  
      │   ├── init.sh                                        # 这个是初始化 bash shell 环境脚本文件  
      │   ├── install.sh                                     # 这个是构建 pyenv+jupyter 镜像的时候在容器内执行流程的脚本   
      │   ├── requirements.txt                               # 这个是 python 安装依赖库文件  
      │   └── run_jupyter                                    # 这个是启动 jupyter 的脚本无密码环境，第一次执行初始密码123456    
      └── update.sh                                          # 这个是 actions 所需要的自动更新 openjdk 和 ijava 脚本  

## 构建命令
### 编译 pyenv 环境并打包到 docker-arm64-debian-pyenv-jupyter/install-jupyter/package 中
    # clone 项目
    git clone https://github.com/smallflowercat1995/docker-arm64-pyenv-jupyter.git
    
    # 进入目录
    cd docker-arm64-pyenv-jupyter/
    
    # 无缓存构建
    docker build --no-cache --platform "linux/arm64/v8" -f Dockerfile -t smallflowercat1995/alpine-pyenv-jupyter:arm64v8 . ; docker builder prune -fa ; docker rmi $(docker images -qaf dangling=true)  
    # 或者这么构建也可以二选一
    docker-compose build --no-cache ; docker builder prune -fa ; docker rmi $(docker images -qaf dangling=true)
    
    # 构建完成后修改 docker-compose.yml 后启动享用，默认密码 123456
    # 初始密码修改环境变量字段 PASSWORD 详细请看 docker-compose.yml
    # 端口默认 8888
    docker-compose up -d --force-recreate
    
    # 也可以查看日志看看有没有问题 ,如果失败了就再重新尝试看看只要最后不报错就好   
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
    # actions 自动获取 openjdk 和 ijava 内核文件
    # update.sh 脚本拆分 openjdk 包
    # 已经将树莓派4B卖了，性能还是不够用
    # 可是项目不管也不行，索性用 github 自带 action 构建镜像提交到 hub.docker.com 仓库即时更新镜像

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
