FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y \
    iptables \
    curl \
    openvpn \
    iproute2 \
    bash \
    && rm -rf /var/lib/apt/lists/*

COPY openvpn-install.sh /openvpn-install.sh
RUN chmod +x /openvpn-install.sh

EXPOSE 1194/udp

CMD ["bash", "/openvpn-install.sh"]
