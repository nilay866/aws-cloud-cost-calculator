# Setup Guide: AWS Cloud Cost Calculator & Alert System

This guide explains how to deploy the project from scratch.

---

## 1) Prerequisites
You should have:
- AWS account (Free Tier)
- GitHub account
- IAM user credentials (Access Key + Secret Key)
- AWS CLI installed
- Terraform installed

---

## 2) What this project does
- Tracks AWS spend using AWS Budgets & Cost Explorer
- Sends email alerts using SNS
- Generates weekly cost report using Lambda
- Stores reports in S3
- Runs weekly automatically using EventBridge

---

## 3) High Level Architecture
1. AWS Budgets monitors monthly costs.
2. When threshold exceeds, SNS sends an email alert.
3. EventBridge triggers Lambda weekly.
4. Lambda fetches cost data from Cost Explorer API.
5. Lambda stores the weekly report JSON in S3.
6. SNS sends report generation confirmation email.

---

## 4) Deployment Steps Overview
### Step A: Create SNS topic + email subscription
### Step B: Create AWS Budget + connect SNS alerts
### Step C: Configure AWS CLI
### Step D: Deploy infra using Terraform
### Step E: Validate weekly report in S3 + CloudWatch logs
### Step F: Cleanup using terraform destroy
