#!/bin/bash 
# file:docker-images.sh

docker rmi id|name      #删除镜像
docker rm $(docker ps -a -q)    #删除所有容

#生成新的镜像
docker run -t -i --name=centos-commit  centos       #在容器中进行操作后，exit退出
docker commit -m="yum install vim,openssh" --author="buhuipao" centos-commit buhuipao/vim:v01

#利用Dockerfile创建镜像
#过程是前几步(获取父镜像，设置信息等)主要是利用上一步的缓存镜像，后面的是创建临时镜像给下一步使用，然后删除临时镜像,直到最后一步
#------------------------------------------------------------------------------------------------
#指定父级镜像
FROM centos:latest

#申明作者信息
MAINTAINER buhuipao "chenhua22@outlook.com"

#设置命令执行者
USER root

#执行命令
RUN yum update -y &&\
    yum install php -y

#添加外部文件,可以是文件夹以及网络文件
ADD abc.txt /root/

#设置工作目录
WORKIDIR /root/

#设置环境变量，启动时可以-e参数修改
ENV WEB_PORT=8000

#暴露端口
EXPOSE 3306 8000

#设置启动命令,用于拼接后面CMD
ENTRYPOINT ["ls"]

#设置启动参数,可以覆盖ENTRYPOINT,可以为-a -l 
CMD ["-a", "-l"]

#设置卷,挂载主机或者其他容器的路径,数据交流
VOLUME ["/data", "/var/www/html"]

#设定子镜像触发操作，构建器把这些命令存在元数据中，其他镜像将此镜像作为基础镜像时，才会执行,如FROM 
ONBUILD ADD . /root

#构建镜像
docker build -t buhuipao/centos7-lnmp:v0.1
docker tag buhuipao/centos7-lnmp:v0.1 buhuipao/centos7-lnmp:v0.2    #名称引用

