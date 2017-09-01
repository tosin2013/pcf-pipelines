#!/bin/bash -e

guid=$(om-linux \
  --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USERNAME}" \
  --password "${OPSMAN_PASSWORD}" \
  curl -s -p /api/v0/deployed/products | jq -r '.[] | select(.type == "cf").guid')

om-linux \
  --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USERNAME}" \
  --password "${OPSMAN_PASSWORD}" \
  curl -s -p /api/v0/deployed/products/$guid/manifest > pcf-manifest.json

export cf_uaa_admin_client_secret=$(cat pcf-manifest.json | jq -r '.instance_groups[] | select(.name=="uaa").properties.uaa.admin.client_secret')

uaac target https://uaa.$SYSTEM_DOMAIN --skip-ssl-validation
uaac token client get admin -s $cf_uaa_admin_client_secret
if [[ $(uaac client get firehose-to-loginsight) = *NotFound* ]]; then
uaac client add $CLIENT_NAME \
--name $CLIENT_NAME \
--authorities $CLIENT_AUTHORITIES \
--authorized_grant_types $CLIENT_GRANT_TYPES \
-s $CLIENT_SECRET
fi

