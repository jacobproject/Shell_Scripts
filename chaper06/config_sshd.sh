#!/bin/bash
#功能描述(Description):修改SSHD配置文件,提升SSH安全性.

config_file="/etc/ssh/sshd_config"
PORT=12345

#将默认端口号修改为自定义端口号.
if grep -q "^Port" $config_file;then
    sed -i "/^Port/c Port $PORT" $config_file
else
    echo "Port $PORT" >> $config_file
fi

#禁止root远程登陆SSH服务器.
if grep -q "^PermitRootLogin" $config_file;then
    sed -i '/^PermitRootLogin/s/yes/no/' $config_file
else
    sed -i '$a PermitRootLogin no' $config_file
fi

#禁止使用密码远程登陆SSH服务器.
if grep -q "^PasswordAuthentication" $config_file;then
    sed -i '/^PasswordAuthentication/s/yes/no/' $config_file
else
    sed -i '$a PasswordAuthentication no' $config_file
fi

#禁止X11图形转发功能.
if grep -q "^X11Forwarding" $config_file;then
    sed -i '/^X11Forwarding/s/yes/no/' $config_file
else
    sed -i '$a X11Forwarding no' $config_file
fi

#禁止DNS查询.
if grep -q "^UseDNS" $config_file;then
    sed -i '/^UseDNS/s/yes/no/' $config_file
else
    sed -i '$a UseDNS no' $config_file
fi

