# !/usr/bin/bash
# Author : Dynamic-Liu
# Email   : Dynamic-liu@outlook.com
#  ����ű����ڷ�װһЩ��������ֵĽӿ������Ҫ�ļ����ǣ�
# 1��iptables�������
# 2����װ�������õ�����
# ��ʱ��һ��ʱ�ڵ���һЩ����Ķ˿�
. AllCommon.sh

# ====================������Ϣ====================
COMMON_TCP="-s 0.0.0.0/0 -d 0.0.0.0/0 -m state --state NEW -p tcp --dport"
COMMON_UDP="-s 0.0.0.0/0 -d 0.0.0.0/0 -m state --state NEW -p UDP --dport"

# ====================End for ������Ϣ====================
# �ȼ���Ƿ���root�û�
notRootExit

# Function : getRulesByPort
# Param :
#    $1 Port ��Ӧ����Ķ˿�
#    $2 Chain ��Ӧ�Ĺ�����
#  Return:
#    ����й���ֻ���ص�һ������(����һ��Ҫע������ж��������Ҫ��֤��ѯ��Σ���Ϊɾ����ǰ�����֮��
#    ����Ĺ�����Ҳ��䣬���һ�����õ�Ҳ���������
function getRulesByPort()
{
	local port="${1}"
	local chain="${2}"
	if [ "x${port}" == "x"  -o "x${chain}" == "x" ] ; then
		showInfo 'e' "getRulesByPort �Ĳ�ѯ�˿�[${port}]��${chain}����Ϊ�գ�"
		return
	fi
	
	local result=$(iptables -nv --line-num -L ${chain} 2>/dev/null | grep  -w "${port}" 2> /dev/null | head -n 1)
	local target=
	if [ "x${result}" == "x" ] ; then
		showInfo 'e' "�ڹ�����[${chain}�����ڶ˿ں�Ϊ[${port}]�Ĺ���"
		return
	else
		target=$(echo "${result}" | awk -F ' ' '{print $1}' | xargs )
		showInfo 'i' "��ѯ���˿ں�[${port}]��Ӧ�Ĺ���[${chain}]���${target}"
	fi
	echo ${target}
}

# Function : deleteRulesWithChainNum
# Param :
#   $1 ��Ӧ�Ĺ�����
#   $2 ��Ӧ�Ĺ�������
#  Return :
#   ����ִ�н��: 0 �ɹ�������ʧ��
function deleteRulesWithChainNum()
{
	local chaint="${1}"
	local num="${2}"
	if [ "x${port}" == "x"  -o "x${chain}" == "x" ] ; then
		showInfo 'e' "deleteRulesWithChainNum �Ĺ�����[${chain}]�ͱ��${num}����Ϊ�գ�"
		return 1
	fi

	showInfo 'i' "deleteRulesWithChainNum ɾ������[$chain}],���[${num}]"
	$(iptables -D ${chain} ${num} 2>/dev/null)
	if [ $? -ne 0 ] ; then
		showInfo 'e'  "${COLOR_RED}ɾ��������ʧ�ܣ����ش�����[$ret}]!${COLOR_CLEAN}"
		return 1
	else
		showInfo 'i' "${COLOR_GRE}ɾ��������[${chain}]�ı��[${num}]�ɹ�${COLOR_CLEAN}"
		return 0
	fi
}

# Function :  addRulesWithStr
# Param :
#  $1 ��Ӧ�Ĺ���ϸ��
# Return :
#   ����ִ�н��0Ϊ�ɹ���1Ϊʧ��
function addRulesWIthStr()
{
	local cmd="${1}"
	if [  "x${cmd}" == "x" ] ; then
		showInfo 'e'  "addRulesWithStr ���ӹ���ʱ��䲻��Ϊ��!"
		return 1
	fi

	showInfo 'i' "���ӹ���[${str}]"
	local ret=
	ret=$(iptables "${str}" 2>/dev/null)
	if [ ${ret} -ne 0 ] ; then
		showInfo 'e'  "${COLOR_RED}���ӹ���ʧ�ܣ�������Ϊ[${ret}]!${COLOR_CLEAN}"
		return 1
	else
		showInfo 'i' "${COLOR_GRE}���ӹ���ɹ�!${COLOR_CLEAN}"
		return 0
	fi

	if 
}
