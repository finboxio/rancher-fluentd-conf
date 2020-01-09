FROM finboxio/rancher-conf-aws:v0.4.2

RUN apk add --no-cache docker

COPY config.toml /etc/rancher-conf/
COPY fluent.conf.tmpl /etc/rancher-conf/
COPY plugins.txt.tmpl /etc/rancher-conf/
COPY reload.sh.tmpl /etc/rancher-conf/
COPY plugins /etc/rancher-conf/plugins

COPY run.sh /opt/rancher/bin/
COPY update-plugins.sh /opt/rancher/bin/
