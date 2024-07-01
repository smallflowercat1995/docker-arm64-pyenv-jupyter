#!/usr/bin/env bash
mkdir -pv package ; cd package
# 下载 alpine aarch64 openjdk 
wget -t 3 -T 5 --verbose --show-progress=on --progress=bar --no-check-certificate --hsts-file=/tmp/wget-hsts -c "https://github.com/adoptium/temurin22-binaries/releases/download/jdk-22.0.1%2B8/OpenJDK22U-jdk_aarch64_alpine-linux_hotspot_22.0.1_8.tar.gz" -O"OpenJDK-jdk_aarch64_alpine-linux_hotspot.tar.gz"

# 下载 jupyter 扩展 ijava 支持java语言环境
wget -t 3 -T 5 --verbose --show-progress=on --progress=bar --no-check-certificate --hsts-file=/tmp/wget-hsts -c "https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip" -O"ijava-1.3.0.zip"

rm -fv OpenJDK-jdk_aarch64_alpine-linux_hotspot.tar.gz.*

# 拆分大型压缩包使 github 可以存储 47MB
split -d -b 47m OpenJDK-jdk_aarch64_alpine-linux_hotspot.tar.gz OpenJDK-jdk_aarch64_alpine-linux_hotspot.tar.gz.

# 删除 OpenJDK-jdk_aarch64_alpine-linux_hotspot.tar.gz 
rm -fv OpenJDK-jdk_aarch64_alpine-linux_hotspot.tar.gz 

# 返回目录
cd -
