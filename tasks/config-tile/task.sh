#!/bin/bash -e

export JSON_SERVICE_AZS=$(echo $SERVICES_NW_AZS | jq -R '(split(",") | map({name: .}))')
export ARRAY_SERVICE_AZS=$(echo $SERVICES_NW_AZS | jq -R 'split(",")')
export FIRST_SERVICE_AZ=$(echo $SERVICES_NW_AZS | jq -R 'split(",") | .[0]')

NETWORK=$(erb < ./pcf-pipelines/tiles/$PRODUCT_NAME-network.json.erb)
PROPERTIES=$(erb < ./pcf-pipelines/tiles/$PRODUCT_NAME-properties.json.erb)
RESOURCES=$(erb < ./pcf-pipelines/tiles/$PRODUCT_NAME-resources.json.erb)

echo "$NETWORK"
echo $NETWORK | jq
echo $PROPERTIES 
echo $PROPERTIES | jq
echo $RESOURCES
echo $RESOURCES | jq

om-linux -t $OPSMAN_URL -u $OPSMAN_USER -p $OPSMAN_PASSWORD -k configure-product -n $PRODUCT_NAME -p "$PROPERTIES" -pn "$NETWORK" -pr "$RESOURCES"
