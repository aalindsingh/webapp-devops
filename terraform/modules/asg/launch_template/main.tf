resource "aws_security_group" "flaskapp-sg" {
  name = "flaskapp-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = var.vpc_id

  tags = {
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.flaskapp-sg.id
  description = "Allow HTTP traffic"
  from_port         = 5000
  ip_protocol       = "tcp"
  to_port           = 5000
  referenced_security_group_id = var.alb_sg_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.flaskapp-sg.id
  description = "Allow SSH traffic"
  cidr_ipv4         = "86.41.21.88/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.flaskapp-sg.id
  cidr_ipv4         = var.cidr_block
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_launch_template" "flaskapp_server_lt" {
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  user_data = base64encode(templatefile("${path.module}/../../../../scripts/userdata.sh", {
    ecr_registry    = var.ecr_registry
    docker_image_tag      = var.docker_image_tag
    aws_region      = var.aws_region
    registry_domain = split("/", var.ecr_registry)[0]
  }))

  vpc_security_group_ids = [aws_security_group.flaskapp-sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "FlaskApp-${var.environment}"
      Environment = var.environment
    }
  }
}
