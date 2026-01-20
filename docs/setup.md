# Setup Notes (How I deployed this)

## Requirements
- AWS account
- AWS CLI configured on EC2
- Terraform installed

## Steps I followed
1. Created infra using Terraform (SNS, Budget, S3, Lambda, EventBridge)
2. Confirmed SNS email subscription from Gmail
3. Ran terraform apply and verified resources
4. Triggered Lambda once to test report generation
5. Checked report JSON in S3

## Files
- terraform/ : infra code
- lambda/    : weekly report lambda
- docs/      : screenshots + setup notes

## Final Result (after deploy)
- SNS email subscription confirmed
- Lambda generated weekly cost report successfully
- Report JSON stored in S3 under /reports/
