variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "email" {
  type        = string
  description = "Email to receive SNS alerts"
}

variable "project" {
  type    = string
  default = "aws-cost-alerts"
}

variable "monthly_budget_usd" {
  type    = number
  default = 10
}
