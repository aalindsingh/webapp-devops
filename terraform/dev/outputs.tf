output "repository_url" {
  value       = module.ecr.repository_url
  description = "The URL of the ECR repository"
}

output "vpc_id" {
  value       = module.networking.vpc_id
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value       = module.networking.public_subnet_ids
  description = "Value of the public subnet IDs"
}