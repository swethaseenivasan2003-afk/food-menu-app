module "networking" {
  source = "./modules/networking"

  vpc_cidr_block      = var.vpc_cidr_block
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  azs                 = var.azs
  project_name        = var.project_name
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
}

module "security_group" {
  source = "./modules/security_groups"

  project_name = var.project_name
  vpc_id       = module.networking.vpc_id
}

module "cloudwatch" {
  source = "./modules/cloudwatch"

  project_name = var.project_name
}

module "alb" {
  source = "./modules/alb"

  project_name               = var.project_name
  alb_sg_id                  = module.security_group.alb_sg_id
  public_subnet_ids          = module.networking.public_subnet_ids
  enable_deletion_protection = var.enable_deletion_protection
  vpc_id                     = module.networking.vpc_id
  certificate_arn            = var.certificate_arn
}

module "ecs" {
  source = "./modules/ecs"

  project_name = var.project_name
  aws_region   = var.aws_region

  execution_role_arn = module.iam.ecs_task_execution_role_arn
  task_role_arn      = module.iam.ecs_task_role_arn

  log_group_name = module.cloudwatch.log_group_name

  ecr_repository_url = module.ecr.ecr_repository_url

  subnet_private_ids = module.networking.private_subnet_ids

  ecs_security_group_id = module.security_group.ecs_sg_id

  target_group_arn = module.alb.target_group_arn
}