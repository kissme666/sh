#!/bin/bash
# Install ss-dcoker for vps
# OS: Ununtu18.04 or Debian 9
# Get init-dcoker.sh
curl https://raw.githubusercontent.com/kissme666/sh/master/init-docker.sh 
curl https://raw.githubusercontent.com/kissme666/sh/master/vps/docker-compose.yaml

if [ -x init.sh && -x docker-compose.yaml ]; then
    ./init.sh
else
    echo "File not found..."
    exit 1

# Docker services start and install ss-libev for docker
docker-compose up -d

echo "Enjoy it"
echo "Bye..."



