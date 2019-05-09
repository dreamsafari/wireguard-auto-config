#!/bin/bash
id=$[$(cat count)+1]
wg-quick down wg0
wg genkey | tee client${id}_privatekey | wg pubkey > client${id}_publickey
echo "
[Peer]
PublicKey = $(cat client${id}_publickey)
AllowedIPs = 10.0.0.$[${id}+2]/32" >> /etc/wireguard/wg0.conf
echo "[Interface]
PrivateKey = $(cat client${id}_privatekey)
Address = 10.0.0.$[${id}+2]/24
DNS = 8.8.8.8
MTU = 1420

[Peer]
PublicKey = $(cat server_publickey)
Endpoint = 159.89.140.51:40937
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25 " > client${id}.conf
echo $id > count
wg-quick up wg0
qrencode -t ansiutf8 < client${id}.conf
exit 0
