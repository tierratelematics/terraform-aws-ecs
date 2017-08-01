/**
 * Required Variables.
 */

variable "project" {
  description = "Name of project"
}

variable "environment" {
  description = "Name of environment (i.e. dev, test, prod)"
}

variable "name" {
  description = "The service name"
}

variable "security_vpc_id" {}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = "list"
}

variable "ssl_certificate_arn" {
  description = "SSL Certificate ARN to use"
}

/**
 * Options.
 */

variable "port" {
  description = "The port on which the load balancer is listening"
  default     = "443"
}

variable "protocol" {
  description = "The protocol for connections from clients to the load balancer. Valid values are HTTP and HTTPS. Defaults to HTTP."
  default     = "HTTPS"
}

variable "target_port" {
  default = "80"
}

variable "target_protocol" {
  default = "HTTP"
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

variable "health_check_port" {
  description = "The port for the health check request."
  default     = "80"
}
