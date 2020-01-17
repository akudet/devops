#!/usr/bin/env bash

export ROOT_PROJECT_NAME=$(gradle properties -q | grep "rootProject:" | awk '{print substr($4,2,length($4)-2)}')
export PROJECT_GROUP=$(gradle properties -q | grep "group:" | awk '{print $2}')
export PROJECT_NAME=$(gradle properties -q | grep "name:" | awk '{print $2}')
export PROJECT_VERSION=$(gradle properties -q | grep "version:" | awk '{print $2}')
export PROJECT_MAJOR_VERSION=$(echo $PROJECT_VERSION | awk '{split($0,v,"."); print v[1]}')
export DOCKER_IMAGE=$DOCKER_SERVER/$ROOT_PROJECT_NAME/$PROJECT_NAME:$PROJECT_VERSION-$BUILD_NUMBER

envsubst < $DEVOPS_WORKSPACE/jenkins/scripts/env > $DEVOPS_WORKSPACE/env
cat $DEVOPS_WORKSPACE/env

gradle build

mkdir -p docker/app

cp -r $DEVOPS_WORKSPACE/jenkins/docker/java/* docker/
cp build/libs/$PROJECT_NAME-$PROJECT_VERSION.jar docker/app/app.jar
envsubst < $DEVOPS_WORKSPACE/jenkins/docker/java/Dockerfile > docker/Dockerfile
