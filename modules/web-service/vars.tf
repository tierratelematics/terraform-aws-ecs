/**
 * Required Variables.
 */

//variable "aws" {
//  type = "map"
//}

variable "project" {
  description = "Name of project"
}

variable "environment" {
  description = "Name of environment (i.e. dev, test, prod)"
}

variable "task_name" {}

variable "task_arn" {}

variable "task_container_port" {}

variable "security_vpc_id" {}

variable "subnet_ids" {
  type        = "list"
  description = "List of subnet IDs that will be passed to the ALB module"
}

variable "security_groups" {
  description = "Comma separated list of security group IDs that will be passed to the ALB module"
}

variable "cluster" {
  description = "The cluster name or ARN"
}

variable "ssl_certificate_arn" {
  description = "SSL Certificate ARN to use"
}

variable "iam_role" {
  description = "IAM Role ARN to use"
}

variable "external_dns_name" {
  description = "The subdomain under which the ALB is exposed externally"
}

variable "external_zone_id" {
  description = "The zone ID to create the record in"
}

/**
 * Options.
 */

variable "healthcheck" {
  description = "Path to a healthcheck endpoint"
  default     = "/"
}

variable "command" {
  description = "The raw json of the task command"
  default     = "[]"
}

variable "env_vars" {
  description = "The raw json of the task env vars"
  default     = "[]"
}

variable "desired_count" {
  description = "The desired count"
  default     = 1
}

variable "memory" {
  description = "The number of MiB of memory to reserve for the container"
  default     = 256
}

variable "cpu" {
  description = "The number of cpu units to reserve for the container"
  default     = 256
}

variable "deployment_minimum_healthy_percent" {
  description = "lower limit (% of desired_count) of # of running tasks during a deployment"
  default     = 100
}

variable "deployment_maximum_percent" {
  description = "upper limit (% of desired_count) of # of running tasks during a deployment"
  default     = 200
}
