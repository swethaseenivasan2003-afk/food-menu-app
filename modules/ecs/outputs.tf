output "ecs_cluster_id" {
    value = aws_ecs_cluster.ecs_cluster.id
}

output "ecs_cluster_arn" {
    value = aws_ecs_cluster.ecs_cluster.arn
}

output "task_def_arn" {
    value = aws_ecs_task_definition.app_task_def.arn
}

output "service_name" {
    value = aws_ecs_service.ecs_service.name
}

output "service_arn" {
    value = aws_ecs_service.ecs_service.arn
}