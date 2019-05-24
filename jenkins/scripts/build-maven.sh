#!/usr/bin/env bash

export ROOT_PROJECT_NAME=$(gradle properties -q | grep "rootProject:" | awk '{print substr($4,2,length($4)-2)}')
export PROJECT_GROUP=$(gradle properties -q | grep "group:" | awk '{print $2}')
export PROJECT_NAME=$(gradle properties -q | grep "name:" | awk '{print $2}')
export PROJECT_VERSION=$(gradle properties -q | grep "version:" | awk '{print $2}')
export PROJECT_JAR="$PROJECT_NAME-$PROJECT_VERSION.jar"

gradle build

mkdir docker
cp "build/libs/$PROJECT_JAR" docker/
envsubst < $WORKSPACE/dists/jenkins/scripts/env.txt > docker/env
envsubst < $WORKSPACE/dists/jenkins/scripts/template.txt > docker/Dockerfile

cat docker/env
cat docker/Dockerfile

