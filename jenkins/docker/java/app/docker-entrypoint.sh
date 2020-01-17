#!/bin/sh

pwd
ls -al
ls -al /run/secrets/run_env/env

source /run/secrets/run_env/env

printenv

java -Duser.timezone=GMT+8 -Dspring.profiles.active=$SPRING_PROFILES_ACTIVE -jar app.jar
