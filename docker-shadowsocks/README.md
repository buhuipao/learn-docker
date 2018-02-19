###基于ubuntu14.04, 使用国内的163源，参考shadowsokcs的官方文档，使用了python的gevent库和部分内核参数进行优化，并么有使用net-speeder进行优化, 国外主机运行：
    sudo docker run -d -p 8081:8081 --name=ssserver buhuipao/shadowsocks
###客户端设置的端口(8081)密码默认为(buhuipao),默认容器内暴露四个端口，可自己修改暴露端口，其实自前想把用户的管理加进来，但是失败了，不久后更新

####母机系统选ubuntu，国外主机推荐帮瓦公，Digital Ocean, Vultr
