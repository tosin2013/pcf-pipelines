#!/usr/bin/env bash
set -e

### Load env

source ./pcf-pipelines/functions/export_cf_credentials.sh
source ./pcf-pipelines/functions/cf-helpers.sh

cf_authenticate_and_target
cf_target_org_and_space system system 


pushd binary
cat > manifest.yml <<EOS
---
applications:
- name: mongodb-service-broker
  memory: 1G
  instances: 1
  path: cloudfoundry-mongodb-service-broker.jar
  env:
    MONGODB_HOST: $MONGO_HOST
    MONGODB_PORT: $MONGO_PORT
    MONGODB_USERNAME: $MONGO_USER
    MONGODB_PASSWORD: $MONGO_PASSWORD
    SECURITY_USER_NAME: mongo
    SECURITY_USER_PASSWORD: $MONGO_BROKER_PASSWORD
EOS
cf push
popd

