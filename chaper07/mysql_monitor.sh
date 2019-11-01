#!/bin/bash

#定义数据库相关变量.
MYSQL_USER=root
MYSQL_PASS=123456
MYSQL_PORT=3306
MYSQL_HOST=localhost
MYSQL_ADMIN="mysqladmin -u$MYSQL_USER -p$MYSQL_PASS -P$MYSQL_PORT -h$MYSQL_HOST"
MYSQL_COMM="mysql -u$MYSQL_USER -p$MYSQL_PASS -P$MYSQL_PORT -h$MYSQL_HOST -e"

#定义变量:显示信息的颜色属性.
SUCCESS="echo -en \\033[1;32m"   #绿色.
FAILURE="echo -en \\033[1;31m"   #红色.
WARNING="echo -en \\033[1;33m"   #黄色.
NORMAL="echo -en \\033[0;39m"    #黑色.

#检查数据库服务器状态.
$MYSQL_ADMIN ping &> /dev/null
if [ $? -ne 0 ];then
    $FAILURE
    echo "无法连接数据库服务器"
    $NORMAL
    exit
else
    echo -n "数据库状态: "
    $SUCCESS
    echo "[OK]"
    $NORMAL
fi

#过滤数据库启动时间.
RUN_TIME=$($MYSQL_COMM "SHOW GLOBAL STATUS LIKE 'uptime'" | awk '/Uptime/{print $2}')
echo -n "数据库已运行时间(秒): "
$SUCCESS
echo $RUN_TIME
$NORMAL

#过滤数据库列表.
DB_LIST=$($MYSQL_COMM "SHOW DATABASES")
DB_COUNT=$($MYSQL_COMM "SHOW DATABASES" | awk 'NR>=2&&/^[^+]/{db_count++} END{print db_count}')
echo -n "该数据库有$DB_COUNT个数据库,分别为:"
$SUCCESS
echo $DB_LIST
$NORMAL

#查询MySQL最大并发连接数.
MAX_CON=$($MYSQL_COMM "SHOW VARIABLES LIKE 'max_connections'" | awk '/max/{print $2}')
echo -n "MySQL最大并发连接数: "
$SUCCESS
echo $MAX_CON
$NORMAL

#查看SELECT指令被执行的次数.
NUM_SELECT=$($MYSQL_COMM "SHOW GLOBAL STATUS LIKE 'com_select'" | awk '/Com_select/{print $2}')
echo -n "SELECT被执行的次数: "
$SUCCESS
echo $NUM_SELECT
$NORMAL

#查看UPDATE指令被执行的次数.
NUM_UPDATE=$($MYSQL_COMM "SHOW GLOBAL STATUS LIKE 'com_update'" | awk '/Com_update/{print $2}')
echo -n "UPDATE被执行的次数: "
$SUCCESS
echo $NUM_UPDATE
$NORMAL

#查看DELETE指令被执行的次数.
NUM_DELETE=$($MYSQL_COMM "SHOW GLOBAL STATUS LIKE 'com_delete'" | awk '/Com_delete/{print $2}')
echo -n "DELETE被执行的次数: "
$SUCCESS
echo $NUM_DELETE
$NORMAL

#查看INSERT指令被执行的次数.
NUM_INSERT=$($MYSQL_COMM "SHOW GLOBAL STATUS LIKE 'com_insert'" | awk '/Com_insert/{print $2}')
echo -n "INSERT被执行的次数: "
$SUCCESS
echo $NUM_INSERT
$NORMAL

#查看COMMIT指令被执行的次数.
NUM_COMMIT=$($MYSQL_COMM "SHOW GLOBAL STATUS LIKE 'com_commit'" | awk '/Com_commit/{print $2}')
echo -n "COMMIT被执行的次数: "
$SUCCESS
echo $NUM_COMMIT
$NORMAL

#查看ROLLBACK指令被执行的次数.
NUM_ROLLBACK=$($MYSQL_COMM "SHOW GLOBAL STATUS LIKE 'com_rollback'" | awk '/Com_rollback/{print $2}')
echo -n "ROLLBACK被执行的次数: "
$SUCCESS
echo $NUM_ROLLBACK
$NORMAL

#查看ROLLBACK指令被执行的次数.
NUM_ROLLBACK=$($MYSQL_COMM "SHOW GLOBAL STATUS LIKE 'com_rollback'" | awk '/Com_rollback/{print $2}')
echo -n "ROLLBACK被执行的次数: "
$SUCCESS
echo $NUM_ROLLBACK
$NORMAL

#查看服务器执行的指令数量.
NUM_QUESTION=$($MYSQL_COMM "SHOW GLOBAL STATUS LIKE 'Questions'" | awk '/Questions/{print $2}')
echo -n "Questions服务器执行的指令数量: "
$SUCCESS
echo $NUM_QUESTION
$NORMAL

NUM_SLOW_QUERY=$($MYSQL_COMM "SHOW GLOBAL STATUS LIKE 'slow_queries'" | awk '/Slow_queries/{print $2}')
echo -n "SLOW Query慢查询数量: "
$SUCCESS
echo $NUM_SLOW_QUERY
$NORMAL

echo -n "数据库QPS: "
$SUCCESS
awk 'BEGIN{print '"$NUM_QUESTION/$RUN_TIME"'}'
$NORMAL

echo -n "数据库TPS: "
$SUCCESS
awk 'BEGIN{print '"($NUM_COMMIT+$NUM_ROLLBACK)/$RUN_TIME"'}'
$NORMAL
