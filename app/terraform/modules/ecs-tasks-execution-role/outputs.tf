output "ecs_tasks_execution_role_name" {
  value = aws_iam_role.ecs_execution.name
}

output "ecs_tasks_execution_role_arn" {
  value = aws_iam_role.ecs_execution.arn
}
