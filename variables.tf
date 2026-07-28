variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public Subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "Private Subnet CIDRs"
  type        = list(string)
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
}

variable "certificate_arn" {
  description = "ACM Certificate ARN"
  type        = string
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection on ALB"
  type        = bool
  default     = false
}