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
      image     = var.container_image
      cpu       = 1024
      memory    = 2048
      essential = true
      environment = [
        {
          name  = "PORT"
          value = "3000"
        }
      ],
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])
}


data "aws_ecs_task_definition" "TD" {
  task_definition = aws_ecs_task_definition.TD.family
}
