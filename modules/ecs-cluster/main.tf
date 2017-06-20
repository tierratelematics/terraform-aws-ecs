/**
 * Resources.
 */

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project}-${var.environment}-${var.cluster_name}-cluster"
}

resource "aws_security_group" "ecs_cluster_group" {
  name        = "${var.project}-${var.environment}-${var.cluster_name}-cluster-sg"
  description = "${var.project}-${var.environment}-${var.cluster_name}-cluster-sg"
  vpc_id      = "${var.security_vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Project     = "${var.project}"
    Environment = "${var.environment}"
    ClusterName = "${title(var.project)}-${var.environment}-${var.cluster_name}-cluster"
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/userdata.sh")}"

  vars {
    project      = "${var.project}"
    environment  = "${var.environment}"
    cluster_name = "${var.cluster_name}"
  }
}

data "aws_ami" "latest" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.aws_ami_latest_filter}"]
  }

  owners = ["${var.aws_ami_latest_owner}"]
}

resource "aws_instance" "ecs_instance" {
  count = "${var.cluster_size}"

  key_name                    = "${var.instance["key_name"]}"
  ami                         = "${var.instance["ami"] == "latest" ? data.aws_ami.latest.id : var.instance["ami"]}"
  instance_type               = "${var.instance["type"]}"
  subnet_id                   = "${element(var.instance_list_public_subnet_id, count.index)}"
  vpc_security_group_ids      = ["${aws_security_group.ecs_cluster_group.id}"]
  user_data                   = "${data.template_file.user_data.rendered}"
  iam_instance_profile        = "${var.instance["profile"]}"
  availability_zone           = "${element(var.instance_list_available_zone, count.index)}"
  associate_public_ip_address = "${var.associate_public_ip_address}"

  tags {
    Name        = "${format("%s-%s-ecs-%s-cluster-node-%d", var.project, var.environment, var.cluster_name, count.index + 1)}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

data "aws_route53_zone" "internal_zone" {
  count = "${var.internal_dns_name == "" ? 0 : 1}"

  name = "${var.internal_dns_name}"
  private_zone = true
}

resource "aws_route53_record" "internal_dns_record" {
  count = "${var.internal_dns_name == "" ? 0 : var.cluster_size}"

  zone_id = "${data.aws_route53_zone.internal_zone.zone_id}"
  name    = "${format("ecs-%s-%d.%s", var.cluster_name, count.index + 1, data.aws_route53_zone.internal_zone.name)}"
  type    = "A"
  ttl     = "${var.internal_dns_ttl}"
  records = ["${element(aws_instance.ecs_instance.*.private_ip, count.index)}"]
}
