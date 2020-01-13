#!/bin/sh

echo 'reloading...'

deployment=$(docker inspect $HOSTNAME | jq -r '.[0].Config.Labels["io.rancher.service.deployment.unit"]')
container=$(docker ps -q | \
  xargs docker inspect \
  | jq -r '.[] | select(.Config.Labels["io.rancher.service.deployment.unit"] == "'$deployment'") | .Id'
  | grep -v $deployment

if [[ "$container" != "" ]]; then
  docker exec $container sh /opt/rancher/bin/update-plugins.sh
fi
