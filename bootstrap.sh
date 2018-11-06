#!/bin/bash

$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do echo == $cp; curl -LO $cp ; done; cd -

sed s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/core-site.xml.template >  /usr/local/hadoop/etc/hadoop/core-site.xml

# setting spark defaults
echo spark.yarn.jars hdfs:///spark/*.jar > $SPARK_HOME/conf/spark-defaults.conf
cp $SPARK_HOME/conf/metrics.properties.template $SPARK_HOME/conf/metrics.properties


/usr/sbin/sshd

$HADOOP_PREFIX/sbin/start-dfs.sh
$HADOOP_PREFIX/sbin/start-yarn.sh



while true; do sleep 1000; done

