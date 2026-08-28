# terraform/outputs.tf

output "ecr_repository_url" {
  description = "URL du depot ECR (relayee depuis le module ecs)"
  value       = module.ecs.ecr_repository_url
}
