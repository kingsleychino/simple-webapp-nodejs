# configure aws provider
provider "aws" {
  region = var.region
}


# create resource from local module
module "vpc" {
  source                 = "../modules/vpc"
  project_name           = var.project_name
  region                 = var.region
  vpc_cidr               = var.vpc_cidr
  public_subnet_az1_cidr = var.public_subnet_az1_cidr
  public_subnet_az2_cidr = var.public_subnet_az2_cidr
}

# create security group
module "security_group" {
  source       = "../modules/security-group"
  vpc_id       = module.vpc.vpc_id
  project_name = module.vpc.project_name
}

# create ecs tasks execution role
module "ecs_tasks_execution_role" {
  source       = "../modules/ecs-tasks-execution-role"
  project_name = module.vpc.project_name
}

# create ecs cluster
module "ecs_cluster" {
  source       = "../modules/ecs-cluster"
  project_name = module.vpc.project_name
}

# create ecs service
module "ecs_service" {
  source                        = "../modules/ecs-service"
  cluster_id                    = module.ecs_cluster.cluster_id
  ecs_tasks_execution_role_name = module.ecs_tasks_execution_role.ecs_tasks_execution_role_name
  alb_security_group            = module.security_group.alb_security_group
  public_subnet_az1_id          = module.vpc.public_subnet_az1_id
  public_subnet_az2_id          = module.vpc.public_subnet_az2_id
  target_group_arn              = module.target_group.target_group_arn
  listener                      = module.load_balancer.listener
  TD_arn                        = module.ecs_task_definition.TD_arn
}

# create load balancer
module "load_balancer" {
  source               = "../modules/load-balancer"
  alb_security_group   = module.security_group.alb_security_group
  public_subnet_az1_id = module.vpc.public_subnet_az1_id
  public_subnet_az2_id = module.vpc.public_subnet_az2_id
  target_group_arn     = module.target_group.target_group_arn
}

# create target group
module "target_group" {
  source = "../modules/target-group"
  vpc_id = module.vpc.vpc_id
}

# create ecs task definition
module "ecs_task_definition" {
  source                       = "../modules/ecs-taskdefiniton"
  container_image              = var.container_image
  ecs_tasks_execution_role_arn = module.ecs_tasks_execution_role.ecs_tasks_execution_role_arn
}
