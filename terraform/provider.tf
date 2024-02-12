provider "aws" {
  region  = "ap-southeast-1" 
  #access_key = "my-access-key"
  #secret_key = "my-secret-key"
}

terraform {
  required_providers {
    aws = {
     source  = "hashicorp/aws"          
    }
  }
  backend "s3" {
    bucket = "assignment-dev-terraform-state"
    key    = "dev/terraform.tfstate"
    region = "ap-southeast-1"
  }
}