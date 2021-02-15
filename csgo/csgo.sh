#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#====================================#
# 系统要求: CentOS 6,7				 #
# 描述: 一键安装CSGO服务器				 #
# 作者: Fisher						 #
# 联系方式: wz2483156090@gmail.com    #
#====================================#

clear
echo -e "\033[34m================================================================\033[0m

            欢迎使用 CSGO服务器 一键安装脚本

            系统要求:  CentOS 6,7
            描述: 一键安装 CSGO 服务器
            作者: Fisher
            联系方式： wz2483156090@gmail.com

\033[34m================================================================\033[0m"

echo

# 当前文件夹
Current_Dir=`pwd`

# 检查用户是否为root
function checkRoot() {
	if [[ $EUID -ne 0 ]]; then
		echo -e "\033[31m 错误: 本脚本必须以root用户执行! \033[0m"
		exit 1
	else
		echo -e "Root用户检查完成"
	fi
}

# 检查系统版本
function checkOS() {
	if [[ -f /etc/redhat-release ]]; then
		OS=`cat /etc/redhat-release`
		echo -e "系统版本检查完成,当前系统为: ${OS}"
	else
		echo -e "\033[31m 目前脚本不支持当前操作系统! \033[0m"
		exit 1
	fi
}

# 安装steamcmd依赖
function installPackage() {
	read -r -p "请回车继续安装, 或者按 Ctrl+C 停止安装"
	yum update -y
	echo -e "开始安装依赖: wget screen glibc.i686 libstdc++.i686 ......"
	yum install -y wget screen glibc.i686 libstdc++.i686
	echo -e "依赖安装完成"
}

# 创建新用户,下载steamcmd并解压,删除安装包
function createUser() {
	read -p "请输入管理steamcmd的用户名(直接回车的话,默认为steam): " steamUser
	[ -z "${steamUser}" ] && steamUser='steam'
	read -p "请输入steamcmd文件夹名称(直接回车的话,默认为steamcmd): " steamcmdFolder
	[ -z "${steamcmdFolder}" ] && steamcmdFolder='steamcmd'
	
	# 创建并切换到该用户根目录下
	useradd -m ${steamUser}
	# su ${steamUser}
	cd "/home/${steamUser}"

	# 创建文件夹
	mkdir ${steamcmdFolder}
	cd ${steamcmdFolder}
	
	# 下载steamcmd并解压
	if ! wget --no-check-certificate https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz; then
		echo -e "\033[31m 下载 steamcmd 文件失败,请检查网络状态. \033[0m"
		exit 1
	fi
	tar zxvf steamcmd_linux.tar.gz
	rm -f steamcmd_linux.tar.gz

	echo
	echo "------------------------------"
	echo "成功设置用户${steamUser}"
	echo "成功创建文件夹${steamcmdFolder}"
	echo "成功下载并解压steamcmd"
	echo "------------------------------"
	echo
}

# 安装CSGO服务器端
function installCSGO() {
	read -p "请输入CSGO服务器端文件夹名称(直接回车的话,默认为csgo_server): " csgoFolder
	[ -z "${csgoFolder}" ] && csgoFolder='csgo_server'
	
	echo -e "正在写入安装CSGO服务器脚本......"
	touch install_csgo.txt
	echo "login anonymous" >> install_csgo.txt
	echo "force_install_dir ../${csgoFolder}" >> install_csgo.txt
	echo "app_update 740 validate" >> install_csgo.txt
	echo "quit" >> install_csgo.txt

	echo "准备安装CSGO服务器端,接下来的操作取决于网络速度(20分钟左右)."
	read -r -p "请回车继续安装, 或者按 Ctrl+C 停止安装"
	./steamcmd.sh +runscript install_csgo.txt
	echo -e "安装CSGO服务器端完成"
}

# 升级CSGO服务器端
function updateCSGO() {
	echo -e "正在写入更新CSGO服务器脚本......"
	touch update_csgo.txt
	echo "login anonymous" >> update_csgo.txt
	echo "force_install_dir ../${csgoFolder}" >> update_csgo.txt
	echo "app_update 740" >> update_csgo.txt
	echo "quit" >> update_csgo.txt
	./steamcmd.sh +runscript update_csgo.txt
	echo -e "写入更新CSGO服务器脚本完成"
}

# 配置CSGO服务器server.cfg文件
function setupCSGO() {
	echo -e "正在下载并配置server.cfg文件......"
	cd "../${csgoFolder}/csgo/cfg"
	touch server.cfg

	# 修改游戏hostname、rcon_paswword和sv_password
	read -p "请输入CSGO服务器名称(默认为Counter-Strike:Global Offensive): " hostname
	[ -z "${hostname}" ] && hostname='Counter-Strike:Global Offensive'
	echo "hostname \"${hostname}\"" >> server.cfg
	
	read -p "请输入RCON密码(用于服务器远程管理登录,默认为空): " rconPassword
	[ -z "${rconPassword}" ] && rconPassword=''
	echo "rcon_password \"${rconPassword}\"" >> server.cfg

	read -p "请输入服务器密码(用于社区服务器浏览器连接进入房间,默认为空): " svPassword
	[ -z "${svPassword}" ] && svPassword=''
	echo "sv_password \"${svPassword}\"" >> server.cfg

	read -p "请输入从steam官方申请的登录令牌(留空则需要自己配置): " steamAccount
	if [[ -n "${steamAccount}" ]]; then
		# 添加steam account信息
		echo "sv_setsteamaccount \"${steamAccount}\"" >> server.cfg
	fi

	cd "../../"
	echo -e "server.cfg文件配置完成"
}

# 安装source mod插件
function installMod() {
	read -p "需要安装MetaMode和SourceMod插件吗？[y/n]: " needmod
	case "${needmod}" in
	'y' | 'Y' )
		cd "csgo/"
		wget --no-check-certificate -O sourcemod.tar.gz https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6502-linux.tar.gz
		tar zxvf sourcemod.tar.gz
		wget --no-check-certificate -O mmsource.tar.gz https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1144-linux.tar.gz
		tar zxvf mmsource.tar.gz
		rm -f sourcemod.tar.gz
		rm -f mmsource.tar.gz
		echo -e "MetaMod和SourceMod插件安装完成"
			;;
	* )
		echo
			;;
	esac
}

