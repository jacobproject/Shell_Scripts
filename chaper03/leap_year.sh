#!/bin/bash
#功能描述(Description):判断闰年.
#条件1:能被4整除,但不能被100整除;条件2:能被400整除.
#满足条件1或者条件2之一就是闰年.

for i in {1..5000}
do
    if [[ $[i%4] -eq 0 && $[i%100] -ne 0 ||  $[i%400] -eq 0 ]];then
        echo "$i:是闰年"
    else
        echo "$i:非闰年"
    fi
done
