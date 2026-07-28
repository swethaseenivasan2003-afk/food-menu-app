output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.app_lb.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app_lb.dns_name
}

output "alb_zone_id" {
  description = "Hosted Zone ID of the Application Load Balancer"
  value       = aws_lb.app_lb.zone_id
}

output "target_group_arn" {
  description = "ARN of the Target Group"
  value       = aws_lb_target_group.alb_tg.arn
}

output "listener_arn" {
  description = "ARN of the ALB Listener"
  value       = aws_lb_listener.alb_listener.arn
}