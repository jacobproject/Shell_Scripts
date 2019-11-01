#!/bin/bash
#功能描述(Description):编写脚本修改Linux内核启动参数.

#使用传统的eth0,eth1风格的网卡名称.
sed -i '/CMDLINE/s/"/ biosdevname=0 net.ifnames=0"/2' /etc/default/grub

#禁用SELinux.
sed -i '/CMDLINE/s/"/ selinux=0"/2' /etc/default/grub

#开启内存大页(HugePage),调整大页容量为4M,大页个数为100个.
#可以/proc/meminfo查看大页的信息.
sed -i '/CMDLINE/s/"/ hugepagesz=4M hugepages=100"/2' /etc/default/grub

#禁用IPv6网络.
sed -i '/CMDLINE/s/"/ ipv6.disable=1"/2' /etc/default/grub

#配置Grub密码:用户名(root),密码(123456).
#手动执行grub2-mkpasswd-pbkdf2获取密码的加密信息,然后将密码写入grub配置文件.
#下面是123456的密文信息.
#grub.pbkdf2.sha512.10000.BE5B2CAB43F2F513ED696C5EB15A8072F0744F123CBA0C16C4285C80507E1192236EFB3CBF21A23D384F1C63AD65DCEE1676ECE5A8DB065741E3CBD58E9C256F.163A3FF46D1935CB9A08FC42FCCC7285E34B789CC006B94195DF42EC53458277C1BBA6A26BD8460C15E6986001EBE10F5F3D6F81E4ED8893AACBFE3351F3A85F
echo '#!/bin/sh -e
cat << EOF
    set superusers="root"
    export superusers
    password_pbkdf2 root grub.pbkdf2.sha512.10000.BE5B2CAB43F2F513ED696C5EB15A8072F0744F123CBA0C16C4285C80507E1192236EFB3CBF21A23D384F1C63AD65DCEE1676ECE5A8DB065741E3CBD58E9C256F.163A3FF46D1935CB9A08FC42FCCC7285E34B789CC006B94195DF42EC53458277C1BBA6A26BD8460C15E6986001EBE10F5F3D6F81E4ED8893AACBFE3351F3A85F
EOF' > /etc/grub.d/01_users

#利用grub2-mkconfig生成新的grub配置文件/boot/grub2/grub.cfg.
grub2-mkconfig -o /boot/grub2/grub.cfg
