variable "vpc_cidr_block" {
    description = "vpc-cidr-block"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "public_subnet_cidr"
    type = list(string)
    default = ["10.0.1.0/24", "10.0.2.0/24" ]
}

variable "private_subnet_cidr" {
    description = "private_subnet_cidr"
    type = list(string)
    default = ["10.0.11.0/24", "10.0.12.0/24" ]
}

variable "azs" {
    description = "availabilty zones"
    type = list(string)
    default = ["ap-south-2a", "ap-south-2b"]
}

variable "project_name" {
    description = "project name"
    default = "food-menu-app"
}
