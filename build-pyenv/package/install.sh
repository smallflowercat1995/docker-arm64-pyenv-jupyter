#!/bin/bash

# 打印检查环境是否导入
export DEBIAN_FRONTEND=noninteractive

echo -e "$DEBIAN_FRONTEND"

mkdir_update_install(){
mkdir -pv $HOME/.pyenv
cp -rv /root/run_build /usr/bin/
chmod -v u+x /usr/bin/run_build

# 改时区
date '+%Y-%m-%d %H:%M:%S'
# cp -rv /etc/localtime /etc/localtime.bak.`date '+%Y-%m-%d_%H-%M-%S'`
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "Asia/Shanghai" > /etc/timezone
date '+%Y-%m-%d %H:%M:%S'

# for i in $(seq -w 3) ; do
# 	echo "try $i"
# 	# 更新软件列表源
# 	apt-get update
# 	# 防止遇到无法拉取 https 源的情况，先使用 http 源并安装
# 	apt-get -y install apt-transport-https ca-certificates apt-utils
# done

# 备份源
# cp -rv /etc/apt/sources.list /etc/apt/sources.list.backup

# 写入清华源
# cat << EOF > /etc/apt/sources.list
# deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
# deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
# deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
# deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
# EOF

# for i in $(seq -w 3) ; do
# 	echo "try $i"
# 	# 更新软件列表源
# 	apt-get update
# 	# 安装一些工具和 pyenv python 必备依赖
# 	apt-get -y install gcc make aria2 
# 	apt-get -y install zlib1g-dev libbz2-dev libncurses-dev 
# 	apt-get -y install libffi-dev libreadline-dev libssl-dev 
# 	apt-get -y install liblzma-dev libgdbm-dev libgdbm-compat-dev 
# 	apt-get -y install libsqlite3-dev uuid-dev tk-dev
# done

# 备份源
cp -rfv /etc/apt/sources.list{,.backup}
cp -rfv /etc/apt/sources.list.d{,.backup}

# 恢复源
#mkdir -pv /etc/apt/sources.list.d
#cp -fv /usr/share/doc/apt/examples/sources.list /etc/apt/sources.list

# 写入 http 清华源
cat << EOF | tee /etc/apt/sources.list
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
# deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free

deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
# deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free

deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
# deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free

# deb http://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
# # deb-src http://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free

deb http://security.debian.org/debian-security bullseye-security main contrib non-free
# deb-src http://security.debian.org/debian-security bullseye-security main contrib non-free
EOF

# 更新软件列表源
apt update

# 防止遇到无法拉取 https 源的情况，先使用 http 源并安装
apt-get -y install apt-transport-https ca-certificates apt-utils eatmydata aptitude

# 写入 https 清华源
sed -i 's;http;https;g' /etc/apt/sources.list

# 更新软件列表源
eatmydata aptitude --without-recommends -o APT::Get::Fix-Missing=true -y update

# 安装一些工具和 pyenv python 必备依赖
eatmydata aptitude --without-recommends -o APT::Get::Fix-Missing=true -y install gcc make aria2
eatmydata aptitude --without-recommends -o APT::Get::Fix-Missing=true -y install zlib1g-dev libbz2-dev libncurses-dev
eatmydata aptitude --without-recommends -o APT::Get::Fix-Missing=true -y install libffi-dev libreadline-dev libssl-dev
eatmydata aptitude --without-recommends -o APT::Get::Fix-Missing=true -y install liblzma-dev libgdbm-dev libgdbm-compat-dev
eatmydata aptitude --without-recommends -o APT::Get::Fix-Missing=true -y install libsqlite3-dev uuid-dev tk-dev
eatmydata aptitude --without-recommends -o APT::Get::Fix-Missing=true -y install build-essential libncurses5-dev libnss3-dev
}

