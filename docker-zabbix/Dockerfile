FROM buhuipao/ubuntu-lnmp

MAINTAINER <buhuipao> chenhua22@outlook.com

ENV ZABBIX_DB zabbix
ENV ZABBIX_DBUSER zabbix
ENV ZABBIX_PW zabbix
ENV SERVICE server_agent
ENV ZABBIX_HOME /usr/local/zabbix-3.2.1

WORKDIR /root

RUN apt-get update;\
    apt-get install make gcc libsnmp-dev snmp libmysqld-dev libcurl4-openssl-dev libxml2-dev -y;\
    wget http://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/3.2.1/zabbix-3.2.1.tar.gz;\
    tar -xavf zabbix-3.2.1.tar.gz;\
    cd zabbix-3.2.1;\
    ./configure --prefix="$ZABBIX_HOME" --enable-server --enable-agent --with-mysql\
     --with-net-snmp --with-libcurl --with-libxml2;\
    make && make install

ADD conf/* /root/

RUN mv /root/zabbix-3.2.1/database/mysql/ /root/mysql_data && cd /root/mysql_data;\
    rm -rf /usr/share/nginx/html/* && cp -R /root/zabbix-3.2.1/frontends/php/* /usr/share/nginx/html/;\
    groupadd zabbix && useradd -g zabbix zabbix;\
    chown -R zabbix:zabbix /usr/share/nginx/html;\
    chmod a+x /root/init_zabbix.sh;\
    apt-get install language-pack-zh-hans -y;\
    mv $ZABBIX_HOME/etc/zabbix_server.conf $ZABBIX_HOME/etc/zabbix_server.conf.bak;\
    mv $ZABBIX_HOME/etc/zabbix_agentd.conf $ZABBIX_HOME/etc/zabbix_agentd.conf.bak;\
    mv /root/zabbix_server.conf $ZABBIX_HOME/etc/zabbix_server.conf;\
    mv /root/zabbix_agentd.conf $ZABBIX_HOME/etc/zabbix_agentd.conf;\
    rm -rf /root/zabbix*;\
    apt-get clean && rm -r /var/lib/apt/lists/*

EXPOSE 10050 10051 80

CMD ["/root/init_zabbix.sh"]
