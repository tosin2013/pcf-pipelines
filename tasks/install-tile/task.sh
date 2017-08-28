#!/bin/bash -e

old_ifs=$IFS
IFS=','
service_azs=($SERVICES_NW_AZS)
IFS=$old_ifs
export FIRST_SERVICE_AZ=${service_azs[0]}
#export OTHER_SERVICE_AZS=("${service_azs[@]:1}")

NETWORK=$(envsubst < ./pcf-pipelines/tiles/$PRODUCT_NAME-network.json)
PROPERTIES=$(envsubst < ./pcf-pipelines/tiles/$PRODUCT_NAME-properties.json)
RESOURCES=$(envsubst < ./pcf-pipelines/tiles/$PRODUCT_NAME-resources.json)

om-linux -t $OPSMAN_URL -u $OPSMAN_USER -p $OPSMAN_PASSWORD -k -k configure-product -n $PRODUCT_NAME -p "$PROPERTIES" -pn "$NETWORK" -pr "$RESOURCES"
