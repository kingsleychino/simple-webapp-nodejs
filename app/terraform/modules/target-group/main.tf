resource "aws_lb_target_group" "TG" {
  name        = "TG"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path     = "/"
    protocol = "HTTP"
    port     = "traffic-port"

    matcher = "200"

    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "TG"
  }
}
