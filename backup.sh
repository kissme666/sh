#!/bin/bash
# 功能: 自动备份docker映射数据脚本
# Author: air
# Time:  2019.09.17

set -ex

[[ $EUID -ne 0 ]] && echo "Error: This script must be run as root!" && exit 1

####### 脚本配置文件 #######
# 备份根目录
BACKUP_ROOT=/root/backup

# Gdrive 上传目录的ID
# 请自行设置
UPLOAD_ID=1iMl9xBp_B1TOBsqeMQ5qnXR0ihRZnq1V

# 日志根目录
LOG_DIR=/root/backup/log/

# 备份文件的时间 
# eg: 20190917000000
# 时间说明:2019年0月17号零时零分零秒
FILE_DATE=$(date +%Y%m%d%H%M%S)

# 日志模块的时间
LOG_DATE=$(date "+%Y-%m-%d %H:%M:%S")

# 要备份的目录
BACKUP_DIR=/docker
####### 脚本配置文件结束 #######


# 这里有点小问题
if [[ ! -d ${LOG_DIR} ]]; then
    mkdir -p ${LOG_DIR}
fi

# 日志文件
log() {
    echo ${LOG_DATE} ":" "$1" >> ${LOG_DIR}/backup.log
}

# 检测配置目录是否存在
# 不存在则创建相应的目录
if [[ ! -d ${BACKUP_ROOT} ]]; then
    mkdir -p ${BACKUP_ROOT}
    log "创建备份根目录"
fi

if [[ ! -d ${BACKUP_DIR} ]]; then
    exit 1
    log "要备份的目录未找到，请重新设置BACKUP_DIR的值"
    log "exit 1"
fi

# 检测gdrive命令是否存在
# 不存在则退出
# 注意：！！！gdrive 必须是安装在可搜索路径中
check_gdrive(){
    command -v gdrive &>/dev/null
    if [[ $? -ne 0 ]]; then
        exit 1 
        log "gdrive命令未找到，请检查安装和配置是否正确"
        log "exit 1"
    fi
}

backup(){
    cd ${BACKUP_ROOT}

    command -v "tar"
    if [[ $? -ne 0 ]]; then
        exit 1
        log "tar 命令未找到"
        log "exit 1"
    fi

    # tar 压缩备份
    file_name=${FILE_DATE}.tar.xz
    tar -acf ${file_name} ${BACKUP_DIR} &>/dev/null
    if [[ $? -eq 0 ]]; then
        log "uploading...."
        gdrive upload --parent ${UPLOAD_ID} --delete ${file_name}
    fi

    if [[ $? -eq 0 ]]; then
        log "${file_name} 上传成功"
    fi
}

main(){
    check_gdrive
    backup
}

main
