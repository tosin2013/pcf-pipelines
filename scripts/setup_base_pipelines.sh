#!/usr/bin/env bash
set -e

## set main if no concourse team identified

## Assumptions: we will assume that credentials are already uploaded to vault and concourse
## has been integrated to read from it. 

## Checking to ensure variables are set.
## We are using direnv to save project level configs in .envrc files
if [[ -z $CONCOURSE_URI ||  \
      -z $CONCOURSE_USER || -z $CONCOURSE_PASSWORD || \
      -z $FLYCMD || \
      -z $FOUNDATION_NAME ]]; then
  echo "one the following environment variables is not set: "
  echo ""
  echo "                 CONCOURSE_URI"
  echo "                 CONCOURSE_USER"
  echo "                 CONCOURSE_PASSWORD"
  echo "                 FLY_CMD"
  echo "                 FOUNDATION_NAME"
  echo ""
  exit 1
fi

echo -e "#############################################################################"
echo "Updating $FOUNDATION_NAME management pipeline on $FOUNDATION_NAME concourse."
echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"

## Release candidate of fly has non-interactive version for set-team
FLYRC=/usr/local/bin/fly-rc

## Login to main team to set target
echo -e "#############################################################################"
echo "Login on to main team on $FOUNDATION_NAME concourse to set target"
echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"
$FLYCMD -t $FOUNDATION_NAME login -c $CONCOURSE_URI -u $CONCOURSE_USER -p $CONCOURSE_PASSWORD -k

## Create team
echo -e "#############################################################################"
echo "Creating team or updating password for $FOUNDATION_NAME concourse with team $FOUNDATION_NAME"
echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"
$FLYRC  -t $FOUNDATION_NAME set-team  --basic-auth-username=$CONCOURSE_USER --basic-auth-password=$CONCOURSE_PASSWORD -n $FOUNDATION_NAME --non-interactive

# Login to team we created
echo -e "#############################################################################"
echo "Login to $FOUNDATION_NAME with team we created, $FOUNDATION_NAME"
echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"
$FLYCMD -t $FOUNDATION_NAME login -c $CONCOURSE_URI -u $CONCOURSE_USER -p $CONCOURSE_PASSWORD -n $FOUNDATION_NAME -k

# Setting deploy PCF and ERT pipeline
echo -e "#############################################################################"
echo "Setting up pipeline for deploying PCF (Operations Manager and ERT) on $FOUNDATION_NAME"
echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"

pushd ../install-pcf/vsphere/
./install.sh -n
popd

# Setting up upgrade pipeline for operations manager
echo -e "#############################################################################"
echo "Setting up upgrade Ops Manager pipeline on $FOUNDATION_NAME"
echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"

pushd ../upgrade-ops-manager/vsphere/
./upgrade.sh -n
popd

# Setting up elastic run time upgrade pipeline
echo -e "#############################################################################"
echo "Setting up upgrade Elastic Runtime pipeline on $FOUNDATION_NAME"
echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"

pushd ../upgrade-tile/
./upgrade-ert.sh -n
popd

# Setting up some pipelines in pipelines folder
# if you add a pipeline to pipelines folder and add install.sh script, then run this script it will add new pipeline
for pipeline in `ls -1d ../pipelines/*`;do
   if [ -f "$pipeline/install.sh" ]; then 
      echo -e "#############################################################################"
      echo "Setting up pipeline $pipeline on $FOUNDATION_NAME"
      echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"
      pushd $pipeline; ./install.sh ;popd
   fi 
done

echo "Done."
