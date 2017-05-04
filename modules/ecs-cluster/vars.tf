variable "instance_list_public_subnet_id" {
  type = "list"
}

variable "instance_list_available_zone" {
  type = "list"
}

variable "cluster_name" {}

variable "security_vpc_id" {}

variable "instance" {
  type = "map"
}

variable "project" {
  description = "Name of project"
}

variable "environment" {
  description = "Name of environment (i.e. dev, test, prod)"
}

variable "cluster_size" {
  description = "Size of cluster"
  default     = 1
}

variable "aws_ami_latest_filter" {
  description = "Filter for take the last aws ami"
  default     = "amzn-ami-*-amazon-ecs-optimized"
}

variable "aws_ami_latest_owner" {
  description = "Owner of the last aws ami"
  default     = "amazon"
}

variable "associate_public_ip_address" {
  description = "Associate a public ip address"
  default     = true
}
