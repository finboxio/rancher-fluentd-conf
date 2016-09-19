FROM finboxio/rancher-conf-aws:dev

RUN apk add --no-cache docker

COPY config.toml /etc/rancher-conf/
COPY fluent.conf.tmpl /etc/rancher-conf/
COPY plugins.txt.tmpl /etc/rancher-conf/
COPY reload.sh.tmpl /etc/rancher-conf/
COPY plugins /etc/rancher-conf/plugins

COPY run.sh /opt/rancher/bin/
COPY start-fluent.sh /opt/rancher/bin/
COPY update-plugins.sh /opt/rancher/bin/
