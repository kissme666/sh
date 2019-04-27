#!/usr/bin/env bash 
# Install docker-ss
# Auther: Air
# OS: Ubuntu18.04
# 2019.4.27 first commint
# 
wget https://raw.githubusercontent.com/kissme666/sh/master/vps/init-docker.sh
wget https://raw.githubusercontent.com/kissme666/sh/master/vps/docker-compose.yaml

if [ -x init-docker.sh ] && [ -f docker-compose.yaml ]; then
    ./init-docker.sh

else
    echo "File not found..."
    exit 1
fi
# Docker services start and install ss-libev for docker
docker-compose up -d

echo "Enjoy it"
echo "Bye..."
