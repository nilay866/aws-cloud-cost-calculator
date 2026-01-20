output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}

output "s3_bucket" {
  value = aws_s3_bucket.reports.bucket
}

output "lambda_name" {
  value = aws_lambda_function.weekly.function_name
}
