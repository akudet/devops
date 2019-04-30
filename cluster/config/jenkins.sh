#!/usr/bin/env bash

docker service create --name jenkins \
  --publish 8080:8080 --publish 50000:50000 \
  --mount src=jenkins_home,dst=/var/jenkins_home \
  jenkins/jenkins:lts
  
docker run \
  --rm -d \
  -u root \
  -p 5080:8080 \
  -v ~/jenkins_blueocean:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ~/jenkins_blueocean_home:/home \
  jenkinsci/blueocean