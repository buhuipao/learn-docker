FROM buhuipao/ubuntu-ssh

MAINTAINER buhuipao <chenhua22@outlook.com>

EXPOSE 80 22

WORKDIR /root

RUN apt-get update ;\
    apt-get install nginx -y;\
    apt-get install php-fpm php-common php-bcmath\
        php-opcache php-pear php-pdo php-mysqlnd php-cli \
        php-gd php-mbstring php-mcrypt php-xml php-tokenizer -y;\
    #php-pecl-apcu php-pecl-memcache php-pecl-memcached
    apt-get install mariadb-server -y

ENV MYSQL_USER buhuipao
ENV MYSQL_PW buhuipao
ENV MYSQL_DB buhuipao

ADD ./conf/* /root/

RUN rm -f /etc/nginx.conf;\
    rm -f /etc/php/7.0/fpm/php.ini;\
    mv /root/nginx.conf /etc/nginx/nginx.conf;\
    mv /root/php.ini /etc/php/7.0/fpm/php.ini;\
    chown -R www-data:www-data /usr/share/nginx/html;\
    chmod a+x /root/init.sh;\
    chmod -R 744 /usr/share/nginx/html

CMD ["/root/init.sh"]
