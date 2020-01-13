#! /bin/sh

while [[ ! -e /etc/rancher-conf/plugins.txt ]]; do
  echo "waiting for plugin file"
  sleep 1
done

plugins=$(cat /etc/rancher-conf/plugins.txt | sort | uniq)
for plugin in $plugins; do
  if echo $plugin | grep -E 'http[s]?://'; then
    fname=$(echo ${plugin##*/} | cut -d# -f1 | cut -d? -f1)
    wget -O /etc/rancher-conf/plugins/$fname $plugin
  else
    gem install $plugin
  fi
done

rm /etc/rancher-conf/plugins.txt

# Restart fluentd process
kill -HUP 1

