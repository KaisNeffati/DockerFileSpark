FROM neffatikais/hadoop

RUN curl -L http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s spark-2.1.0-bin-hadoop2.7 spark

ENV SPARK_HOME /usr/local/spark
RUN mkdir $SPARK_HOME/yarn-remote-client
ADD yarn-remote-client $SPARK_HOME/yarn-remote-client 

ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV PATH $PATH:$SPARK_HOME/bin:$HADOOP_PREFIX/bin

# update boot script
COPY starthadoop.sh /bootstrap.sh
RUN chown root.root /bootstrap.sh
RUN chmod 700 /bootstrap.sh

RUN bash /bootstrap.sh && $HADOOP_PREFIX/bin/hdfs dfsadmin -safemode leave && \
$HADOOP_PREFIX/bin/hdfs dfs -put $SPARK_HOME-2.1.0-bin-hadoop2.7/jars /spark


# update boot script
COPY bootstrap.sh /bootstrap.sh
RUN chown root.root /bootstrap.sh
RUN chmod 700 /bootstrap.sh

#Fixing memory usage to prevent yarn form killing container by virtual memory limits
COPY yarn-site.xml $HADOOP_PREFIX/etc/hadoop/yarn-site.xml 
RUN chown root.root $HADOOP_PREFIX/etc/hadoop/yarn-site.xml
RUN chmod 700 $HADOOP_PREFIX/etc/hadoop/yarn-site.xml

ENTRYPOINT ["bash","/bootstrap.sh"]


