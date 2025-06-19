output "ecr_repository_url" {
  value = aws_ecr_repository.flaskapp_repo.repository_url
}

output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.flaskapp_profile.name
}
