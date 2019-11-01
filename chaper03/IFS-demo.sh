#!/bin/bash
#功能描述(Description):IFS对循环影响的演示.

#因为使用默认IFS的值,所以按空格为分隔符,X变量有4个值,for循环4次.
echo -e "\033[32m案例1:未自定义IFS,对X="a b c d"循环4次结束.\033[0m"
X="a b c d"
for i in $X
do
   echo "I am $i."
done
echo

#备份IFS分隔符
OLD_IFS="$IFS"
#定义分隔符为分号,而X变量的值又没有分号分隔的数据,因此for仅会循环1次.
echo -e "\033[32m案例2:自定义IFS为分号,对X="1 2 3 4"循环1次结束.\033[0m"
IFS=";"
X="1 2 3 4"
for i in $X
do
   echo "I am $i."
done
echo

#定义分隔符为分号,X变量的值也使用分号分隔,因此循环了4次,每次循环输出一个名字.
echo -e "\033[32m案例3:自定义IFS为分号,对X='Jacob;Rose;Vicky;Rick'循环4次结束.\033[0m"
IFS=";"
X="Jacob;Rose;Vicky;Rick"
for i in $X
do
   echo "I am $i."
done
echo

#定义多个分隔符,X变量的值也使用多个分隔符分隔.
#多个分隔符为或者关系,即使用分号或者句点或者冒号为分隔符.最终循环次数为4次.
echo -e "\033[32m案例4:自定义IFS为:分号|句点|冒号,对X=Jacob;Rose.Vicky:Rick循环4次结束.\033[0m"
IFS=";.:"
X="Jacob;Rose.Vicky:Rick"
for i in $X
do
   echo "I am $i."
done
echo
