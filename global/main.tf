provider "aws" {
  region     = var.AWS_REGION
}

data "aws_sns_topic" "codepipeline"{
  count = length(var.ENV)
  name = "${var.ENV[count.index]}-github-action-Pipeline" 
}

# data "aws_cloudformation_stack" "chatbot" {
#   # count = var.ENV != "develop" ? 1 : 0
#   name = "chatbot-slack-configuration-awschatbot-${var.PROJECT_NAME}"
# }

module "chatbot_slack_configuration" {
  source  = "waveaccounting/chatbot-slack-configuration/aws"
  version = "1.0.0"

  count = length(var.ENV)

  configuration_name = "awschatbot-${var.PROJECT_NAME}"
  iam_role_arn       = aws_iam_role.awschatbot_role.arn
  slack_channel_id   = var.SLACK_CHANNEL
  slack_workspace_id = var.SLACK_WORKSPACE

  sns_topic_arns = [
    # data.aws_cloudformation_stack.chatbot.parameters["SnsTopicArnsParameter"],
    data.aws_sns_topic.codepipeline[count.index].arn
  ] 
}

resource "aws_iam_role" "awschatbot_role" {
    name = "awschatbot_role_${var.PROJECT_NAME}"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "chatbot.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "awschatbot_role_policy" {
  name = "awschatbot_policy"
  role = aws_iam_role.awschatbot_role.name
  policy = data.aws_iam_policy_document.awschatbot_policy.json
}

data "aws_iam_policy_document" "awschatbot_policy" {
    statement{
        actions=[
            "cloudwatch:Describe*",
            "cloudwatch:Get*",
            "cloudwatch:List*"
        ]
        resources = ["*"] 
    }
}
