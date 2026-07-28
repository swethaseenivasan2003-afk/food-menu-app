variable "project_name" {
    type = string
}

variable "execution_role_arn" {
    type = string
}

variable "task_role_arn" {
   type = string
}

variable "log_group_name" {
    type = string
}


variable "ecr_repository_url" {
    type = string
}

variable "aws_region" {
    type = string
}

variable "subnet_private_ids" {
    type = list(string)
}

variable "ecs_security_group_id" {
    type = string
}

variable "target_group_arn" {
    type = string
}