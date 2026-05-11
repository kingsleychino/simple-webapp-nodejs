variable "container_image" {
  description = "ECR image URI passed in from Jenkins"
  type        = string
}

variable "project_name" {}
variable "vpc_cidr" {}
variable "public_subnet_az1_cidr" {}
variable "public_subnet_az2_cidr" {}
variable "region" {}

