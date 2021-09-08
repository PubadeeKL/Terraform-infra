provider "aws" {
  region     = var.AWS_REGION
}

## S3 WEB HOSTING
module "s3_webhost" {
  source      = "../modules/s3-webhosting"
  BUCKET_NAME_HOSTING = local.BUCKET_HOSTING
  ENV = var.ENV_NAME
}

## CI/CD pipeline
module "codepipeline" {
  source = "../modules/pipeline-S3-Host"
  # Get output form s3_webhost module 
  AWS_CF_DISTRIBUTION_ID = "${module.s3_webhost.cloudfront-id}"
  S3_HOST_ARN = "${module.s3_webhost.arn-s3-host}"
  SLACK_CHANNEL_ID = var.SLACK_CHANNEL
  SLACK_WORKSPACE_ID = var.SLACK_WORKSPACE

  PROJECT_NAME = var.PROJECT_NAME
  ENV = var.ENV_NAME
  REPO_IP = var.REPO_ID

  BRANCH_NAME = var.BRANCH_NAME
  BUCKET_NAME = local.BUCKET_S3
  CODEPIPELINE_NAME = local.PIPELINE_NAME


}