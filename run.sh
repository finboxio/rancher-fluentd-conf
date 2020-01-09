#! /bin/sh

FLUENTD_DATA_DIR=${FLUENTD_DATA_DIR:-/home/fluent}

while [[ ! -e /etc/rancher-conf/fluent.conf ]]; do
  echo "waiting for fluentd configuration file"
  sleep 2
done

mkdir -p $FLUENTD_DATA_DIR

/opt/rancher/bin/update-plugins.sh

exec fluentd \
  -c /etc/rancher-conf/fluent.conf \
  -p /etc/rancher-conf/plugins \
  $@
