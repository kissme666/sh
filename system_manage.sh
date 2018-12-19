#!/usr/bin/env bash 
# system manage
# 2019.1.2
menu() {
	cat<<-EOF
	+---------------------------------------+
	|	h. help				|
	|	f. disk partition		|
	|	d. file system mount status	|
	|	m. memory status		|
	|	u. system load			|
	|	q. exit				|
	+---------------------------------------+
	EOF
}
clear
menu
while true
do	
	echo -en "\033[32m please input your choice (h for help) \033[0m"
	read  num
	case $num in
	h)
		menu
		;;
	f)
		lsblk
		;;
	d)
		df -h
		;;
	m)
		free -m
		;;
	u)
		uptime
		;;
	# 如果是 exit 那么会退出程 
	q)
		break
		;;
	"")
		clear
		menu
		;;
	*)
		echo "please input your choice"
		;;	
	esac
done
