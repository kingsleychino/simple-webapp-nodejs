variable "ecs_tasks_execution_role_arn" {
  type = string
}

variable "container_image" {
  description = "ECR image URI passed in from Jenkins"
  type        = string
}
