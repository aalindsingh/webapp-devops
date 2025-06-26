resource "aws_ecr_repository" "flaskapp_repo" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name    = var.ecr_repo_name
    Project = var.project
  }
}

resource "aws_cloudwatch_log_group" "flask_app_logs" {
  name              = "flask-app-logs"
  retention_in_days = 1
}

resource "aws_iam_role" "devops_admin_role" {
  name = "devops_admin_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Project = var.project
  }
}

resource "aws_iam_policy_attachment" "ecr_read_access" {
  name       = "AttachAmazonEC2ContainerRegistryReadOnly"
  roles      = [aws_iam_role.devops_admin_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_policy_attachment" "cloudwatch_logs_access" {
  name       = "AttachCloudWatchLogsPolicy"
  roles      = [aws_iam_role.devops_admin_role.name]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "flaskapp_profile" {
  name = "flaskapp_profile"
  role = aws_iam_role.devops_admin_role.name
}
