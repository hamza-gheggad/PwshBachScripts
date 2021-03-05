#!/bin/bash
printf "%-40s | %-40s | %-40s | %-40s\n" "RESOURCE" "Type" "Mail" "Role"
for PROJECT in $(\
  gcloud projects list \
  --format="value(projectId)" \
  )
do
    Users=$(gcloud projects get-iam-policy ${PROJECT} | grep user\: | cut -d':' -f 2)
    Groups=$(gcloud projects get-iam-policy ${PROJECT} | grep group\: | cut -d':' -f 2)
    ServiceAccounts=$(gcloud projects get-iam-policy ${PROJECT} | grep serviceAccount\: | cut -d':' -f 2)
    
    set -- $Users 
    while [ $# -gt 0 ]
    do
        User="$1"
        if [ -z "$User" ]
        then
            :
        else
            Role=$(gcloud projects get-iam-policy ${PROJECT} \
            --flatten="bindings[].members" \
            --format="table(bindings.role)" \
            --filter="bindings.members:$User")
            FT_Role=$(echo $Role | cut -d' ' -f 2)
            printf "%-40s | %-40s | %-40s | %-40s\n" "$PROJECT" "User" "$User" "$FT_Role"
        fi
        shift
    done

    set -- $Groups 
    while [ $# -gt 0 ]
    do
        Group="$1"
        if [ -z "$Group" ]
        then
            :
        else
            Role=$(gcloud projects get-iam-policy ${PROJECT} \
            --flatten="bindings[].members" \
            --format="table(bindings.role)" \
            --filter="bindings.members:$Group")
            FT_Role=$(echo $Role | cut -d' ' -f 2)
            printf "%-40s | %-40s | %-40s | %-40s\n" "$PROJECT" "Group" "$Group" "$FT_Role"
        fi
        shift
    done

    set -- $ServiceAccounts
    while [ $# -gt 0 ]
    do
        SA="$1"
        if [ -z "$SA" ]
        then
            :
        else
            Role=$(gcloud projects get-iam-policy ${PROJECT} \
            --flatten="bindings[].members" \
            --format="table(bindings.role)" \
            --filter="bindings.members:$SA")
            FT_Role=$(echo $Role | cut -d' ' -f 2)
            printf "%-40s | %-40s | %-40s | %-40s\n" "$PROJECT" "ServiceAccount" "$SA" "$FT_Role"
        fi
        shift
    done
done 
