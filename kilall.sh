#!/bin/bash

echo "Stopping all services ..."
echo "Stopping Mongo .."
docker service rm mongodb-secondary-2
docker service rm mongodb-secondary-1
docker service rm mongodb
echo "Done"
echo "Elastc Search .."
docker service rm elastic-search
echo "Done"
echo "Transporter .."
docker service rm mongo-es-transporter
echo "Done"
echo " Remove any containers.."
containers=`docker ps -all -q`
echo $containers
for cont in `echo $containers`
do
  echo "remove container $cont"
  docker rm $cont
done
