variable "aws_region" {}
variable "vpc_cidr" {}
variable "azs" {}
variable "public_subnets" {}
variable "private_subnets" {}
variable "cluster_version" {}

variable "system_node_group" {
  type = object({
    name           = string
    instance_types = list(string)
    desired_size   = number
    min_size       = number
    max_size       = number
    capacity_type  = string
    ami_type       = string
  })
}

variable "app_node_group" {
  type = object({
    name           = string
    instance_types = list(string)
    desired_size   = number
    min_size       = number
    max_size       = number
    capacity_type  = string
    ami_type       = string
  })
}