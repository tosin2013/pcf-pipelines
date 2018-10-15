#!/bin/bash -e

source ./pcf-pipelines/functions/export_cf_credentials.sh

uaac target https://uaa.$SYSTEM_DOMAIN --skip-ssl-validation
uaac token client get admin -s $uaa_admin_client_secret
if [[ $(uaac client get firehose-to-loginsight) = *NotFound* ]]; then
uaac client add $CLIENT_NAME \
--name $CLIENT_NAME \
--authorities $CLIENT_AUTHORITIES \
--authorized_grant_types $CLIENT_GRANT_TYPES \
-s $CLIENT_SECRET
fi

