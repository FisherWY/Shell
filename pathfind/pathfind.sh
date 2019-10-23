#!/bin/sh
#
# 在查找路径下寻找一个或多个原始文件或文件模式
# 查找路径由特定的环境变量所定义
#
# 标准输出所产生的结果, 通常是查找路径下找到的每个文件的第一个实体的完整路径
# 或是"filename: not found"的标准错误输出
#
# 如果所有文件都找到, 则退出码为0,
# 否则, 即为找不到的文件个数(非0)
# Shell的退出码限制为125
#
# 语法: pathfind [--all] [--?] [--help] [--version] envvar pattern(s)
#
# 使用--all选项时, 在路径下的每个匹配结果都会输出
#

# 避免利用输入分割符的攻击
IFS=' '
# 防止调用欺骗软件执行脚本
OLDPATH="$PATH"
PATH=/bin:/usr/bin
export PATH

# 输出错误信息
function error() {
	echo "$@" 1>&2
	usage_and_exit 1
}

# 使用方法
function usage() {
	echo "Usage: $PROGRAM [--all] [--?] [--help] [--version] envvar pattern(s)"
}

# 输出使用方法后退出
function usage_and_exit() {
	usage
	exit $1
}

# 版本信息
function version() {
	echo "$PROGRAM version: $VERSION"
}

# 警告信息
function warning() {
	echo "$@" 1>&2
	EXITCODE=`expr $EXITCODE + 1`
}

# 初始化环境变量
all=no
envvar=
EXITCODE=0
PROGRAM="pathfind.sh"
VERSION=0.1

# 读取参数，程序入口
while test $# -gt 0; do
	case $1 in
		# all选项
		--a* | -a* )
			all=yes
			;;
		# 帮助
		--h* | -h* | '--?' | '-?' )
			usage_and_exit 0
			;;
		# 版本
		--v* | -v* )
			version
			exit 0
			;;
		# 剩余其他情况
		-* )
			error "Unrecognized option: $1"
			;;
		* )
			break
			;;
	esac
	shift
done

# 获取环境变量参数
envvar="$1"
test $# -gt 0 && shift
# 将用户输入的环境变量更新
test "x$envvar" = "xPATH" && envvar=$OLDPATH
# 将环境变量中的":"转为" "
dirpath=`eval echo "$envvar" 2>/dev/null | tr : ' '`

# 为错误情况进行监测
if test -z "$envvar"
then
	error "Environment variable missing or empty"
# elif test "x$dirpath" = "x$envvar"
# then
# 	error "Broken sh on this platform: cannot expand $envvar"
elif test -z "$dirpath"
then
	error "Empty directory search path"
elif test $# -eq 0
then
	exit 0
fi

# 查找文件
for pattern in "$@"
do
	result=
	for dir in $dirpath
	do
		for file in $dir/$pattern
		do
			if test -f "$file"
			then
				result="$file"
				echo $result
				test "$all" = "no" && break 2
			fi
		done
	done
	test -z "$result" && warning "$pattern: not found"
done

# 限制退出状态
test $EXITCODE -gt 125 && EXITCODE=125
exit $EXITCODE