#!/bin/bash

# 打印检查环境是否导入
export DEBIAN_FRONTEND=noninteractive
export NOTEBOOK_ROOT=/notebook
export PASSWORD=123456

echo "$DEBIAN_FRONTEND \n$NOTEBOOK_ROOT \n$PASSWORD "

# 更新安装依赖
update_install(){
# 改时区
date '+%Y-%m-%d %H:%M:%S'
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "Asia/Shanghai" > /etc/timezone
date '+%Y-%m-%d %H:%M:%S'

# 新建 notebook 存储目录
mkdir -pv $NOTEBOOK_ROOT
cp -rv $HOME/run_jupyter /usr/bin/
chmod -v u+x /usr/bin/run_jupyter

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
                                                                                  zlib1g-dev libbz2-dev libncurses-dev python-openssl \
                                                                                  libffi-dev libreadline-dev libssl-dev llvm \
                                                                                  liblzma-dev libgdbm-dev libgdbm-compat-dev git \
                                                                                  libsqlite3-dev uuid-dev tk-dev libnss3-dev \
                                                                                  build-essential libncurses5-dev libncursesw5-dev locales \
                                                                                  unzip python-dev libevent-dev libzmq3-dev
                                                                                  

}


pyenv_install(){
# 使用locale-gen命令生成中文本地支持
sed -i 's;# zh_CN.UTF-8 UTF-8;zh_CN.UTF-8 UTF-8;g;s;en_US.UTF-8 UTF-8;# en_US.UTF-8 UTF-8;g' /etc/locale.gen

locale-gen zh_CN
locale-gen zh_CN.UTF-8

# 写入中文字符集环境变量
cat << EOF | tee /etc/default/locale
LANGUAGE=zh_CN.UTF-8
LC_ALL=zh_CN.UTF-8
LANG=zh_CN.UTF-8
LC_CTYPE=zh_CN.UTF-8
EOF

cat << EOF | tee -a /etc/environment
export LANGUAGE=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export LANG=zh_CN.UTF-8
export LC_CTYPE=zh_CN.UTF-8
EOF

cat << EOF | tee -a $HOME/.bashrc
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export LANGUAGE=zh_CN.UTF-8
export LC_CTYPE=zh_CN.UTF-8
EOF

cat << EOF | tee -a $HOME/.profile
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export LANGUAGE=zh_CN.UTF-8
export LC_CTYPE=zh_CN.UTF-8
EOF

source /etc/environment
source $HOME/.profile
source $HOME/.bashrc

# 持久化
update-locale LANG=zh_CN.UTF-8 LC_ALL=zh_CN.UTF-8 LANGUAGE=zh_CN.UTF-8

# 看看当前启用的本地支持
cat /etc/default/locale
locale
locale -a

cd $HOME
# 解压已经编译好的压缩包
tar zxf pyenv.tar.gz -C $HOME/

# 写入 pyenv 环境变量
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $HOME/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> $HOME/.bashrc
echo 'eval "$(pyenv init -)"' >> $HOME/.bashrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $HOME/.profile
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> $HOME/.profile
echo 'eval "$(pyenv init -)"' >> $HOME/.profile
echo 'eval "$(pyenv virtualenv-init -)"' >> $HOME/.bashrc
echo 'export PYENV_VIRTUALENV_DISABLE_PROMPT=1' >> $HOME/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> $HOME/.profile
echo 'export PYENV_VIRTUALENV_DISABLE_PROMPT=1' >> $HOME/.profile

source /etc/environment
source $HOME/.profile
source $HOME/.bashrc

# 移除已经存在的虚拟环境
pyenv_var=`pyenv virtualenvs | grep '*' | awk '{print $2}'`
pyenv deactivate $pyenv_var
pyenv virtualenv-delete -f $pyenv_var
sed -i '/'"${pyenv_var}"'/d' $HOME/.pyenv/version

# 重新创建虚拟python环境
pyenv_var=`pyenv versions | sed 's;*;;g;s;/; ;g;s; ;;g' | grep -oE '^[0-9]*\.?[0-9]*\.?[0-9]*?$' | awk '{print $1}'`
pyenv global $pyenv_var
pyenv virtualenv $pyenv_var py$pyenv_var
pyenv global py$pyenv_var $pyenv_var
pyenv activate py$pyenv_var
# python 版本
pyenv version
pyenv versions
}

