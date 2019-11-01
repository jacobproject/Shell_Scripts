#!/bin/bash
#功能描述(Description):一键部署LNMP环境.
#执行脚本时需要在当前目录下有:nginx-1.14.2.tar.gz,mysql-boost-8.0.13.tar.gz,php-7.3.0.tar.gz.

#设置各种显示消息的颜色属性.
SETCOLOR_SUCCESS="echo -en \\033[1;32m"
SETCOLOR_FAILURE="echo -en \\033[1;31m"
SETCOLOR_WARNING="echo -en \\033[1;34m"
SETCOLOR_NORMAL="echo -e \\033[0;39m"

#测试yum源是否可用,awk和sed的用法在后面章节中有介绍.
test_yum(){
    yum clean all &>/dev/null
    num=$(yum repolist -e 0 | awk '/repolist/{print $2}' | sed 's/,//')
    if [ $num -le 0 ];then
        $SETCOLOR_FAILURE
        echo -n "[ERROR]:没有YUM源!"
        $SETCOLOR_NORMAL
        exit
    fi
}

#安装LNMP环境所需要的依赖包.
install_deps(){
    yum -y install gcc pcre-devel openssl-devel cmake ncurses-devel gcc-c++ bison  bison-devel
    yum -y install libxml2 libxml2-devel curl curl-devel libjpeg libjpeg-devel freetype gd gd-devel
    yum -y install freetype-devel libxslt libxslt-devel bzip2 bzip2-devel libpng libpng-devel
}

#源码安装Nginx:创建账户,激活需要的模块,禁用不需要的模块.
install_nginx(){
    if ! id nginx &>/dev/null ;then
        useradd -s /sbin/nologin nginx
    fi
    tar -xf nginx-1.14.2.tar.gz
    cd nginx-1.14.2
    ./configure --prefix=/usr/local/nginx \
    --user=nginx --group=nginx \
    --with-http_stub_status_module \
    --with-stream \
    --with-http_realip_module \
    --with-http_ssl_module \
    --without-http_autoindex_module \
    --without-mail_pop3_module \
    --without-mail_imap_module \
    --without-mail_smtp_module
    $SETCOLOR_WARNING
    echo -n "正在编译Nginx,请耐心等待..."
    $SETCOLOR_NORMAL
    make &>/dev/null && make install &>/dev/null 
    cd ..
    ln -s /usr/local/nginx/sbin/nginx /usr/sbin/nginx
}

#默认源码安装的软件没有service文件无法通过systemd管理.
#手动编写service文件,方便在CentOS7的环境中管理服务.
conf_nginx_systemd(){
cat > /usr/lib/systemd/system/nginx.service <<- EOF
	[Unit]
	Description=nginx
	After=syslog.target network.target

	[Service]
	Type=forking
	PIDFile=/usr/local/nginx/logs/nginx.pid
	ExecStartPre=/usr/sbin/nginx -t
	ExecStart=/usr/local/nginx/sbin/nginx
	ExecReload=/usr/sbin/nginx -s reload
	ExecStop=/bin/kill -s QUIT $MAINPID

	[Install]
	WantedBy=multi-user.target
EOF
}

