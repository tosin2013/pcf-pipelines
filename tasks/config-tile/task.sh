#!/bin/bash

set -eu

tile_network=$(
  echo '{}' |
  jq \
    --arg network_name "$NETWORK_NAME" \
    --arg other_azs "$DEPLOYMENT_NW_AZS" \
    --arg singleton_az "$SINGLETON_JOB_AZ" \
    '
    . +
    {
      "network": {
        "name": $network_name
      },
      "other_availability_zones": ($other_azs | split(",") | map({name: .})),
      "singleton_availability_zone": {
        "name": $singleton_az
      }
    }
    '
)


if [ "${CLIENT_SECRET}" == "true" ]; then
  AUTH_PAIR="--client-id ${OPS_MGR_USR} --client-secret ${OPS_MGR_PWD}"
else
  AUTH_PAIR="--username ${OPS_MGR_USR} --password ${OPS_MGR_PWD}"
fi

om-linux \
  --target https://$OPS_MGR_HOST \
  ${AUTH_PAIR} \
  --skip-ssl-validation \
  configure-product \
  --product-name $PRODUCT_NAME \
  --product-network "$tile_network" 
