#!/bin/sh

# 换源
# sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories

# 安装一些必备工具
apk add --no-cache tzdata

# 修改时钟
date +'%Y-%m-%d %H:%M:%S'
ln -sfv /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
date +'%Y-%m-%d %H:%M:%S'

# 换成 bash
apk add --no-cache bash shadow procps
chsh -s /bin/bash

# 尝试用 bash 环境运行 install.sh
bash install.sh
rm -fv /bin/sh ; echo -e '#!/bin/bash\nbash' > /bin/sh ; chmod -v +x /bin/sh
