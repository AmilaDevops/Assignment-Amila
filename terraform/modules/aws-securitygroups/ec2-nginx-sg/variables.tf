variable "ingress_source_security_group_id" {
    type = string
}
variable "security_group_name" {
    type = string
}
variable "vpc_id" {
    type = string
}
variable "environment" {
    type = string
}
variable "additional_tag_key" {
    type = string
    default = "project"
}
variable "additional_tag_value" {
    type = string
    default = "f13"
}
