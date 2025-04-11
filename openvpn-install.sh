#!/bin/bash

set -e

echo "Starting OpenVPN setup..."

# Настройки
VPN_PORT=1194
VPN_PROTOCOL=udp
SERVER_IP=$(curl -s ifconfig.me || echo "0.0.0.0")
SERVER_CONF="/etc/openvpn/server.conf"
EASYRSA_DIR="/etc/openvpn/easy-rsa"

# Установка Easy-RSA
mkdir -p $EASYRSA_DIR
curl -sL https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.8/EasyRSA-3.0.8.tgz | tar xz --strip-components=1 -C $EASYRSA_DIR

cd $EASYRSA_DIR
./easyrsa init-pki
echo -ne '\n' | ./easyrsa build-ca nopass
./easyrsa gen-dh
EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-server-full server nopass
openvpn --genkey --secret ta.key

# Копирование ключей
cp pki/ca.crt pki/private/server.key pki/issued/server.crt pki/dh.pem ta.key /etc/openvpn/

# Создание server.conf
cat > $SERVER_CONF <<EOF
port $VPN_PORT
proto $VPN_PROTOCOL
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
auth SHA256
tls-auth ta.key 0
topology subnet
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 1.1.1.1"
keepalive 10 120
cipher AES-256-CBC
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
verb 3
explicit-exit-notify 1
EOF

echo "OpenVPN setup complete. Starting OpenVPN..."
exec openvpn --config "$SERVER_CONF"
