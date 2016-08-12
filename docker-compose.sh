#!/bin/bash
#file: docker-compose.sh

#安装，构建.yml文件
sudo pip install docker-compose 





#将环境变量带入.yml文件，类似于C编译的编译，检查
sudo docker-compose config

#环境变量.env文件
cat .env
TAG=1.8
#.yml文件
version: '2.0'
services:
  web:
    env_file:
      - .env
    image: "nginx:${TAG}"

