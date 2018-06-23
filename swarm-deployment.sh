#!/bin/bash

# Run mongodb replication set
# Set the vm size
sudo sysctl -w vm.max_map_count=262144
./createDockerVolumes.sh
echo "Setting up Mongo Primary Node..."
docker service create \
  --name mongodb \
  -p 30001:27017 \
  --mount type=volume,source=mongo-data-primary,target=/data/db \
  --mount type=volume,source=mongo-config-primary,target=/data/configdb \
  --network flavournw \
  --detach=false \
  mongo:3.4 mongod --replSet flavour-mongo-set
echo "Done"

echo "Setting up Secondary Mongo Node 1..."
docker service create \
  --name mongodb-secondary-1 \
  -p 30002:27017 \
  --mount type=volume,source=mongo-data-secondary-1,target=/data/db \
  --mount type=volume,source=mongo-config-secondary-1,target=/data/configdb \
  --network flavournw \
  --detach=false \
  mongo:3.4 mongod --replSet flavour-mongo-set

echo "Done"

echo "Setting up Secondary Mongo Node 2..."
docker service create \
  --name mongodb-secondary-2 \
  -p 30003:27017 \
  --mount type=volume,source=mongo-data-secondary-2,target=/data/db \
  --mount type=volume,source=mongo-config-secondary-2,target=/data/configdb \
  --network flavournw \
  --detach=false \
  mongo:3.4 mongod --replSet flavour-mongo-set

echo "Done"

echo "Wait for Services to Start..."
sleep 1
echo "Setup Replication .."
docker exec -it $(docker ps -qf label=com.docker.swarm.service.name=mongodb) \
  mongo --eval 'rs.initiate({ _id: "flavour-mongo-set", members: [{ _id: 0, host: "mongodb:27017" }, { _id: 1, host: "mongodb-secondary-1:27017", priority:0 }, { _id: 2, host: "mongodb-secondary-2:27017", priority : 0 }], settings: { getLastErrorDefaults: { w: "majority", wtimeout: 30000 }}})'
echo "Wait for Replication voting..."
sleep 1
docker exec -it $(docker ps -qf label=com.docker.swarm.service.name=mongodb) mongo --eval 'rs.status()'
echo "Done"


echo "+++++++++++++++++++++++++"
echo "Starting Elastic Search"
echo "+++++++++++++++++++++++++"
docker service create \
  --name elastic-search \
  -p 9300:9200 \
  --network flavournw \
  --mount type=volume,source=elastic-search-data,target=/usr/share/elasticsearch/data \
  --detach=false \
  docker.elastic.co/elasticsearch/elasticsearch:5.6.8
echo "Done"

echo "--------------------------"
echo "Starting Transporter"
echo "--------------------------"
work_dir=`pwd`
docker service create \
  --name mongo-es-transporter \
  --network flavournw \
  --detach=false \
  --mount type=bind,source=/var/log,target=/var/log \
  --mount type=bind,source=$work_dir/mongo-connector-startup.sh,target=/tmp/startup.sh \
  --env MONGO=mongodb \
  --env ELASTICSEARCH=http://elastic:changeme@elastic-search \
  yeasy/mongo-connector

echo "Done"

docker service ls
