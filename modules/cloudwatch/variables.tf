variable "project_name" {
  description = "Project name"
  type        = string
}

variable "retention_in_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 30
}