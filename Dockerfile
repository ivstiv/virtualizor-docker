FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG='C.UTF-8' LANGUAGE='C.UTF-8' LC_ALL='C.UTF-8'
ARG S6_OVERLAY_VERSION=3.1.0.1

RUN apt-get update > /dev/null 2>&1 && apt-get upgrade > /dev/null 2>&1 && apt-get install -y tzdata lsb-release iputils-ping wget xz-utils > /dev/null 2>&1
RUN apt-get install -y vim curl python kpartx gcc openssl unzip sendmail make cron fuse e2fsprogs tar gnupg > /dev/null 2>&1

# Add s6 script
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz

# Copy S6 init scripts
COPY s6/ /etc

ENTRYPOINT ["/init"]
