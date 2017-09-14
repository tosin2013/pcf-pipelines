#!/bin/bash -e

export pcf_admin_username=$(om-linux \
  --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USER}" \
  --password "${OPSMAN_PASSWORD}" \
  credentials  -p cf -c .uaa.admin_credentials -f identity)

export pcf_admin_password=$(om-linux \
  --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USER}" \
  --password "${OPSMAN_PASSWORD}" \
  credentials  -p cf -c .uaa.admin_credentials -f password)

export uaa_admin_client=$(om-linux \
  --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USER}" \
  --password "${OPSMAN_PASSWORD}" \
  credentials  -p cf -c .uaa.admin_client_credentials -f identity)

export uaa_admin_client_secret=$(om-linux \
  --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USER}" \
  --password "${OPSMAN_PASSWORD}" \
  credentials  -p cf -c .uaa.admin_client_credentials -f password)

export cf_product_guid=$(om-linux \		 +source ./pcf-pipelines/functions/export_cf_credentials.sh
  --target "https://${OPSMAN_URL}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USER}" \
  --password "${OPSMAN_PASSWORD}" \
  curl -s -p /api/v0/deployed/products | jq -r '.[] | select(.type == "cf").guid'
