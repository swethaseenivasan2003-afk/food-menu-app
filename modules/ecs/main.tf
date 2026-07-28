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

   lifecycle {
    ignore_changes = [
      desired_count
    ]
  }

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

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.container_max_capacity
  min_capacity       = var.container_min_capacity
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "cpu_target_tracking" {
  name               = "${var.project_name}-cpu-tracking"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

    depends_on = [
    aws_appautoscaling_target.ecs_target
  ]

  target_tracking_scaling_policy_configuration {
    target_value = var.cpu_target_value
    disable_scale_in   = false
    scale_in_cooldown  = 300
    scale_out_cooldown = 60

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "${var.project_name}-memory-tracking-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

    depends_on = [
    aws_appautoscaling_target.ecs_target
  ]

  target_tracking_scaling_policy_configuration {
    target_value       = var.memory_target_value
    disable_scale_in   = false
    scale_in_cooldown  = 300
    scale_out_cooldown = 60
    

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }
}