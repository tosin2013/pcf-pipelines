#!/usr/bin/env bash
set -e

## set main if no concourse team identified
#: ${CONCOURSE_TEAM:-main}

## Assumptions: we will assume that credentials are already uploaded to vault and concourse
## has been integrated to read from it. 

## Checking to ensure variables are set.
## We are using direnv to save project level configs in .envrc files
if [[ -z $CONCOURSE_URI || -z $CONCOURSE_TARGET || \
      -z $CONCOURSE_USER || -z $CONCOURSE_PASSWORD || \
      -z $CONCOURSE_TEAM || -z $FLYCMD || \
      -z $FOUNDATION_NAME ]]; then
  echo "one the following environment variables is not set: "
  echo ""
  echo "                 CONCOURSE_URI"
  echo "                 CONCOURSE_TARGET"
  echo "                 CONCOURSE_USER"
  echo "                 CONCOURSE_PASSWORD"
  echo "                 CONCOURSE_TEAM"
  echo "                 FLY_CMD"
  echo "                 FOUNDATION_NAME"
  echo ""
  exit 1
fi

echo -e "#############################################################################"
echo "Updating $FOUNDATION_NAME management pipeline on $CONCOURSE_TARGET concourse."
echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"

## Release candidate of fly has non-interactive version for set-team
FLYRC=/usr/local/bin/fly-rc

## Login to main team to set target
echo -e "#############################################################################"
echo "Login on to main team on $CONCOURSE_TARGET concourse to set target"
echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"
$FLYCMD -t $CONCOURSE_TARGET login -c $CONCOURSE_URI -u $CONCOURSE_USER -p $CONCOURSE_PASSWORD -k

## Create team
echo -e "#############################################################################"
echo "Creating team or updating password for $CONCOURSE_TARGET concourse with team $CONCOURSE_TEAM"
echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"
$FLYRC  -t $CONCOURSE_TARGET set-team  --basic-auth-username=$CONCOURSE_USER --basic-auth-password=$CONCOURSE_PASSWORD -n $CONCOURSE_TEAM --non-interactive

# Login to team we created
echo -e "#############################################################################"
echo "Login to $CONCOURSE_TARGET with team we created, $CONCOURSE_TEAM"
echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"
$FLYCMD -t $CONCOURSE_TARGET login -c $CONCOURSE_URI -u $CONCOURSE_USER -p $CONCOURSE_PASSWORD -n $CONCOURSE_TEAM -k

# Setting deploy PCF and ERT pipeline
echo -e "#############################################################################"
echo "Setting up pipeline for deploying PCF (Operations Manager and ERT) on $FOUNDATION_NAME"
echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"

pushd install-pcf/vsphere/
./install.sh -n
popd

# Setting up upgrade pipeline for operations manager
echo -e "#############################################################################"
echo "Setting up upgrade Ops Manager pipeline on $FOUNDATION_NAME"
echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"

pushd upgrade-ops-manager/vsphere/
./upgrade.sh -n
popd

# Setting up elastic run time upgrade pipeline
echo -e "#############################################################################"
echo "Setting up upgrade Elastic Runtime pipeline on $FOUNDATION_NAME"
echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"

pushd upgrade-tile/
./upgrade-ert.sh -n
popd

# Setting up install of redis
echo -e "#############################################################################"
echo "Setting up install of redis pipeline on $FOUNDATION_NAME"
echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"

pushd pipelines/install-redis/
./install.sh -n
popd

# Setting up install of rabbit
echo -e "#############################################################################"
echo "Setting up install of rabbit pipeline on $FOUNDATION_NAME"
echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"

pushd pipelines/install-rmq/
./install.sh -n
popd

echo "Done."
