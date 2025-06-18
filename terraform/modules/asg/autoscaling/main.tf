resource "aws_autoscaling_group" "flaskapp_asg" {  
  max_size               = var.max_size
  min_size               = var.min_size
  desired_capacity       = var.desired_capacity
  vpc_zone_identifier    = var.subnet_ids
  target_group_arns      = [var.target_group_arn]
  health_check_type      = "EC2"
  health_check_grace_period = 120

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 90
      instance_warmup        = 120
    }
  }

  tag {
    key                 = "Name"
    value               = "Flaskapp-ASG-${var.environment}"
    propagate_at_launch = true
  }
}
