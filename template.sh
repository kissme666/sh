#!/usr/bin/env bash
# xxxx安装模板

# debug
# set -x

##### 全局变量设置 #####
CMD_INSTALL=''
CMD_UPDATE=''



#######color code########
RED="31m"      # Error message
GREEN="32m"    # Success message
YELLOW="33m"   # Warning message
BLUE="36m"     # Info message

# 颜色输出函数
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

# 检查当前用户是否为root
[ ${UID} -ne 0 ] && color_echo ${RED} "This script must run as root!" && exit 1


