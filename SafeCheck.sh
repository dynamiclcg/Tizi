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

# Function : checkBrute
# Parm : NULL  不需要参数
# Return : 1 有迹象，并输出对应有问题的IP, 0 无迹象
# function checkBrute()
function checkBrute()
{
    local result=1
    local info=`lastb | head -n 50 `
<<<<<<< HEAD
    local count=`echo ${info} | wc -l`
=======
    local count=`echo "${info}" | wc -l`
>>>>>>> feature_brute
    if [ ${count} -lt 3 ] ; then
		showInfo 'i' "无大量密码爆破尝试记录"
		return 0
    fi

    local ips=`echo "${info}" |  awk -F ' ' '{print $1 $3}' | sort | uniq`
    showInfo 'e' "尝试暴力破解的用户ip如下:"
    for i in `echo "ips"`
    do
		echo -e "${COLOR_RED}${i}${COLOR_CLEAN}"
    done
	return 1 
<<<<<<< HEAD
}

# Function : checkSshPort
# Param    : NULL
# Return   : 1 需要修改，0不需要修改
function checkSshPort()
{
	local result=0
	# 端口确认：
	local gport=`grep Port /etc/ssh/sshd_config 2>/dev/null -w | grep -v \# | awk -F ' ' '{print $2}'`
	if [ "x${gport}" == "x" ] ; then
		showInfo 'e' "${COLOR_RED}没有ssh的端口设置信息${COLOR_CLEAN}"
		result=1
	fi

	if [ ${gport} -eq 22 ] ; then
		showInfo 'e' "${COLOR_RED}还是用的默认端口22${COLOR_CLEAN}"
		result=1
	else
		showInfo 'i' "使用的ssh端口为:${gport}"
	fi
	return ${result}
}

=======
}

# Function : checkSshPort
# Param    : NULL
# Return   : 1 需要修改，0不需要修改
function checkSshPort()
{
	local result=0
	# 端口确认：
	local gport=`grep Port /etc/ssh/sshd_config 2>/dev/null -w | grep -v \# | awk -F ' ' '{print $2}'`
	if [ "x${gport}" == "x" ] ; then
		showInfo 'e' "没有ssh的端口设置信息，用的是默认端口22，建议修改！"
		# 没端口的话不向下执行了
		result=1				# 规范下，免得后续更新，这里是有问题的还是直接通过了
		return  ${result}
	fi

	if [ ${gport} -eq 22 ] ; then
		showInfo 'e' "还是用的默认端口22"
		result=1
	else
		showInfo 'i' "使用的ssh端口为:${gport}"
	fi
	return ${result}
}

>>>>>>> feature_brute
# Function : checkSshPasswdLogin
# Param : NULL
# Return : 1 还是在启用密码登录，0已经禁用密码登录
function checkSshPasswdLogin()
{
	local result=0
	# 端口确认：
	local gport=`grep PasswordAuthentication /etc/ssh/sshd_config 2>/dev/null -w | grep -v \# | awk -F ' ' '{print $1}'`
	if [ "x${gport}" == "x" ] ; then
<<<<<<< HEAD
		showInfo 'e' "${COLOR_RED}没有ssh的密码登录设置信息${COLOR_CLEAN}"
=======
		showInfo 'e' "没有ssh的密码登录设置信息"
>>>>>>> feature_brute
		result=1
	fi

	if [ "x${gport}" == "xon" ] ; then
<<<<<<< HEAD
		showInfo 'e' "${COLOR_RED}启用了远程密码登录，有爆破危险!${COLOR_CLEAN}"
=======
		showInfo 'e' "启用了远程密码登录，有爆破危险!"
>>>>>>> feature_brute
		result=1
	else
		showInfo 'i' "未启用远程密码登录，无威胁！"
	fi
	# 其实还可以检查下是否启用了root的远程登录正常情况下root的远程登录也是有问题的
	# 但是如果没开密码登录，风险也小点，默认推荐只开密钥登录的功能
	return ${result}
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
例如：
    Bash SaveCheck.sh -c 即可检查相应的暴力破解登录信息
"
}

function main()
{
	local result=0
    while getopts chs: OPT; do
	case $OPT in
	    c|+c)
			echo "==================== 开始检查服务 ===================="
			showInfo "t" "暴力破解记录"
			checkBrute
			if [ $? -ne 0 ] ; then
				showInfo "f"
				result=$((${result}+1))
			else
				showInfo "p"
			fi

			showInfo "t" "SSH端口设置"
			checkSshPort
			if [ $? -ne 0 ] ; then
				showInfo "f"
				result=$((${result}+1))
			else
				showInfo "p"
			fi

			showInfo "t" "SSH密码登录"
			checkSshPasswdLogin
			if [ $? -ne 0 ] ; then
				showInfo "f"
				result=$((${result}+1))
			else
				showInfo "p"
			fi

			echo "检查项完成！检查结果："
			if [ $result -eq 0 ] ; then
				echo -e "${COLOR_GRE_FLUSH}检查完毕，所有项检查正常！${COLOR_CLEAN}"
			else
<<<<<<< HEAD
				echo -e "${COLOR_RED_FLUSH}检查完毕，存在${result}项漏洞，建议处理！"
=======
				echo -e "${COLOR_RED_FLUSH}检查完毕，存在${result}项漏洞，建议处理！${COLOR_CLEAN}"
>>>>>>> feature_brute
			fi
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
