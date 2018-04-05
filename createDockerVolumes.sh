#!/bin/bash

echo "Creating Docker Volumes for Mongo ..."
echo "Creating data Volume for Primary.."
exists=`docker volume ls | grep mongo-data-primary`
if [ "$exists" == "" ]
then
  docker volume create --name mongo-data-primary
  echo "Done"
else
  echo "Volume mongo-data-primary already exists."
fi
echo "Creating Config Volume for Primary.."
exists=`docker volume ls | grep mongo-config-primary`
if [ "$exists" == "" ]
then
  docker volume create --name mongo-config-primary
  echo "Done"
else
  echo "Volume mongo-config-primary already exists."
fi
echo "Creating data Volume for Secondary 1.."
exists=`docker volume ls | grep mongo-data-secondary-1`
if [ "$exists" == "" ]
then
  docker volume create --name mongo-data-secondary-1
  echo "Done"
else
  echo "Volume mongo-data-secondary-1 already exists."
fi
echo "Creating Config Volume for Secondary 1.."
exists=`docker volume ls | grep mongo-config-secondary-1`
if [ "$exists" == "" ]
then
  docker volume create --name mongo-config-secondary-1
  echo "Done"
else
  echo "Volume mongo-config-secondary-1 already exists."
fi
echo "Creating data Volume for Secondary 2.."
exists=`docker volume ls | grep mongo-data-secondary-2`
if [ "$exists" == "" ]
then
  docker volume create --name mongo-data-secondary-2
  echo "Done"
else
  echo "Volume mongo-data-secondary-2 already exists."
fi
echo "Creating Config Volume for Secondary 2.."
exists=`docker volume ls | grep mongo-config-secondary-2`
if [ "$exists" == "" ]
then
  docker volume create --name mongo-config-secondary-2
  echo "Done"
else
  echo "Volume mongo-config-secondary-2 already exists."
fi
echo "Creating Docker Volumes for Elastic Search..."
exists=`docker volume ls | grep elastic-search-data`
if [ "$exists" == "" ]
then
  docker volume create --name elastic-search-data
  echo "Done"
else
  echo "Volume elastic-search-data already exists."
fi
