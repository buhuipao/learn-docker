#!/bin/bash
# init.sh
set -eo

# mysql init
service mysql start
#groupadd -r mysql && useradd -r -g mysql mysql
mkdir -p /var/data
chown -R mysql:mysql /var/data
mysql_install_db --datadir=/var/data
echo 'MariaDB init process in progress...'
mysqladmin -u root password $MYSQL_PW
mysql -uroot -p$MYSQL_PW << EOF
create database if not exists $MYSQL_DB character set utf8 collate utf8_bin;
grant all on $MYSQL_DB.* to $MYSQL_USER@localhost identified by '$MYSQL_PW';
flush privileges;
quit
EOF

# up servers
echo 'php-fpm starting ...'
/etc/init.d/php7.0-fpm start && echo 'php-fpm start over'
echo 'ngxin starting ...'
/etc/init.d/nginx start && echo 'nginx server start over'
echo 'ssh starting ...'
/etc/init.d/ssh start -D
