if [[ -z $SYSTEM_DOMAIN || -z $pcf_admin_username || -z $pcf_admin_password ]]; then
  echo "ERROR: one of the following environment variables is not set: "
  echo ""
  echo "                 SYSTEM_DOMAIN"
  echo "                 pcf_admin_username"
  echo "                 pcf_admin_password"
  echo ""
  exit 1
fi

function cf_authenticate_and_target() {
  cf api https://api.${SYSTEM_DOMAIN} --skip-ssl-validation
  cf auth $pcf_admin_username $pcf_admin_password
  exit_on_error "Error authenticating with cf"
}

function cf_target_org_and_space() {
  ORG=$1
  SPACE=$2

  if ! (cf orgs | grep "^${ORG}$"); then
    cf create-org $ORG
  fi
  cf target -o $ORG

  if ! (cf spaces | grep "^${SPACE}$"); then
    cf create-space $SPACE
  fi
  cf target -s $SPACE
  exit_on_error "Error with authentication"
}

function cf_create_service() {
  SERVICE_NAME=$1
  PLAN=$2
  SERVICE_INSTANCE_NAME=$3

  if ! (cf marketplace | grep  "^${SERVICE_NAME}\ "); then
    exit_on_error "You need to have ${SERVICE_NAME} in your marketplace to use this product."
  fi

  if ! (cf services | grep  "^${SERVICE_INSTANCE_NAME}\ "); then
    cf create-service $SERVICE_NAME $PLAN $SERVICE_INSTANCE_NAME
    exit_on_error "Error Creating Service."
  else
    echo "The service instance $SERVICE_INSTANCE_NAME exists."
  fi
}

# Todo: think how this can be exatracted?
function exit_on_error() {
  ERROR_MESSAGE=$1
  if [ $? != 0 ];
  then
      echo $ERROR_MESSAGE
      exit 1
  fi
}

function register_broker() {
  
  PRODUCT_NAME=$1;
  BROKER_HOST=$2;
  [ -z "$1" ] && { echo "PRODUCT_NAME arg must be set"; exit 1; }
  [ -z "$2" ] && { echo "SECURITY_USER_NAME arg must be set"; exit 1; }
  [ -z "$3" ] && { echo "SECURITY_USER_PASSWORD arg must be set"; exit 1; }
  [ -z "$4" ] && { echo "BROKER_HOST arg must be set"; exit 2; }
 
  PRODUCT_NAME=$1;
  SECURITY_USER_NAME=$2;
  SECURITY_USER_PASSWORD=$3;
  BROKER_HOST=$4;

  broker=`cf service-brokers | grep $1 || true`
  if [[ -z "$broker" ]]; then
    cf create-service-broker $1 $2 $3 $4
    exit_on_error "Error Creating Service."
  else
    cf update-service-broker $1 $2 $3 $4
    exit_on_error "Error Updating Service."
  fi
}

function enable_global_access() {

  [ -z "$1" ] && { echo "BROKER_PLAN_NAMES arg must be set"; exit 1; }

  plan_name=$1;
  cf enable-service-access $plan_name
  exit_on_error "Error enabling serivce access."

}
