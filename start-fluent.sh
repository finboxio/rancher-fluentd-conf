#! /bin/sh

set -x

/opt/rancher/bin/update-plugins.sh

exec fluentd \
  -c /etc/rancher-conf/fluent.conf \
  -p /etc/rancher-conf/plugins \
  $FLUENTD_OPT
