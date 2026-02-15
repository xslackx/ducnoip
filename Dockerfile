FROM ubuntu:latest

COPY entrypoint.sh /entrypoint.sh
COPY noipv.sh   /opt/noipv.sh

ENV LATEST="https://www.noip.com/download/linux/latest"

RUN apt update && \
apt upgrade -y && \
apt install wget \
ca-certificates \
busybox -y && \
mkdir /usr/share/busybox && \
busybox --install -s /usr/share/busybox && \
useradd -c "NOIP" -m -s /usr/share/busybox/sh duc && \ 
cd /opt && \
wget --content-disposition $LATEST && \
chmod +x noipv.sh && ./noipv.sh && \
chown -R duc:duc /entrypoint.sh && \
chmod +x /entrypoint.sh

COPY bash_aliases /home/duc/.bash_aliases

USER duc

ENTRYPOINT /entrypoint.sh