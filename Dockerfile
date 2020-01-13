FROM finboxio/rancher-conf-aws:v0.5.0

RUN apk add --no-cache docker

VOLUME /var/log/fluent

COPY config.toml /etc/rancher-conf/
COPY fluent.conf.tmpl /etc/rancher-conf/
COPY plugins.txt.tmpl /etc/rancher-conf/
COPY plugins /etc/rancher-conf/plugins

COPY run.sh /opt/rancher/bin/
COPY update-plugins.sh /opt/rancher/bin/
COPY reload.sh /opt/rancher/bin/