# 修改权限
function chmodSteam() {
	cd "/home/${steamUser}"
	mv "${Current_Dir}/Steam/" "/home/${steamUser}/"
	mv "${Current_Dir}/.steam/" "/home/${steamUser}/"
	chown -R steamUser *
}

# 安装完成, 向用户展示安装信息
function showInfo() {
	cd Current_Dir
	clear

	echo -e "---------------安装完成-----------------"
	echo
	echo -e "你的steamcmd用户名: ${steamUser}"
	echo -e "你的steamcmd文件夹目录: /home/${steamUser}/${steamcmdFolder}"
	echo -e "你的CSGO服务器文件夹目录: /home/${steamUser}/${csgoFolder}"
	echo -e "steamcmd安装CSGO服务器脚本文件(位于${steamcmdFolder}中): install_csgo.txt"
	echo -e "steamcmd更新CSGO服务器脚本文件(位于${steamcmdFolder}中): update_csgo.txt"
	echo
	echo -e "screen已安装, 关于如何启动服务器和在游戏中连接服务器, 请访问: https://www.jianshu.com/p/b2cde3ba7908"
	echo -e "如已安装MetaMod和SourceMod, 关于如何添加各种插件, 请访问插件作者的官网。MetaMod和SourceMod安装在CSGO服务器文件夹中的: csgo/addons 中"
	echo
	echo -e "--------------------------------------"
	echo
	exit 1
}


# 安装步骤
# 检查root权限
checkRoot
# 检查系统版本
checkOS
# 安装依赖
installPackage
# 创建用户
createUser
# 安装CSGO服务器端
installCSGO
# 更新CSGO服务器端
updateCSGO
# 配置CSGO文件
setupCSGO
# 安装SourceMod
installMod
# 修改权限
chmodSteam
# 安装完成
showInfo
