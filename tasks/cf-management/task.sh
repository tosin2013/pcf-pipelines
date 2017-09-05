#!/bin/bash

source ./pcf-pipelines/functions/export_cf_credentials.sh

export SYSTEM_DOMAIN=$SYSTEM_DOMAIN
export USER_ID=$pcf_admin_username
export PASSWORD=$pcf_admin_password
export CLIENT_SECRET=$uaa_admin_client_secret
export LDAP_PASSWORD=$LDAP_PASSWORD

cf-mgmt $CF_MGMT_COMMAND --config-dir ./pcf-pipelines/pipelines/cf-management/config

