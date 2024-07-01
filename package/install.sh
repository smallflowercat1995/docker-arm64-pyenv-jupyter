#!/bin/bash
# 将执行脚本移动到可执行目录并授权
mv -fv run_jupyter /usr/bin/
chmod -v u+x /usr/bin/run_jupyter

# 汉化安装中文字体
apk add --no-cache font-noto-cjk font-wqy-zenhei

# 写入汉化配置环境
cat << SMALLFLOWERCAT1995 | tee -a /etc/environment
LANG=zh_CN.UTF-8
LC_CTYPE="zh_CN.UTF-8"
LC_NUMERIC="zh_CN.UTF-8"
LC_TIME="zh_CN.UTF-8"
LC_COLLATE="zh_CN.UTF-8"
LC_MONETARY="zh_CN.UTF-8"
LC_MESSAGES="zh_CN.UTF-8"
LC_PAPER="zh_CN.UTF-8"
LC_NAME="zh_CN.UTF-8"
LC_ADDRESS="zh_CN.UTF-8"
LC_TELEPHONE="zh_CN.UTF-8"
LC_MEASUREMENT="zh_CN.UTF-8"
LC_IDENTIFICATION="zh_CN.UTF-8"
LC_ALL=
SMALLFLOWERCAT1995

# 安装 pyenv 管理 python 环境 https://github.com/pyenv/pyenv 
# 安装脚本 https://github.com/pyenv/pyenv-installer
apk add --no-cache make gcc build-base sed curl coreutils git
curl https://pyenv.run | sh

# 写入 pyenv 环境
cat << SMALLFLOWERCAT1995 | tee -a $HOME/.bashrc
#!/bin/bash
export PYENV_ROOT="\$HOME/.pyenv"
[[ -d \$PYENV_ROOT/bin ]] && export PATH="\$PYENV_ROOT/bin:\$PATH"
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
SMALLFLOWERCAT1995

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# 更新 bash 环境
cd $HOME/.pyenv/plugins/python-build/../.. && git pull && cd -

# 安装编译依赖
apk add --no-cache git bash build-base libffi-dev openssl-dev bzip2-dev zlib-dev xz-dev readline-dev sqlite-dev tk-dev

# 安装最新版 python https://github.com/pyenv/pyenv/wiki#suggested-build-environment
# 构建问题参考 https://github.com/pyenv/pyenv/wiki/Common-build-problems
pyenv install -v -f $(pyenv install --list | grep -Eo '^[[:space:]]*([0-9]+\.[0-9]+\.[0-9]+)$' | tail -1) versions

# 刷新
pyenv rehash
# 检查
pyenv version
pyenv versions

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

# python 虚拟环境检查
pyenv version
pyenv versions

# 整合拆分包
cat ./OpenJDK-jdk_aarch64_alpine-linux_hotspot.tar.gz.* > /tmp/OpenJDK-jdk_aarch64_alpine-linux_hotspot.tar.gz

# 解压缩
tar xvf /tmp/OpenJDK-jdk_aarch64_alpine-linux_hotspot.tar.gz -C /opt/

# 写入 java 环境变量
cat << EOF | tee -a $HOME/.bashrc
export JAVA_HOME=/opt/$(ls -al /opt | grep jdk | awk '{print $9}' | tail -1)
export CLASSPATH=.:\$JAVA_HOME/lib/tools.jar:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib
export PATH=\$PATH:\$JAVA_HOME/bin
EOF

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
        python -m pip --no-cache-dir install -v --upgrade pip 
        python -m pip --no-cache-dir install -v -r requirements.txt
        # python -m pip --no-cache-dir install -v --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple
        # python -m pip --no-cache-dir install -v -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
    else
        echo "python 版本 ${ADDR}"
        python -m pip --no-cache-dir install -v --upgrade pip --break-system-packages
        python -m pip --no-cache-dir install -v -r requirements.txt --break-system-packages
        # python -m pip --no-cache-dir install -v --upgrade pip --break-system-packages -i https://pypi.tuna.tsinghua.edu.cn/simple
        # python -m pip --no-cache-dir install -v -r requirements.txt --break-system-packages -i https://pypi.tuna.tsinghua.edu.cn/simple
    fi
else
    echo "超出版本预期，脚本需要更新！！"
fi

# 生成 jupyter 默认配置文件
echo y | jupyter-notebook --generate-config --allow-root

# 查看 jupyter 版本
jupyter --version

# 安装 ijava 支持扩展
cp -fv ./ijava-1.3.0.zip /tmp/ijava.zip
unzip -o -d /tmp/ijava /tmp/ijava.zip
cd /tmp/ijava
python install.py --sys-prefix
cd -
rm -fv /tmp/ijava.zip /tmp/OpenJDK-jdk_aarch64_alpine-linux_hotspot.tar.gz OpenJDK-jdk_aarch64_alpine-linux_hotspot.tar.gz.* ijava-1.3.0.zip requirements.txt
