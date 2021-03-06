#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

DOWNLOAD_LINK="https://dl.mumble.info/latest/stable/server-linux-x86"

# 检查用户是否为root
function checkRoot() {
	if [[ $EUID -ne 0 ]]; then
		echo -e "\033[31m 错误: 本脚本必须以root用户执行! \033[0m"
		exit 1
	else
		echo -e "Root用户检查完成"
	fi
}

# 下载murmur软件包
function download() {
    echo "下载最新版软件包..."
    if ! wget --no-check-certificate -O murmur.tar.bz2 -c $DOWNLOAD_LINK; then
        echo "下载失败, 请检查网络状态"
        exit 1
    fi
}

# 替换murmur文件夹中的旧文件
function update() {
    tar -vxjf murmur.tar.bz2 --strip-components 1 -C /usr/local/murmur
    rm murmur.tar.bz2
}

# 停止murmur服务
function stopServer() {
    if ! service murmur stop; then
        echo "停止murmur服务失败, 请查看日志以检查失败原因"
        exit 1
    fi
}

# 启动murmur服务
function startServer() {
    if ! service murmur start; then
        echo "启动murmur服务失败, 请查看日志以检查失败原因"
        exit 1
    fi
}

checkRoot
download
stopServer
update
startServer
echo "murmur更新完成"