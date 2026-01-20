# Screenshots

## 1) Lambda Run + S3 Report Proof
This screenshot shows:
- terraform outputs (lambda_name, bucket, sns topic)
- lambda invoked successfully (StatusCode 200)
- report file present inside S3 reports folder

![Lambda + S3 proof](images/lambda-s3-proof.png)

---

## 2) SNS Email Notification Proof
This screenshot shows the email notification received from SNS after the report is generated.

![SNS email proof](images/sns-email-proof.png)
