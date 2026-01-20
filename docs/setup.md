# Setup Guide (Beginner Friendly)

This guide helps you deploy this project step-by-step even if you are new to AWS.

## What this project does
- Creates an AWS Budget (monthly cost limit)
- Sends email alerts using SNS when spending crosses 80% and 100%
- Runs a Lambda function weekly using EventBridge
- Stores weekly cost report JSON in an S3 bucket

## Requirements
You need:
- AWS account
- IAM Access Key + Secret Key
- Email address for alerts
- AWS CLI installed
- Terraform installed
- Git installed

## Step 1: Create IAM Access Keys (One Time)
If you already have access keys, skip this step:
1. AWS Console → IAM
2. Create user (example: devops-user)
3. Attach permission: AdministratorAccess (for testing/learning)
4. Security credentials → Create access key
5. Save Access Key ID and Secret Access Key

## Step 2: Configure AWS CLI
Check AWS CLI:
aws --version

Configure AWS CLI:
aws configure

Enter:
- Access Key ID
- Secret Access Key
- Region (example: ap-south-1)
- Output: json

Test login:
aws sts get-caller-identity

## Step 3: Check Terraform
terraform -version

## Step 4: Clone repo
git clone <your-repo-url>
cd aws-cloud-cost-calculator

## Step 5: Deploy using Terraform
cd terraform
terraform init
terraform apply
(Type yes when asked)

Terraform creates:
- SNS topic + email subscription
- Monthly budget alerts (80% and 100%)
- S3 bucket for reports
- Lambda weekly report function
- EventBridge weekly schedule

## Step 6: Confirm SNS email subscription
After terraform apply, AWS sends an email:
"AWS Notification - Subscription Confirmation"
Open Gmail and click: Confirm subscription

## Step 7: Test Lambda manually
cd terraform
LAMBDA=$(terraform output -raw lambda_name)
aws lambda invoke --function-name "$LAMBDA" out.json
cat out.json

## Step 8: Verify report in S3
BUCKET=$(terraform output -raw s3_bucket)
aws s3 ls "s3://$BUCKET/reports/"

If a weekly-report JSON file is visible, deployment is successful.

## Cleanup
cd terraform
terraform destroy
