#!/usr/bin/env bash

set -e

source $DEVOPS_WORKSPACE/env

cat Dockerfile

docker login $DOCKER_SERVER -u $DOCKER_USERNAME -p $DOCKER_PASSWORD

docker build -t $DOCKER_IMAGE .
docker push $DOCKER_IMAGE

docker tag $DOCKER_IMAGE $DOCKER_REPOSITORY:$PROJECT_MAJOR_VERSION
docker tag $DOCKER_IMAGE $DOCKER_REPOSITORY:$PROJECT_VERSION
docker tag $DOCKER_IMAGE $DOCKER_REPOSITORY:$PROJECT_VERSION-$DATE_TAG
docker push $DOCKER_REPOSITORY

docker image rm $DOCKER_IMAGE
docker image rm $DOCKER_REPOSITORY:$PROJECT_MAJOR_VERSION
docker image rm $DOCKER_REPOSITORY:$PROJECT_VERSION
docker image rm $DOCKER_REPOSITORY:$PROJECT_VERSION-$DATE_TAG
