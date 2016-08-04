#!/bin/sh
# file:docker-base.sh

docker create|run	#利用镜像创建容器|创建并运行
docker ps 		#列出运行的容器
docker ps -a 		#列出所有容器 
	  -l 		#最后创建的容器
	  -n=3 		#列出最后三个容器

docker run -i -t --name=base_shell centos /bin/bash 	#创建交互的容器，-i：打开容器标注输入，-t：创建一个终端 
docker run --name while -d centos /bin/bash -c "while true; do echo hell buhuipao!; sleep 1; done" #-d 后台运行
docker stop id|name     #停止容器
docker rm -f  id|name   #强制删除容器

#容器推出后可以重启,默认不重启
docker run --restart=always --name=while_restart -d  centos /bin/bash -c "while true;do echo Hello buhuipao!;sleep 1;done"
           --restart=on-failure:5   #退出码不为0后重启5次

#在启动交互容器时，需要提供依附,退出交互需要ctrl + d,容器停止
docker start centos-bash 
docker attach cenos-bash

#查看一个后台运行容器日志,ctrl+c退出日志
docker logs -f bg-logs      #-f会实时输出
docker logs -f --tail=5 -t  #输出最后五个并且会一直增加，显示时间
docker top bg-logs          #查看进程
docker inspect bg-logs      #查看容器信息,可以加--format '{{ .NetworksSettings.IPAddrress }}'等

#容器内执行命令,类似shell
docker exec -d bg-logs touch /root/testfile
docker exec -i -t bg-logs /bin/bash

#导出容器为tar包，导入tar为镜像
docker export bg-logs > exported.tar
cat exported.tar | docker import - imported:v0.1 
docker import url net_imported:v0.1     #可以从网络上导入容器

