terraform {
  required_providers {
    aws        = { source = "hashicorp/aws", version = "~> 5.0" }
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.25" }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

data "aws_vpc" "default" { default = true }
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "ecs" {
  source       = "./modules/ecs"
  vpc_id       = data.aws_vpc.default.id
  subnet_ids   = data.aws_subnets.default.ids
  lab_role_arn = "arn:aws:iam::661688898602:role/LabRole"
}

module "k8s" {
  source = "./modules/k8s"
}
