variable "environment" {
    type = string
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
}

variable "ami" {
    type = string
}

variable "instance_type" {
    type = string
}

variable "ec2_name" {
    type = string
}

variable "subnet_id" {
    type = string
}

variable "key_name" {
    type = string
}

variable "security_groups_ids" {
    type = list
}

