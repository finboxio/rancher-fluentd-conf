
1.11.6 / 2021-12-30
==================

  * Add image name/tag to docker plugin

1.11.5 / 2021-06-16
==================

  * update rancher-conf

1.11.4 / 2021-06-12
==================

  * Update rancher-conf image

1.11.2 / 2021-04-14
==================

  * Update rancher-conf-aws base image (fix null host issue)

1.11.1 / 2021-04-02
==================

  * Fix deadlock issue preventing config update
  * Create LICENSE

1.11.0 / 2020-11-14
==================

  * Multiprocess workers, ECS support, and split processing

1.10.0 / 2020-04-06
==================

  * Separate config for agent & collector

1.9.0 / 2020-02-25
==================

  * Add host metadata to log messages

1.8.4 / 2020-02-13
==================

  * Fix selection of nested timestamps

1.8.3 / 2020-01-12
==================

  * Make buffer directory a volume
  * Fix reload script and optimize buffer settings
  * Clean up reload mechanism

1.8.2 / 2020-01-12
==================

  * Nest expat fields using _ to avoid ECS compatibility issues

1.8.1 / 2020-01-12
==================

  * Fix kibana log format

1.8.0 / 2020-01-09
==================

  * Update config for fluentd v1

0.0.9 / 2020-01-07
===================

  * Fix fluent conf for docker.container fields

0.0.8 / 2020-01-07
==================

  * Fix docker label resolution

0.0.7 / 2020-01-07
==================

  * Add host.name to records

0.0.6 / 2020-01-07
==================

  * Add kibana filter for @timestamp

0.0.5 / 2020-01-02
==================

  * Support timestamp override

0.0.4 / 2017-01-10
==================

  * sanitize non-utf8 characters from docker logs prior to processing
  * try to fix parsing of strings with extended ascii characters
  * switch to released rancher-aws-conf

0.0.3 / 2016-10-10
==================

  * support parsing fields as numbers

0.0.2 / 2016-09-21
==================

  * uncolorize log before pattern-matching

0.0.1 / 2016-09-19
==================

  * service-configurable plugins stores, and pipelines

0.0.0 / 2016-09-10
==================

 * Initial commit
