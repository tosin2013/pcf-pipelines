#!/bin/bash

set -eu

json_network_doc=". + $(cat pcf-pipelines/tiles/redis-network.json)"
json_properties_doc=". + $(cat pcf-pipelines/tiles/redis-network.json)"
json_resource_doc=". + $(cat pcf-pipelines/tiles/redis-network.json)"

tile_network=$(
  echo '{}' |
  jq \
    --arg network_name "$NETWORK_NAME" \
    --arg other_azs "$DEPLOYMENT_NW_AZS" \
    --arg singleton_az "$SINGLETON_JOB_AZ" \
    --arg service_network_name "$SERVICE_NETWORK_NAME" \
    "$json_network_doc"
)


om-linux \
  --target https://$OPS_MGR_HOST \
  --username $OPS_MGR_USR \
  --password $OPS_MGR_PWD \
  --skip-ssl-validation \
  configure-product \
  --product-name $PRODUCT_NAME \
  --product-network "$tile_network" #\
#  --product-properties "$tile_properties" \
#  --product-resources "$tile_resources"
