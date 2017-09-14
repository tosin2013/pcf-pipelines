#!/bin/bash -e

source ./pcf-pipelines/functions/export_bosh_credentials.sh
source ./pcf-pipelines/functions/export_cf_credentials.sh


bosh -n -d rmq-broker deploy ./pcf-pipelines/tasks/deploy-rmq-broker/rmq-broker.yml \
  -v cf_deployment_name=$cf_product_guid \
  -v broker_ip=$RMQ_BROKER_IP \
  -v system_domain=$SYSTEM_DOMAIN \
  -v pcf_admin_user=$pcf_admin_username \
  -v pcf_admin_password=$pcf_admin_password \
  -v syslog_host=$SYSLOG_HOST \
  -v syslog_port=$SYSLOG_PORT \
  -v rmq_management_domain=$RMQ_MANAGEMENT_DOMAIN \
  -v rmq_host=$RMQ_HOST \
  -v rmq_user=$RMQ_USER \
  -v rmq_password=$RMQ_PASSWORD \
  -v broker_ip=$RMQ_BROKER_IP 


 bosh -n -d rmq-broker run-errand broker-registrar
