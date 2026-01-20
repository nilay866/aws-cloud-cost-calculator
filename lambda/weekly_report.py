import boto3
import os
import json
from datetime import date, timedelta

ce = boto3.client("ce")
s3 = boto3.client("s3")
sns = boto3.client("sns")

BUCKET = os.environ["BUCKET_NAME"]
TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]

def lambda_handler(event, context):
    end = date.today()
    start = end - timedelta(days=7)

    data = ce.get_cost_and_usage(
        TimePeriod={"Start": str(start), "End": str(end)},
        Granularity="DAILY",
        Metrics=["UnblendedCost"]
    )

    report = {
        "start": str(start),
        "end": str(end),
        "results": data.get("ResultsByTime", [])
    }

    key = f"reports/weekly-report-{start}-to-{end}.json"
    s3.put_object(
        Bucket=BUCKET,
        Key=key,
        Body=json.dumps(report, indent=2)
    )

    sns.publish(
        TopicArn=TOPIC_ARN,
        Subject="AWS Weekly Cost Report",
        Message=f"Report saved to s3://{BUCKET}/{key}"
    )

    return {"ok": True, "s3_key": key}
