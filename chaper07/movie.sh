#!/bin/bash
#功能描述(Description):编写网络爬虫,抓取网络视频下载链接.
#备注:因为网站随时可能改版,因此具体的爬取数据和过滤的方法需要根据实际情况适当修订.

tmpfile="/tmp/tmp_$$.txt"
pagefile="/tmp/page_"
moviefile="/tmp/movie_"
listfile="/tmp/list.txt"

#下载首页源码,并获取子页面链接列表(id=menu到/div中间的行为子页面的链接).
curl -s https://www.dytt8.net > $tmpfile
LANG=C sed -i '/id="menu"/,/\/div/!d' $tmpfile

#上面进行数据过滤后结果如下,需要继续使用awk将多余的数据清洗掉.
#awk通过-F选项指定以双引号"为分隔符.
#<a href="http://www.ygdy8.net/html/gndy/dyzz/index.html">最新影片</a></li><li>
#<a href="http://www.ygdy8.net/html/gndy/index.html">经典影片</a></li><li>
#<a href="http://www.ygdy8.net/html/gndy/china/index.html">国内电影</a></li><li>
#<a href="http://www.ygdy8.net/html/gndy/oumei/index.html">欧美电影</a></li><li>
URL=$(sed -n '/id="menu"/,/\/div/p' $tmpfile | awk -F\" '/href/&&/http/{print $2}')

#清洗后结果如下:
#https://www.ygdy8.net/html/gndy/dyzz/index.html
#https://www.ygdy8.net/html/gndy/index.html
#https://www.ygdy8.net/html/gndy/china/index.html
#https://www.ygdy8.net/html/gndy/oumei/index.html

#利用循环访问每个子页面,分别获取电影列表信息.
echo -e "\033[32m正在抓取网站中视频数据的链接.\033[0m"
echo "根据网站数据量不同,可能需要比较长的时间,请耐心等待..."
x=1
y=1
for subpage in $URL
do
    curl -s $subpage > $pagefile$x
    #过滤class="co_content8到class="x"之间的行,其他行都删除.
    sed -i '/class="co_content8"/,/class="x"/!d' $pagefile$x

    #获取具体电影的主页链接,过滤包含href的链接行,默认链接只有路径,没有网站主域名,需要使用awk修改改路径.
    
    #修改前:/html/gndy/dyzz/20190411/58451.html
    #修改后:http://www.ygdy8.net/html/gndy/dyzz/20190411/58451.html
    SUB_URL=$(awk -F[\'\"] '/<a href/{print "https://www.ygdy8.net"$2}' $pagefile$x  | grep -v index.html | grep html) 
    #在电影的主页中过滤具体的视频资源链接.
    for i in $SUB_URL
    do
        curl -s $i > $moviefile$y
        sed -i '/ftp/!d' $moviefile$y
        #将最终过滤的视频链接保存至$listfile文件.
        touch $listfile
        awk -F\" '{print $6}' $moviefile$y >> $listfile
        let y++
    done
    let x++
done
rm -rf "$tmpfile"
rm -rf /tmp/page_*
rm -rf /tmp/movie_*
