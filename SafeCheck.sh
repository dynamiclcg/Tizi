# !/usr/bin/bash
# Author : Dynamic-Liu
# Email   : Dynamic-Liu@outlook.com
# 这个脚本主要方便拿到vps之后，对vps进行安全加固，避免被暴力破解影响安全
# 1、检查是否有暴力破解情况
# 2、确认有暴力破解后需要进行相应的修改和处理
# 确认处理完了之后可以进行其他操作

# 设置一些常用的颜色用于后面输出
COLOR_RED="\e[31m"
COLOR_GRE="\e[32m"
COLOR_CLEAN="\e[0m"
COLOR_RED_FLUSH="\e[31;5m"
COLOR_GRE_FLUSH="\e[32;5m"

# if [ "x${EUID}" != "x0" ] ; then
# echo -e "${COLOR_RED_FLUSH}当前脚本必须用root用户执行脚本！！！${COLOR_CLEAN}"
# exit 1
# fi

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
	    echo "[ error ] ${str}"
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

# Function : checkBrute
# Parm : NULL  不需要参数
# Return : True 有迹象，并输出对应有问题的IP, False 无迹象
# function checkBrute()
checkBrute()
{
    local result=1
    local info=`lastb | head -n 50 `
    showInfo t "BruteTry"
    local count=`echo ${info} | wc -l`
    if [ ${count} -lt 3 ] ; then
		showInfo 'i' ""
		showInfo 'p'
		return 
    fi

    local ips=`echo "${info}" |  awk -F ' ' '{print $1}' | sort | uniq`
    showInfo 'e' "尝试暴力破解的用户ip如下:"
    for i in `echo "ips"`
    do
		echo -e "${COLOR_RED}${i}${COLOR_CLEAN}"
    done
    showInfo 'f'
}

# Function : showHelp
# Param : NULL
# Return : NULL
function showHelp()
{
"$0 Usage:
    -c  检查是否被暴力破解过
    -h  用法帮助
    -s  保留接口，后续要做一键设置ssh服务的接口
"
}

function main()
{
    while getopts chs: OPT; do
	case $OPT in
	    c|+c)
		checkBrute
		;;
	    s|+s)
		;;
	    h|+h)
		showHelp
		;;
	    *)
		showHelp
		exit 2
	esac
    done
}

main $@
