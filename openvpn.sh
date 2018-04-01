#!/bin/bash

# 配置文件所在目录
CONFIG_DIR='/home/ff/ovpn-data-example'
# 服务器ip
# SERVER_DOMAIN_IP='192.168.2.133'
SERVER_DOMAIN_IP=`curl -s  ipinfo.io/ip`
# 暴露的 UDP 端口
EXPORT_PORT='1194'
# 客户端名字
CLIENT_NAME='CLIENTNAME'

# 生成配置文件
sudo docker run -v ${CONFIG_DIR}:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://${SERVER_DOMAIN_IP}
# 生成密钥文件
sudo docker run -v ${CONFIG_DIR}:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki
# 启动OpenVPN服务
sudo docker run -v ${CONFIG_DIR}:/etc/openvpn -d -p ${EXPORT_PORT}:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
# 生成客户端证书
sudo docker run -v ${CONFIG_DIR}:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full ${CLIENT_NAME} nopass
# 导出客户端配置
sudo docker run -v ${CONFIG_DIR}:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient ${CLIENT_NAME} > ${CLIENT_NAME}.ovpn
