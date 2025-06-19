provider "aws" {
  region = "us-east-1" # Change as needed
}

module "networking" {
  source      = "../modules/networking"
  environment = "dev"
  az          = ["us-east-1a", "us-east-1b"]
}

module "alb" {
  source      = "../modules/alb"
  environment = "dev"
  vpc_id      = module.networking.vpc_id
  subnet_ids  = module.networking.public_subnet_ids
  cidr_block  = "0.0.0.0/0"
}

module "launch_template" {
  source                    = "../modules/asg/launch_template"
  ami_id                    = "ami-020cba7c55df1f615"
  vpc_id                    = module.networking.vpc_id
  instance_type             = "t2.micro"
  key_name                  = "flaskapp-devops-key"
  environment               = "dev"
  cidr_block                = "0.0.0.0/0"
  alb_sg_id                 = module.alb.alb_sg_id
  docker_image_tag          = var.docker_image_tag
  ecr_registry              = data.terraform_remote_state.bootstrap.outputs.ecr_repository_url
  aws_region                = "us-east-1"
  iam_instance_profile_name = data.terraform_remote_state.bootstrap.outputs.ec2_instance_profile_name
}

module "autoscaling" {
  source             = "../modules/asg/autoscaling"
  max_size           = 3
  min_size           = 1
  desired_capacity   = 2
  subnet_ids         = module.networking.public_subnet_ids
  launch_template_id = module.launch_template.launch_template_id
  target_group_arn   = module.alb.target_group_arn
  environment        = "dev"
}
