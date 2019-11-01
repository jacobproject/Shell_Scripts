#!/bin/bash
#功能描述(Description):编写网络爬虫,抓取网络视频下载链接.
#备注:因为网站随时可能改版,因此具体的爬取数据和过滤的方法需要根据实际情况适当修订.

tmpfile="/tmp/tmp_$$.txt"
pagefile="/tmp/page_"
moviefile="/tmp/movie_"
listfile="/tmp/list.txt"

#下载首页源码,并获取子页面链接列表.
curl -s https://www.dytt8.net > $tmpfile
sed -i '/^<a href="http/!d' $tmpfile

#上面进行数据过滤后结果如下,需要继续使用sed将多余的数据清洗掉.
#<a href="https://www.ygdy8.net/html/gndy/dyzz/index.html">最新影片</a></li><li>
#<a href="https://www.ygdy8.net/html/gndy/index.html">经典影片</a></li><li>
#<a href="https://www.ygdy8.net/html/gndy/china/index.html">国内电影</a></li><li>
#<a href="https://www.ygdy8.net/html/gndy/oumei/index.html">欧美电影</a></li><li>
sed -i 's/<a href="//' $tmpfile
LANG=C sed -i 's/".*//' $tmpfile
#因为数据源中有中文,LANG=C可以临时设置语言环境,让sed可以处理中文.
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
for i in $(cat $tmpfile)
do
    curl -s $i > $pagefile$x
    #第一行之start:body content之间的所有行删除.
    sed -i '1,/start:body content/d' $pagefile$x
    #删除包含index.html的行.
    sed -i "/index.html/d" $pagefile$x 
    #仅保留包含<a href的行,其他行都删除.
    sed -i '/<a href/!d' $pagefile$x
    #清理除网页链接路径之外的字符数据.
    sed -i 's/.*<a href="//' $pagefile$x
    LANG=C sed -i 's/".*//' $pagefile$x
    LANG=C sed -i "s/.*='//" $pagefile$x
    LANG=C sed -i "s/'.*//" $pagefile$x
    #删除包含list或者#的行.
    sed -ri '/list|#/d' $pagefile$x
    #给数据链接路径前面添加网站,修改前后对比效果如下.
    #修改前:/html/gndy/dyzz/20190411/58451.html
    #修改后:https://www.ygdy8.net/html/gndy/dyzz/20190411/58451.html
    sed -i 's#^#https://www.ygdy8.net#' $pagefile$x
    for j in $(cat $pagefile$x)
    do
        curl -s $j > $moviefile$y
        sed -i '/ftp/!d' $moviefile$y
        LANG=C sed -i 's/.*="//' $moviefile$y
        LANG=C sed -i 's/">.*//' $moviefile$y
        #将最终过滤的视频链接保存至$listfile文件.
        cat $moviefile$y >> $listfile
        let y++
    done
    let x++
done
sed -i '/^ftp:/!d' $listfile
rm -rf $tmpfile
rm -rf $pagefile
rm -rf $moviefile

