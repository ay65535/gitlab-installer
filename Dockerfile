FROM ubuntu:16.04
ADD . /vagrant
WORKDIR /vagrant
RUN set -ex && \
    sed -i.bak -e "s%http://[^ ]\+%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list && \
    apt-get -y update && \
    apt-get -y install tzdata language-pack-ja-base language-pack-ja && \
    . /etc/default/locale && \
    ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    date
CMD ["bash"]
