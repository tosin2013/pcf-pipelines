#!/usr/bin/env bash
set -e

### Load env

source ./pcf-pipelines/functions/export_cf_credentials.sh
source ./pcf-pipelines/functions/cf-helpers.sh
cf_authenticate_and_target
cf_target_org_and_space system system

register_broker mongodb-enterprise mongo $MONGO_BROKER_PASSWORD "https://mongodb-service-broker.$APPS_DOMAIN"

enable_global_access mongodb-enterprise
