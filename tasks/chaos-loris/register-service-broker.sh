#!/usr/bin/env bash
set -e

### Load env

source ./pcf-pipelines/functions/export_cf_credentials.sh
cf api https://api.${SYSTEM_DOMAIN} --skip-ssl-validation
cf auth $pcf_admin_username $pcf_admin_password
cf target -o $ORG -s $SPACE

cf_target_org_and_space system chaos-loris

cf_create_service p-mysql 10mb chaos-loris-broker

register_broker chaos-loris loris cha0s-l0r1s "https://chaos-loris-broker.$APPS_DOMAIN"

enable_global_access chaos-loris
