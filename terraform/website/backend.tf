# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket = "kinsley-bucket-0504"
    key    = "nodejs-website.tfstate"
    region = "us-east-1"
  }
}
