#!/bin/bash
#功能描述(Description):使用guestfish工具修改虚拟机网卡配置文件.
#脚本在不启动登陆虚拟机的情况下,直接修改虚拟机网卡的配置文件.

read -p "请输入需要编辑的虚拟机名称:" vname

#测试虚拟机是否为正在运行状态.
if virsh domstate $vname | grep -q running ;then
    echo "修改虚拟机网卡配置,请先关闭虚拟机."
    exit
fi

#创建挂载点,测试挂载点是否正在被其他程序使用.
mountpint="/media/$vname"
[ ! -d $mountpint ] && mkdir -p $mountpint
if mount | grep -q "$mountpint";then
    umount $mountpint
fi

#使用guestmount命令将虚拟机文件系统挂载到真实主机.
echo "请稍后..."
guestmount -i -d $vname $mountpint

#读取必要的配置文件参数.
vpath="etc/sysconfig/network-scripts/"
read -p "请输入需要编辑的网卡名称:" devname
if [ ! -f $mountpint/$vpath/ifcfg-$devname ];then
    echo "未找到${devname}网卡配置文件"
    exit
fi
read -p "请输入IP地址与子网掩码(如:192.168.4.1/24):" addr
ipaddr=$(echo $addr | cut -d/ -f1)
netmask=$(echo $addr | cut -d/ -f2)
read -p "请输入默认网关:" gateway
read -p "请输入DNS:" dns

#修改网卡配置文件.
sed -i '/BOOTPROTO/c BOOTPROTO=static' $mountpint/$vpath/ifcfg-$devname
sed -i '/ONBOOT/c ONBOOT=yes' $mountpint/$vpath/ifcfg-$devname
#修改IP地址.
if grep -q IPADDR $mountpint/$vpath/ifcfg-$devname;then
    sed -i "/IPADDR/c IPADDR=$ipaddr" $mountpint/$vpath/ifcfg-$devname
else
    echo "IPADDR=$ipaddr" >> $mountpint/$vpath/ifcfg-$devname
fi
#修改子网掩码.
if grep -q PREFIX $mountpint/$vpath/ifcfg-$devname;then
    sed -i "/PREFIX/c PREFIX=$netmask" $mountpint/$vpath/ifcfg-$devname
else
    echo "PREFIX=$netmask" >> $mountpint/$vpath/ifcfg-$devname
fi
#修改默认网关.
if grep -q GATEWAY $mountpint/$vpath/ifcfg-$devname;then
    sed -i "/GATEWAY/c GATEWAY=$gateway" $mountpint/$vpath/ifcfg-$devname
else
    echo "GATEWAY=$gateway" >> $mountpint/$vpath/ifcfg-$devname
fi
#修改DNS服务器.
if grep -q DNS $mountpint/$vpath/ifcfg-$devname;then
    sed -i "/DNS/c DNS1=$dns" $mountpint/$vpath/ifcfg-$devname
else
    echo "DNS1=$dns" >> $mountpint/$vpath/ifcfg-$devname
fi

#取消文件系统挂载.
guestunmount $mountpint
