#! /bin/sh

FLUENTD_DATA_DIR=${FLUENTD_DATA_DIR:-/home/fluent}

while [[ ! -e /etc/rancher-conf/fluent.conf ]]; do
  echo "waiting for fluentd configuration file"
  sleep 2
done

mkdir -p $FLUENTD_DATA_DIR

chown -R fluent:fluent $FLUENTD_DATA_DIR
chown -R fluent:fluent /etc/rancher-conf

while true; do
  setfacl -m u:fluent:rx /var/lib/docker/containers
  ls /var/lib/docker/containers | xargs -I{} setfacl -m u:fluent:rx /var/lib/docker/containers/{}
  ls /var/lib/docker/containers/**/*-json.log | xargs setfacl -m u:fluent:rx
  ls /var/lib/docker/containers/**/config*.json | xargs setfacl -m u:fluent:rx
  sleep 10
done &

exec dosu fluent /opt/rancher/bin/start-fluent.sh
