resource "aws_ecs_service" "ECS-Service" {
  name                               = "my-service"
  launch_type                        = "FARGATE"
  platform_version                   = "LATEST"
  cluster                            = var.cluster_id
  task_definition                    = var.TD_arn
  scheduling_strategy                = "REPLICA"
  desired_count                      = 2
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  depends_on                         = [var.listener, var.ecs_tasks_execution_role_name]


  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "main-container"
    container_port   = 3000
  }


  network_configuration {
    assign_public_ip = true
    security_groups  = [var.alb_security_group]
    subnets          = [var.public_subnet_az1_id, var.public_subnet_az2_id]
  }
}
