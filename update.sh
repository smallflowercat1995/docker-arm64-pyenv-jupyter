#!/usr/bin/env bash
# 失效了？
# curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://github.com`curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k 'https://github.com/pyenv/pyenv/releases' | grep '.tar.gz' | sed 's;";  ;g' | awk '{print $3}' | head -n 1`" -o build-pyenv/package/pyenv.tar.gz -O
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://github.com`curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k 'https://github.com/pyenv/pyenv/releases' | sed 's;";\n;g;s;releases/tag;archive/refs/tags;g' | grep '/tags/' | head -n 1`.tar.gz" -o build-pyenv/package/pyenv.tar.gz -O

# 失效了？
# curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://github.com`curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k 'https://github.com/pyenv/pyenv-virtualenv/releases' | grep '.tar.gz' | sed 's;";  ;g' | awk '{print $3}' | head -n 1`" -o build-pyenv/package/pyenv-virtualenv.tar.gz -O
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://github.com`curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k 'https://github.com/pyenv/pyenv-virtualenv/releases' | sed 's;";\n;g;s;releases/tag;archive/refs/tags;g' | grep '/tags/' | head -n 1`.tar.gz" -o build-pyenv/package/pyenv-virtualenv.tar.gz -O

# 下载预编译 python 包
python_version=3.11.5
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://www.python.org/ftp/python/${python_version}/Python-${python_version}.tar.xz"  -o build-pyenv/package/Python-${python_version}.tar.xz -O

# 下载 aarch64 openjdk 
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.8%2B7/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.8_7.tar.gz" -o install-jupyter/package/OpenJDK-jdk_linux_hotspot.tar.gz -O

# 下载 jupyter 扩展 ijava 支持java语言环境
curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip" -o install-jupyter/package/ijava-1.3.0.zip -O

cd install-jupyter/package/
rm -fv OpenJDK-jdk_linux_hotspot.tar.gz.*

# 拆分大型压缩包使 github 可以存储 47MB
split -d -b 47m OpenJDK-jdk_linux_hotspot.tar.gz OpenJDK-jdk_linux_hotspot.tar.gz.

# 删除 OpenJDK-jdk_linux_hotspot.tar.gz 
rm -fv OpenJDK-jdk_linux_hotspot.tar.gz 

# 返回目录
cd -
