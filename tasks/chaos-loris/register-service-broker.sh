#!/usr/bin/env bash
set -e

### Load env

source ./pcf-pipelines/functions/export_cf_credentials.sh
source ./pcf-pipelines/functions/cf-helpers.sh
cf_authenticate_and_target
cf_target_org_and_space system chaos-loris
cf target -o $ORG -s $SPACE

cf_create_service p-mysql 100mb chaos-loris-broker

register_broker chaos-loris loris cha0s-l0r1s "https://chaos-loris-broker.$APPS_DOMAIN"

enable_global_access chaos-loris
