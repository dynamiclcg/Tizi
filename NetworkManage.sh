# !/usr/bin/bash
# Author : Dynamic-Liu
# Email   : Dynamic-liu@outlook.com
#  这个脚本用于封装一些网络管理部分的接口命令，主要的几类是：
# 1、iptables规则管理
# 2、封装几个常用的命令
# 定时隔一段时期调整一些服务的端口
. AllCommon.sh

# ====================常量信息====================
COMMON_TCP="-s 0.0.0.0/0 -d 0.0.0.0/0 -m state --state NEW -p tcp --dport"
COMMON_UDP="-s 0.0.0.0/0 -d 0.0.0.0/0 -m state --state NEW -p UDP --dport"

# ====================End for 常量信息====================
# 先检查是否是root用户
notRootExit

# Function : getRulesByPort
# Param :
#    $1 Port 对应规则的端口
#    $2 Chain 对应的规则链
#  Return:
#    如果有规则只返回第一个规则(这里一定要注意如果有多个规则，需要保证查询多次，因为删除了前面规则之后
#    后面的规则编号也会变，这个一次性拿到也是有问题的
function getRulesByPort()
{
	local port="${1}"
	local chain="${2}"
	if [ "x${port}" == "x"  -o "x${chain}" == "x" ] ; then
		showInfo 'e' "getRulesByPort 的查询端口[${port}]和${chain}不可为空！"
		return
	fi
	
	local result=$(iptables -nv --line-num -L ${chain} 2>/dev/null | grep  -w "${port}" 2> /dev/null | head -n 1)
	local target=
	if [ "x${result}" == "x" ] ; then
		showInfo 'e' "在规则链[${chain}不存在端口号为[${port}]的规则！"
		return
	else
		target=$(echo "${result}" | awk -F ' ' '{print $1}' | xargs )
		showInfo 'i' "查询到端口号[${port}]对应的规则[${chain}]编号${target}"
	fi
	echo ${target}
}

# Function : deleteRulesWithChainNum
# Param :
#   $1 对应的规则名
#   $2 对应的规则链号
#  Return :
#   命令执行结果: 0 成功，其他失败
function deleteRulesWithChainNum()
{
	local chaint="${1}"
	local num="${2}"
	if [ "x${port}" == "x"  -o "x${chain}" == "x" ] ; then
		showInfo 'e' "deleteRulesWithChainNum 的规则链[${chain}]和编号${num}不可为空！"
		return 1
	fi

	showInfo 'i' "deleteRulesWithChainNum 删除规则[$chain}],编号[${num}]"
	$(iptables -D ${chain} ${num} 2>/dev/null)
	if [ $? -ne 0 ] ; then
		showInfo 'e'  "${COLOR_RED}删除规则链失败，返回错误码[$ret}]!${COLOR_CLEAN}"
		return 1
	else
		showInfo 'i' "${COLOR_GRE}删除规则链[${chain}]的编号[${num}]成功${COLOR_CLEAN}"
		return 0
	fi
}

# Function :  addRulesWithStr
# Param :
#  $1 对应的规则细节
# Return :
#   命令执行结果0为成功，1为失败
function addRulesWIthStr()
{
	local cmd="${1}"
	if [  "x${cmd}" == "x" ] ; then
		showInfo 'e'  "addRulesWithStr 增加规则时语句不可为空!"
		return 1
	fi

	showInfo 'i' "增加规则[${str}]"
	local ret=
	ret=$(iptables "${str}" 2>/dev/null)
	if [ ${ret} -ne 0 ] ; then
		showInfo 'e'  "${COLOR_RED}增加规则失败，错误码为[${ret}]!${COLOR_CLEAN}"
		return 1
	else
		showInfo 'i' "${COLOR_GRE}增加规则成功!${COLOR_CLEAN}"
		return 0
	fi

	if 
}
