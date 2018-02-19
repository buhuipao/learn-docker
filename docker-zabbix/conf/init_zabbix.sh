#!/bin/bash
# init_zabbix.sh
set -ex

# php.ini for zabbix
sed -i 's/^max_execution_time = 30/max_execution_time = 300/g' /etc/php/7.0/fpm/php.ini
sed -i 's/^max_input_time = 60/max_input_time = 300/g' /etc/php/7.0/fpm/php.ini
sed -i 's/^post_max_size = 8M/post_max_size= 16M/g' /etc/php/7.0/fpm/php.ini
sed -i 's/^;date.timezone =/date.timezone = PRC/g' /etc/php/7.0/fpm/php.ini

# config php-fpm and nginx
sed -i 's/^\[www\]/[zabbix]/g' /etc/php/7.0/fpm/pool.d/www.conf
sed -i 's/^user = www-data/user = zabbix/g' /etc/php/7.0/fpm/pool.d/www.conf
sed -i 's/^group = www-data/group = zabbix/g' /etc/php/7.0/fpm/pool.d/www.conf
sed -i 's/^listen.owner = www-data/listen.owner = zabbix/g' /etc/php/7.0/fpm/pool.d/www.conf
sed -i 's/^listen.group = www-data/listen.group = zabbix/g' /etc/php/7.0/fpm/pool.d/www.conf
sed -i 's/^user www-data/user zabbix/g' /etc/nginx/nginx.conf
/etc/init.d/php7.0-fpm start
/etc/init.d/nginx start

# create dbuser and database
/etc/init.d/mysql start
mysql -uroot -pbuhuipao << EOF
create database if not exists $ZABBIX_DB character set utf8 collate utf8_bin;
grant all privileges on $ZABBIX_DB.* to $ZABBIX_DBUSER@localhost identified by '$ZABBIX_PW';
quit
EOF

# source database
cd /root/
mysql -uroot -pbuhuipao $ZABBIX_DB < mysql_data/schema.sql
echo "resource schema.sql successful"
mysql -uroot -pbuhuipao $ZABBIX_DB < mysql_data/images.sql
echo "resource image.sql successful"
mysql -uroot -pbuhuipao $ZABBIX_DB < mysql_data/data.sql
echo "resource data.sql successful"
rm -rf /root/mysql_data

# start zabbix service, default service is zabbix_server
mkdir /var/log/zabbix/
chown -R zabbix:zabbix /var/log/zabbix/
mkdir /run/zabbix/
chown -R zabbix:zabbix /run/zabbix/
case  $SERVICE in
  server)
    $ZABBIX_HOME/sbin/zabbix_server -c $ZABBIX_HOME/etc/zabbix_server.conf
    ;;
  *)
    $ZABBIX_HOME/sbin/zabbix_agentd -c $ZABBIX_HOME/etc/zabbix_agentd.conf
    $ZABBIX_HOME/sbin/zabbix_server -c $ZABBIX_HOME/etc/zabbix_server.conf
    ;;
esac

# start sshd
/etc/init.d/ssh start -D
