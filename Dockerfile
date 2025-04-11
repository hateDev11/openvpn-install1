FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y curl iptables openvpn unzip wget net-tools gnupg ca-certificates systemd && \
    apt-get clean

COPY openvpn-install.sh /openvpn-install.sh
RUN chmod +x /openvpn-install.sh

RUN /openvpn-install.sh <<EOF
1
EOF

EXPOSE 1194/udp

CMD ["openvpn", "--config", "/etc/openvpn/server/server.conf"]
