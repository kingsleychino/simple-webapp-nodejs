resource "aws_lb_target_group" "TG" {
  name        = "TG"
  port        = "80"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  tags = {
    Name = "TG"
  }
}
