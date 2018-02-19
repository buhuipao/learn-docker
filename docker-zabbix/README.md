## 基于自己的ubuntu-lnmp镜像，编译安装Zabbix-3.2.1

内部自定义了多个环境变量:
```
ZABBIX_DB       zabbix                    #zabbix_server数据库名称
ZABBIX_DBUSER   zabbix                    #zabbix_server数据库用户名
ZABBIX_PW       zabbix                    #zabbix_server数据库密码
SERVICE         server_agent              #默认安装
ZABBIX_HOME     /usr/local/zabbix-3.2.1   #安装目录
```
默认安装server和agent服务，可修改参数SERVICE=server，只启动server服务; 数据库等安装目录也可自行更改

server 和 agent日志文件位于/var/log/zabbix目录
