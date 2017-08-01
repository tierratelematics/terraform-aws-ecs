/**
 * Resources.
 */

resource "aws_ecs_service" "main" {
  cluster                            = "${var.cluster}"
  name                               = "${var.task_name}-${var.environment}"
  task_definition                    = "${var.task_arn}"
  desired_count                      = "${var.desired_count}"
  iam_role                           = "${var.iam_role}"
  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"
  deployment_maximum_percent         = "${var.deployment_maximum_percent}"

  load_balancer {
    target_group_arn = "${module.alb.alb_target_group_arn}"
    container_name   = "${var.task_name}"
    container_port   = "${var.task_container_port}"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["module.alb"]
}

module "alb" {
  source = "../alb"

  environment = "${var.environment}"
  project     = "${var.project}"

  name     = "${var.task_name}"
  port     = "443"
  protocol = "HTTPS"

  target_port = "${var.task_container_port}"

  security_vpc_id     = "${var.security_vpc_id}"
  subnet_ids          = "${var.subnet_ids}"
  ssl_certificate_arn = "${var.ssl_certificate_arn}"

  health_check_healthy_threshold   = "${var.health_check_healthy_threshold}"
  health_check_unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
  health_check_unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
  health_check_timeout             = "${var.health_check_timeout}"
  health_check_interval            = "${var.health_check_interval}"
  health_check_path                = "${var.health_check_path}"
  health_check_port                = "${var.health_check_port}"
}

resource "aws_route53_record" "service-alias" {
  zone_id = "${var.external_zone_id}"
  name    = "lb-${var.task_name}.${var.environment}.${var.external_dns_name}"
  type    = "A"

  weighted_routing_policy {
    weight = 1
  }

  set_identifier = "lb-${var.task_name}"

  alias {
    name                   = "${module.alb.alb_dns_name}"
    zone_id                = "${module.alb.alb_zone_id}"
    evaluate_target_health = false
  }
}
