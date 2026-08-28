# Orchestration automatisée : ECS et Kubernetes

Déploiement d'une application conteneurisée sur AWS ECS (Fargate) et Kubernetes (Minikube),
piloté par un pipeline Jenkins unique via Terraform.

## Structure
- terraform/ : code Terraform (modules ecs et k8s)
- app/ : application conteneurisée
- jenkins/ : Jenkinsfile
- docs/ : rapport et schémas
