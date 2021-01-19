#!/bin/bash
for PROJECT in $(\
  gcloud projects list \
  --format="value(projectId)" \
  )
do
    printf "%s:\n" ${PROJECT}
    Users=$(gcloud projects get-iam-policy ${PROJECT} | grep user\: | cut -d':' -f 2)
    set -- $Users
    while [ $# -gt 0 ]
    do
        User="$1"
        if [ -z "$User" ]
        then
            :
        else
            echo $User
            gcloud projects get-iam-policy ${PROJECT} \
            --flatten="bindings[].members" \
            --format="table(bindings.role)" \
            --filter="bindings.members:$User"
            printf "\n"
        fi
        shift
    done  
done
