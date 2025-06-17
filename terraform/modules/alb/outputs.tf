output "target_group_arn" {
  value = aws_lb_target_group.flask_tg.arn
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}