git_clone(){

# clone 编译 pyenv 写入环境
# for i in $(seq -w 3) ; do
# 	echo "try $i"
# 	# git clone https://github.com/pyenv/pyenv.git ~/.pyenv
#       # curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://github.com`curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k 'https://github.com/pyenv/pyenv/releases' | grep '.tar.gz' | sed 's;";  ;g' | awk '{print $3}' | head -n 1`" -o pyenv.tar.gz -O
#       tar zxvf pyenv.tar.gz -C ~/.pyenv
#       mv -v .pyenv/*/.* .pyenv/*/* .pyenv/
# 	cd ~/.pyenv && src/configure && make -C src
# done

tar zxvf $HOME/pyenv.tar.gz -C $HOME/.pyenv/
cp -rfv $HOME/.pyenv/pyenv-*/.[^.]* $HOME/.pyenv/pyenv-*/* $HOME/.pyenv/
cd $HOME/.pyenv && src/configure && make -C src && cd $HOME/

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $HOME/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> $HOME/.bashrc
echo 'eval "$(pyenv init -)"' >> $HOME/.bashrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $HOME/.profile
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> $HOME/.profile
echo 'eval "$(pyenv init -)"' >> $HOME/.profile
source /etc/environment
source $HOME/.zshrc
source $HOME/.profile
source $HOME/.bashrc
# clone pyenv 管理插件写入环境
# for i in $(seq -w 3) ; do
# 	echo "try $i"
# 	# git clone https://github.com/pyenv/pyenv-virtualenv.git `pyenv root`/plugins/pyenv-virtualenv
#       # curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k "https://github.com`curl -SL --connect-timeout 30 -m 60 --speed-time 30 --speed-limit 1 --retry 2 -H "Connection: keep-alive" -k 'https://github.com/pyenv/pyenv-virtualenv/releases' | grep '.tar.gz' | sed 's;";  ;g' | awk '{print $3}' | head -n 1`" -o pyenv-virtualenv.tar.gz -O
#       tar zxvf pyenv-virtualenv.tar.gz -C `pyenv root`/plugins/pyenv-virtualenv
#       mv -v `pyenv root`/plugins/pyenv-virtualenv/*/.* `pyenv root`/plugins/pyenv-virtualenv/*/* `pyenv root`/plugins/pyenv-virtualenv/
# done

mkdir -pv `pyenv root`/plugins/pyenv-virtualenv
tar zxvf $HOME/pyenv-virtualenv.tar.gz -C `pyenv root`/plugins/pyenv-virtualenv
cp -rfv `pyenv root`/plugins/pyenv-virtualenv/pyenv-virtualenv-*/.[^.]* `pyenv root`/plugins/pyenv-virtualenv/pyenv-virtualenv-*/* `pyenv root`/plugins/pyenv-virtualenv/

echo 'eval "$(pyenv virtualenv-init -)"' >> $HOME/.bashrc
echo 'export PYENV_VIRTUALENV_DISABLE_PROMPT=1' >> $HOME/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> $HOME/.profile
echo 'export PYENV_VIRTUALENV_DISABLE_PROMPT=1' >> $HOME/.profile
source $HOME/.profile
source $HOME/.bashrc
# 预放置 python 离线包
mkdir -v $HOME/.pyenv/cache
mv -fv $HOME/Python-*.tar.xz $HOME/.pyenv/cache

}

clean_remove(){
# 清理
# apt-get -y purge make libssl-dev zlib1g-dev \
# 	libbz2-dev libreadline-dev wget curl llvm \
# 	libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev \
# 	liblzma-dev
# for i in $(seq -w 3) ; do
# 	echo "try $i"
# 	apt-get -y install procps htop python3-tk build-essential
# 	apt-get install -fy
# done
apt-get -y autoremove
apt-get -y autopurge
apt-get clean

rm -rfv $HOME/.pyenv/pyenv-* `pyenv root`/plugins/pyenv-virtualenv/pyenv-virtualenv-* $HOME/pyenv-virtualenv.tar.gz $HOME/pyenv.tar.gz /var/lib/apt/lists/* /root/run_build

# 还原源
mv -fv /etc/apt/sources.list.backup /etc/apt/sources.list
# apt-get update

# 清除记录
history -c
echo '' > /root/.bash_history
}

mkdir_update_install
git_clone
clean_remove
# 脚本终结
echo 'it is done!'
