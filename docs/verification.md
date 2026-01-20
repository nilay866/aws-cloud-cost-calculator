# Verification Checklist

After deployment I verified:
- SNS subscription confirmed (email confirmed)
- Terraform apply completed successfully
- Lambda invoked successfully using CLI
- Weekly report JSON created in S3 under reports/

Quick commands:
cd terraform
LAMBDA=$(terraform output -raw lambda_name)
BUCKET=$(terraform output -raw s3_bucket)
aws lambda invoke --function-name "$LAMBDA" out.json
aws s3 ls "s3://$BUCKET/reports/"
