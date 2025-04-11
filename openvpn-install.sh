#!/bin/bash

set -e  # если ошибка — вылетим
echo "[INFO] Запуск скрипта OpenVPN install..."

# Пример базовой настройки
mkdir -p /etc/openvpn

echo "[INFO] Генерация базового server.conf..."
cat > /etc/openvpn/server.conf <<EOF
port 1194
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
keepalive 10 120
persist-key
persist-tun
user nobody
group nogroup
status openvpn-status.log
verb 3
EOF

echo "[INFO] Конфигурация создана!"

# Заглушка, чтобы контейнер не упал
sleep infinity
