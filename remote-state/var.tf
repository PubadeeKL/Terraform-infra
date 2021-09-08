variable "AWS_REGION"{
    default= "eu-west-1"
}

variable "BITBUCKET_REPO_NAME" {}
variable "BITBUCKET_BRANCH" {}

locals{
    S3_REMOTE = "${var.BITBUCKET_REPO_NAME}-s3-terraform-state"
    DynamoDB_REMOTE = "${var.BITBUCKET_BRANCH}-${var.BITBUCKET_REPO_NAME}-dynamodb-terraform-state"
}
