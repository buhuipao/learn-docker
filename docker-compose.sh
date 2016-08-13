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

#compose允许引入其他.yml文件，类似于Djando的模版文件extends其他模版,达到多用的效果
#cpu_shares 为优先级，控制cpu的使用，还有参数cpu-period=10000,cpu-quota=5000,则可用50%cpu资源

#以下为例子，首先是一个Dockerfile, 
FROM nginx:lastest
...
...

CMD [...]

#然后是common-services.yml,
version: '2'
services:
  app:
    build: .
    envronment:
      CONFIG_FILE_PATH: /code/config
      API_KEY: xxxxyyy
    depends_on:
      - db
    links:
      - db
    restart: always
    cpu_shares: 5

  db:
    image: mysql:5.7
    volumes:
    - "./.data/db:/var/lib/mysql"
    restart: always

#然后是docker-compose.yml
web:
  extends:
    file: common-service.yml
    service: webapp
  environment:
      - DEBUG=1
  ports:
  - 8080:80
  links:
    - db
  cpu_shares: 5

other_web:
  extends: web
  cpu_shares: 10

