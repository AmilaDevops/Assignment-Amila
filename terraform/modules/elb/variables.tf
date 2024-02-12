variable "name" {
    type = string
}
variable "port" {
    type = number
}
variable "load_balancer_type" {
    type = string
}
variable "environment" {
    type = string
}
variable "security_group_id" {
    type = list
}
variable "subnet_ids" {
    type = list
}
variable "certificate_arn" {
    default = ""
    type = string
}
variable "protocol" {
    type = string
}
variable "vpc_id" {
    type = string
}
variable "default_action_type" {
    type = string
}
variable "target_group_name" {
    type = string
}
