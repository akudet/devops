#!/usr/bin/env bash

export ROOT_PROJECT_NAME=$(gradle properties -q | grep "rootProject:" | awk '{print substr($4,2,length($4)-2)}')
export PROJECT_GROUP=$(gradle properties -q | grep "group:" | awk '{print $2}')
export PROJECT_NAME=$(gradle properties -q | grep "name:" | awk '{print $2}')
export PROJECT_VERSION=$(gradle properties -q | grep "version:" | awk '{print $2}')
export PROJECT_MAJOR_VERSION=$(echo $PROJECT_VERSION | awk '{split($0,v,"."); print v[1]}')
export PROJECT_JAR="$PROJECT_NAME-$PROJECT_VERSION.jar"
export DOCKER_IMAGE=$DOCKER_SERVER/$ROOT_PROJECT_NAME/$PROJECT_NAME:$PROJECT_VERSION-$BUILD_NUMBER
export APP_NAME=$PROJECT_NAME-v$PROJECT_MAJOR_VERSION

envsubst < $WORKSPACE/dists/jenkins/scripts/env > env

gradle build

mkdir docker
cp "build/libs/$PROJECT_JAR" docker/
envsubst < $WORKSPACE/dists/jenkins/docker/java/Dockerfile > docker/Dockerfile

sh $WORKSPACE/dists/jenkins/scripts/gen-helm.sh

cat env

