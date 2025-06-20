output "launch_template_id" {
  value = aws_launch_template.flaskapp_server_lt.id
}

output "latest_version" {
  value = aws_launch_template.flaskapp_server_lt.latest_version
}