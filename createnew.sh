#!/bin/bash
if [ `whoami` = "root" ];then
  interface=$(find /sys/class/net ! -type d | xargs --max-args=1 realpath  | awk -F\/ '/pci/{print $NF}')
  ip=$(curl -s http://ipv4.icanhazip.com)
  mkdir -p /etc/wireguard && chmod 0777 /etc/wireguard > /dev/null
  cd /etc/wireguard/
  wg-quick down wg0 > /dev/null
  echo 0 > count
  add-apt-repository ppa:wireguard/wireguard -y
  apt install wireguard resolvconf qrencode -y
  if [ $(cat /proc/sys/net/ipv4/ip_forward) = 0 ];then
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
    sysctl -p
  fi
  umask 077
  wg genkey | tee server_privatekey | wg pubkey > server_publickey
  wg genkey | tee client0_privatekey | wg pubkey > client0_publickey
  echo "[Interface]
  PrivateKey = $(cat server_privatekey)
  Address = 10.0.0.1/24
  PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o $interface -j MASQUERADE
  PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o $interface -j MASQUERADE
  ListenPort = 13813
  DNS = 8.8.8.8
  MTU = 1420
  [Peer]
  PublicKey = $(cat client0_publickey)
  AllowedIPs = 10.0.0.2/32 " > wg0.conf
  systemctl enable wg-quick@wg0
  echo "[Interface]
  PrivateKey = $(cat client0_privatekey)
  Address = 10.0.0.2/24
  DNS = 8.8.8.8
  MTU = 1420
  [Peer]
  PublicKey = $(cat server_publickey)
  Endpoint = $ip:13813
  AllowedIPs = 0.0.0.0/0
  PersistentKeepalive = 30" > client0.conf
  wg-quick up wg0
  qrencode -t ansiutf8 < /etc/wireguard/client0.conf
  exit 0
else
  echo "This script should be run as root. Now exit."
  exit 1
fi
