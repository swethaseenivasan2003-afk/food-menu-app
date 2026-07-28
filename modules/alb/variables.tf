variable "project_name"{
    type = string
}
  
variable "alb_sg_id"{
    type = string
  }

variable "public_subnet_ids"{
    type = list(string)
  }

variable "enable_deletion_protection"{
    type = bool
  }

variable "vpc_id"{
    type = string
  }

variable "certificate_arn"{
    type = string
}

