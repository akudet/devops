#!/usr/bin/env bash

source ../env

export DEPLOY_NAME=${PROJECT_NAME}-${DEPLOY_ENV}
export DEPLOY_TIMEOUT=360

# --force is needed  due to an issue https://github.com/helm/helm/issues/3208
# TODO: better solution
helm upgrade -i --wait --timeout $DEPLOY_TIMEOUT --force --kube-context $DEPLOY_SERVER --namespace $DEPLOY_ENV $DEPLOY_NAME .

if [[ $? -ne 0 ]]; then
    helm rollback --wait --timeout $DEPLOY_TIMEOUT --kube-context $DEPLOY_SERVER $DEPLOY_NAME 0
    exit 1
fi