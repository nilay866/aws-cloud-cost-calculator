# AWS Cloud Cost Alerts + Weekly Report

This project helps track AWS costs and sends email alerts when spending crosses a limit.
It also generates a weekly cost report and stores it in S3.

## What it does
- Budget alerts (email)
- Weekly report (Lambda)
- Stores report in S3
- Runs automatically every week

## Tech used
AWS Budgets, SNS, Lambda, S3, EventBridge, Cost Explorer, Terraform

## Setup
See: docs/setup.md

## Cleanup
terraform destroy
