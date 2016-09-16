FROM finboxio/rancher-conf-aws

RUN apk add --no-cache docker

COPY config.toml /etc/rancher-conf/
COPY fluent.conf.tmpl /etc/rancher-conf/
COPY plugins.txt.tmpl /etc/rancher-conf/
COPY plugins /etc/rancher-conf/plugins

COPY update-plugins.sh /opt/rancher/bin/
COPY run.sh /opt/rancher/bin/
