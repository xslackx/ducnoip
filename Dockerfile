FROM ubuntu:latest

COPY entrypoint.sh /entrypoint.sh

ENV NOIP_USERNAME="CHANGEME"
ENV NOIP_PASSWORD="CHANGEME"
ENV NOIP_LOG_LEVEL="info"
ENV NOIP_HTTP_TIMEOUT="60s"
ENV NOIP_DAEMON_USER="duc"
ENV NOIP_CHECK_INTERVAL="30m"
ENV NOIP_DAEMON_GROUP="duc"
ENV LATEST="https://www.noip.com/download/linux/latest"

RUN apt update && \
apt upgrade -y && \
apt install wget \
ca-certificates \
busybox -Y && \
mkdir /usr/share/busybox && \
busybox --install -s /usr/share/busybox && \
useradd -c "NOIP" -m -s /usr/share/busybox/sh duc && \ 
cd /opt && \
wget --content-disposition $LATEST && \
if [[ $(ls) =~ noip-duc_([0-9].{1,4}).tar.gz ]]; then

    duc_version=${BASH_REMATCH[1]}
    duc_tar=${BASH_REMATCH[0]}
    duc_folder=${duc_tar%%.tar.gz}
    echo -e "Dynamic DNS Update Client (DUC) version ${duc_version}\n"

fi && \
tar xf $duc_tar && \
cd $duc_folder/binaries && \
for typeos in "_amd64" "_arm64" "_armhf"; do
    for machine in "x86_64" "aarch64" "armhf"; do

        if [[ $(uname -m) == $machine ]]; then
            package="${duc_folder}${typeos}.deb"
            found=true
            break
        fi

    done
    if $found; then break; fi
done && \
dpkg -i $package && \
chown -R duc:duc /entrypoint.sh && \
chmod +x /entrypoint.sh

COPY bash_aliases /home/duc/.bash_aliases

USER duc

ENTRYPOINT /entrypoint.sh
