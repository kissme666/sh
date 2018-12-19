#!/usr/bin/env bash 
centos=192.168.199.157
ubuntu_server=192.168.199.77
ubuntu_desktop=192.168.199.x
clear
while : 
do
	cat<<-EOF
	+----------------------------+
	|    Jump Server Manger	     |
	|    1. centos 1	     |
	|    2. ubuntu server 18.04  |
	|    3. ubuntu desktop 18.04 |
	|    q. exit 	             |
	+----------------------------+
	EOF
	echo -n "input you choice : "
	read num
	case $num in
		1) ssh air@$centos
		;;
		2) ssh air@$ubuntu_server
		;;
		3) ssh air@$ubuntu_desktop
		;;
		q) exit 0
		u;; 
		*) echo "请重新选择"
		;;
	esac
done
