#!/bin/bash
stage=$GIT_BRANCH
dynamodb=$(terraform output dynamodb_remote_state_name)
s3=$(terraform output S3_remote_state_name)
region=$(terraform output s3_region)

sed -i "s|(dynamodb_remote_state_name)|$dynamodb|g" ../$GIT_BRANCH/remotestate.tf
sed -i "s|(S3_remote_state_name)|$s3|g" ../$GIT_BRANCH/remotestate.tf
sed -i "s|(stage)|$GIT_BRANCH|g" ../$GIT_BRANCH/remotestate.tf
sed -i "s|(s3_region)|$region|g" ../$GIT_BRANCH/remotestate.tf

sed  "s|(dynamodb_remote_state_name)|$dynamodb|g" ../$GIT_BRANCH/remotestate.tf
sed  "s|(S3_remote_state_name)|$s3|g" ../$GIT_BRANCH/remotestate.tf
sed  "s|(stage)|$s3|g" ../$GIT_BRANCH/remotestate.tf
sed  "s|(s3_region)|$region|g" ../$GIT_BRANCH/remotestate.tf