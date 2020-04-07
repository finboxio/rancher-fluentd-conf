#! /bin/sh

FLUENTD_DATA_DIR=${FLUENTD_DATA_DIR:-/home/fluent}

while [[ ! -e /etc/rancher-conf/agent.conf ]]; do
  echo "waiting for fluentd configuration file"
  sleep 2
done

mkdir -p $FLUENTD_DATA_DIR

/opt/rancher/bin/update-plugins.sh

exec fluentd \
  -c /etc/rancher-conf/agent.conf \
  -p /etc/rancher-conf/plugins \
  $@
