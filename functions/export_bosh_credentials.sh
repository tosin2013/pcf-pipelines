#!/bin/bash -e

export pcf_admin_username=$(om-linux \
  --target "https://${OPSMAN_URL}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USER}" \
  --password "${OPSMAN_PASSWORD}" \
  credentials  -p cf -c .uaa.admin_credentials -f identity)

export pcf_admin_password=$(om-linux \
  --target "https://${OPSMAN_URL}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USER}" \
  --password "${OPSMAN_PASSWORD}" \
  credentials  -p cf -c .uaa.admin_credentials -f password)

export uaa_admin_client=$(om-linux \
  --target "https://${OPSMAN_URL}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USER}" \
  --password "${OPSMAN_PASSWORD}" \
  credentials  -p cf -c .uaa.admin_client_credentials -f identity)

export uaa_admin_client_secret=$(om-linux \
  --target "https://${OPSMAN_URL}" \
  --skip-ssl-validation \
  --username "${OPSMAN_USER}" \
  --password "${OPSMAN_PASSWORD}" \
  credentials  -p cf -c .uaa.admin_client_credentials -f password)
