resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_name}-ecs_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
   tags = {
    Name = "${var.project_name}-cluster"
  }
}

resource "aws_ecs_task_definition" "app_task_def" {
  family = "${var.project_name}-app_task-def"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn
  container_definitions = jsonencode([
    {
      name      = "food-menu-container"
      image     = "${var.ecr_repository_url}:latest"
      essential = true

      logConfiguration = {
      logDriver = "awslogs"

      options = {
      awslogs-group         = var.log_group_name
      awslogs-region        = var.aws_region
      awslogs-stream-prefix = "ecs"
    }
}
      
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
   tags = {
    Name = "${var.project_name}-task-def"
  }
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.project_name}_app_service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.app_task_def.arn
  desired_count   = 2
  launch_type = "FARGATE"

  network_configuration  {
    subnets          = var.subnet_private_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = false
  }


  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "food-menu-container"
    container_port   = 3000
}

  tags = {
    Name = "${var.project_name}-ecs-service"
}
}