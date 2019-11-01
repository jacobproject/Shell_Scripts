#!/bin/bash
#功能描述(Description):一键安装部署DHCP服务.

#定义变量:显示信息的颜色属性及配置文件路径.
SUCCESS="echo -en \\033[1;32m"   #绿色.
FAILURE="echo -en \\033[1;31m"   #红色.
WARNING="echo -en \\033[1;33m"   #黄色.
NORMAL="echo -en \\033[0;39m"    #黑色.
conf_file=/etc/dhcp/dhcpd.conf

#测试YUM源是否可用.
test_yum(){
    num=$(yum repolist | tail -1 | sed  's/.*: *//;s/,//')
    if [ $num -le 0 ];then
        $FAILURE
        echo "没有可用的Yum源."
        $NORMAL
        exit
    else
        if ! yum list dhcp &> /dev/null ;then
            $FAILURE
            echo "Yum源中没有dhcp软件包."
            $NORMAL
            exit
        fi
    fi
}

#安装部署dhcp软件包.
install_dhcp(){
    #如果软件包已经安装则提示警告信息并退出脚本.
    if rpm -q dhcp &> /dev/null ;then
        $WARNING
        echo "dhcp已安装."
        $NORMAL
        exit
    else
        yum -y install dhcp
    fi
}


#修改dhcp配置文件.
modify_conf(){
    #拷贝模板配置文件.
    /bin/cp -f /usr/share/doc/dhcp*/dhcpd.conf.example /etc/dhcp/dhcpd.conf
    sed -i '/10.152.187.0/{N;d}' $conf_file   #删除多余配置,通过N读取多行,然后d删除.
    sed -i '/10.254.239.0/,+3d' $conf_file    #删除多余配置,通过正则匹配某行以及之后的3行都删除.
    sed -i '/10.254.239.32/,+4d' $conf_file   #删除多余配置,正则匹配某行以及后面的4行都删除.
    sed -i "s/10.5.5.0/$subnet/" $conf_file   #设置DHCP网段.
    sed -i "s/255.255.255.224/$netmask/" $conf_file #设置DHCP网段的子网掩码.
    sed -i "s/10.5.5.26/$start/" $conf_file   #设置DHCP为客户端分配的IP地址池起始IP.
    sed -i "s/10.5.5.30/$end/" $conf_file     #设置DHCP为客户端分配的IP地址池结束IP.
    sed -i "s/ns1.internal.example.org/$dns/" $conf_file  #设置为客户端分配的DNS.
    sed -i '/internal.example.org/d' $conf_file #删除多余的配置行.
    sed -i "/routers/s/10.5.5.1/$router/" $conf_file #设置为客户端分配的默认网关.
    sed -i '/broadcast-address/d' $conf_file  #删除多余的配置行.
}


test_yum      #调用函数,测试yum源.
install_dhcp  #调用函数,安装软件包.

#读取必要的配置参数.
echo -n "请输入DHCP网段(如:192.168.4.0):"
$SUCCESS
read subnet
$NORMAL
echo -n "请输入DHCP网段的子网掩码(如:255.255.255.0):"
$SUCCESS
read netmask
$NORMAL
echo -n "请输入为客户端分配的地址池(如:192.168.4.1-192.168.4.10):"
$SUCCESS
read pools
$NORMAL
echo -n "请输入为客户端分配的默认网关:"
$SUCCESS
read router
$NORMAL
echo -n "请输入为客户端分配的DNS服务器:"
$SUCCESS
read dns
$NORMAL
start=$(echo $pools | cut -d- -f1)     #获取起始IP.
end=$(echo $pools | cut -d- -f2)       #获取结束IP.

modify_conf   #调用函数,修改配置文件.

#重启服务.
systemctl restart dhcpd  &>/dev/null
if [ $? -eq 0 ];then
    $SUCCESS
    echo "部署配置DHCP完毕."
else
    $FAILURE
    echo "部署配置DHCP失败,通过 journalctl -xe查看日志."
fi
$NORMAL
