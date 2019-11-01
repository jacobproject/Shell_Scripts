#!/bin/bash
####################################
#积分<=30:初学乍练
#积分31-60:初窥门径
#积分61-70:略有小成
#积分71-80:炉火纯青
#积分81-90:登封造极
#积分>90:笑傲江湖
###################################

read -p "请输入论坛积分:"  score
if [[ $score -gt 90 ]];then
    echo "笑傲江湖."
elif [[ $score -gt 80 ]];then
    echo "登峰造极."
elif [[ $score -gt 70 ]];then
    echo "炉火纯青."
elif [[ $score -gt 60 ]];then
    echo "略有小成."
elif [[ $score -gt 30 ]];then
    echo "初窥门径."
else
    echo "初学乍练."
fi

#或者下面的排序方式也可以
#if [ $score -le 30 ];then
#    echo "初学乍练."
#elif [ $score -le 60 ];then
#    echo "初窥门径."
#elif [ $score -le 70 ];then
#    echo "略有小成."
#elif [ $score -le 80 ];then
#    echo "炉火纯青."
#elif [ $score -le 90 ];then
#    echo "登封造极."
#else
#    echo "笑傲江湖."
#fi
