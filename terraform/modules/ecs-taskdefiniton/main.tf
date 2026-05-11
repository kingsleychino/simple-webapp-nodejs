resource "aws_ecs_task_definition" "TD" {
  family                   = "mynode"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = var.ecs_tasks_execution_role_arn
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  container_definitions = jsonencode([
    {
      name      = "main-container"
      image     = "503499294473.dkr.ecr.us-east-1.amazonaws.com/my-app:latest"
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}


data "aws_ecs_task_definition" "TD" {
  task_definition = aws_ecs_task_definition.TD.family
}
