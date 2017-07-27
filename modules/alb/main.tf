/**
 * Resources.
 */

resource "aws_alb" "alb" {
  name     = "${var.project}-${var.environment}-${var.name}-alb"
  internal = false

  security_groups = ["${aws_security_group.alb_security_group.id}"]
  subnets         = "${var.subnet_ids}"

  tags {
    Name       = "${var.project}-${var.environment}-${var.name}-alb"
    Project    = "${var.project}"
    Deployment = "${var.environment}"
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "${var.port}"
  protocol          = "${var.protocol}"

  certificate_arn = "${var.ssl_certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "alb_target_group" {
  name = "${format("%s-%s-%s-%s", var.project, var.environment, var.name, var.port)}"

  port     = "${var.target_port}"
  protocol = "${var.target_protocol}"
  vpc_id   = "${var.security_vpc_id}"

  health_check {
    healthy_threshold   = "${var.health_check_healthy_threshold}"
    unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
    timeout             = "${var.health_check_timeout}"
    interval            = "${var.health_check_interval}"
    path                = "${var.health_check_path}"
    port                = "${var.health_port}"
  }

  tags {
    Name       = "${var.project}-${var.environment}-${var.name}-tg"
    Project    = "${var.project}"
    Deployment = "${var.environment}"
  }
}

resource "aws_security_group" "alb_security_group" {
  name        = "${var.project}-${var.environment}-sg-${var.name}-lb"
  description = "${var.name} load balancer security group"
  vpc_id      = "${var.security_vpc_id}"

  ingress {
    from_port   = "${var.port}"
    to_port     = "${var.port}"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
