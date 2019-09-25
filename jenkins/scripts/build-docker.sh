#!/usr/bin/env bash

cd docker

source $DEVOPS_WORKSPACE/env

cat Dockerfile

docker login $DOCKER_SERVER -u $DOCKER_USERNAME -p $DOCKER_PASSWORD

docker build -t $DOCKER_IMAGE .
docker push $DOCKER_IMAGE
docker image rm $DOCKER_IMAGE
