#!/bin/bash
printf "%-40s | %-40s | %-40s | %-40s | %-40s\n" "RESOURCE" "Type" "Mail" "Role" "KEY_ID (for SA)"
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
            prefix_role="ROLE"
            FT_Role=$(echo "$Role"  | sed -e "s/^$prefix_role//")
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
            prefix_role="ROLE"
            FT_Role=$(echo "$Role"  | sed -e "s/^$prefix_role//")
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
            prefix_role="ROLE"
            FT_Role=$(echo "$Role"  | sed -e "s/^$prefix_role//")
            Key=$(gcloud iam service-accounts keys list --iam-account=$SA --format="table(KEY_ID)" --filter="9999")
            prefix_keyid="KEY_ID"
            FT_Key=$(echo $Key | sed -e "s/^$prefix_keyid//")
            if [ -z "$Key" ]
            then
                :
            else
                printf "%-40s | %-40s | %-40s | %-40s | %-40s\n" "$PROJECT" "ServiceAccount" "$SA" "$FT_Role" "$FT_Key"
            fi
        fi
        shift
    done
done 

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------

# This second part is dedicated for auditing folders 

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------


folders_array=$(gcloud alpha resource-manager folders list --organization=478735633679 \
  --format="value(ID)")
array1=$(for id in $(gcloud alpha resource-manager folders list --organization=478735633679 \
  --format="value(ID)"); do gcloud alpha resource-manager folders list --folder=$id --format="value(ID)" ; done)
for i in $array1; do folders_array+=" $i" ; done
array2=$(for id in $array1; do gcloud alpha resource-manager folders list --folder=$id --format="value(ID)" ; done)
for i in $array2; do folders_array+=" $i" ; done
array3=$(for id in $array2; do gcloud alpha resource-manager folders list --folder=$id --format="value(ID)" ; done)
for i in $array3; do folders_array+=" $i" ; done

for FOLDER in $folders_array
do
    Users=$(gcloud alpha resource-manager folders get-iam-policy $FOLDER | grep user\: | cut -d':' -f 2)
    Groups=$(gcloud alpha resource-manager folders get-iam-policy $FOLDER | grep group\: | cut -d':' -f 2)
    ServiceAccounts=$(gcloud alpha resource-manager folders get-iam-policy $FOLDER | grep serviceAccount\: | cut -d':' -f 2)
    
    set -- $Users 
    while [ $# -gt 0 ]
    do
        User="$1"
        if [ -z "$User" ]
        then
            :
        else
            Role=$(gcloud alpha resource-manager folders get-iam-policy $FOLDER \
            --flatten="bindings[].members" \
            --format="table(bindings.role)" \
            --filter="bindings.members:$User")
            prefix_role="ROLE"
            FT_Role=$(echo "$Role"  | sed -e "s/^$prefix_role//")
            printf "%-40s | %-40s | %-40s | %-40s\n" "FOLDER:$FOLDER" "User" "$User" "$FT_Role"
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
            Role=$(gcloud alpha resource-manager folders get-iam-policy $FOLDER \
            --flatten="bindings[].members" \
            --format="table(bindings.role)" \
            --filter="bindings.members:$Group")
            prefix_role="ROLE"
            FT_Role=$(echo "$Role"  | sed -e "s/^$prefix_role//")
            printf "%-40s | %-40s | %-40s | %-40s\n" "FOLDER:$FOLDER" "Group" "$Group" "$FT_Role"
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
            prefix_role="ROLE"
            FT_Role=$(echo "$Role"  | sed -e "s/^$prefix_role//")
            Key=$(gcloud iam service-accounts keys list --iam-account=$SA --format="table(KEY_ID)" --filter="9999")
            prefix_keyid="KEY_ID"
            FT_Key=$(echo $Key | sed -e "s/^$prefix_keyid//")
            if [ -z "$Key" ]
            then
                :
            else
                printf "%-40s | %-40s | %-40s | %-40s | %-40s\n" "$PROJECT" "ServiceAccount" "$SA" "$FT_Role" "$FT_Key"
            fi
        fi
        shift
    done
done 
