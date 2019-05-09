# wireguard-auto-config
Automated setup of wireguard configs for Ubuntu 18.04 and above.

Tested on 19.04
## Usage
1. Installing Wireguard:

    Afther the script, you will see a QR code on the terminal. Use the Android/iOS app to scan the QR code to load the config. The client config file can also be found at /etc/wireguard/client0.conf

```shell
wget https://raw.githubusercontent.com/dreamsafari/wireguard-auto-config/master/createnew.sh && chmod +x createnew.sh
sudo ./createnew.sh
```

2. Adding user/configs to existing installation

    Please be advised the script **ONLY** works if your installation is done using the scripts here. Afther the script, you will also see a QR code on the terminal. Use the Android/iOS app to scan the QR code to load the config. The client config file can also be found at /etc/wireguard/client**X**.conf

```shell
wget https://raw.githubusercontent.com/dreamsafari/wireguard-auto-config/master/addclient.sh && chmod +x addclient.sh
sudo ./addclient.sh
```