#源码安装部署MySQL8.0版本的数据库软件.
#注意:需要提前到官网下载带boost版本的MySQL(mysql-boost-8.0.13.tar.gz).
install_mysql8(){
    if ! id mysql &>/dev/null ;then
        useradd -s /sbin/nologin mysql
    fi
    tar -xf mysql-boost-8.0.13.tar.gz
    cd mysql-8.0.13/ 
    $SETCOLOR_WARNING
    echo "请确保有超过2G的可用内存,否则编译可能出错,并提示Killed (程序 cc1plus)"
    echo -n "编译MySQL需要一个漫长的过程,请耐心等待."
    $SETCOLOR_NORMAL
    sleep 5
    cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DDEFAULT_CHARSET=utf8mb4 -DDEFAULT_COLLATION=utf8_general_ci -DENABLED_LOCAL_INFILE=ON -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DWITH_PERFSCHEMA_STORAGE_ENGINE=1 -DWITH_BOOST=./boost -DSYSCONFDIR=/etc/ -DMYSQL_UNIX_ADDR=/tmp/mysql.sock
    #DCMAKE_INSTALL_PREFIX:指定安装路径.
    #DDEFAULT_CHARSET:设置默认字符集.
    #DDEFAULT_COLLATION:默认的字符集序,决定了字符的排列顺序.
    #DENABLED_LOCAL_INFILE:允许通过本地文件导入数据库.
    #DWITH_INNOBASE_STORAGE_ENGINE:开启INNODB存储引擎.
    #DWITH_FEDERATED_STORAGE_ENGINE:开启FEDERATED存储引擎,支持远程数据库.
    #DWITH_BLACKHOLE_STORAGE_ENGINE:开启BLACKHOLE黑洞存储引擎,主从同步进行多级复制时使用.
    #DWITHOUT_EXAMPLE_STORAGE_ENGINE:禁用EXAMPLE存储引擎.
    #DWITH_PARTITION_STORAGE_ENGINE:开启PARTITION分区存储引擎.
    #DWITH_PERFSCHEMA_STORAGE_ENGINE:开启PERFSCHEMA存储引擎.
    #DWITH_BOOST:指定BOOST程序的目录位置.
    #DSYSCONFDIR:指定配置文件目录.
    #DMYSQL_UNIX_ADDR:指定sock文件位置.
    make -j 5        #多进程编译.
    make install
    chown -R mysql.mysql /usr/local/mysql/
    mkdir /var/log/mariadb
    touch /var/log/mariadb/mariadb.log
    chown -R mysql.mysql /var/log/mariadb/
    mkdir -p /var/lib/mysql/data/
    chown -R mysql.mysql /var/lib/mysql/ 
    ln -s /usr/local/mysql/bin/* /bin/
    cat > /etc/ld.so.conf.d/mysql.conf <<- EOF
	/usr/local/mysql/lib
EOF
    cd ..
}

init_mysql8(){
#创建MySQL配置文件(设置socket文件,数据库目录,以及优化等参数).
cat > /etc/my.cnf <<- EOF
	[client]
	port = 3306
	socket = /tmp/mysql.sock

	[mysqld]
	port = 3306
	socket = /tmp/mysql.sock
	datadir = /var/lib/mysql/data
	skip-external-locking
	key_buffer_size = 16M
	max_allowed_packet = 1M
	table_open_cache = 64
	sort_buffer_size = 512K
	net_buffer_length = 16K
	read_buffer_size = 256K
	read_rnd_buffer_size = 512K
	myisam_sort_buffer_size = 8M
	thread_cache_size = 8
	tmp_table_size = 16M
	performance_schema_max_table_instances = 500
	back_log = 3000
	binlog_cache_size = 2048KB
	binlog_checksum = CRC32
	binlog_order_commits = ON
	binlog_rows_query_log_events = OFF
	binlog_row_image = full
	binlog_stmt_cache_size = 32768
	block_encryption_mode = "aes-128-ecb"
	bulk_insert_buffer_size = 4194304
	character_set_filesystem = binary
	character_set_server = utf8mb4
	default_time_zone = SYSTEM
	default_week_format = 0
	delayed_insert_limit = 100
	delayed_insert_timeout = 300
	delayed_queue_size = 1000
	delay_key_write = ON
	disconnect_on_expired_password = ON
	range_alloc_block_size = 4096
	range_optimizer_max_mem_size = 8388608
	table_definition_cache = 512
	table_open_cache = 2000
	table_open_cache_instances = 1
	thread_cache_size = 100
	thread_stack = 262144
	explicit_defaults_for_timestamp = true
	#skip-networking
	max_connections = 10000
	max_connect_errors = 100
	open_files_limit = 65535
	log-bin = mysql-bin
	binlog_format = mixed
	server-id   = 1
	binlog_expire_logs_seconds = 864000
	early-plugin-load = ""

	default_storage_engine = InnoDB
	innodb_file_per_table = 1
	innodb_data_home_dir = /var/lib/mysql/data
	innodb_data_file_path = ibdata1:10M:autoextend
	innodb_log_group_home_dir = /var/lib/mysql/data
	innodb_buffer_pool_size = 16M
	innodb_log_file_size = 5M
	innodb_log_buffer_size = 8M
	innodb_flush_log_at_trx_commit = 1
	innodb_lock_wait_timeout = 50

	[mysqldump]
	quick
	max_allowed_packet = 16M

	[mysql]
	no-auto-rehash

	[myisamchk]
	key_buffer_size = 20M
	sort_buffer_size = 20M
	read_buffer = 2M
	write_buffer = 2M
EOF
#初始化MySQL数据库.
    /usr/local/mysql/bin/mysqld --initialize-insecure \
    --basedir=/usr/local/mysql \
    --datadir=/var/lib/mysql/data/ \
    --user=mysql
#拷贝启动脚本.
    cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
}

install_php7(){
    useradd -s /sbin/nologin www
    tar -xf php-7.3.0.tar.gz
    cd php-7.3.0
    ./configure --prefix=/usr/local/php \
    --enable-fpm \
    --with-fpm-user=www --with-fpm-group=www \
    --with-curl --with-freetype-dir \
    --with-gd --with-gettext \
    --with-iconv-dir  \
    --with-libdir=lib64 
    --with-libxml-dir  \
    --with-mysqli \
    --with-pdo-mysql \
    --with-openssl \
    --with-pcre-regex \
    --with-pdo-sqlite \
    --with-pear --with-png-dir \
    --with-xmlrpc --with-xsl  \
    --with-zlib --enable-bcmath \
    --enable-libxml \
    --enable-inline-optimization \
    --enable-mbregex --enable-mbstring \
    --enable-opcache --enable-pcntl \
    --enable-shmop --enable-soap \
    --enable-sockets --enable-sysvsem --enable-xml
    make -j 5
    make install
    cp php.ini-production /usr/local/php/etc/php.ini
    sed -i 's#;date.timezone =#date.timezone = Asia/Shanghai#' /usr/local/php/etc/php.ini
    sed -i 's#max_execution_time = .*#max_execution_time = 300#' /usr/local/php/etc/php.ini
    sed -i 's#post_max_size =.*#post_max_size = 32M#' /usr/local/php/etc/php.ini
    sed -i 's#max_input_time = .*#max_input_time = 300#' /usr/local/php/etc/php.ini
    cp sapi/fpm/php-fpm.service /usr/lib/systemd/system/
    ln -s /usr/local/php/sbin/php-fpm /usr/sbin/
    ln -s /usr/local/php/bin/* /bin/
    cp /usr/local/php/etc/{php-fpm.conf.default,php-fpm.conf}
    cp /usr/local/php/etc/php-fpm.d/{www.conf.default,www.conf}
    cd ..
}

#调用执行函数,安装部署LNMP环境.
test_yum
install_deps
install_nginx
conf_nginx_systemd
install_mysql8
init_mysql8
install_php7
