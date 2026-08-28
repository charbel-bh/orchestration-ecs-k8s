variable "vpc_id" {
  description = "ID du VPC dans lequel deployer les ressources ECS"
  type        = string
}

variable "subnet_ids" {
  description = "Liste des IDs de sous-reseaux pour le service ECS (awsvpc)"
  type        = list(string)
}

variable "lab_role_arn" {
  description = "ARN du role LabRole impose par AWS Academy (execution + task role)"
  type        = string
}
