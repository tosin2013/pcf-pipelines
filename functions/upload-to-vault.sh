#!/bin/bash
set -e

yaml=$1
team=$2
pipeline=$3

function usage () {
   echo "$0 [yamlfile] [concourse team] <pipeline>"
}

# ensure team not empty
if [ -z $team ]; then
  echo "team is empty"
  usage
  exit 3
fi

# if less than 2 or more than 3 
if [ $# -lt 2 ]; then 
  echo "Pass in at least two arguments..."
  usage
  exit 1
elif [ $# -gt 3 ]; then
  echo "Too many arguments passed in, something is amist..."
  exit 1
fi

# Check if is file
if [ ! -f $yaml ]; then
  echo "$yaml is not a file"
  usage
  exit 2
fi


## Show values
#yaml2json install-pcf-vars-sd.yml | jq -r '. | to_entries[] | "\(.key)\t\(.value)"' | xargs -0 -l bash -c 'echo "$0 ---------------- $1"'

options=$(yaml2json $yaml | jq -r '. | to_entries[] | "\(.key)\t\(.value)"')

while read -r line; do
  array=($line)
  key=${array[0]}
  val=${array[1]}
  if [ "$val" == "null" ]; then
    val=""
  fi  
  vault write /concourse/$team/$pipeline/$key value=$val
done <<< "$options"

