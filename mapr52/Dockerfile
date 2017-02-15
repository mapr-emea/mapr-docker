FROM devproof/ubuntu

# Set environment variables
ENV MAPR_USER mapr
ENV MAPR_HOME /opt/mapr
ENV CLUSTER_NAME docker.mapr.com
ENV DISKS_FILE /root/disks.txt
ENV STORAGE_FILE /tmp/storagefile
ENV DISK_SIZE_IN_GB 20

ADD ./config /root/config

# Import key
RUN wget -nv -O - http://package.mapr.com/releases/pub/maprgpg.key | sudo apt-key add -

# Remote repository
RUN echo deb http://package.mapr.com/releases/v5.2.0/ubuntu/ mapr optional >> /etc/apt/sources.list
RUN echo deb http://package.mapr.com/releases/MEP/MEP-2.0.0/ubuntu/ binary trusty >> /etc/apt/sources.list
RUN echo deb http://package.mapr.com/patches/releases/v5.2.0/ubuntu/ binary/ >> /etc/apt/sources.list

RUN apt-get -qq update

# Install MapR core
RUN apt-get -qq install -y --force-yes \
    mapr-core \
    mapr-fileserver \
    mapr-cldb \
    mapr-zookeeper \
    mapr-loopbacknfs nfs-common \
    mapr-webserver \
    mapr-gateway \
    mapr-resourcemanager \
    mapr-nodemanager \
    mapr-historyserver

RUN apt-get -qq install -y --force-yes \
    mapr-patch

#RUN cp /root/config/core-site.xml ${HADOOP_HOME}/etc/hadoop/core-site.xml


# Hive
ENV HIVE_HOME ${MAPR_HOME}/hive/hive-1.2
RUN apt-get -qq install -y --force-yes mapr-hive mapr-hiveserver2 mapr-hivemetastore
RUN cp /root/config/hive-site.xml ${HIVE_HOME}/conf/hive-site.xml

# Spark
ENV SPARK_HOME ${MAPR_HOME}/spark/spark-2.0.1
RUN apt-get -qq install -y --force-yes mapr-spark
#RUN cp /root/config/hive-site.xml ${SPARK_HOME}/conf/hive-site.xml

# Drill
RUN apt-get -qq install -y --force-yes mapr-drill

RUN echo $STORAGE_FILE >> $DISKS_FILE

EXPOSE 123 389 636 1111 2049 2888 3306 3888 4040 5181 5660 6660 7077 7220 7221 7222 7443 7660 \
       8002 8008 8030 8031 8032 8033 8040 8041 8042 8044 8047 8080 8088 8090 8443 8888 9001 9083 \
       9090 9997 9997 9998 9998 10000 10020 11000 12000 13562 14000 18080 19888 19890 \
       21000 21050 25000 25010 25020 50030 50060 60000 60010 60020

ADD ./init_cluster.sh /root/init_cluster.sh
RUN chmod u+x /root/init_cluster.sh
CMD /root/init_cluster.sh

