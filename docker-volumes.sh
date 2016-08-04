#!/bin/bash
# file:docker-volume.sh

#查看docker端口,可以看到把主机某个端口映射到容器5000的端口
docker run -d -P training/webapp python app.py
docker ps 

#指定端口映射，-p
docker run -d -p 8000:5000 training/webapp python app.py            #把主机8000端口映射到容器5000，注意顺序
docker run -d -p 127.0.0.1:8000:5000 training/webapp python app.py  #同上
docker run -d -p 127.0.0.1::5000 training/webapp python app.py      #同上
docker run -d -p 8000:5000 -p 8080:80 training/webapp python app.py #一次映射两个端口

#查看网络配置，一般情况，使用过滤参数来，但是输出结果很不友好
docker inspect --format '{{ .NetworkSettings}}' container_id

#如果不采用过滤，虽然输出json方便查看，但输出信息过长不方便查找,可以采取点小技巧
docker inspect container_id |grep NetworkSetting -A 20              #使用grep -A 参数输出关键字后20行，
                                                                    # -B 向前输，-C 输出前后20行(共40)
docker inspect container_id |grep -i ipaddress                      #查看ip地址

#只声明不映射数据卷,-v 参数,则docker会在/var/lib/docker/volumes/下建立一个目录(可用inspect 查看)
docker run -d -P -v /webapp training/webapp python app.py
docker run -d -P -v `pwd`:/webdata training/webdata python app.py   #使用pwd的原因是，映射不接受相对目录
                                                                    #需要注意，如果容器内存在/webapp目录，挂载后本地目录对其覆盖

#用inspect输出信息时，观察到VolumesRW值为ture（读写）,改为只可读
docker run -d -P -v `pwd`:/webdata:ro training/webdata python app.py

echo "hello buhuipao" > test.txt
docker run -it -P -v /home/buhuipao/docker/test.txt:/root/test.txt centos:latest /bin/bash       #挂载文件
cat /root/test.txt                          #在容器中执行
echo "hello, xiaoyang">> /root/test.txt     #添加一行
exit
cat test.txt                                #回母机查看文件，显示增加一行

#数据卷容器，创建一个容器专门挂载数据
docker run -d -v /data --name=mydata mariadb 
docker run -d --volumes-from=mydata --name=dbuser0 mariadb   #user0引用mydata的数据卷，
docker run -d --volumes-from=mydata --name=dbuser1 mariadb
docker run -d --volumes-from=dbuser0 --name=dbuser2 mariadb  #也可以引用user0的数据卷一样的
#注意一点: 删除数据容器也不会删除数据卷，删完所有依赖数据卷的容器也不会删除数据卷，
#除非删除最后一个引用数据卷的容器时，加上参数-v, -v --volumes   Remove the volumes associated with the container

#容器的数据备份和恢复,数据将被打包在本目录下
docker run -d -v /data --name=mydata mariadb 
docker run --volumes-from=mydata -v `pwd`:/root/backup centos tar -cvf /root/backup/data.tar /data

#解压数据至restore目录下，也就是数据卷中
docker run -v /data --name=yourdata mariadb
docker run --volumes-from=yourdata -v `pwd`:/root/restore centos tar -xavf /root/restore/data.tar.gz


