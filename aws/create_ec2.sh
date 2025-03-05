#!/bin/bash

# AWS EC2 Instance Creation Script
# This script automates the creation of an EC2 instance using AWS CLI

# Error handling
set -e
trap 'echo "Error: Script failed on line $LINENO"' ERR

# Check AWS CLI installation
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it first."
    exit 1
fi

# Configuration variables
INSTANCE_TYPE="t2.micro"
AMI_ID="ami-0c55b159cbfafe1f0"  # Ubuntu 20.04 LTS
KEY_NAME="v2ray-key"
SECURITY_GROUP_NAME="v2ray-sg"
INSTANCE_NAME="v2ray-server"

# Create key pair if it doesn't exist
if ! aws ec2 describe-key-pairs --key-names "${KEY_NAME}" &> /dev/null; then
    echo "Creating new key pair..."
    aws ec2 create-key-pair \
        --key-name "${KEY_NAME}" \
        --query 'KeyMaterial' \
        --output text > "${KEY_NAME}.pem"
    chmod 400 "${KEY_NAME}.pem"
fi

# Create security group if it doesn't exist
if ! aws ec2 describe-security-groups --group-names "${SECURITY_GROUP_NAME}" &> /dev/null; then
    echo "Creating security group..."
    SECURITY_GROUP_ID=$(aws ec2 create-security-group \
        --group-name "${SECURITY_GROUP_NAME}" \
        --description "Security group for v2ray server" \
        --query 'GroupId' \
        --output text)

    # Configure security group rules
    aws ec2 authorize-security-group-ingress \
        --group-id "${SECURITY_GROUP_ID}" \
        --protocol tcp \
        --port 22 \
        --cidr 0.0.0.0/0

    aws ec2 authorize-security-group-ingress \
        --group-id "${SECURITY_GROUP_ID}" \
        --protocol tcp \
        --port 80 \
        --cidr 0.0.0.0/0

    aws ec2 authorize-security-group-ingress \
        --group-id "${SECURITY_GROUP_ID}" \
        --protocol tcp \
        --port 443 \
        --cidr 0.0.0.0/0
fi

# Launch EC2 instance
echo "Launching EC2 instance..."
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "${AMI_ID}" \
    --instance-type "${INSTANCE_TYPE}" \
    --key-name "${KEY_NAME}" \
    --security-groups "${SECURITY_GROUP_NAME}" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${INSTANCE_NAME}}]" \
    --query 'Instances[0].InstanceId' \
    --output text)

echo "Waiting for instance to be running..."
aws ec2 wait instance-running --instance-ids "${INSTANCE_ID}"

# Get instance public IP
PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids "${INSTANCE_ID}" \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text)

echo "EC2 instance created successfully!"
echo "Instance ID: ${INSTANCE_ID}"
echo "Public IP: ${PUBLIC_IP}"
echo "SSH command: ssh -i ${KEY_NAME}.pem ubuntu@${PUBLIC_IP}"
