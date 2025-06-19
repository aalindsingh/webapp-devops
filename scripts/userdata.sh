#!/bin/bash

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
aws ecr get-login-password --region ${aws_region} | docker login --username AWS --password-stdin ${registry_domain}

# Pull and run your Flask app image
docker pull ${ecr_registry}:${docker_image_tag}
docker run --name flask-webapp -d -p 5000:5000 ${ecr_registry}:${docker_image_tag}
