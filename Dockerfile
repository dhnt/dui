# https://github.com/francescou/docker-compose-ui
# DOCKER-VERSION 1.12.3
FROM python:2.7-alpine

##
WORKDIR /opt/bin

RUN wget --no-check-certificate -qO- "https://github.com/gostones/goreman/releases/download/v0.2.1-bin/goreman_0.2.1-bin_linux_amd64.tar.gz" \
    | tar -xzv

RUN wget --no-check-certificate -qO- "https://github.com/ginuerzh/gost/releases/download/v2.7.2/gost_2.7.2_linux_amd64.tar.gz" \
    | tar -xzv --strip-component=1

RUN wget --no-check-certificate -qO- "https://github.com/jedisct1/dnscrypt-proxy/releases/download/2.0.21/dnscrypt-proxy-linux_arm64-2.0.21.tar.gz" \
    | tar -xzv --strip-component=1 linux-arm64/dnscrypt-proxy

RUN wget --no-check-certificate -qO- "https://github.com/gostones/discodns/releases/download/v0.0.8-bin/discodns_0.0.8-bin_linux_amd64.tar.gz" \
    | tar -xzv

RUN wget --no-check-certificate -qO- "https://github.com/etcd-io/etcd/releases/download/v3.3.12/etcd-v3.3.12-linux-amd64.tar.gz" \
    | tar -xzv --strip-component=1 etcd-v3.3.12-linux-amd64/etcd

RUN wget --no-check-certificate -qO traefik "https://github.com/containous/traefik/releases/download/v1.7.9/traefik_linux-amd64"

RUN chmod -R a+x /opt/bin && chown -R root:root /opt/bin

##
WORKDIR /

RUN pip install virtualenv

RUN apk add -U --no-cache curl git

COPY ./requirements.txt /app/requirements.txt
RUN virtualenv /env && /env/bin/pip install --no-cache-dir -r /app/requirements.txt

COPY . /app

VOLUME ["/opt/docker-compose"]

COPY docker-compose /opt/docker-compose

EXPOSE 5000

ENV PATH=/opt/bin:${PATH}

ENTRYPOINT ["/env/bin/python", "/app/main.py"]

WORKDIR /opt/docker-compose/

CMD []
