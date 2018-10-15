#/bin/bash

if [[ -z $CONCOURSE_URI || -z $CONCOURSE_TARGET || -z $CONCOURSE_USER || -z $CONCOURSE_PASSWORD || -z $CONCOURSE_TEAM ]]; then
  echo "one the following environment variables is not set: "
  echo ""
  echo "                 CONCOURSE_URI"
  echo "                 CONCOURSE_TARGET"
  echo "                 CONCOURSE_USER"
  echo "                 CONCOURSE_PASSWORD"
  echo "                 CONCOURSE_TEAM"
  echo ""
  exit 1
fi

echo "$FLYCMD -t $CONCOURSE_TARGET login -c $CONCOURSE_URI -u XXXXX -p YYYYYY -n $CONCOURSE_TEAM -k "
$FLYCMD -t $CONCOURSE_TARGET login -c $CONCOURSE_URI -u $CONCOURSE_USER -p $CONCOURSE_PASSWORD -n $CONCOURSE_TEAM -k

