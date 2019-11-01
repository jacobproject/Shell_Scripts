#!/bin/bash
#描述信息：本脚本主要目的是获取主机的数据信息（内存、网卡IP、CPU负载）

localip=$(ifconfig eth0 | grep netmask | tr -s " " | cut -d" " -f3)
mem=$(free |grep Mem |tr -s " " | cut -d" " -f7)
cpu=$(uptime | tr -s " " | cut -d" " -f13)
echo "本机IP地址是:$localip"
echo "本机内存剩余容量为:$mem"
echo "本机CPU 15分钟的平均负载为:$cpu"
