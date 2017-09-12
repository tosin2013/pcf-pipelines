#!/usr/bin/env bash
#
#
set -e

source ./pcf-pipelines/functions/export_cf_credentials.sh
source ./pcf-pipelines/functions/cf-helpers.sh
cf_authenticate_and_target
cf_target_org_and_space system chaos-loris

cd simple-victim-app

cat > manifest.yml <<EOS
---
applications:
- name: simple-victim-app
  memory: 1G
  instances: 3
  path: .
EOS
cf push
CF_CL_URL=chaos-loris.$APPS_DOMAIN
VICTIM_APP_NAME=simple-victim-app
APP_GUID=`cf curl "/v2/apps" -X GET -H "Content-Type: application/x-www-form-urlencoded" -d "q=name:$VICTIM_APP_NAME" | jq -r .resources[0].metadata.guid`

curl -k "https://$CF_CL_URL/applications" -i -X POST -H 'Content-Type: application/json' -d "{
  \"applicationId\" : \"$APP_GUID\"
}"

#APP_URL=`curl -k "https://$CF_CL_URL/applications" -i -X GET -H 'Content-Type: application/json' | tail -1 | jq -r '._embedded.applications[] | select ( .applicationId == "$APP_GUID") ._links.self.href'`;

#if [ -z echo $APP_URL ];
#then          
#   curl -k "https://$CF_CL_URL/applications/$APP_GUID" -i -X DELETE -H 'Content-Type: application/json'
#fi   
echo $APP_URL;  

SCHED_HASH=`cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 12 | head -n 1`                                                                
echo "########################################"                                                                                         
echo " SCHEDULE HASH IS: $SCHED_HASH"                                                                                                   
echo "########################################"                                                                                         
                                                                                                                                        
curl -k "https://$CF_CL_URL/schedules" -i -X POST -H 'Content-Type: application/json' -d "{                                             
  \"name\" : \"$SCHED_HASH\",                                                                                                           
  \"expression\" : \"*/3 * * * * *\"                                                                                                    
}" | grep Location | awk '{print $2}' | tr -d '"';                                                                                      
                                                                                                                                        
echo "********************************"                                                                                                 
SCHEDULE_URL=`curl -k "https://$CF_CL_URL/schedules" -i -X GET -H 'Content-Type: application/json' | tail -1 | jq -r "._embedded.schedules[] | select ( .name == \"$SCHED_HASH\") ._links.self.href";`
echo "********************************"                                                                                                 

echo " create a chaos ** "                                                                                                              
curl -k "https://$CF_CL_URL/chaoses" -i -X POST -H 'Content-Type: application/json' -d "{                                               
  \"schedule\" : \"$SCHEDULE_URL\",                                                                                                     
  \"application\" : \"$APP_URL\",                                                                                                       
  \"probability\" : 0.3                                                                                                                 
}" 1> /dev/null;

# List Chaoses                                                                                                                          
echo "List of Chaoses: "                                                                                                                                        
curl -k "https://$CF_CL_URL/chaoses" -i -X GET -H 'Content-Type: application/json' | tail -1 | jq '.'

CHAOS_NUMBER=`curl -k "https://$CF_CL_URL/chaoses" -i -X GET -H 'Content-Type: application/json' | tail -1 | jq '. | .page.number' `
SCHED_NUMBER=`curl -k "https://$CF_CL_URL/schedules" -i -X GET -H 'Content-Type: application/json' |tail -1 | jq '. | .page.number'`

echo "Waiting for 30 minutes of schedule activity"
CANT=0;
while [ $CANT -lt 60 ];
do
  let CANT=$((CANT))+1;
  sleep 1;
  printf ".";
done
echo                                                                                                                             
echo "Events: "
curl -k "https://$CF_CL_URL/events" -i -X GET -H 'Content-Type: application/json' | tail -1 | jq '.'
echo "Delete the Chaos"
curl -k "https://$CF_CL_URL/chaoses/$CHAOS_NUMBER" -i -X DELETE -H 'Content-Type: application/json'
echo "Delete the Schedule"
curl -k "https://$CF_CL_URL/schedules/$SCHED_NUMBER" -i -X DELETE -H 'Content-Type: application/json'
