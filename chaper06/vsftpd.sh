#!/bin/bash
#功能描述(Description):自动部署配置vsftpd服务器,管理FTP服务器,针对RHEL|CentOS系统.
#本地账户访问FTP的共享目录为/common,其中/common/pub为可上传目录.
#匿名账户访问FTP的共享目录为/var/ftp,其中/var/ftp/pub为可上传目录.

#定义变量:显示信息的颜色属性及配置文件路径.
SUCCESS="echo -en \\033[1;32m"   #绿色.
FAILURE="echo -en \\033[1;31m"   #红色.
WARNING="echo -en \\033[1;33m"   #黄色.
NORMAL="echo -en \\033[0;39m"    #黑色.
conf_file=/etc/vsftpd/vsftpd.conf

#####从这里开始先将所有需要的功能定义为函数.#####
#定义脚本的主菜单功能.
menu(){
    clear
    echo "-----------------------------------"
    echo "#          菜单(Menu)             #"
    echo "-----------------------------------"
    echo "# 1.安装配置vsftpd.               #"
    echo "# 2.创建FTP账户.                  #"
    echo "# 3.删除FTP账户.                  #"
    echo "# 4.配置匿名账户.                 #"
    echo "# 5.启动关闭vsftpd.               #"
    echo "# 6.退出脚本.                     #"
    echo "-----------------------------------"
    echo
}

#定义配置匿名账户的子菜单.
anon_sub_menu(){
    clear
    echo "-----------------------------------"
    echo "#      匿名配置子菜单(Menu)       #"
    echo "-----------------------------------"
    echo "# 1.禁用匿名账户.                 #"
    echo "# 2.启用匿名登陆.                 #"
    echo "# 3.允许匿名账户上传.             #"
    echo "-----------------------------------"
    echo
}

#定义服务管理的子菜单.
service_sub_menu(){
    clear
    echo "-----------------------------------"
    echo "#       服务管理子菜单(Menu)      #"
    echo "-----------------------------------"
    echo "# 1.启动vsftpd.                   #"
    echo "# 2.关闭vsftpd.                   #"
    echo "# 3.重启vsftpd.                   #"
    echo "-----------------------------------"
    echo
}

#测试YUM是否可用.
test_yum(){
    num=$(yum repolist | tail -1 | sed  's/.*: *//;s/,//')
    if [ $num -le 0 ];then
        $FAILURE
        echo "没有可用的Yum源."
        $NORMAL
        exit
    else
        if ! yum list vsftpd &> /dev/null ;then
            $FAILURE
            echo "Yum源中没有vsftpd软件包."
            $NORMAL
            exit
        fi
    fi
}

#安装部署vsftpd软件包.
install_vsftpd(){
#如果软件包已经安装则提示警告信息并退出脚本.
    if rpm -q vsftpd &> /dev/null ;then
        $WARNING
        echo "vsftpd已安装."
        $NORMAL
        exit
    else
        yum -y install vsftpd
    fi
}

#修改初始化配置文件.
init_config(){
#备份配置文件.
    [ ! -e $conf_file.bak ] && cp $conf_file{,.bak}

#为本地账户创建共享目录/common,修改配置文件指定共享根目录.
    [ ! -d /common/pub ] && mkdir -p /common/pub
    chmod a+w /common/pub
    grep -q local_root $conf_file || sed -i '$a local_root=/common' $conf_file

#默认客户端通过本地账户访问FTP时
#允许使用cd命令跳出共享目录,可以看到/etc等系统目录及文件.
#通过设置chroot_local_user=YES可以将账户禁锢在自己的家目录,无法进入其他目录.
    sed -i 's/^#chroot_local_user=YES/chroot_local_user=YES/' $conf_file
}

#创建FTP账户,如果账户已存在则直接退出脚本.
create_ftpuser(){
    if id $1 &> /dev/null ;then
        $FAILURE
        echo "$1账户已存在."
        $NORMAL
        exit
    else
        useradd $1
        echo "$2" | passwd --stdin $1 &>/dev/null
    fi
}

#删除FTP账户,如果账户不存在则直接退出脚本.
delete_ftpuser(){
    if ! id $1 &> /dev/null ;then
        $FAILURE
        echo "$1账户不存在."
        $NORMAL
        exit
    else
        userdel $1
    fi
}

#配置匿名账户.
#第一个位置参数为1则将匿名账户禁用.
#第一个位置参数为2则开启匿名账户登陆功能.
#第一个位置参数为3则设置允许匿名账户上传文件.
anon_config(){ 
    if [ ! -f $conf_file ];then
        $FAILURE
        echo "配置文件不存在."
        $NORMAL
        exit
    fi
#设置anonymous_enable=YES可以开启匿名登陆功能,默认为开启状态.
#设置anonymous_enable=NO可以禁止匿名登陆功能.
#设置anon_upload_enable=YES可以允许匿名上传文件,默认该配置被注释.
#设置anon_mkdir_write_enable=YES可以允许匿名账户创建目录,默认该配置被注释.
case $1 in
1)
    sed -i 's/anonymous_enable=YES/anonymous_enable=NO/' $conf_file
    systemctl restart vsftpd;;
2)
    sed -i 's/anonymous_enable=NO/anonymous_enable=YES/' $conf_file
    systemctl restart vsftpd;;
3)
    sed -i 's/^#anon_/anon_/' $conf_file
    chmod a+w /var/ftp/pub
    systemctl restart vsftpd;;
esac
}

#服务管理.
#第一个位置参数为start时启动vsftpd服务.
#第一个位置参数为stop时关闭vsftpd服务.
#第一个位置参数为restart时重启vsftpd服务.
proc_manager(){
    if ! rpm -q vsftpd &>/dev/null ;then
        $FAILURE
        echo "未安装vsftpd软件包."
        $NORMAL
        exit
    fi
case $1 in
start)
    systemctl start vsftpd;; 
stop)
    systemctl stop vsftpd;; 
restart)
    systemctl restart vsftpd;; 
esac
}


######从这里开始调用前面定义的函数.#####
menu
read -p "请输入选项[1-6]:" input
case $input in
1)
    test_yum           #测试yum源.
    install_vsftpd     #安装vsftpd软件包.
    init_config;;      #初始化修改配置文件.
2) 
    read -p "请输入账户名称:" username
    read -s -p "请输入账户密码:" password
    echo
    create_ftpuser $username $password;;   #创建FTP账户.
3)
    read -p "请输入账户名称:" username
    delete_ftpuser $username $password;;   #删除FTP账户.
4)
    anon_sub_menu
    read -p "请输入选项[1-3]:" anon
    if [ $anon -eq 1 ];then
        anon_config 1                     #禁止匿名登陆.
    elif [ $anon -eq 2 ];then
        anon_config 2                     #启用匿名登陆.
    elif [ $anon -eq 3 ];then
        anon_config 3                     #允许匿名上传.
    fi;;
5)
    service_sub_menu    
    read -p "请输入选项[1-3]:" proc
    if [ $proc -eq 1 ];then
        proc_manager start                #启动vsftpd服务.
    elif [ $proc -eq 2 ];then
        proc_manager stop                 #关闭vsftpd服务.
    elif [ $proc -eq 3 ];then
        proc_manager restart              #重启vsftpd服务.
    fi;;
6)
    exit;;
*)
    $FAILURE
    echo "您的输入有误."
    $NORMAL
    exit;;
esac
