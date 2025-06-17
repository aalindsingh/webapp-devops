#!/bin/bash
set -e

# Update and install required packages
apt-get update -y
apt-get install -y unzip curl

# Install Docker
apt-get install -y docker.io
systemctl enable docker
systemctl start docker

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
unzip /tmp/awscliv2.zip -d /tmp
/tmp/aws/install

# Log in to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 571600835023.dkr.ecr.us-east-1.amazonaws.com

# Pull and run your Flask app image
docker pull 571600835023.dkr.ecr.us-east-1.amazonaws.com/flask-webapp:latest
docker run --name flask-webapp -d -p 5000:5000 571600835023.dkr.ecr.us-east-1.amazonaws.com/flask-webapp:latest
