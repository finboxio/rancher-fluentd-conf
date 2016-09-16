#! /bin/sh

plugins=$(cat /etc/rancher-conf/plugins.txt)
for plugin in $plugins; do
  if echo $plugin | grep 'http[s]?://'; then
    curl -L -o /etc/rancher-conf/plugins/ $plugin
  else
    gem install $plugin
  fi
done
