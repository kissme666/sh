#!/usr/bin/env bash 
# Ubuntu18.04 配置WPS shell script
# 
# 检查当前用户是否为root
[ ${UID} -ne 0 ] && color_echo ${RED} "This script must run as root!" && exit 1

# 设置wps 缺失字体
set_dep_fonts() {
	cp * /usr/share/fonts \
	&& mkfontscale \
	&& mkfontdir \
	&& fc-cache
	if [[ $? -eq 0 ]]; then
		echo "配置成功"
		return 0
	else
		echo "配置错误"
		return 1
	fi

}

main() {
	set_dep_fonts
}

main