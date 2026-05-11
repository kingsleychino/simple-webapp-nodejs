output "cluster_arn" {
  value = aws_ecs_cluster.ECS.arn
}

output "cluster_id" {
  value = aws_ecs_cluster.ECS.id
}

output "cluster_name" {
  value = aws_ecs_cluster.ECS.name
}
