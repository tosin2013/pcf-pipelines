#!/bin/bash -e

export SERVICE_AZS=$(echo $SERVICES_NW_AZS | jq -R '(split(",") | map({name: .}))')
export FIRST_SERVICE_AZ=$(echo $SERVICES_NW_AZS | jq -R 'split(",") | .[0]')

NETWORK=$(envsubst < ./pcf-pipelines/tiles/$PRODUCT_NAME-network.json)
PROPERTIES=$(envsubst < ./pcf-pipelines/tiles/$PRODUCT_NAME-properties.json)
RESOURCES=$(envsubst < ./pcf-pipelines/tiles/$PRODUCT_NAME-resources.json)

om-linux -t $OPSMAN_URL -u $OPSMAN_USER -p $OPSMAN_PASSWORD -k configure-product -n $PRODUCT_NAME -p "$PROPERTIES" -pn "$NETWORK" -pr "$RESOURCES"
