#!/bin/bash
ROLE="roles/owner"
for PROJECT in $(\
  gcloud projects list \
  --format="value(projectId)" \
  )
do
  echo "%s:\n" ${PROJECT}
  gcloud projects get-iam-policy ${PROJECT} \
  --flatten="bindings[].members[]" \
  --filter="bindings.role=${ROLE}" \
  --format="value(bindings.members)"
  printf "\n"
done
