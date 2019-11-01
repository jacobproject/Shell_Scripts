#!/bin/bash
#功能描述(Description):根据数据的HASH值监控网站数据是否被篡改.

url="http://192.168.4.5/index.html"
date=$(date +"%Y-%m-%d %H:%M:%S")

#定义变量并赋值为源数据的HASH值.
source_hash="e3eb0a1df437f3f97a64aca5952c8ea0"
#实时检测网页数据的HASH值
url_hash=$(curl -s $url |md5sum | cut -d ' ' -f1)

if [ "$url_hash" != "$source_hash" ];then
     mail -s http_Warning root@localhost <<- EOF
	检测时间为:$date
	数据完整性校验失败,$url,页面数据被篡改.
	请尽快排查异常.
	EOF
else
    cat >> /var/log/http_check.log <<- EOF
	$date "$url,数据完整性校验正常."
	EOF
fi
