#!/bin/bash -e

nonint=$1

## Sanity check
if [ "$nonint" == "-n" ]; then
  echo "Enabling non-interactive..."
else
  nonint=''
fi

$FLYCMD -t $CONCOURSE_TARGET set-pipeline -p install-rmq-broker -c pipeline.yml $nonint
