output "listener" {
  value = aws_alb_listener.Listener
}

output "load_balancer_dns_name" {
  value = aws_lb.LB.dns_name
}
