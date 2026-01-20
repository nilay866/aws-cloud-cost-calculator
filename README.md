# AWS Cost Alerts + Weekly Report (Terraform)

This project monitors AWS billing and sends email alerts when monthly spending crosses a limit.
It also generates a weekly cost report using AWS Cost Explorer, stores it in S3, and runs automatically every week.

## What it does
- Creates a monthly budget (AWS Budgets)
- Sends alerts by email using SNS
- Runs a Lambda weekly using EventBridge (automatic schedule)
- Stores weekly cost report JSON in S3 under `reports/`

## Services used
AWS Budgets, SNS, Lambda, S3, EventBridge, Cost Explorer, Terraform

## Repo structure
- terraform/ : Infrastructure as Code (Terraform)
- lambda/    : Lambda function code (weekly report)
- docs/      : Setup notes, verification, screenshots, challenges

## Deploy
1) Configure AWS CLI:
aws configure
aws sts get-caller-identity

2) Deploy infra:
cd terraform
terraform init
terraform apply
(Type yes when asked)

Important: SNS will send a confirmation email — confirm it once.

## Test after deployment
cd terraform
LAMBDA=$(terraform output -raw lambda_name)
BUCKET=$(terraform output -raw s3_bucket)
aws lambda invoke --function-name "$LAMBDA" out.json
cat out.json
aws s3 ls "s3://$BUCKET/reports/"

## Cleanup
cd terraform
terraform destroy

## Documentation
- Setup steps: docs/setup.md
- Verification: docs/verification.md
- Commands used: docs/commands-used.md
- Screenshots: docs/screenshots.md
- Challenges: docs/challenges.md
