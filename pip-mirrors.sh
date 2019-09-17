#!/bin/bash
# 自动配置pip 国内镜像

# pip 配置目录
PIP_CONF_DIR=${HOME}/.pip

# pip conf 文件位置
PIP_CONF_FILE=${HOME}/.pip/pip.conf


# 检测 .pip目录是否存在
if [[ ! -d ${PIP_CONF_DIR} ]]; then
    echo "[+] mkdir ~/.pip"
    mkdir ${PIP_CONF_DIR}
fi

# 直接写入~/.pip/pip.conf 文件
cat >>${PIP_CONF_FILE}<<EOF
[global]
index-url = https://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
EOF

# 输出配置完成的信息
if [[ $? -eq 0 ]]; then
    # 输出配置成功信息
    echo "[+] Successful configuration"
else
    # 输出配置失败信息
    echo "[-] Configuration failed"
fi
