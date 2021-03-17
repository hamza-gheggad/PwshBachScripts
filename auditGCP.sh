#!/bin/bash
printf "%-40s | %-40s | %-40s | %-40s | %-40s\n" "RESOURCE" "Type" "Mail" "Role" "KEY_ID (for SA)"
for PROJECT in $(\
  gcloud projects list \
  --format="value(projectId)" \
  )
do
    Users=$(gcloud projects get-iam-policy ${PROJECT} | grep user\: | cut -d':' -f 2) 
    Users_without_duplicates=$(echo $Users | xargs -n1 | sort -u | xargs)
    Groups=$(gcloud projects get-iam-policy ${PROJECT} | grep group\: | cut -d':' -f 2)
    Groups_without_duplicates=$(echo $Groups | xargs -n1 | sort -u | xargs)
    ServiceAccounts=$(gcloud projects get-iam-policy ${PROJECT} | grep serviceAccount\: | cut -d':' -f 2)
    SA_without_duplicates=$(echo $ServiceAccounts | xargs -n1 | sort -u | xargs)
    
    set -- $Users_without_duplicates 
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
            Role_sans_prefix=$(echo $Role  | sed -e "s/^$prefix_role//")
            FT_Role=$(echo $Role_sans_prefix | tr ' ' ' && ')
            printf "%-40s | %-40s | %-40s | %-40s | %-40s\n" "$PROJECT" "User" "$User" "$FT_Role" "N/A"
        fi
        shift
    done

    set -- $Groups_without_duplicates 
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
            Role_sans_prefix=$(echo $Role  | sed -e "s/^$prefix_role//")
            FT_Role=$(echo $Role_sans_prefix | tr ' ' ' && ')
            printf "%-40s | %-40s | %-40s | %-40s | %-40s\n" "$PROJECT" "Group" "$Group" "$FT_Role" "N/A"
        fi
        shift
    done

    set -- $SA_without_duplicates
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
            Role_sans_prefix=$(echo $Role  | sed -e "s/^$prefix_role//")
            FT_Role=$(echo $Role_sans_prefix | tr ' ' ' && ')
            Key=$(gcloud iam service-accounts keys list --iam-account=$SA --format="table(KEY_ID)" --filter="9999")
            prefix_keyid="KEY_ID"
            FT_Key=$(echo $Key | sed -e "s/^$prefix_keyid//")
            if [ -z "$Key" ]
            then
                printf "%-40s | %-40s | %-40s | %-40s | %-40s\n" "$PROJECT" "ServiceAccount" "$SA" "$FT_Role" "NULL"
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
    Users_without_duplicates=$(echo $Users | xargs -n1 | sort -u | xargs)
    Groups=$(gcloud alpha resource-manager folders get-iam-policy $FOLDER | grep group\: | cut -d':' -f 2)
    Groups_without_duplicates=$(echo $Groups | xargs -n1 | sort -u | xargs)
    ServiceAccounts=$(gcloud alpha resource-manager folders get-iam-policy $FOLDER | grep serviceAccount\: | cut -d':' -f 2)
    SA_without_duplicates=$(echo $ServiceAccounts | xargs -n1 | sort -u | xargs)
    
    set -- $Users_without_duplicates
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
            Role_sans_prefix=$(echo $Role  | sed -e "s/^$prefix_role//")
            FT_Role=$(echo $Role_sans_prefix | tr ' ' ' && ')
            printf "%-40s | %-40s | %-40s | %-40s | %-40s\n" "FOLDER:$FOLDER" "User" "$User" "$FT_Role" "N/A"
        fi
        shift
    done

    set -- $Groups_without_duplicates 
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
            Role_sans_prefix=$(echo $Role  | sed -e "s/^$prefix_role//")
            FT_Role=$(echo $Role_sans_prefix | tr ' ' ' && ')
            printf "%-40s | %-40s | %-40s | %-40s | %-40s\n" "FOLDER:$FOLDER" "Group" "$Group" "$FT_Role" "N/A"
        fi
        shift
    done

    set -- $SA_without_duplicates
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
            Role_sans_prefix=$(echo $Role  | sed -e "s/^$prefix_role//")
            FT_Role=$(echo $Role_sans_prefix | tr ' ' ' && ')
            Key=$(gcloud iam service-accounts keys list --iam-account=$SA --format="table(KEY_ID)" --filter="9999")
            prefix_keyid="KEY_ID"
            FT_Key=$(echo $Key | sed -e "s/^$prefix_keyid//")
            if [ -z "$Key" ]
            then
                printf "%-40s | %-40s | %-40s | %-40s | %-40s\n" "$PROJECT" "ServiceAccount" "$SA" "$FT_Role" "NULL"
            else
                printf "%-40s | %-40s | %-40s | %-40s | %-40s\n" "$PROJECT" "ServiceAccount" "$SA" "$FT_Role" "$FT_Key"
            fi
        fi
        shift
    done
