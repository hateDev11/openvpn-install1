FROM debian:bullseye-slim

# Устанавливаем необходимые пакеты
RUN apt-get update && apt-get install -y \
    bash \
    iproute2 \
    iptables \
    openvpn \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Копируем скрипт в контейнер
COPY openvpn-install.sh /openvpn-install.sh

# Делаем его исполняемым
RUN chmod +x /openvpn-install.sh

# Запускаем его
CMD ["/openvpn-install.sh"]
