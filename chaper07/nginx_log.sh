#!/bin/bash
#功能描述(Description):Nginx标准日志分析脚本.
#统计信息包括:
#1.页面访问量PV
#2.用户量UV
#3.人均访问量
#4.每个IP的访问次数
#5.HTTP状态码统计
#6.累计页面字节流量
#7.热点数据

GREEN_COL='\033[32m'
NONE_COL='\033[0m'
line='echo ++++++++++++++++++++++++++++++++++'

read -p "请输入日志文件:" logfile
echo

#判断日志文件是否存在.
if [ ! -f $logfile ];then
    echo "$logfile文件不存在."
    exit
fi

#统计页面访问量(PV).
PV=$(sed -n '$=' $logfile)

#统计用户数量(UV).
UV=$(awk '{IP[$1]++} END{ print length(IP)}' $logfile)

#统计人均访问次量.
Average_PV=$(echo "scale=2;$PV/$UV" | bc)

#统计每个IP的访问次数.
#sort选项:
# -n可以按数字排序,默认为升序.
# -r为倒序排列,降序.
# -k可以指定按照第几列排序,k3按照第三列排序.
IP=$(awk '{IP[$1]++} END{ for(i in IP){print i,"\t的访问次数为:",IP[i]}"\r"}' $logfile | sort -rn -k3)

#统计各种HTTP状态码的个数,如404报错的次数,500错误的次数等.
STATUS=$(awk '{IP[$9]++} END{ for(i in IP){print i"状态码的次数:",IP[i]}"\r"}' $logfile | sort -rn -k2)

#统计累计网页字节大小.
Body_size=$(awk '{SUM+=$10} END{ print SUM }' $logfile)


#统计热点数据,将所有页面的访问次数写入数组,
#如果访问次数大于500,则显示该页面文件名与具体访问次数.
# awk '                                    \
# {IP[$7]++}                               \
# END{                                     \
#      for(i in IP){                       \
#          if(IP[i]>=500) {                \
#             print i"的访问次数:",IP[i]   \
#          }                               \
#      }                                   \
# }'  $logfile
URI=$(awk '{IP[$7]++} END{ for(i in IP){ if(IP[i]>=500) {print i"的访问次数:",IP[i]}}}' $logfile)


#从这里开始显示前面获取的各种数据.
echo -e "\033[91m\t日志分析数据报表\033[0m"

#显示PV与UV访问量,平均用户访问量.
$line
echo -e "累计PV量: $GREEN_COL$PV$NONE_COL"
echo -e "累计UV量: $GREEN_COL$UV$NONE_COL"
echo -e "平均用户访问量: $GREEN_COL$Average_PV$NONE_COL"

#显示累计网页字节数.
$line
echo -e "累计访问字节数: $GREEN_COL$Body_size$NONE_COL Byte"

#显示指定的HTTP状态码数量.
#变量STATUS的值为多行数据,包含有换行符.
#注意:调用变量时必须使用双引号!否则将无法处理换行符号.
$line
echo "$STATUS"

#显示每个IP的访问次数.
$line
echo "$IP"

#显示访问量大于500的URI
echo -e "$GREEN_COL访问量大于500的URI:$NONE_COL"
echo "$URI"
