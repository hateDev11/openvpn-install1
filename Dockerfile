FROM debian:bullseye-slim

# Устанавливаем необходимые пакеты
RUN apt-get update && \
    apt-get install -y \
    iptables \
    curl \
    openvpn \
    iproute2 \
    bash \
    ca-certificates \
    gnupg \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Копируем скрипт установки
COPY openvpn-install.sh /openvpn-install.sh

# Устанавливаем OpenVPN автоматически (без вопросов)
RUN chmod +x /openvpn-install.sh && AUTO_INSTALL=y /openvpn-install.sh

# Открываем порт VPN (UDP)
EXPOSE 1194/udp

# Запускаем OpenVPN с конфигурацией
CMD ["openvpn", "--config", "/etc/openvpn/server.conf"]