done 


#------------------------------------------------------------------------------
#------------------------------------------------------------------------------

# This third part is dedicated for auditing organization

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------

Users=$(gcloud organizations get-iam-policy 478735633679 | grep user\: | cut -d':' -f 2) 
Users_without_duplicates=$(echo $Users | xargs -n1 | sort -u | xargs)
Groups=$(gcloud organizations get-iam-policy 478735633679 | grep group\: | cut -d':' -f 2)
Groups_without_duplicates=$(echo $Groups | xargs -n1 | sort -u | xargs)
ServiceAccounts=$(gcloud organizations get-iam-policy 478735633679 | grep serviceAccount\: | cut -d':' -f 2)
SA_without_duplicates=$(echo $ServiceAccounts | xargs -n1 | sort -u | xargs)

set -- $Users_without_duplicates
while [ $# -gt 0 ]
do
    User="$1"
    if [ -z "$User" ]
    then
        :
    else
        Role=$(gcloud organizations get-iam-policy 478735633679 \
        --flatten="bindings[].members" \
        --format="table(bindings.role)" \
        --filter="bindings.members:$User")
        prefix_role="ROLE"
        Role_sans_prefix=$(echo $Role  | sed -e "s/^$prefix_role//")
        FT_Role=$(echo $Role_sans_prefix | tr ' ' ' && ')
        printf "%-40s | %-40s | %-40s | %-40s | %-40s\n" "Organization" "User" "$User" "$FT_Role" "N/A"
    fi
    shift
done

set -- $Groups_without_duplicates 
while [ $# -gt 0 ]
do
    Group="$1"
    if [ -z "$Group" ]
    then
        :
    else
        Role=$(gcloud organizations get-iam-policy 478735633679 \
        --flatten="bindings[].members" \
        --format="table(bindings.role)" \
        --filter="bindings.members:$Group")
        prefix_role="ROLE"
        Role_sans_prefix=$(echo $Role  | sed -e "s/^$prefix_role//")
        FT_Role=$(echo $Role_sans_prefix | tr ' ' ' && ')
        printf "%-40s | %-40s | %-40s | %-40s | %-40s\n" "Organization" "Group" "$Group" "$FT_Role" "N/A"
    fi
    shift
done

set -- $SA_without_duplicates
while [ $# -gt 0 ]
do
    SA="$1"
    if [ -z "$SA" ]
    then
        :
    else
        Role=$(gcloud organizations get-iam-policy 478735633679 \
        --flatten="bindings[].members" \
        --format="table(bindings.role)" \
        --filter="bindings.members:$SA")
        prefix_role="ROLE"
        Role_sans_prefix=$(echo $Role  | sed -e "s/^$prefix_role//")
        FT_Role=$(echo $Role_sans_prefix | tr ' ' ' && ')
        Key=$(gcloud iam service-accounts keys list --iam-account=$SA --format="table(KEY_ID)" --filter="9999")
        prefix_keyid="KEY_ID"
        FT_Key=$(echo $Key | sed -e "s/^$prefix_keyid//")
        if [ -z "$Key" ]
        then
            printf "%-40s | %-40s | %-40s | %-40s | %-40s\n" "Organization" "ServiceAccount" "$SA" "$FT_Role" "NULL"
        else
            printf "%-40s | %-40s | %-40s | %-40s | %-40s\n" "Organization" "ServiceAccount" "$SA" "$FT_Role" "$FT_Key"
        fi
    fi
    shift
done