#!/bin/bash
#功能描述(Description):通过设置锁文件防止脚本重复执行.

#使用Ctrl+C中断脚本时,删除锁文件.
trap 'rm -rf /tmp/lockfile;exit' HUP INT

#检查是否存在锁文件,没有锁文件就执行backup备份函数,如果有锁文件脚本则脚本直接退出.
lock_check(){
    if (set -C; :> /tmp/lockfile) 2>/dev/null ;then
        backup
    else
        echo -e "\033[91mWarning:其他用户在执行该脚本.\033[0m"
        exit 66
    fi
}

#执行备份前创建所文件,然后执行备份数据库的操作,备份完成后删除锁文件.
#sleep 10实验测试时使用,为了防止小数据库备份太快,无法验证重复执行脚本的效果.
backup(){
    touch /tmp/lockfile
    mysqldump --all-database > /var/log/mysql-$(date +%Y%m%d).bak
    sleep 10
    rm -rf /tmp/lockfile
}

lock_check
backup