# 下载安装 Openjdk
openjdk_install(){
# Adoptium 官网：https://adoptium.net/zh-CN/temurin/releases
# Adoptium github 地址： https://github.com/adoptium
# if [ $(uname -m) = "x86_64" ];then
#     echo is amd64
#     wget --verbose --show-progress=on --progress=bar --hsts-file=/tmp/wget-hsts -c "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.8%2B7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.8_7.tar.gz" -O /tmp/OpenJDK-jdk_linux_hotspot.tar.gz
# elif [ $(uname -m) = "aarch64" ];then
#     echo is aarch64
#     wget --verbose --show-progress=on --progress=bar --hsts-file=/tmp/wget-hsts -c "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.8%2B7/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.8_7.tar.gz" -O /tmp/OpenJDK-jdk_linux_hotspot.tar.gz
# fi

# 整合拆分包
cat $HOME/OpenJDK-jdk_linux_hotspot.tar.gz.* > $HOME/OpenJDK-jdk_linux_hotspot.tar.gz
mv -fv $HOME/OpenJDK-jdk_linux_hotspot.tar.gz /tmp/OpenJDK-jdk_linux_hotspot.tar.gz

# 解压缩
tar xvf /tmp/OpenJDK-jdk_linux_hotspot.tar.gz -C /opt/

# 写入环境变量
cat << EOF | tee -a /etc/environment
export JAVA_HOME=/opt/jdk-*
export CLASSPATH=.:\$JAVA_HOME/lib/tools.jar:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib
export PATH=\$PATH:\$JAVA_HOME/bin
EOF

cat << EOF | tee -a $HOME/.bashrc
export JAVA_HOME=/opt/jdk-*
export CLASSPATH=.:\$JAVA_HOME/lib/tools.jar:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib
export PATH=\$PATH:\$JAVA_HOME/bin
EOF

cat << EOF | tee -a $HOME/.profile
export JAVA_HOME=/opt/jdk-*
export CLASSPATH=.:\$JAVA_HOME/lib/tools.jar:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib
export PATH=\$PATH:\$JAVA_HOME/bin
EOF

source /etc/environment
source $HOME/.zshrc
source $HOME/.profile
source $HOME/.bashrc

sed -i "s|export JAVA_HOME=/opt/jdk-.*|export JAVA_HOME=$(dirname $(whereis java | awk '{print $2}') | sed 's;/bin;;g')|g" /etc/environment
sed -i "s|export JAVA_HOME=/opt/jdk-.*|export JAVA_HOME=$(dirname $(whereis java | awk '{print $2}') | sed 's;/bin;;g')|g" $HOME/.bashrc
sed -i "s|export JAVA_HOME=/opt/jdk-.*|export JAVA_HOME=$(dirname $(whereis java | awk '{print $2}') | sed 's;/bin;;g')|g" $HOME/.profile

source /etc/environment
source $HOME/.zshrc
source $HOME/.profile
source $HOME/.bashrc
}

# 安装 ijava 支持 java 编译
ijava_install(){
# ijava github: https://github.com/SpencerPark/IJava
# wget --verbose --show-progress=on --progress=bar --hsts-file=/tmp/wget-hsts -c "https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip" -O /tmp/ijava-1.3.0.zip
mv -fv $HOME/ijava-1.3.0.zip /tmp/ijava.zip
unzip -o -d /tmp/ijava /tmp/ijava.zip
cd /tmp/ijava
python install.py --sys-prefix
}

# 安装 jupyter
jupyter_install(){
# 创建软链接
if [ -e $(command -v python3) ]
then
    ln -fsv $(command -v python3) /usr/bin/python
    ln -fsv $(command -v pip3) /usr/bin/pip
else
    echo "python3 没找到"
fi

# 获取Python版本
version=$(python --version 2>&1 | awk '{print $2}')
IFS='.' read -ra ADDR <<< "$version"

# 更新 pip
# python -m pip install --upgrade pip

# 配置默认清华源
# pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
# pip install pip -U

# jupyter notebook 相关
# pip --no-cache-dir install jupyterlab notebook voila ipywidgets qtconsole jupyter_contrib_nbextensions jupyter-console


# 检查版本是否为2
if [[ ${ADDR[0]} -eq 2 ]]
then
    echo "版本过低 python2"
elif [[ ${ADDR[0]} -eq 3 ]]
then
    # 检查版本是否小于等于3.10
    if [[ ${ADDR[1]} -le 10 ]]
    then
        echo "python 版本 ${ADDR}"
        pip --no-cache-dir install -U pip
        pip --no-cache-dir install jupyterlab
        pip --no-cache-dir install notebook==6.5.5
        pip --no-cache-dir install voila
        pip --no-cache-dir install ipywidgets
        pip --no-cache-dir install qtconsole
        pip --no-cache-dir install jupyter_contrib_nbextensions
        pip --no-cache-dir install jupyter-console
    else
        echo "python 版本 ${ADDR}"
        pip --no-cache-dir install -U pip --break-system-packages
        pip --no-cache-dir install jupyterlab --break-system-packages
        pip --no-cache-dir install notebook==6.5.5 --break-system-packages
        pip --no-cache-dir install voila --break-system-packages
        pip --no-cache-dir install ipywidgets --break-system-packages
        pip --no-cache-dir install qtconsole --break-system-packages
        pip --no-cache-dir install jupyter_contrib_nbextensions --break-system-packages
        pip --no-cache-dir install jupyter-console --break-system-packages
    fi
else
    echo "超出版本预期，脚本需要更新！！"
fi

# 生成 jupyter 默认配置文件
echo y | jupyter-notebook --generate-config --allow-root

# 查看 jupyter 版本
jupyter --version

ijava_install

# 尝试安装扩展支持跳过检查
jupyter contrib nbextension install --user --skip-running-check

# 生成配置文件
jupyter-server --generate-config -y

# 生成密码 123456
PASSWORD=$(python -c "from notebook.auth import passwd; print(passwd('${PASSWORD}'))")

# 写入默认密码
cat << EOF | tee $HOME/.jupyter/jupyter_server_config.json
{
  "IdentityProvider": {
    "hashed_password": "$PASSWORD"
  }
}
EOF

mv -fv  $HOME/.jupyter $HOME/.jupyter.backup
}



clean_remove(){
# 修改sh软链接
ln -fsv /bin/bash /bin/sh

# 清理
apt-get -y autoremove
apt-get -y autopurge
apt-get clean

# 解除环境变量
unset NOTEBOOK_ROOT

# 删除压缩包
rm -rfv $HOME/pyenv.tar.gz $HOME/OpenJDK-jdk_linux_hotspot.tar.gz.* /tmp/OpenJDK-jdk_linux_hotspot.tar.gz /tmp/ijava /tmp/ijava-1.3.0.zip $HOME/run_jupyter /var/lib/apt/lists/*

# 清除记录
echo '' > /root/.bash_history ; history -c ; history -p
}

update_install
pyenv_install
openjdk_install
jupyter_install
clean_remove
# 脚本终结
echo 'it is done!'
