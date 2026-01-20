# Troubleshooting

## 1) AccessDenied for Cost Explorer
Fix: Ensure Lambda has permission:
- ce:GetCostAndUsage

## 2) SNS email not received
Fix:
- Confirm subscription from email inbox
- Check spam/junk

## 3) No report file in S3
Fix:
- Verify Lambda role has s3:PutObject permission
- Ensure correct bucket name

## 4) Terraform apply failed
Fix:
- terraform init
- terraform validate
- terraform plan
- Check AWS CLI credentials

## 5) Budget alerts not triggering
Fix:
- Budgets can take time to evaluate
- Set low test threshold for testing
