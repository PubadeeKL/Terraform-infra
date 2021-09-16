#!/bin/bash

# Region=$1
Region="eu-west-1"
PATH_STORE="/Terraform/SNS_Topic/Noti_Pipeline/"

aws ssm get-parameters-by-path \
    --path $PATH_STORE  \
    --query "Parameters[*].{Value:Value}" \
    --output text \
    --profile Terraform \
    --region $Region > arn.txt

echo $( $( echo cat arn.txt ) | sed 's|^|"|' | sed 's|$|"|' ) | sed 's|[[:space:]]|,|'
# cat arn.txt
echo $Test
echo ENV=[$( echo cat arn.txt)]