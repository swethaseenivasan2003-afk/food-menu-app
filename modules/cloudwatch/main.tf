resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = var.retention_in_days

  tags = {
    Name = "${var.project_name}-log-group"
  }
}