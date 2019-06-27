#!/usr/bin/env bash

cat Dockerfile

docker login $DOCKER_SERVER

docker build -t $DOCKER_IMAGE .
docker push $DOCKER_IMAGE
docker image rm $DOCKER_IMAGE
