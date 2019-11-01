#!/bin/bash
#注意:案例中操作对象用的都是常量，实际编写脚本时很多应该是变量。

if ! mkdir "/media/cdrom"
then
    echo "failed to create cdrom directory."
fi
if ! yum -y -q install ABC
then
    echo "failed to install soft."
fi

