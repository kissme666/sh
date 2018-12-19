#!/usr/bin/env bash 
centos=192.168.199.157
ubuntu_server=192.168.199.77
ubuntu_desktop=192.168.199
while : 
do
	echo "Jump Server Manger"
	echo "1. centos 1"
	echo "2. ubuntu server 18.04"
	echo "3. ubuntu desktop 18.04"
	echo -n "input you choice : "
	read num
	case $num in
		1) ssh air@$centos
		;;
		2) ssh air@$ubuntu_server
		;;
		3) ssh air@$ubuntu_desktop
		;;
		*) echo "请重新选择"
		;;
	esac
done
