#!/bin/bash
#功能描述(Description):快速克隆虚拟机脚本.
#使用qemu-img工具基于虚拟机后端模板磁盘创建前端盘,
#使用cp拷贝XML描述文件,通过sed工具修改XML文件.

#定义错误返回码(exit code): 
#    65 -> can't found base vm image.
#    66 -> can't found base vm.
#    67 -> vm disk image already exist.
#    68 -> vm's XML file already exist.
#    69 -> vm name already exist.

#定义变量:镜像存储路径,后端模板虚拟机名称,已存在虚拟机列表.
IMG_DIR="/var/lib/libvirt/images"
XML_DIR="/etc/libvirt/qemu"
BASE_VM="centos7.5_6"
exist_vm=$(virsh list --name --all)

#定义变量:显示信息的颜色属性.
SUCCESS="echo -en \\033[1;32m"   #绿色.
FAILURE="echo -en \\033[1;31m"   #红色.
WARNING="echo -en \\033[1;33m"   #黄色.
NORMAL="echo -en \\033[0;39m"    #黑色.


#测试后端模板虚拟机镜像文件是否存在.
if [[ ! -e ${IMG_DIR}/${BASE_VM}.qcow2 ]];then
    $FAILURE
    echo "找不到后端模板虚拟机镜像文件$IMG_DIR/${BASE_VM}.qcow2."
    $NORMAL
    exit 65
fi

#测试后端模板虚拟机XML文件是否存在.
if [[ ! -e ${XML_DIR}/centos7.5_6.xml ]];then 
        $FAILURE
        echo "后端模板虚拟机${BASE_VM}.xml文件不存在."
        $NORMAL
        exit 66
fi

read -p "请输入新克隆的虚拟机名称:" newvm

#测试虚拟机镜像文件是否已经存在.
if [[ -e $IMG_DIR/$newvm.qcow2 ]];then
    $FAILURE
    echo "${IMG_DIR}/${newvm}.qcow2虚拟机镜像文件已存在."
    $NORMAL
    exit 67
fi

#测试虚拟机的XML文件是否已经存在.
if [[ -e ${XML_DIR}/${newvm}.xml ]];then 
        $FAILURE
        echo "虚拟机${newvm}.xml文件已存在."
        $NORMAL
        exit 68
fi

#测试虚拟机名称是否已经存在.
for i in $exist_vm
do
    if [[ "$newvm" ==  "$i" ]];then
        $FAILURE
        echo "名称为${newvm}的虚拟机已经存在."
        $NORMAL
        exit 69
    fi
done

#使用qemu-img克隆虚拟机镜像文件.
echo -en "Creating a new virtual machine disk image...\t"
qemu-img create -f qcow2 -b ${IMG_DIR}/${BASE_VM}.qcow2  ${IMG_DIR}/${newvm}.qcow2 &>/dev/null
$SUCCESS
echo "[OK]"
$NORMAL

#克隆XML文件.
virsh dumpxml $BASE_VM > ${XML_DIR}/${newvm}.xml
#生成随机UUID.
UUID=$(uuidgen)
#修改XML文件中的UUID.
sed -i "/<uuid>/c <uuid>$UUID</uuid>" ${XML_DIR}/${newvm}.xml
#修改XML文件中的虚拟机名称.
sed -i "/<name>/c <name>$newvm</name>" ${XML_DIR}/${newvm}.xml
#修改XML文件中虚拟机对应的磁盘镜像文件.
sed -i "s#${IMG_DIR}/${BASE_VM}\.qcow2#${IMG_DIR}/${newvm}.qcow2#" ${XML_DIR}/${newvm}.xml
#获取XML文件中的MAC地址列表.
mac=$(sed -rn "s/<mac address=(.*)\/>/\1/p" ${XML_DIR}/${newvm}.xml)
#使用循环将所有MAC地址修改为新的随机MAC地址.
pools="0123456789abcdef"
for i in $mac
do
    new_mac="52:54:00"
    for j in {1..3}
    do
        tmp1=${pools:$[RANDOM%16]:1}
        tmp2=${pools:$[RANDOM%16]:1}
        new_mac=${new_mac}:${tmp1}${tmp2}
    done
    sed -i "s/$i/'$new_mac'/" ${XML_DIR}/${newvm}.xml
done

#使用新的XML文件定义虚拟机.
echo -en "Defining a new virtual machine...\t\t"
virsh define ${XML_DIR}/${newvm}.xml &>/dev/null
if [ $? -eq 0 ];then
$SUCCESS
echo "[OK]"
$NORMAL
fi
