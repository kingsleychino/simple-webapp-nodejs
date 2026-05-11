variable "container_image" {
  description = "ECR image URI passed in from Jenkins"
  type        = string
}

variable "project_name" {
  default = "my-app"
}

variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_az1_cidr" {
  default = "10.0.1.0/24"
}

variable "public_subnet_az2_cidr" {
  default = "10.0.2.0/24"
}
