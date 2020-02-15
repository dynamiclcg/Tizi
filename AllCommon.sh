# !/usr/bin/bash
# Author : Dynamic-Liu
# Email  : Dynamic-Liu@outlook.com
#  ��װһЩ���õ��������һЩ����ű��ظ�дͨ������

# ====================��������====================
# ����һЩ���õ���ɫ���ں������
COLOR_RED="\e[31m"
COLOR_GRE="\e[32m"
COLOR_CLEAN="\e[0m"
COLOR_RED_FLUSH="\e[31;5m"
COLOR_GRE_FLUSH="\e[32;5m"
# ====================END for ��������====================


# Function: isRoot
# Param: NULL
# Return :  0 �����ǣ�����������
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
#  ��װ�¼���Ƿ���root������ű�������ܶ඼Ҫд���
function notRootExit()
{
	isRoot
	if [ $? -ne 0 ] ; then
		showInfo 'e' "${COLOR_RED_FLUSH}��ǰ�ű�������root�û�ִ�нű�������${COLOR_CLEAN}"
		exit 1
	fi
}

# Function : showInfo
# Param :
#    $1 type  t����i���������e��������
#    $2 str     ���������
# Return : NULL
function showInfo()
{
    local type="$1"
    local str="$2"
    if [ "x${type}" == "x"  ] ; then
	echo -e "${COLOR_RED_FLUSH}��������쳣��${COLOR_CLEAN}"
	return
	fi
    case ${type} in
	't')
	    # ������������
	    echo -e "========������${COLOR_GRE}${str}${COLOR_CLEAN}"
	    ;;
	'i')
	    echo "[ info ] ${str}"
	    ;;
	'p')
	    echo -e "�������${COLOR_GRE}PASS${COLOR_CLEAN}"
	    echo 
	    ;;
	'f')
	    echo -e "�������${COLOR_RED}FAIL${COLOR_CLEAN}"
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
