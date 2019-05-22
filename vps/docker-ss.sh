#!/usr/bin/env bash 
# Install docker-ss
# Auther: Air
# OS: Ubuntu18.04
# 2019.4.27 first commint
# 2019.5.22 Redesign
current_dir=$(pwd)

# install docker on vps
install_docker() {
	apt-get update && \
	apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common  && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -  && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository \
   		"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   		$(lsb_release -cs) \
   		stable"  && \
   	apt-get update && \
   	apt-get install docker-ce docker-ce-cli containerd.io docker-compose -y && \

   	return 0
}

# get docker-compose configurition
get_config() {
	wget https://raw.githubusercontent.com/kissme666/sh/dev/vps/docker-compose.yaml
}

main() {
	mkdir $current_dir/docker/ss-libev && \
	cd $current_dir/docker/ss-libev/
	$status=install_docker
	if [ $status -eq 0 ]; then
		get_config
		if [ -f docker-compose.yaml ]; then
			# Docker services start and install ss-libev for docker
			docker-compose up -d
			echo "Enjoy it"
		fi
	else
		echo "Warning: ss-libev unsuccessful installation"
		exit 1
	fi

}

main
