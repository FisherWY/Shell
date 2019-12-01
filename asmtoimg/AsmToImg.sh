#!/bin/bash
# PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
# export PATH

# 将.asm文件转换为.img文件，输出的.img文件将放到.asm的同一文件夹下
#
# 输入的第一个参数为.asm文件位置
#
# 语法: ./AsmToImg.sh [-h] source.asm
#

PROGRAM="AsmToImg.sh"
SOURCE_FILE=""
SOURCE_FILE_NAME=""

# 使用方法
function usage() {
	echo "Usage: $PROGRAM [-h] source.asm"
	exit 0
}

# 报错信息
function error() {
	echo "$@" 1>&2
	exit 1
}

# 去掉文件扩展名
function getFileName() {
	SOURCE_FILE_NAME=${SOURCE_FILE%.asm}
}

# -* 参数
while test $# -gt 0; do
	case $1 in
		--h | -h* | '--?' | '-?' )
			usage
			;;
		-* )
			error "Unkown option: $1"
			;;
		* )
			break
			;;
	esac
done

# 源文件
if test -f $1;
then
	SOURCE_FILE=$1
	shift
else
	error "目标文件没有找到"
fi

# 检查依赖工具
if [ ! -x "$(command -v nasm)" ]; then
	error "nasm未安装或未配置环境变量,请检查相关配置"
fi
if [ ! -x "$(command -v dd)" ]; then
	error "dd未安装,请检查安装情况"
fi

# 去掉源文件扩展名
getFileName
# 将.asm文件编译为.bin文件
echo "正在将.asm文件编译为.bin文件"
nasm "$SOURCE_FILE" -o "$SOURCE_FILE_NAME.bin"
# 将.bin文件写入为.img文件
echo "正在将.bin文件写入为.img文件"
dd if="$SOURCE_FILE_NAME.bin" of="$SOURCE_FILE_NAME.img"
# 删除.bin文件
echo "删除.bin文件"
rm "$SOURCE_FILE_NAME.bin"
echo "转换完成"
exit 0