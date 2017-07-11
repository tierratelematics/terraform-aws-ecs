/**
 * Required Variables.
 */

variable "project" {
  description = "Name of project"
}

variable "environment" {
  description = "Name of environment (i.e. dev, test, prod)"
}

variable "cluster_name" {}

variable "security_vpc_id" {}

variable "instance" {
  type = "map"
}

variable "instance_list_public_subnet_id" {
  type = "list"
}

variable "instance_list_available_zone" {
  type = "list"
}

//variable "instance_type" {
//  default = "t2.micro"
//}
//
//variable "key_pair_name" {
//  default = "tfm-dev"
//}
//
//variable "instance_profile_name" {
//  default = "tfm-dev-server-profile"
//}
//
//variable "security_group_ecs_instance_id" {
//  default = "sg-c7313abe"
//}
//
//variable "ecs_cluster_subnet_ids" {
//  type = "list"
//  default = ["subnet-172af35e", "subnet-8364b7e4"]
//}
//
//variable "ami" {
//  default = "ami-a1e6f5c7"
//}
//
//variable "asg_min" {
//  default = "1"
//}
//
//variable "asg_max" {
//  default = "1"
//}

/**
 * Options.
 */

variable "asg_min" {
  description = "Minimum number of EC2 instances to run in the ECS cluster"
  default     = "1"
}

variable "asg_max" {
  description = "Maximum number of EC2 instances to run in the ECS cluster"
  default     = "1"
}

variable "aws_ami_latest_filter" {
  description = "Filter for take the last aws ami"
  default     = "amzn-ami-*-amazon-ecs-optimized"
}

variable "aws_ami_latest_owner" {
  description = "Owner of the last aws ami"
  default     = "amazon"
}
