#!/bin/sh

source /run/secrets/run_env/env

java -Duser.timezone=GMT+8 -jar app.jar
