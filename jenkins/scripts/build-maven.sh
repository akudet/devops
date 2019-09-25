#!/usr/bin/env bash

export ROOT_PROJECT_NAME=$(mvn -q \
    -Dexec.executable=echo \
    -Dexec.args='${project.name}' \
    --non-recursive \
    exec:exec)
export PROJECT_GROUP==$(mvn -q \
    -Dexec.executable=echo \
    -Dexec.args='${project.groupId}' \
    --non-recursive \
    exec:exec)
export PROJECT_NAME=$(mvn -q \
    -Dexec.executable=echo \
    -Dexec.args='${project.artifactId}' \
    --non-recursive \
    exec:exec)
export PROJECT_VERSION=$(mvn -q \
    -Dexec.executable=echo \
    -Dexec.args='${project.version}' \
    --non-recursive \
    exec:exec)
export PROJECT_MAJOR_VERSION=$(echo $PROJECT_VERSION | awk '{split($0,v,"."); print v[1]}')
export DOCKER_IMAGE=$DOCKER_SERVER/$ROOT_PROJECT_NAME/$PROJECT_NAME:$PROJECT_VERSION-$BUILD_NUMBER

envsubst < $DEVOPS_WORKSPACE/jenkins/scripts/env > $DEVOPS_WORKSPACE/env
cat $DEVOPS_WORKSPACE/env

mvn package  -Dmaven.test.skip=true

mkdir -p docker/app
cp build/libs/$PROJECT_NAME-$PROJECT_VERSION.jar docker/app/app.jar
envsubst < $DEVOPS_WORKSPACE/jenkins/docker/java/Dockerfile > docker/Dockerfile
