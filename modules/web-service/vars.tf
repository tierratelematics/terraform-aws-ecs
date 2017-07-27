/**
 * Required Variables.
 */

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

variable "health_check_healthy_threshold" {
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy."
  default     = "5"
}

variable "health_check_unhealthy_threshold" {
  description = "The number of consecutive health check failures required before considering the target unhealthy."
  default     = "2"
}

variable "health_check_timeout" {
  description = "The amount of time, in seconds, during which no response means a failed health check."
  default     = "5"
}

variable "health_check_interval" {
  description = "The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds."
  default     = "30"
}

variable "health_check_path" {
  description = "The destination for the health check request."
  default     = "/health"
}

variable "health_port" {
  description = "The port for the health check request."
}
