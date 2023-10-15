#!/bin/bash

# 打印检查环境是否导入
export DEBIAN_FRONTEND=noninteractive

echo -e "$DEBIAN_FRONTEND"

# 更新安装依赖
update_install(){
cp -rv /root/run_build /usr/bin/
chmod -v u+x /usr/bin/run_build

# 改时区
date '+%Y-%m-%d %H:%M:%S'
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "Asia/Shanghai" > /etc/timezone
date '+%Y-%m-%d %H:%M:%S'

# 备份源
#cp -rfv /etc/apt/sources.list{,.backup}
#cp -rfv /etc/apt/sources.list.d{,.backup}

# 恢复源
#mkdir -pv /etc/apt/sources.list.d
#cp -fv /usr/share/doc/apt/examples/sources.list /etc/apt/sources.list

# 更新软件列表源
apt update

# 防止遇到无法拉取 https 源
apt-get -y install apt-transport-https ca-certificates apt-utils eatmydata aptitude

# 更新软件列表源
eatmydata aptitude --without-recommends -o APT::Get::Fix-Missing=true -y update

# 安装一些工具和 pyenv python 必备依赖
eatmydata aptitude --without-recommends -o APT::Get::Fix-Missing=true -y install  gcc make aria2 xz-utils \
                                                                                  zlib1g-dev libbz2-dev libncurses-dev python3-openssl \
                                                                                  libffi-dev libreadline-dev libssl-dev llvm \
                                                                                  liblzma-dev libgdbm-dev libgdbm-compat-dev git \
                                                                                  libsqlite3-dev uuid-dev tk-dev libnss3-dev \
                                                                                  build-essential libncurses5-dev libncursesw5-dev python-dev \
                                                                                  libevent-dev libzmq3-dev
}

install_pyenv(){
# 在线 clone 编译 pyenv 写入环境
git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv

# 离线安装pyenv
# tar zxvf $HOME/pyenv.tar.gz -C $HOME/.pyenv/
# cp -rfv $HOME/.pyenv/pyenv-*/.[^.]* $HOME/.pyenv/pyenv-*/* $HOME/.pyenv/

cd $HOME/.pyenv && src/configure && make -C src && cd $HOME/

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $HOME/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> $HOME/.bashrc
echo 'eval "$(pyenv init -)"' >> $HOME/.bashrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $HOME/.profile
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> $HOME/.profile
echo 'eval "$(pyenv init -)"' >> $HOME/.profile
source /etc/environment

source $HOME/.profile
source $HOME/.bashrc

# 在线 clone pyenv 管理插件写入环境
git clone https://github.com/pyenv/pyenv-virtualenv.git `pyenv root`/plugins/pyenv-virtualenv

# 离线安装pyenv-virtualenv
#mkdir -pv `pyenv root`/plugins/pyenv-virtualenv
#tar zxvf $HOME/pyenv-virtualenv.tar.gz -C `pyenv root`/plugins/pyenv-virtualenv
#cp -rfv `pyenv root`/plugins/pyenv-virtualenv/pyenv-virtualenv-*/.[^.]* `pyenv root`/plugins/pyenv-virtualenv/pyenv-virtualenv-*/* `pyenv root`/plugins/pyenv-virtualenv/

echo 'eval "$(pyenv virtualenv-init -)"' >> $HOME/.bashrc
echo 'export PYENV_VIRTUALENV_DISABLE_PROMPT=1' >> $HOME/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> $HOME/.profile
echo 'export PYENV_VIRTUALENV_DISABLE_PROMPT=1' >> $HOME/.profile

source $HOME/.profile
source $HOME/.bashrc

# 预放置 python 离线包
# mkdir -v $HOME/.pyenv/cache
# mv -fv $HOME/Python-*.tar.xz $HOME/.pyenv/cache
}

clean_remove(){
apt-get -y autoremove
apt-get -y autopurge
apt-get clean

rm -rfv $HOME/.pyenv/pyenv-* `pyenv root`/plugins/pyenv-virtualenv/pyenv-virtualenv-* $HOME/pyenv-virtualenv.tar.gz $HOME/pyenv.tar.gz /var/lib/apt/lists/* /root/run_build

# 清除记录
echo '' > /root/.bash_history ; history -c ; history -p
}

update_install
install_pyenv
clean_remove

# 脚本终结
echo 'it is done!'
