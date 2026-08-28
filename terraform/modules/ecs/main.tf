resource "aws_ecr_repository" "app" {
  name                 = "demo-app"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecs_cluster" "main" {
  name = "demo-cluster"
}

resource "aws_security_group" "svc_sg" {
  name        = "demo-svc-sg"
  description = "Autorise HTTP entrant uniquement"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "demo-app-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.lab_role_arn
  task_role_arn            = var.lab_role_arn

  container_definitions = jsonencode([{
    name         = "demo-app"
    image        = "${aws_ecr_repository.app.repository_url}:1.0"
    portMappings = [{ containerPort = 80, protocol = "tcp" }]
  }])
}

resource "aws_ecs_service" "app" {
  name            = "demo-app-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.svc_sg.id]
    assign_public_ip = true
  }
}
