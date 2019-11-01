#!/bin/bash
#功能描述(Description):分析系统登陆日志,过滤异常IP地址,并通过防火墙禁用该IP.

#强制退出时关闭所有后台进程.
trap 'kill $one_pid; kill $five_pid; kill $fifteen_pid; exit' EXIT INT

#日志文件路径.
LOGFILE=/var/log/secure
BLOCKFILE=/tmp/blockip.txt

one_minute(){
    while :
    do
        #获取计算机当前时间,以及1分钟前的时间,时间格式:
        #%b(月份简写,Jan)  %e(日期,1) %T(时间 18:00:00)
        #LANG=C的作用是否防止输出中文.
        #使用local定义局部变量的好处是多个函数使用相同的变量名也不会冲突.
        local curtime_month=$(LANG=C date  +"%b")
        local curtime_day=$(LANG=C date  +"%e")
        local curtime_time=$(LANG=C date  +"%T")
        local one_minus_ago=$(LANG=C date -d "1 minutes ago" +"%T")
        #将当前时间转换为距离1970-01-01 00:00:00的秒数,方便后期计算.
        local curtime_seconds=$(LANG=C date +"%s")
        #分析1分钟内所有的日志,如果密码失败则过滤倒数第4列的IP地址.
        #通过管道对过滤的IP进行计数统计,提取密码失败次数大于等于3次的IP地址.
        #awk调用外部Shell的变量时,双引号在外面表示字符串("''"),单引号在外边表示数字('""').
        pass_fail_ip=$(awk '
                       $1=="'$curtime_month'" &&   \
                       $2=='"$curtime_day"'   &&   \
                       $3>="'$one_minus_ago'" &&   \
                       $3<="'$curtime_time'"       \
                       { if($6=="Failed" && $9!="invalid") {print $(NF-3)}}' $LOGFILE | \
                       awk '{IP[$1]++} END{ for(i in IP){ if(IP[i]>=3) {print i} } }')
        #将密码失败次数大于3次的IP写入黑名单文件,
        #每次写入前都需要判断黑名单中是否已经存在该IP.
        #写入黑名单时附加时间标记,实现仅将IP放入黑名单特定的时间,
        #如:密码失败3次后,禁止该IP在20分钟内再次访问服务器.
        for i in $pass_fail_ip
        do
           if ! grep -q "$i" $BLOCKFILE ;then
               echo "$curtime_seconds $i" >> $BLOCKFILE
           fi
        done
        #提取无效账户登陆服务器3次的IP地址,并将其加入黑名单.
        user_invalid_ip=$(awk '
                       $1=="'$curtime_month'" &&   \
                       $2=='"$curtime_day"'   &&   \
                       $3>="'$one_minus_ago'" &&   \
                       $3<="'$curtime_time'"       \
                       { if($6=="Invalid") {print $(NF-2)}}' $LOGFILE | \
                       awk '{IP[$1]++} END{ for(i in IP){ if(IP[i]>=3) {print i} } }')
        for j in $user_invalid_ip
        do
           if ! grep -q "$j" $BLOCKFILE ;then
               echo "$curtime_seconds $j" >> $BLOCKFILE
           fi
        done
        sleep 60
    done
}

five_minutes(){
    while :
    do
        #获取计算机当前时间,以及5分钟前的时间,时间格式:
        #%b(月份简写,Jan)  %e(日期,1) %T(时间 18:00:00)
        #使用local定义局部变量的好处是多个函数使用相同的变量名也不会冲突.
        local curtime_month=$(LANG=C date  +"%b")
        local curtime_day=$(LANG=C date  +"%e")
        local curtime_time=$(LANG=C date  +"%T")
        local one_minus_ago=$(LANG=C date -d "5 minutes ago" +"%T")
        #将当前时间转换为距离1970-01-01 00:00:00的秒数,方便后期计算.
        local curtime_seconds=$(LANG=C date +"%s")
        #分析5分钟内所有的日志,提取3次密码错误的IP地址并加入黑名单.
        pass_fail_ip=$(awk '
                       $1=="'$curtime_month'" &&   \
                       $2=='"$curtime_day"'   &&   \
                       $3>="'$one_minus_ago'" &&   \
                       $3<="'$curtime_time'"       \
                       { if($6=="Failed" && $9!="invalid") {print $(NF-3)}}' $LOGFILE | \
                       awk '{IP[$1]++} END{ for(i in IP){ if(IP[i]>=3) {print i} } }')
        for i in $pass_fail_ip
        do
           if ! grep -q "$i" $BLOCKFILE ;then
               echo "$curtime_seconds $i" >> $BLOCKFILE
           fi
        done
        #提取错误用户名登陆服务器3次的IP地址,并将其加入黑名单.
        user_invalid_ip=$(awk '
                       $1=="'$curtime_month'" &&   \
                       $2=='"$curtime_day"'   &&   \
                       $3>="'$one_minus_ago'" &&   \
                       $3<="'$curtime_time'"       \
                       { if($6=="Invalid") {print $(NF-2)}}' $LOGFILE | \
                       awk '{IP[$1]++} END{ for(i in IP){ if(IP[i]>=3) {print i} } }')
        for j in $user_invalid_ip
        do
           if ! grep -q "$j" $BLOCKFILE ;then
               echo "$curtime_seconds $j" >> $BLOCKFILE
           fi
        done
        sleep 300
    done
}

fifteen_minutes(){
    while :
    do
        #获取计算机当前时间,以及15分钟前的时间,时间格式:
        #%b(月份简写,Jan)  %e(日期,1) %T(时间 18:00:00)
        #使用local定义局部变量的好处是多个函数使用相同的变量名也不会冲突.
        local curtime_month=$(LANG=C date  +"%b")
        local curtime_day=$(LANG=C date  +"%e")
        local curtime_time=$(LANG=C date  +"%T")
        local one_minus_ago=$(LANG=C date -d "15 minutes ago" +"%T")
        #将当前时间转换为距离1970-01-01 00:00:00的秒数,方便后期计算.
        local curtime_seconds=$(LANG=C date +"%s")
        #分析15分钟内所有的日志,提取3次密码错误的IP地址并加入黑名单.
        pass_fail_ip=$(awk '
                       $1=="'$curtime_month'" &&   \
                       $2=='"$curtime_day"'   &&   \
                       $3>="'$one_minus_ago'" &&   \
                       $3<="'$curtime_time'"       \
                       { if($6=="Failed" && $9!="invalid") {print $(NF-3)}}' $LOGFILE | \
                       awk '{IP[$1]++} END{ for(i in IP){ if(IP[i]>=3) {print i} } }')
        for i in $pass_fail_ip
        do
           if ! grep -q "$i" $BLOCKFILE ;then
               echo "$curtime_seconds $i" >> $BLOCKFILE
           fi
        done
        #提取错误用户名登陆服务器3次的IP地址,并将其加入黑名单.
        user_invalid_ip=$(awk '
                       $1=="'$curtime_month'" &&   \
                       $2=='"$curtime_day"'   &&   \
                       $3>="'$one_minus_ago'" &&   \
                       $3<="'$curtime_time'"       \
                       { if($6=="Invalid") {print $(NF-2)}}' $LOGFILE | \
                       awk '{IP[$1]++} END{ for(i in IP){ if(IP[i]>=3) {print i} } }')
        for j in $user_invalid_ip
        do
           if ! grep -q "$j" $BLOCKFILE ;then
               echo "$curtime_seconds $j" >> $BLOCKFILE
           fi
        done
        sleep 1200
    done
}

#每隔20分钟检查一次黑名单,清理大于20分钟的黑名单IP.
clear_blockip(){
    while :
    do
        sleep 1200
        #将当前时间转换为距离1970-01-01 00:00:00的秒数,方便后期计算.
        local curtime_seconds=$(LANG=C date +"%s")
        #awk调用外部shell变量的另一种方式是使用-v选项.
        #当前时间减去黑名单中的时间标记,大于等于1200秒(20分钟)则将其从黑名单中删除.
        tmp=$(awk -v now=$curtime_seconds '(now-$1)>=1200 {print $2}' $BLOCKFILE)
        for i in $tmp
        do
            sed -i "/$i/d" $BLOCKFILE
        done
    done
}

> $BLOCKFILE
one_minute  &
one_pid="$!"
five_minutes &
five_pid="$!"
fifteen_minutes &
fifteen_pid="$!"
clear_blockip 
