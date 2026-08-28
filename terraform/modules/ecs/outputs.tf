output "ecr_repository_url" {
  description = "URL du depot ECR pour push/pull des images"
  value       = aws_ecr_repository.app.repository_url
}

output "ecs_cluster_name" {
  description = "Nom du cluster ECS cree"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "Nom du service ECS cree"
  value       = aws_ecs_service.app.name
}
