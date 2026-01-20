terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "me" {}

# SNS
resource "aws_sns_topic" "alerts" {
  name = "${var.project}-alerts"
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.email
}

# Budget
resource "aws_budgets_budget" "monthly" {
  name         = "${var.project}-monthly-budget"
  budget_type  = "COST"
  time_unit    = "MONTHLY"
  limit_amount = tostring(var.monthly_budget_usd)
  limit_unit   = "USD"

  notification {
    notification_type = "ACTUAL"
    threshold_type    = "PERCENTAGE"
    threshold         = 80
    comparison_operator       = "GREATER_THAN"
    subscriber_sns_topic_arns = [aws_sns_topic.alerts.arn]
  }

  notification {
    notification_type = "ACTUAL"
    threshold_type    = "PERCENTAGE"
    threshold         = 100
    comparison_operator       = "GREATER_THAN"
    subscriber_sns_topic_arns = [aws_sns_topic.alerts.arn]
  }
}

# S3 for reports
resource "aws_s3_bucket" "reports" {
  bucket = "${var.project}-${data.aws_caller_identity.me.account_id}-reports"
}

resource "aws_s3_bucket_public_access_block" "reports_block" {
  bucket = aws_s3_bucket.reports.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# IAM for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.project}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "sts:AssumeRole",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name = "${var.project}-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["ce:GetCostAndUsage"],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = ["s3:PutObject"],
        Resource = "${aws_s3_bucket.reports.arn}/*"
      },
      {
        Effect   = "Allow",
        Action   = ["sns:Publish"],
        Resource = aws_sns_topic.alerts.arn
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Zip lambda
data "archive_file" "zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/weekly_report.py"
  output_path = "${path.module}/weekly_report.zip"
}

resource "aws_lambda_function" "weekly" {
  function_name    = "${var.project}-weekly-report"
  role             = aws_iam_role.lambda_role.arn
  handler          = "weekly_report.lambda_handler"
  runtime          = "python3.12"
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME   = aws_s3_bucket.reports.bucket
      SNS_TOPIC_ARN = aws_sns_topic.alerts.arn
    }
  }
}

# EventBridge
resource "aws_cloudwatch_event_rule" "weekly_rule" {
  name                = "${var.project}-weekly-rule"
  schedule_expression = "rate(7 days)"
}

resource "aws_cloudwatch_event_target" "weekly_target" {
  rule      = aws_cloudwatch_event_rule.weekly_rule.name
  target_id = "weekly-lambda"
  arn       = aws_lambda_function.weekly.arn
}

resource "aws_lambda_permission" "allow_events" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.weekly.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.weekly_rule.arn
}
