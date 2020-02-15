# !/usr/bin/bash
# Author : Dynamic-Liu
# Email  : Dynamic-Liu@outlook.com
#  封装一些常用的命令，避免一些管理脚本重复写通用命令

# ====================常量定义====================
# 设置一些常用的颜色用于后面输出
COLOR_RED="\e[31m"
COLOR_GRE="\e[32m"
COLOR_CLEAN="\e[0m"
COLOR_RED_FLUSH="\e[31;5m"
COLOR_GRE_FLUSH="\e[32;5m"
# ====================END for 常量定义====================


# Function: isRoot
# Param: NULL
# Return :  0 代表是，其他代表不是
function isRoot()
{
	if [ "x${EUID}" != "x0" ] ; then
		return 1
	fi
	return 0
}

# Function : notRootExit
# Param : NULL
# Return : NULL
#  封装下检查是否是root的这个脚本，避免很多都要写这个
function notRootExit()
{
	isRoot
	if [ $? -ne 0 ] ; then
		showInfo 'e' "${COLOR_RED_FLUSH}当前脚本必须用root用户执行脚本！！！${COLOR_CLEAN}"
		exit 1
	fi
}

# Function : showInfo
# Param :
#    $1 type  t检查项，i正常输出，e错误数据
#    $2 str     输出的数据
# Return : NULL
function showInfo()
{
    local type="$1"
    local str="$2"
    if [ "x${type}" == "x"  ] ; then
	echo -e "${COLOR_RED_FLUSH}输出内容异常！${COLOR_CLEAN}"
	return
	fi
    case ${type} in
	't')
	    # 输出检查项内容
	    echo -e "========》检查项：${COLOR_GRE}${str}${COLOR_CLEAN}"
	    ;;
	'i')
	    echo "[ info ] ${str}"
	    ;;
	'p')
	    echo -e "检查结果：${COLOR_GRE}PASS${COLOR_CLEAN}"
	    echo 
	    ;;
	'f')
	    echo -e "检查结果：${COLOR_RED}FAIL${COLOR_CLEAN}"
	    echo 
	    ;;
	'e')
	    echo  "[ error ] ${str}"
	    ;;
	*)
	    esac
}

# Simple test for show Function
# function testShowInfo()
# {
#     showInfo t "lcg"
#     showInfo i "info"
#     showInfo e "wrong"
#     showInfo p
#     showInfo f
# }
