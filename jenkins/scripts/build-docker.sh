#!/usr/bin/env bash

source ./env

docker login -u$DOCKER_USERNAME -p$DOCKER_PASSWORD $DOCKER_SERVER

docker build -t $DOCKER_IMAGE .
docker push $DOCKER_IMAGE
docker image rm $DOCKER_IMAGE
