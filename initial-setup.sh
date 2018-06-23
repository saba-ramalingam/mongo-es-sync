#!/bin/bash
docker network create --driver=overlay flavournw
sudo sysctl -w vm.max_map_count=262144

