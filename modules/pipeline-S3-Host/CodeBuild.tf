resource "aws_codebuild_project" "codebuild" {
  name = "${var.PROJECT_NAME}-codebuild"
  service_role = aws_iam_role.RoleCodebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment{
      compute_type = "BUILD_GENERAL1_SMALL"
      image = "aws/codebuild/standard:4.0"
      type = "LINUX_CONTAINER"

      environment_variable {
          name ="AWS_S3_BUCKET"
          value = var.BUCKET_NAME
      }

       environment_variable {
          name ="AWS_CF_DISTRIBUTION_ID"
          value = var.AWS_CF_DISTRIBUTION_ID
      }
  }
  source{
    type = "CODEPIPELINE"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group-${var.PROJECT_NAME}"
      stream_name = "log-stream-${var.PROJECT_NAME}"
    }
  }
  
}

resource "aws_iam_role" "RoleCodebuild" {
  name = "Codebuild_role_${var.CODEPIPELINE_NAME}_${var.ENV}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "Codebuild_role_policy" {
  name = "Codebuild_policy_${var.CODEPIPELINE_NAME}"
  role = aws_iam_role.RoleCodebuild.name
  policy = data.aws_iam_policy_document.codebuild_policy.json
}


data "aws_iam_policy_document" "codebuild_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "s3:*"
    ]
    resources = [
      "${var.S3_HOST_ARN}/*",
      "${var.S3_HOST_ARN}",
      "${aws_s3_bucket.codepipeline_bucket.arn}/*",
      "${aws_s3_bucket.codepipeline_bucket.arn}"
    ]
  }
  statement {
    actions = [
      "codebuild:*"
    ]
    resources = [ "${aws_codebuild_project.codebuild.arn}/*" ]
  }

  statement {
    actions = [ 
      "acm:ListCertificates",
                "cloudfront:*",
                "iam:ListServerCertificates",
                "waf:ListWebACLs",
                "waf:GetWebACL",
                "wafv2:ListWebACLs",
                "wafv2:GetWebACL",
                "kinesis:ListStreams",
                "kinesis:DescribeStream",
                "iam:ListRoles"

    ]
    resources = [ "*" ]
  }
}