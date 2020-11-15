FROM finboxio/rancher-conf-aws:v1.1.0

RUN apk add --no-cache docker

VOLUME /var/log/fluent

COPY config.toml /etc/rancher-conf/
COPY agent.conf.tmpl /etc/rancher-conf/
COPY collector.conf.tmpl /etc/rancher-conf/
COPY plugins.txt.tmpl /etc/rancher-conf/
COPY plugins /etc/rancher-conf/plugins

COPY run-agent.sh /opt/rancher/bin/
COPY run-collector.sh /opt/rancher/bin/
COPY update-plugins.sh /opt/rancher/bin/
COPY reload.sh /opt/rancher/bin/
