FROM debian:stretch-slim

LABEL maintainer="didlich@t-online.de"

ENV DEBIAN_FRONTEND noninteractive

RUN apt -q -y update \
  && apt -q -y install curl wget inetutils-ping openssh-server ike screen

RUN mkdir -p /var/run/sshd \
  && apt -q -y clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "root:root" | chpasswd \
  && sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config \
  && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# prepare ike site path
RUN mkdir /sites \
  && mkdir -p /root/.ike \
  && ln -s /sites /root/.ike/sites

EXPOSE 22

VOLUME ["/sites"]
WORKDIR /sites

COPY  entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]


