variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC."
}

variable "region" {
  description = "The name of the AWS region"
}                                 

variable "availability_zones" {
  description = "The nameS of the AWS AZ"
}                                 

variable "environment" {
    type = string
}

variable "private_subnets_cidr" {
  description = "A list of CIDR in which to distribute subnets."
  type        = list(string)
}

variable "public_subnets_cidr" {
  description = "A list of CIDR in which to distribute subnets."
  type        = list(string)
}

variable "enable_dns_support" {
    type = bool
}
variable "enable_dns_hostnames" {
    type = bool
}

variable "number_of_nat_gws" {
    type = number
}

variable "num_of_eips" {
    type = number
}