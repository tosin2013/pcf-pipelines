#!/bin/bash 

nonint=$1

## Sanity check
if [ "$nonint" == "-n" ]; then
  echo "Enabling non-interactive..."
else
  nonint=''
fi

yaml-patch -o ../operations/use-different-git-repo.yml <pipeline.yml > tmp-pipeline.yml
sed -i -e "s/{{/((/g" -e "s/}}/))/g" tmp-pipeline.yml 

$FLYCMD -t $CONCOURSE_TARGET set-pipeline -p upgrade-elastic-runtime -c tmp-pipeline.yml  $nonint
