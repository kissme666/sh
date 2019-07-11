#!/bin/bash
# init local vm os
# 待添加功能：
# 1. 增加用户
# 2. 自动配置zsh和vim
##### 全局变量设置 #####
CMD_INSTALL=''
CMD_UPDATE=''


#######color code########
RED="31m"      # Error message
GREEN="32m"    # Success message
YELLOW="33m"   # Warning message
BLUE="36m"     # Info message


# 颜色输出函数
# Usage: colorEcho ${color} "info"
color_echo() {
    local color=$1
    echo -e "\033[${color}${@:2}\033[0m" #${@:2}为颜色输出的信息
}


# 检测当前包管理系统
# return 0 apt-get or yum 
get_pms() {
    if [[ -n $(command -v apt) ]]; then
        CMD_UPDATE="apt-get -qq update"
        CMD_INSTALL="apt-get -y -qq install"
    elif [[ -n $(command -v yum) ]]; then
        CMD_UPDATE="yum -q makecache"
        CMD_INSTALL="yum -y -q install"
    else
        return 1
    fi
    return 0
}

# 安装依赖软件
# 0 安装成功
# 1 安装不成功
install_software() {
    softs=$@
    
    get_pms
    if [[ $? -eq 1 ]]; then
        color_echo ${RED} "The system package manager tool isn't APT or YUM."
        return 1
    fi

    $CMD_UPDATE
    $CMD_INSTALL "$@"

    if [[ $? -ne 0 ]]; then
        color_echo ${RED} "Failed to install $@. Please install it manually."
        return 1
    fi
    return 0
}

set_ubuntu18_mirrors() {
    cat > /etc/apt/sources.list <<- EOF
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
EOF

    return 0
}

set_centos7_mirrors() {
    # 不能用curl，初期安装的系统不一定有curl和wget
    # curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
    cat > /etc/yum.repos.d/CentOS-Base.repo <<-EOF
# CentOS-Base.repo
#CentOS-Base.repo
# The mirror system uses the connecting IP address of the client and the
# update status of each mirror to pick mirrors that are updated to and
# geographically close to the client.  You should use this for CentOS updates
# unless you are manually picking other mirrors.
#
# If the mirrorlist= does not work for you, as a fall back you can try the
# remarked out baseurl= line instead.
#
#

[base]
name=CentOS-$releasever - Base
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/os/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

#released updates
[updates]
name=CentOS-$releasever - Updates
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/updates/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/extras/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-$releasever - Plus
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/centosplus/$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
EOF

    return 0
}


# 检查当前用户是否为root
check_user(){
    [ ${UID} -ne 0 ] && color_echo ${RED} "This script must run as root!" && exit 1

    return 0
}

# 目前换源仅仅支持Ubuntu18.04/Centos7
# 0 换源成功
# 1 换源不成功
set_mirrors() {
    
    if  grep "Ubuntu 18.04" /etc/os-release &>/dev/null ; then
        #备份并设置Ubuntu18.04 为国内阿里云源
        mv /etc/apt/sources.list /etc/apt/sources.list.bakcup \
        && set_ubuntu18_mirrors
        color_echo ${GREEN} "Successful source change"
    elif grep "CentOS Linux 7" /etc/os-release &>/dev/null ; then
        #备份被设置Centos7为国内tuna的源
        mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup \
        && set_centos7_mirrors 
        color_echo ${GREEN} "Successful source change"
    else
        # 输出不支持系统的警告信息
        color_echo ${RED} "Unsupported system type"
        exit 1
    fi

    return 0
}


git_settings(){
    git config --global user.email m787715894@gmail.com
    git config --global user.name "Air"
    color_echo ${GREEN} "Git is set up"

    return 0
}

# main 程序入口
main() {
    check_user \
    && set_mirrors \
    && install_software git wget curl zsh \
    && git_settings
    color_echo ${GREEN} "Installed..."
}

main