#!/bin/bash

# Prepare empty file for MapR-FS
dd if=/dev/zero of=$STORAGE_FILE bs=1G count=$DISK_SIZE_IN_GB
chmod 777 $STORAGE_FILE
#$MAPR_HOME/server/configure.sh -v -a -G 5000 -U 5000 -N $CLUSTER_NAME -C $(hostname -f) -Z $(hostname -f) -HS $(hostname -f) -F $DISKS_FILE -no-autostart -noDB --isvm
RunConfigureMapR=$(cat << EOF
$MAPR_HOME/server/configure.sh -v -a -G 5000 -U 5000 -N $CLUSTER_NAME -C localhost -Z localhost -HS localhost -F $DISKS_FILE -no-autostart -noDB --isvm
EOF
)
eval $RunConfigureMapR
echo $RunConfigureMapR
echo "mapr:mapr" | chpasswd


# Start Zookeeper
service mapr-zookeeper start

# Start Warden
service mapr-warden start

# Verify MapR availability
sleep 120
maprcli node cldbmaster
maprcli service list
maprcli disk list -host $(hostname -f)
maprcli config save -values '{"cldb.volumes.default.replication": 1, "cldb.volumes.default.min.replication":1}'

# Reset volume replication to one
maprcli volume list -json | jq '.data[].volumename' | xargs -L 1 maprcli volume modify -replication 1 -minreplication 1 -name
maprcli volume list -json | jq '.data[].volumename' | xargs -L 1 maprcli volume modify -nsreplication 1 -nsminreplication 1 -name
maprcli alarm clearall

#cp /opt/mapr/conf/mapr-clusters.conf dest=/usr/local/mapr-loopbacknfs/conf/mapr-clusters.conf
#mkdir /mapr
#service rpcbind start
#service mapr-loopbacknfs start

# Install Ecosystem Components
echo CONFIGURE >> /DOCKER_STATE

# SPARK Installation #
hadoop fs -mkdir -p /apps/spark
hadoop fs -chmod 777 /apps/spark

echo READY >> /DOCKER_STATE
/bin/bash