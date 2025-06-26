#!/bin/bash

# Update and install required packages
apt update -y
apt install -y unzip curl

# Install Docker
apt install -y docker.io
systemctl enable docker
systemctl start docker

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
unzip /tmp/awscliv2.zip -d /tmp
/tmp/aws/install

# Install CloudWatch Agent on Ubuntu
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb -O /tmp/amazon-cloudwatch-agent.deb
dpkg -i /tmp/amazon-cloudwatch-agent.deb

# Create config file
mkdir -p /opt/aws/amazon-cloudwatch-agent/bin
cat <<EOF > /opt/aws/amazon-cloudwatch-agent/bin/config.json
{
  "metrics": {
    "append_dimensions": {
      "InstanceId": "$${aws:InstanceId}"
    },
    "metrics_collected": {
      "cpu": {
        "measurement": ["cpu_usage_idle", "cpu_usage_iowait"],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": ["used_percent"],
        "metrics_collection_interval": 60,
        "resources": ["*"]
      },
      "mem": {
        "measurement": ["mem_used_percent"],
        "metrics_collection_interval": 60
      }
    }
  }
}
EOF

# Start the agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json \
  -s

# Log in to ECR
aws ecr get-login-password --region ${aws_region} | docker login --username AWS --password-stdin ${registry_domain}

# Pull and run your Flask app image
docker pull ${ecr_registry}:${docker_image_tag}
docker run --log-driver=awslogs \
  --log-opt awslogs-region=us-east-1 \
  --log-opt awslogs-group=flask-app-logs \
  --log-opt awslogs-stream=app --name flask-webapp -d -p 5000:5000 ${ecr_registry}:${docker_image_tag}
